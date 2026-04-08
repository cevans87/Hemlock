#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/custom.h>

#include <liburing.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

/*****************************************************************************
 * Helpers for extracting C.Liburing custom block pointers.
 *
 * The custom block layout matches liburing_stubs.c:
 *   *((struct io_uring_sqe **)Data_custom_val(v))
 *****************************************************************************/

static struct io_uring_sqe *sqe_of_value(value v) {
    return *((struct io_uring_sqe **)Data_custom_val(v));
}

/*****************************************************************************
 * Buffer-safe io_uring prep wrappers.
 *
 * These malloc C buffers so the kernel operates on stable memory that the
 * OCaml GC cannot relocate. The malloc'd pointer is returned to OCaml as a
 * nativeint for later copy-back and free.
 *****************************************************************************/

/* hemlock_os_file_prep_openat: sqe -> dfd -> path_bytes -> flags -> mode -> nativeint
 *
 * Copies the OCaml path bytes to a malloc'd NUL-terminated C string and calls
 * io_uring_prep_openat. Returns the malloc'd pathname pointer (for later free).
 */
CAMLprim value
hemlock_os_file_prep_openat(value a_sqe, value a_dfd, value a_path,
                            value a_flags, value a_mode) {
    CAMLparam5(a_sqe, a_dfd, a_path, a_flags, a_mode);
    struct io_uring_sqe *sqe = sqe_of_value(a_sqe);
    int dfd = (int)Int64_val(a_dfd);
    size_t n = caml_string_length(a_path);
    int flags = (int)Int64_val(a_flags);
    mode_t mode = (mode_t)Int64_val(a_mode);

    char *pathname = (char *)malloc(n + 1);
    assert(pathname != NULL);
    memcpy(pathname, Bytes_val(a_path), n);
    pathname[n] = '\0';

    io_uring_prep_openat(sqe, dfd, pathname, flags, mode);

    CAMLreturn(caml_copy_nativeint((intnat)pathname));
}

/* hemlock_os_file_prep_close: sqe -> fd -> unit */
CAMLprim value
hemlock_os_file_prep_close(value a_sqe, value a_fd) {
    struct io_uring_sqe *sqe = sqe_of_value(a_sqe);
    int fd = (int)Int64_val(a_fd);
    io_uring_prep_close(sqe, fd);
    return Val_unit;
}

/* hemlock_os_file_prep_read: sqe -> fd -> nbytes -> nativeint
 *
 * Mallocs a read buffer. The kernel writes into this buffer. Returns the
 * malloc'd buffer pointer (for later copy-back via read_copyback).
 * Offset is -1 to use current file position.
 */
CAMLprim value
hemlock_os_file_prep_read(value a_sqe, value a_fd, value a_nbytes) {
    struct io_uring_sqe *sqe = sqe_of_value(a_sqe);
    int fd = (int)Int64_val(a_fd);
    unsigned int nbytes = (unsigned int)Int64_val(a_nbytes);

    void *buf = malloc(nbytes);
    assert(buf != NULL);

    io_uring_prep_read(sqe, fd, buf, nbytes, (uint64_t)-1);

    return caml_copy_nativeint((intnat)buf);
}

/* hemlock_os_file_prep_write: sqe -> fd -> ocaml_bytes -> nbytes -> nativeint
 *
 * Mallocs a buffer and copies OCaml bytes into it, then calls
 * io_uring_prep_write. Returns the malloc'd buffer pointer (for later free).
 * Offset is -1 to use current file position.
 */
CAMLprim value
hemlock_os_file_prep_write(value a_sqe, value a_fd, value a_bytes, value a_nbytes) {
    CAMLparam4(a_sqe, a_fd, a_bytes, a_nbytes);
    struct io_uring_sqe *sqe = sqe_of_value(a_sqe);
    int fd = (int)Int64_val(a_fd);
    unsigned int nbytes = (unsigned int)Int64_val(a_nbytes);

    void *buf = malloc(nbytes);
    assert(buf != NULL);
    memcpy(buf, Bytes_val(a_bytes), nbytes);

    io_uring_prep_write(sqe, fd, buf, nbytes, (uint64_t)-1);

    CAMLreturn(caml_copy_nativeint((intnat)buf));
}

/*****************************************************************************
 * Completion helpers
 *****************************************************************************/

/* hemlock_os_file_read_copyback: c_buf -> ocaml_bytes -> n -> unit
 *
 * Copies n bytes from the malloc'd C buffer into OCaml bytes, then frees
 * the C buffer.
 */
CAMLprim value
hemlock_os_file_read_copyback(value a_cbuf, value a_bytes, value a_n) {
    CAMLparam3(a_cbuf, a_bytes, a_n);
    void *cbuf = (void *)Nativeint_val(a_cbuf);
    size_t n = (size_t)Int64_val(a_n);

    memcpy(Bytes_val(a_bytes), cbuf, n);
    free(cbuf);

    CAMLreturn(Val_unit);
}

/* hemlock_os_file_free_buf: nativeint -> unit
 *
 * Frees a malloc'd buffer (pathname or write buffer).
 */
CAMLprim value
hemlock_os_file_free_buf(value a_cbuf) {
    void *cbuf = (void *)Nativeint_val(a_cbuf);
    free(cbuf);
    return Val_unit;
}

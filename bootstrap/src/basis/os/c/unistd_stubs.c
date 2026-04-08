#define _GNU_SOURCE
#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <unistd.h>
#include <errno.h>

/*****************************************************************************
 * Standard file descriptors (STDIN_FILENO, STDOUT_FILENO, STDERR_FILENO)
 *****************************************************************************/

CAMLprim value hemlock__c__unistd__stdin_fileno(value unit)  { (void)unit; return caml_copy_int64(STDIN_FILENO); }
CAMLprim value hemlock__c__unistd__stdout_fileno(value unit) { (void)unit; return caml_copy_int64(STDOUT_FILENO); }
CAMLprim value hemlock__c__unistd__stderr_fileno(value unit) { (void)unit; return caml_copy_int64(STDERR_FILENO); }

/*****************************************************************************
 * Seek whence constants (SEEK_SET, SEEK_CUR, SEEK_END)
 *****************************************************************************/

CAMLprim value hemlock__c__unistd__seek_set(value unit) { (void)unit; return caml_copy_int64(SEEK_SET); }
CAMLprim value hemlock__c__unistd__seek_cur(value unit) { (void)unit; return caml_copy_int64(SEEK_CUR); }
CAMLprim value hemlock__c__unistd__seek_end(value unit) { (void)unit; return caml_copy_int64(SEEK_END); }

/*****************************************************************************
 * lseek
 *****************************************************************************/

CAMLprim value
hemlock__c__unistd__lseek(value a_offset, value a_whence, value a_fd) {
    off_t offset = (off_t)Int64_val(a_offset);
    int whence = (int)Int64_val(a_whence);
    int fd = (int)Int64_val(a_fd);

    off_t result = lseek(fd, offset, whence);
    if (result == (off_t)-1) {
        /* Error: return Error errno */
        value v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(errno));
        return v_result;
    } else {
        /* Ok: return Ok result */
        value v_ok = caml_alloc(1, 0);
        Store_field(v_ok, 0, caml_copy_int64(result));
        return v_ok;
    }
}

/*****************************************************************************
 * write (synchronous)
 *****************************************************************************/

CAMLprim value
hemlock__c__unistd__write(value a_bytes, value a_n, value a_fd) {
    const char *bytes = (const char *)Bytes_val(a_bytes);
    size_t n = (size_t)Int64_val(a_n);
    int fd = (int)Int64_val(a_fd);

    ssize_t result = write(fd, bytes, n);
    if (result == -1) {
        value v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(errno));
        return v_result;
    } else {
        value v_ok = caml_alloc(1, 0);
        Store_field(v_ok, 0, caml_copy_int64(result));
        return v_ok;
    }
}

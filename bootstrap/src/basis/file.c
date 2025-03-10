#define _GNU_SOURCE // For O_DIRECT,
#define _LARGEFILE64_SOURCE // For O_LARGEFILE

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stddef.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include "common.h"
#include "executor.h"
#include "ioring.h"

// Export underlying ctype values for File.Open.Flag.t.
#define HEMLOCK_BASIS_FILE_OPEN_FLAG_T(FLAG) \
CAMLprim value hemlock_basis_file_open_flag_t_ ## FLAG () { \
    return caml_copy_int64(FLAG); \
}

HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_RDONLY)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_RDWR)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_WRONLY)

HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_CLOEXEC)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_CREAT)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_DIRECTORY)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_EXCL)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_NOCTTY)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_NOFOLLOW)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_TMPFILE)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_TRUNC)

HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_APPEND)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_ASYNC)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_DIRECT)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_DSYNC)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_LARGEFILE)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_NDELAY)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_NOATIME)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_NONBLOCK)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_PATH)
HEMLOCK_BASIS_FILE_OPEN_FLAG_T(O_SYNC)

#undef HEMLOCK_BASIS_FILE_OPEN_FLAG

// Export underlying ctype values for File.Open.Mode.t.
#define HEMLOCK_BASIS_FILE_OPEN_MODE_T(MODE) \
CAMLprim value hemlock_basis_file_open_mode_t_ ## MODE () { \
    return caml_copy_int64(MODE); \
}

HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_ISUID)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_ISGID)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_ISVTX)

HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IRWXU)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IRUSR)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IWUSR)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IXUSR)

HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IRWXG)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IRGRP)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IWGRP)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IXGRP)

HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IRWXO)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IROTH)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IWOTH)
HEMLOCK_BASIS_FILE_OPEN_MODE_T(S_IXOTH)

#undef HEMLOCK_BASIS_FILE_OPEN_MODE

int flags_of_hemlock_file_flag[] = {
    /* R_O   */ O_RDONLY,
    /* W     */ O_WRONLY | O_CREAT | O_TRUNC,
    /* W_A   */ O_WRONLY | O_APPEND | O_CREAT,
    /* W_AO  */ O_WRONLY | O_APPEND,
    /* W_C   */ O_WRONLY | O_CREAT | O_EXCL,
    /* W_O   */ O_WRONLY | O_TRUNC,
    /* RW    */ O_RDWR | O_CREAT | O_TRUNC,
    /* RW_A  */ O_RDWR | O_APPEND| O_CREAT,
    /* RW_AO */ O_RDWR | O_APPEND,
    /* RW_C  */ O_RDWR | O_CREAT | O_EXCL,
    /* RW_O  */ O_RDWR | O_TRUNC,
};

CAMLprim value
hemlock_basis_file_stdin_inner(value a_unit) {
    return caml_copy_int64(STDIN_FILENO);
}

CAMLprim value
hemlock_basis_file_stdout_inner(value a_unit) {
    return caml_copy_int64(STDOUT_FILENO);
}

CAMLprim value
hemlock_basis_file_stderr_inner(value a_unit) {
    return caml_copy_int64(STDERR_FILENO);
}

CAMLprim value
hemlock_basis_file_write_inner(value a_bytes, value a_fd) {
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);
    int fd = Int64_val(a_fd);

    assert(n > 0);
    int result = write(fd, bytes, n);

    return hemlock_basis_executor_finalize_result(result);
}

CAMLprim value
hemlock_basis_file_seek_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hemlock_basis_executor_finalize_result(lseek(fd, i, SEEK_CUR));
}

CAMLprim value
hemlock_basis_file_seek_hd_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hemlock_basis_executor_finalize_result(lseek(fd, i, SEEK_SET));
}

CAMLprim value
hemlock_basis_file_seek_tl_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hemlock_basis_executor_finalize_result(lseek(fd, i, SEEK_END));
}

// hemlock_basis_file_read_complete_inner: !&Stdlib.Bytes.t -> Basis.File.Read.inner >{os}-> int
CAMLprim value
hemlock_basis_file_read_complete_inner(value a_bytes, value a_user_data) {
    hemlock_user_data_t *user_data = (hemlock_user_data_t *)Int64_val(a_user_data);

    int64_t res = hemlock_ioring_user_data_complete(user_data, &hemlock_executor_get()->ioring);

    if (res >= 0) {
        uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
        memcpy(bytes, user_data->buf, res);
    }

    return caml_copy_int64(res);
}

// hemlock_basis_file_open_submit_inner: Basis.File.Flag.t -> uns -> Stdlib.Bytes.t >{os}->
//   (int * &File.Open.t)
CAMLprim value
hemlock_basis_file_open_submit_inner(value a_flag, value a_mode, value a_bytes) {
    size_t flag = Long_val(a_flag);
    size_t mode = Int64_val(a_mode);
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);

    int flags = flags_of_hemlock_file_flag[flag];

    uint8_t *pathname = (uint8_t *)malloc(sizeof(uint8_t) * (n + 1));
    assert(pathname != NULL);
    memcpy(pathname, bytes, sizeof(uint8_t) * n);
    pathname[n] = '\0';

    hemlock_opt_error_t oe = HEMLOCK_OE_NONE;

    hemlock_user_data_t *user_data = NULL;
    HEMLOCK_OE(
        oe,
        hemlock_ioring_open_submit(
            &user_data, pathname, flags, mode, &hemlock_executor_get()->ioring
        )
    );

LABEL_OUT:
    return hemlock_basis_executor_submit_out(oe, user_data);
}

/**
 * _of_path: Flag.ctype -> Mode.ctype -> Path.ctype >{os}-> (Errno.ctype * Open.ctype)
 *
 * Above signature assumes namespace of `Basis.File.Open` module.
 */
CAMLprim value
hemlock_basis_file_open_of_path(value a_flags, value a_modes, value a_path) {
    size_t flags = Long_val(a_flags);
    size_t mode = Int64_val(a_modes);
    uint8_t *path = (uint8_t *)Bytes_val(a_path);

    size_t n = caml_string_length(a_path);
    uint8_t *path_copy = (uint8_t *)malloc(sizeof(uint8_t) * (n + 1));
    assert(path_copy != NULL);
    memcpy(path_copy, path, sizeof(uint8_t) * n);
    path_copy[n] = '\0';
    path = path_copy;

    hemlock_opt_error_t oe = HEMLOCK_OE_NONE;

    hemlock_user_data_t *user_data = NULL;
    HEMLOCK_OE(
        oe,
        hemlock_ioring_open_submit(
            &user_data, path, flags, mode, &hemlock_executor_get()->ioring
        )
    );

LABEL_OUT:
    return hemlock_basis_executor_submit_out(oe, user_data);
}

// hemlock_basis_file_close_submit_inner: Basis.File.t >{os}-> (int * &Basis.File.Close.t)
CAMLprim value
hemlock_basis_file_close_submit_inner(value a_fd) {
    int fd = Int64_val(a_fd);

    hemlock_opt_error_t oe = HEMLOCK_OE_NONE;

    hemlock_user_data_t *user_data = NULL;
    HEMLOCK_OE(oe, hemlock_ioring_close_submit(&user_data, fd, &hemlock_executor_get()->ioring));

LABEL_OUT:
    return hemlock_basis_executor_submit_out(oe, user_data);
}

// hemlock_basis_file_read_submit_inner: uns -> Basis.File.t >{os}-> (int * &Basis.File.Read.inner)
CAMLprim value
hemlock_basis_file_read_submit_inner(value a_count, value a_fd) {
    uint64_t count = Int64_val(a_count);
    int fd = Int64_val(a_fd);

    uint8_t *buf = (uint8_t *)malloc(sizeof(uint8_t) * count);
    assert(buf != NULL);

    hemlock_opt_error_t oe = HEMLOCK_OE_NONE;

    hemlock_user_data_t *user_data = NULL;
    HEMLOCK_OE(
        oe, hemlock_ioring_read_submit( &user_data, fd, buf, count, &hemlock_executor_get()->ioring)
    );

LABEL_OUT:
    return hemlock_basis_executor_submit_out(oe, user_data);
}

// hemlock_basis_file_write_submit_inner: Stdlib.Bytes.t -> Basis.File.t >{os}->
//   (int * &Basis.File.Write.inner)
CAMLprim value
hemlock_basis_file_write_submit_inner(value a_bytes, value a_fd) {
    hemlock_opt_error_t oe = HEMLOCK_OE_NONE;
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);
    int fd = Int64_val(a_fd);

    uint8_t *buf = (uint8_t *)malloc(sizeof(uint8_t) * n);
    assert(buf != NULL);
    memcpy(buf, bytes, n);

    hemlock_user_data_t *user_data = NULL;
    HEMLOCK_OE(
        oe, hemlock_ioring_write_submit(&user_data, fd, buf, n, &hemlock_executor_get()->ioring)
    );

LABEL_OUT:
    value a_ret = caml_alloc_tuple(2);
    Store_field(a_ret, 0, caml_copy_int64((uint64_t)oe));
    Store_field(a_ret, 1, caml_copy_int64((uint64_t)user_data));

    return a_ret;
}

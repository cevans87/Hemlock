#define _LARGEFILE64_SOURCE
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

#include "executor.h"
#include "ioring.h"

int flags_of_hemlock_file_flag[] = {
    /* R_O   */ O_RDONLY | O_LARGEFILE,
    /* W     */ O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE,
    /* W_A   */ O_WRONLY | O_APPEND | O_CREAT | O_LARGEFILE,
    /* W_AO  */ O_WRONLY | O_APPEND | O_LARGEFILE,
    /* W_C   */ O_WRONLY | O_CREAT | O_EXCL | O_LARGEFILE,
    /* W_O   */ O_WRONLY | O_TRUNC | O_LARGEFILE,
    /* RW    */ O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE,
    /* RW_A  */ O_RDWR | O_APPEND| O_CREAT | O_LARGEFILE,
    /* RW_AO */ O_RDWR | O_APPEND | O_LARGEFILE,
    /* RW_C  */ O_RDWR | O_CREAT | O_EXCL | O_LARGEFILE,
    /* RW_O  */ O_RDWR | O_TRUNC | O_LARGEFILE,
};

CAMLprim value
hemlock_file_stdin(value a_unit) {
    return caml_copy_int64(STDIN_FILENO);
}

CAMLprim value
hemlock_file_stdout(value a_unit) {
    return caml_copy_int64(STDOUT_FILENO);
}

CAMLprim value
hemlock_file_stderr(value a_unit) {
    return caml_copy_int64(STDERR_FILENO);
}

// hemlock_file_read_complete: !&Stdlib.Bytes.t -> Basis.File.Read.inner >{os}-> int
CAMLprim value
hemlock_file_read_complete(value a_bytes, value a_user_data) {
    hemlock_ioring_user_data_t *user_data = (hemlock_ioring_user_data_t *)Int64_val(a_user_data);

    hemlock_ioring_error_t error = hemlock_ioring_user_data_complete(
      user_data, &hemlock_executor_get()->ioring);

    if (error == HEMLOCK_IORING_ERROR_NONE && user_data->cqe.res >= 0) {
        uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
        memcpy(bytes, user_data->buffer, user_data->cqe.res);
    }

    return caml_copy_int64(error);
}

// hemlock_file_write_complete: Basis.File.UserData.t >{os}-> (uns * uns)
CAMLprim value
hemlock_file_write_complete(value a_user_data) {
    hemlock_ioring_user_data_t *user_data = (hemlock_ioring_user_data_t *)Int64_val(a_user_data);

    hemlock_ioring_error_t error = hemlock_ioring_user_data_complete(
      user_data, &hemlock_executor_get()->ioring);

    value a_ret = caml_alloc_tuple(2);
    Store_field(a_ret, 0, caml_copy_int64(-user_data->cqe.res));
    Store_field(a_ret, 1, caml_copy_int64(user_data->cqe.res));

    return a_ret;
}

// hemlock_file_open_submit: Basis.File.Flag.t -> Basis.File.Mode.t -> Stdlib.Bytes.t >{os}->
//   (int * &File.Open.t)
CAMLprim value
hemlock_file_open_submit(value a_flag, value a_mode, value a_bytes) {
    size_t flag = Long_val(a_flag);
    size_t mode = Int64_val(a_mode);
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);

    int flags = flags_of_hemlock_file_flag[flag];

    uint8_t *pathname = (uint8_t *)malloc(sizeof(uint8_t) * (n + 1));
    assert(pathname != NULL);
    memcpy(pathname, bytes, sizeof(uint8_t) * n);
    pathname[n] = '\0';

    hemlock_ioring_user_data_t *user_data = NULL;
    hemlock_ioring_error_t error = hemlock_ioring_open_submit(
      &user_data, pathname, flags, mode, &hemlock_executor_get()->ioring);

    return hemlock_executor_submit_out(error, user_data);
}

// hemlock_file_open_complete: !&Basis.File.Open.t >{os}-> (uns * uns)
CAMLprim value
hemlock_file_open_complete(value a_user_data) {
    hemlock_ioring_user_data_t *user_data = (hemlock_ioring_user_data_t *)Int64_val(a_user_data);

    hemlock_ioring_error_t error = hemlock_ioring_user_data_complete(
        user_data, &hemlock_executor_get()->ioring);

    value a_ret = caml_alloc_tuple(2);
    Store_field(a_ret, 0, caml_copy_int64(-user_data->cqe.res));
    Store_field(a_ret, 1, caml_copy_int64(user_data->cqe.res));

    return a_ret;
}

// hemlock_file_close_submit: Basis.File.t >{os}-> (int * &Basis.File.Close.t)
CAMLprim value
hemlock_file_close_submit(value a_fd) {
    int fd = Int64_val(a_fd);

    hemlock_ioring_user_data_t *user_data = NULL;
    hemlock_ioring_error_t error = hemlock_ioring_close_submit(
        &user_data, fd, &hemlock_executor_get()->ioring);

    return hemlock_executor_submit_out(error, user_data);
}

// hemlock_file_read_submit: uns -> Basis.File.t -> Basis.File.Offset.t >{os}-> (int * &Basis.File.Read.inner)
CAMLprim value
hemlock_file_read_submit(value a_n, value a_fd, value a_offset) {
    uint64_t n = Int64_val(a_n);
    int fd = Int64_val(a_fd);
    int64_t offset = Int64_val(a_offset);

    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t) * n);
    assert(buffer != NULL);

    hemlock_ioring_user_data_t *user_data = NULL;
    hemlock_ioring_error_t error = hemlock_ioring_read_submit(
        &user_data, fd, offset, buffer, n, &hemlock_executor_get()->ioring);

    return hemlock_executor_submit_out(error, user_data);
}

// hemlock_file_write_submit: Stdlib.Bytes.t -> Basis.File.t >{os}->
//   (int * &Basis.File.Write.inner)
CAMLprim value
hemlock_file_write_submit(value a_bytes, value a_fd, value a_offset) {
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    int fd = Int64_val(a_fd);
    int64_t offset = Int64_val(a_offset);

    size_t n = caml_string_length(a_bytes);
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t) * n);
    assert(buffer != NULL);
    memcpy(buffer, bytes, n);

    hemlock_ioring_user_data_t *user_data = NULL;
    hemlock_ioring_error_t error = hemlock_ioring_write_submit(
        &user_data, fd, offset, buffer, n, &hemlock_executor_get()->ioring);
    
    return hemlock_executor_submit_out(error, user_data);
}

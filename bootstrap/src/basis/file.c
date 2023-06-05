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

#include "common.h"
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
hm_basis_file_stdin_inner(value a_unit) {
    return caml_copy_int64(STDIN_FILENO);
}

CAMLprim value
hm_basis_file_stdout_inner(value a_unit) {
    return caml_copy_int64(STDOUT_FILENO);
}

CAMLprim value
hm_basis_file_stderr_inner(value a_unit) {
    return caml_copy_int64(STDERR_FILENO);
}

CAMLprim value
hm_basis_file_write_inner(value a_bytes, value a_fd) {
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);
    int fd = Int64_val(a_fd);

    assert(n > 0);
    int result = write(fd, bytes, n);

    return hm_basis_executor_finalize_result(result);
}

CAMLprim value
hm_basis_file_seek_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hm_basis_executor_finalize_result(lseek(fd, i, SEEK_CUR));
}

CAMLprim value
hm_basis_file_seek_hd_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hm_basis_executor_finalize_result(lseek(fd, i, SEEK_SET));
}

CAMLprim value
hm_basis_file_seek_tl_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hm_basis_executor_finalize_result(lseek(fd, i, SEEK_END));
}

// hm_basis_file_read_complete_inner: !&Stdlib.Bytes.t -> Basis.File.Read.inner >{os}-> int
CAMLprim value
hm_basis_file_read_complete_inner(value a_bytes, value a_user_data) {
    hm_user_data_t *user_data = (hm_user_data_t *)Int64_val(a_user_data);

    int64_t res = hm_ioring_user_data_complete(user_data, &hm_executor_get()->ioring);

    if (res >= 0) {
        uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
        memcpy(bytes, user_data->buffer, res);
    }

    return caml_copy_int64(res);
}

// hm_basis_file_open_submit_inner: Basis.File.Flag.t -> uns -> Stdlib.Bytes.t >{os}->
//   (int * &File.Open.t)
CAMLprim value
hm_basis_file_open_submit_inner(value a_flag, value a_mode, value a_bytes) {
    size_t flag = Long_val(a_flag);
    size_t mode = Int64_val(a_mode);
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);

    int flags = flags_of_hemlock_file_flag[flag];

    uint8_t *pathname = (uint8_t *)malloc(sizeof(uint8_t) * (n + 1));
    assert(pathname != NULL);
    memcpy(pathname, bytes, sizeof(uint8_t) * n);
    pathname[n] = '\0';

    hm_opt_error_t oe = HM_OE_NONE;

    hm_user_data_t *user_data = NULL;
    HM_OE(oe, hm_ioring_open_submit(&user_data, pathname, flags, mode, &hm_executor_get()->ioring));

LABEL_OUT:
    return hm_basis_executor_submit_out(oe, user_data);
}

// hm_basis_file_close_submit_inner: Basis.File.t >{os}-> (int * &Basis.File.Close.t)
CAMLprim value
hm_basis_file_close_submit_inner(value a_fd) {
    int fd = Int64_val(a_fd);

    hm_opt_error_t oe = HM_OE_NONE;

    hm_user_data_t *user_data = NULL;
    HM_OE(oe, hm_ioring_close_submit(&user_data, fd, &hm_executor_get()->ioring));

LABEL_OUT:
    return hm_basis_executor_submit_out(oe, user_data);
}

// hm_basis_file_read_submit_inner: uns -> Basis.File.t >{os}-> (int * &Basis.File.Read.inner)
CAMLprim value
hm_basis_file_read_submit_inner(value a_n, value a_fd) {
    uint64_t n = Int64_val(a_n);
    int fd = Int64_val(a_fd);

    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t) * n);
    assert(buffer != NULL);

    hm_opt_error_t oe = HM_OE_NONE;

    hm_user_data_t *user_data = NULL;
    HM_OE(oe, hm_ioring_read_submit(&user_data, fd, buffer, n, &hm_executor_get()->ioring));

LABEL_OUT:
    return hm_basis_executor_submit_out(oe, user_data);
}

// hm_basis_file_write_submit_inner: Stdlib.Bytes.t -> Basis.File.t >{os}->
//   (int * &Basis.File.Write.inner)
CAMLprim value
hm_basis_file_write_submit_inner(value a_bytes, value a_fd) {
    hm_opt_error_t oe = HM_OE_NONE;
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);
    int fd = Int64_val(a_fd);

    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t) * n);
    assert(buffer != NULL);
    memcpy(buffer, bytes, n);

    hm_user_data_t *user_data = NULL;
    HM_OE(oe, hm_ioring_write_submit(&user_data, fd, buffer, n, &hm_executor_get()->ioring));

LABEL_OUT:
    value a_ret = caml_alloc_tuple(2);
    Store_field(a_ret, 0, caml_copy_int64((uint64_t)oe));
    Store_field(a_ret, 1, caml_copy_int64((uint64_t)user_data));

    return a_ret;
}

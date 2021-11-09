#include <errno.h>
#include <fcntl.h>
#include <stddef.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include "executor.h"
#include "ioring.h"

int flags_of_hemlock_file_flag[] = {
    /* R_O   */ O_RDONLY,
    /* W     */ O_WRONLY | O_CREAT,
    /* W_A   */ O_WRONLY | O_APPEND | O_CREAT,
    /* W_AO  */ O_WRONLY | O_APPEND,
    /* W_C   */ O_WRONLY | O_CREAT | O_EXCL,
    /* W_O   */ O_WRONLY,
    /* RW    */ O_RDWR | O_CREAT,
    /* RW_A  */ O_RDWR | O_APPEND| O_CREAT,
    /* RW_AO */ O_RDWR | O_APPEND,
    /* RW_C  */ O_RDWR | O_CREAT | O_EXCL,
    /* RW_O  */ O_RDWR,
};

CAMLprim value
hm_basis_file_setup(value a_unit) {
    hm_opt_error_t oe = HM_OE_NONE;
    HM_OE(oe, hm_executor_setup(hm_executor_get()));

OUT:
    return caml_copy_int64(oe);
}

CAMLprim value
hm_basis_file_teardown(value a_unit) {
    hm_opt_error_t oe = HM_OE_NONE;

    HM_OE(oe, hm_executor_teardown(hm_executor_get()));

OUT:
    return caml_copy_int64(oe);
}

CAMLprim value
hm_basis_file_error_to_string_get_length(value a_error) {
    int error = Int64_val(a_error);

    int length = strlen(strerror(error));

    return caml_copy_int64(length);
}

CAMLprim value
hm_basis_file_error_to_string_inner(value a_n, value a_bytes, value a_error) {
    size_t n = Int64_val(a_n);
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    int error = Int64_val(a_error);

    strncpy(bytes, strerror(error), n);

    return Val_unit;
}

CAMLprim value
hm_basis_file_finalize_result(int result) {
    if (result == -1) {
        result = -errno;
    }

    return caml_copy_int64(result);
}

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
hm_basis_file_close_inner(value a_fd) {
    int fd = Int64_val(a_fd);

    return hm_basis_file_finalize_result(close(fd));
}

CAMLprim value
hm_basis_file_read_inner(value a_bytes, value a_fd) {
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);
    int fd = Int64_val(a_fd);

    int result = read(fd, bytes, n);

    return hm_basis_file_finalize_result(result);
}

CAMLprim value
hm_basis_file_write_inner(value a_bytes, value a_fd) {
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);
    int fd = Int64_val(a_fd);

    int result = write(fd, bytes, n);

    return hm_basis_file_finalize_result(result);
}

CAMLprim value
hm_basis_file_seek_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hm_basis_file_finalize_result(lseek(fd, i, SEEK_CUR));
}

CAMLprim value
hm_basis_file_seek_hd_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hm_basis_file_finalize_result(lseek(fd, i, SEEK_SET));
}

CAMLprim value
hm_basis_file_seek_tl_inner(value a_i, value a_fd) {
    size_t i = Int64_val(a_i);
    int fd = Int64_val(a_fd);

    return hm_basis_file_finalize_result(lseek(fd, i, SEEK_END));
}

CAMLprim value
hm_basis_file_generic_complete_inner(value a_user_data) {
    hm_user_data_t * user_data = (hm_user_data_t *) Int64_val(a_user_data);

    int64_t res = hm_ioring_generic_complete(user_data, &hm_executor_get()->ioring);

    return caml_copy_int64(res);
}

CAMLprim value
hm_basis_file_nop_submit_inner(value a_unit) {
    hm_user_data_t * user_data = hm_ioring_nop_submit(&hm_executor_get()->ioring);

    return caml_copy_int64((uint64_t) user_data);
}

CAMLprim value
hm_basis_file_open_submit_inner(value a_flag, value a_mode, value a_bytes) {
    size_t flag = Long_val(a_flag);
    size_t mode = Int64_val(a_mode);
    uint8_t *bytes = (uint8_t *)Bytes_val(a_bytes);
    size_t n = caml_string_length(a_bytes);

    int flags = flags_of_hemlock_file_flag[flag];

    uint8_t * pathname = (uint8_t *)malloc(sizeof(uint8_t) * (n + 1));
    memcpy (pathname, bytes, sizeof(uint8_t) * n);
    pathname[n] = '\0';

    hm_user_data_t * user_data = hm_ioring_open_submit(pathname, flags, mode,
      &hm_executor_get()->ioring);

    return caml_copy_int64((uint64_t) user_data);
}

value
hm_basis_file_user_data_decref(value a_user_data) {
    hm_user_data_decref((hm_user_data_t *) Int64_val(a_user_data));

    return Val_unit;
}

CAMLprim value
hm_basis_file_user_data_pp(value a_user_data) {
    hm_user_data_t * user_data = (hm_user_data_t *) Int64_val(a_user_data);

    hm_user_data_pp(STDOUT_FILENO, 0, user_data);

    return Val_unit;
}

CAMLprim value
hm_basis_file_cqring_pp(value a_unit) {
    hm_cqring_pp(STDOUT_FILENO, 0, &hm_executor_get()->ioring.cqring);

    return Val_unit;
}

CAMLprim value
hm_basis_file_sqring_pp(value a_unit) {
    hm_sqring_pp(STDOUT_FILENO, 0, &hm_executor_get()->ioring.sqring);

    return Val_unit;
}

CAMLprim value
hm_basis_file_ioring_pp(value a_unit) {
    hm_ioring_pp(STDOUT_FILENO, 0, &hm_executor_get()->ioring);

    return Val_unit;
}
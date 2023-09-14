#include <assert.h>
#include <string.h>
#include <threads.h>

#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include "ioring.h"

#include "executor.h"

thread_local hemlock_executor_t executor = {0};

hemlock_ioring_error_t
hemlock_executor_setup(hemlock_executor_t *executor) {
    return hemlock_ioring_setup(&executor->ioring);
}

void
hemlock_executor_teardown(hemlock_executor_t *executor) {
    hemlock_ioring_teardown(&executor->ioring);
}

hemlock_executor_t *
hemlock_executor_get() {
    return &executor;
}

// hemlock_executor_user_data_decref: !&Basis.File.{Open|Close|Read|Write}.t >{os}-> unit
CAMLprim value
hemlock_executor_user_data_decref(value a_user_data) {
    hemlock_ioring_user_data_decref((hemlock_ioring_user_data_t *)Int64_val(a_user_data));

    return Val_unit;
}

// hemlock_executor_user_data_pp: Basis.File.t -> &Basis.File.{Open|Close|Read|Write}.t >{os}-> unit
CAMLprim value
hemlock_executor_user_data_pp(value a_fd, value a_user_data) {
    hemlock_ioring_user_data_t *user_data = (hemlock_ioring_user_data_t *)Int64_val(a_user_data);
    int fd = Int64_val(a_fd);

    hemlock_ioring_user_data_pp(fd, 0, user_data);

    return Val_unit;
}

// hemlock_executor_complete_inner: !&Basis.File.{Open|Close}.t >{os}-> int
CAMLprim value
hemlock_executor_user_data_complete(value a_user_data) {
    hemlock_ioring_user_data_t *user_data = (hemlock_ioring_user_data_t *)Int64_val(a_user_data);

    hemlock_ioring_error_t error = hemlock_ioring_user_data_complete(
        user_data, &hemlock_executor_get()->ioring);

    return caml_copy_int64(error);
}

CAMLprim value
hemlock_executor_submit_out(hemlock_ioring_error_t error, hemlock_ioring_user_data_t *user_data) {
    value a_ret = caml_alloc_tuple(2);
    Store_field(a_ret, 0, caml_copy_int64((uint64_t)error));
    Store_field(a_ret, 1, caml_copy_int64((uint64_t)user_data));

    return a_ret;
}

// hemlock_executor_nop_submit_inner: unit >{os}-> (int * &Basis.File.Nop.t)
CAMLprim value
hemlock_executor_nop_submit_inner(value a_unit) {
    hemlock_ioring_user_data_t *user_data = NULL;
    hemlock_ioring_error_t error = hemlock_ioring_nop_submit(
        &user_data, &hemlock_executor_get()->ioring);

    return hemlock_executor_submit_out(error, user_data);
}

// hemlock_executor_setup_inner: unit >{os}-> int
CAMLprim value
hemlock_executor_setup_inner(value a_unit) {
    return caml_copy_int64(hemlock_executor_setup(hemlock_executor_get()));
}

// hemlock_executor_teardown_inner: unit >{os}-> unit
CAMLprim value
hemlock_executor_teardown_inner(value a_unit) {
    hemlock_executor_teardown(hemlock_executor_get());

    return Val_unit;
}

// hemlock_executor_cqring_pp: Basis.File.t >{os}-> unit
CAMLprim value
hemlock_executor_cqring_pp(value a_fd) {
    int fd = Int64_val(a_fd);
    hemlock_cqring_pp(fd, 0, &hemlock_executor_get()->ioring.cqring);

    return Val_unit;
}

// hemlock_executor_sqring_pp: Basis.File.t >{os}-> unit
CAMLprim value
hemlock_executor_sqring_pp(value a_fd) {
    int fd = Int64_val(a_fd);
    hemlock_sqring_pp(fd, 0, &hemlock_executor_get()->ioring.sqring);

    return Val_unit;
}

// hemlock_executor_ioring_pp: Basis.File.t >{os}-> unit
CAMLprim value
hemlock_executor_ioring_pp(value a_fd) {
    int fd = Int64_val(a_fd);
    hemlock_ioring_pp(fd, 0, &hemlock_executor_get()->ioring);

    return Val_unit;
}

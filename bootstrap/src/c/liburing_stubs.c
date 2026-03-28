#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/custom.h>

#include <liburing.h>
#include <liburing/io_uring.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include "sockaddr_stubs.h"

/*****************************************************************************
 * Io_uring_sqe (struct io_uring_sqe)
 *****************************************************************************/

static void hemlock__c__liburing__io_uring__sqe__finalize(value v) {
    /* SQE memory is owned by the ring's mmap'd region; do not free. */
    (void)v;
}

static struct custom_operations hemlock__c__liburing__io_uring__sqe__ops = {
    "hemlock__c__liburing__io_uring__sqe",
    hemlock__c__liburing__io_uring__sqe__finalize,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

static value hemlock__c__liburing__io_uring__sqe__alloc(struct io_uring_sqe *sqe) {
    value v = caml_alloc_custom(
        &hemlock__c__liburing__io_uring__sqe__ops, sizeof(struct io_uring_sqe *), 0, 1);
    *((struct io_uring_sqe **)Data_custom_val(v)) = sqe;
    return v;
}

static struct io_uring_sqe *hemlock__c__liburing__io_uring__sqe__of_value(value v) {
    return *((struct io_uring_sqe **)Data_custom_val(v));
}

/*****************************************************************************
 * Io_uring_cqe (struct io_uring_cqe)
 *****************************************************************************/

static void hemlock__c__liburing__io_uring__cqe__finalize(value v) {
    /* CQE memory is owned by the ring; do not free. */
    (void)v;
}

static struct custom_operations hemlock__c__liburing__io_uring__cqe__ops = {
    "hemlock__c__liburing__io_uring__cqe",
    hemlock__c__liburing__io_uring__cqe__finalize,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

static value hemlock__c__liburing__io_uring__cqe__alloc(struct io_uring_cqe *cqe) {
    value v = caml_alloc_custom(
        &hemlock__c__liburing__io_uring__cqe__ops, sizeof(struct io_uring_cqe *), 0, 1);
    *((struct io_uring_cqe **)Data_custom_val(v)) = cqe;
    return v;
}

static struct io_uring_cqe *hemlock__c__liburing__io_uring__cqe__of_value(value v) {
    return *((struct io_uring_cqe **)Data_custom_val(v));
}

/*****************************************************************************
 * Io_uring_params (struct io_uring_params)
 *****************************************************************************/

static struct custom_operations hemlock__c__liburing__io_uring__params__ops = {
    "hemlock__c__liburing__io_uring__params",
    custom_finalize_default,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

static struct io_uring_params *hemlock__c__liburing__io_uring__params__of_value(value v) {
    return (struct io_uring_params *)Data_custom_val(v);
}

CAMLprim value
hemlock__c__liburing__io_uring__params__make(value unit) {
    CAMLparam1(unit);
    value v = caml_alloc_custom(
        &hemlock__c__liburing__io_uring__params__ops,
        sizeof(struct io_uring_params), 0, 1);
    memset(Data_custom_val(v), 0, sizeof(struct io_uring_params));
    CAMLreturn(v);
}

/* Setters */

CAMLprim value
hemlock__c__liburing__io_uring__params__set_flags(value a_flags, value a_params) {
    hemlock__c__liburing__io_uring__params__of_value(a_params)->flags =
        (__u32)Int64_val(a_flags);
    return Val_unit;
}

CAMLprim value
hemlock__c__liburing__io_uring__params__set_sq_thread_cpu(value a_cpu, value a_params) {
    hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_thread_cpu =
        (__u32)Int64_val(a_cpu);
    return Val_unit;
}

CAMLprim value
hemlock__c__liburing__io_uring__params__set_sq_thread_idle(value a_idle, value a_params) {
    hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_thread_idle =
        (__u32)Int64_val(a_idle);
    return Val_unit;
}

CAMLprim value
hemlock__c__liburing__io_uring__params__set_wq_fd(value a_fd, value a_params) {
    hemlock__c__liburing__io_uring__params__of_value(a_params)->wq_fd =
        (__u32)Int64_val(a_fd);
    return Val_unit;
}

/* Getters — top-level fields */

CAMLprim value hemlock__c__liburing__io_uring__params__sq_entries(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_entries;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_entries(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_entries;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__flags(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->flags;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__features(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->features;
    return caml_copy_int64(v);
}

/* Getters — sq_off fields */

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_head(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.head;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_tail(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.tail;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_ring_mask(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.ring_mask;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_ring_entries(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.ring_entries;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_flags(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.flags;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_dropped(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.dropped;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_array(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.array;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__sq_off_user_addr(value a_params) {
    __u64 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->sq_off.user_addr;
    return caml_copy_int64(v);
}

/* Getters — cq_off fields */

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_head(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.head;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_tail(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.tail;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_ring_mask(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.ring_mask;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_ring_entries(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.ring_entries;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_overflow(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.overflow;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_cqes(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.cqes;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_flags(value a_params) {
    __u32 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.flags;
    return caml_copy_int64(v);
}

CAMLprim value hemlock__c__liburing__io_uring__params__cq_off_user_addr(value a_params) {
    __u64 v = hemlock__c__liburing__io_uring__params__of_value(a_params)->cq_off.user_addr;
    return caml_copy_int64(v);
}

/*****************************************************************************
 * Syscalls
 *****************************************************************************/

/* val io_uring_setup : entries -> params -> (fd, errno) result */
CAMLprim value
hemlock__c__liburing__io_uring__setup(value a_entries, value a_params) {
    CAMLparam2(a_entries, a_params);
    CAMLlocal1(v_result);
    struct io_uring_params *p =
        hemlock__c__liburing__io_uring__params__of_value(a_params);
    int ret = (int)syscall(SYS_io_uring_setup, (uint32_t)Int64_val(a_entries), p);
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(errno));
    } else {
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, caml_copy_int64(ret));
    }
    CAMLreturn(v_result);
}

/* val io_uring_enter : fd -> entries -> entries -> enter_flags -> (entries, errno) result */
CAMLprim value
hemlock__c__liburing__io_uring__enter(
    value a_fd, value a_to_submit, value a_min_complete, value a_flags) {
    CAMLparam4(a_fd, a_to_submit, a_min_complete, a_flags);
    CAMLlocal1(v_result);
    int ret = (int)syscall(SYS_io_uring_enter,
        (unsigned int)Int64_val(a_fd),
        (unsigned int)Int64_val(a_to_submit),
        (unsigned int)Int64_val(a_min_complete),
        (unsigned int)Int64_val(a_flags),
        NULL, 0);
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(errno));
    } else {
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, caml_copy_int64(ret));
    }
    CAMLreturn(v_result);
}

/* val io_uring_register : fd -> register_op -> buf option -> nr_args -> (res, errno) result */
CAMLprim value
hemlock__c__liburing__io_uring__register(
    value a_fd, value a_opcode, value a_buf_opt, value a_nr_args) {
    CAMLparam4(a_fd, a_opcode, a_buf_opt, a_nr_args);
    CAMLlocal1(v_result);
    void *arg = (a_buf_opt == Val_int(0)) ? NULL : (void *)Bytes_val(Field(a_buf_opt, 0));
    int ret = (int)syscall(SYS_io_uring_register,
        (unsigned int)Int64_val(a_fd),
        (unsigned int)Int64_val(a_opcode),
        arg,
        (unsigned int)Int64_val(a_nr_args));
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(errno));
    } else {
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, caml_copy_int64(ret));
    }
    CAMLreturn(v_result);
}

/*****************************************************************************
 * Setup flags (IORING_SETUP_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__setup__iopoll(value unit)             { (void)unit; return caml_copy_int64(IORING_SETUP_IOPOLL); }
CAMLprim value hemlock__c__liburing__ioring__setup__sqpoll(value unit)             { (void)unit; return caml_copy_int64(IORING_SETUP_SQPOLL); }
CAMLprim value hemlock__c__liburing__ioring__setup__sq_aff(value unit)             { (void)unit; return caml_copy_int64(IORING_SETUP_SQ_AFF); }
CAMLprim value hemlock__c__liburing__ioring__setup__cqsize(value unit)             { (void)unit; return caml_copy_int64(IORING_SETUP_CQSIZE); }
CAMLprim value hemlock__c__liburing__ioring__setup__clamp(value unit)              { (void)unit; return caml_copy_int64(IORING_SETUP_CLAMP); }
CAMLprim value hemlock__c__liburing__ioring__setup__attach_wq(value unit)          { (void)unit; return caml_copy_int64(IORING_SETUP_ATTACH_WQ); }
CAMLprim value hemlock__c__liburing__ioring__setup__r_disabled(value unit)         { (void)unit; return caml_copy_int64(IORING_SETUP_R_DISABLED); }
CAMLprim value hemlock__c__liburing__ioring__setup__submit_all(value unit)         { (void)unit; return caml_copy_int64(IORING_SETUP_SUBMIT_ALL); }
CAMLprim value hemlock__c__liburing__ioring__setup__coop_taskrun(value unit)       { (void)unit; return caml_copy_int64(IORING_SETUP_COOP_TASKRUN); }
CAMLprim value hemlock__c__liburing__ioring__setup__taskrun_flag(value unit)       { (void)unit; return caml_copy_int64(IORING_SETUP_TASKRUN_FLAG); }
CAMLprim value hemlock__c__liburing__ioring__setup__sqe128(value unit)             { (void)unit; return caml_copy_int64(IORING_SETUP_SQE128); }
CAMLprim value hemlock__c__liburing__ioring__setup__cqe32(value unit)              { (void)unit; return caml_copy_int64(IORING_SETUP_CQE32); }
CAMLprim value hemlock__c__liburing__ioring__setup__single_issuer(value unit)      { (void)unit; return caml_copy_int64(IORING_SETUP_SINGLE_ISSUER); }
CAMLprim value hemlock__c__liburing__ioring__setup__defer_taskrun(value unit)      { (void)unit; return caml_copy_int64(IORING_SETUP_DEFER_TASKRUN); }
CAMLprim value hemlock__c__liburing__ioring__setup__no_mmap(value unit)            { (void)unit; return caml_copy_int64(IORING_SETUP_NO_MMAP); }
CAMLprim value hemlock__c__liburing__ioring__setup__registered_fd_only(value unit) { (void)unit; return caml_copy_int64(IORING_SETUP_REGISTERED_FD_ONLY); }
CAMLprim value hemlock__c__liburing__ioring__setup__no_sqarray(value unit)         { (void)unit; return caml_copy_int64(IORING_SETUP_NO_SQARRAY); }

/*****************************************************************************
 * Feature flags (IORING_FEAT_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__feat__single_mmap(value unit)     { (void)unit; return caml_copy_int64(IORING_FEAT_SINGLE_MMAP); }
CAMLprim value hemlock__c__liburing__ioring__feat__nodrop(value unit)           { (void)unit; return caml_copy_int64(IORING_FEAT_NODROP); }
CAMLprim value hemlock__c__liburing__ioring__feat__submit_stable(value unit)    { (void)unit; return caml_copy_int64(IORING_FEAT_SUBMIT_STABLE); }
CAMLprim value hemlock__c__liburing__ioring__feat__rw_cur_pos(value unit)       { (void)unit; return caml_copy_int64(IORING_FEAT_RW_CUR_POS); }
CAMLprim value hemlock__c__liburing__ioring__feat__cur_personality(value unit)  { (void)unit; return caml_copy_int64(IORING_FEAT_CUR_PERSONALITY); }
CAMLprim value hemlock__c__liburing__ioring__feat__fast_poll(value unit)        { (void)unit; return caml_copy_int64(IORING_FEAT_FAST_POLL); }
CAMLprim value hemlock__c__liburing__ioring__feat__poll_32bits(value unit)      { (void)unit; return caml_copy_int64(IORING_FEAT_POLL_32BITS); }
CAMLprim value hemlock__c__liburing__ioring__feat__sqpoll_nonfixed(value unit)  { (void)unit; return caml_copy_int64(IORING_FEAT_SQPOLL_NONFIXED); }
CAMLprim value hemlock__c__liburing__ioring__feat__ext_arg(value unit)          { (void)unit; return caml_copy_int64(IORING_FEAT_EXT_ARG); }
CAMLprim value hemlock__c__liburing__ioring__feat__native_workers(value unit)   { (void)unit; return caml_copy_int64(IORING_FEAT_NATIVE_WORKERS); }
CAMLprim value hemlock__c__liburing__ioring__feat__rsrc_tags(value unit)        { (void)unit; return caml_copy_int64(IORING_FEAT_RSRC_TAGS); }
CAMLprim value hemlock__c__liburing__ioring__feat__cqe_skip(value unit)         { (void)unit; return caml_copy_int64(IORING_FEAT_CQE_SKIP); }
CAMLprim value hemlock__c__liburing__ioring__feat__linked_file(value unit)      { (void)unit; return caml_copy_int64(IORING_FEAT_LINKED_FILE); }
CAMLprim value hemlock__c__liburing__ioring__feat__reg_reg_ring(value unit)     { (void)unit; return caml_copy_int64(IORING_FEAT_REG_REG_RING); }
CAMLprim value hemlock__c__liburing__ioring__feat__recvsend_bundle(value unit)  { (void)unit; return caml_copy_int64(IORING_FEAT_RECVSEND_BUNDLE); }
CAMLprim value hemlock__c__liburing__ioring__feat__min_timeout(value unit)      { (void)unit; return caml_copy_int64(IORING_FEAT_MIN_TIMEOUT); }

/*****************************************************************************
 * SQE flags (IOSQE_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__iosqe__fixed_file(value unit)       { (void)unit; return caml_copy_int64(IOSQE_FIXED_FILE); }
CAMLprim value hemlock__c__liburing__iosqe__io_drain(value unit)         { (void)unit; return caml_copy_int64(IOSQE_IO_DRAIN); }
CAMLprim value hemlock__c__liburing__iosqe__io_link(value unit)          { (void)unit; return caml_copy_int64(IOSQE_IO_LINK); }
CAMLprim value hemlock__c__liburing__iosqe__io_hardlink(value unit)      { (void)unit; return caml_copy_int64(IOSQE_IO_HARDLINK); }
CAMLprim value hemlock__c__liburing__iosqe__async(value unit)            { (void)unit; return caml_copy_int64(IOSQE_ASYNC); }
CAMLprim value hemlock__c__liburing__iosqe__buffer_select(value unit)    { (void)unit; return caml_copy_int64(IOSQE_BUFFER_SELECT); }
CAMLprim value hemlock__c__liburing__iosqe__cqe_skip_success(value unit) { (void)unit; return caml_copy_int64(IOSQE_CQE_SKIP_SUCCESS); }

/*****************************************************************************
 * CQE flags (IORING_CQE_F_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__cqe_f__buffer(value unit)        { (void)unit; return caml_copy_int64(IORING_CQE_F_BUFFER); }
CAMLprim value hemlock__c__liburing__ioring__cqe_f__more(value unit)          { (void)unit; return caml_copy_int64(IORING_CQE_F_MORE); }
CAMLprim value hemlock__c__liburing__ioring__cqe_f__sock_nonempty(value unit) { (void)unit; return caml_copy_int64(IORING_CQE_F_SOCK_NONEMPTY); }
CAMLprim value hemlock__c__liburing__ioring__cqe_f__notif(value unit)         { (void)unit; return caml_copy_int64(IORING_CQE_F_NOTIF); }

/*****************************************************************************
 * Enter flags (IORING_ENTER_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__enter__getevents(value unit)        { (void)unit; return caml_copy_int64(IORING_ENTER_GETEVENTS); }
CAMLprim value hemlock__c__liburing__ioring__enter__sq_wakeup(value unit)        { (void)unit; return caml_copy_int64(IORING_ENTER_SQ_WAKEUP); }
CAMLprim value hemlock__c__liburing__ioring__enter__sq_wait(value unit)          { (void)unit; return caml_copy_int64(IORING_ENTER_SQ_WAIT); }
CAMLprim value hemlock__c__liburing__ioring__enter__ext_arg(value unit)          { (void)unit; return caml_copy_int64(IORING_ENTER_EXT_ARG); }
CAMLprim value hemlock__c__liburing__ioring__enter__registered_ring(value unit)  { (void)unit; return caml_copy_int64(IORING_ENTER_REGISTERED_RING); }

/*****************************************************************************
 * Register opcodes (IORING_REGISTER_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__register__buffers(value unit)           { (void)unit; return caml_copy_int64(IORING_REGISTER_BUFFERS); }
CAMLprim value hemlock__c__liburing__ioring__unregister__buffers(value unit)         { (void)unit; return caml_copy_int64(IORING_UNREGISTER_BUFFERS); }
CAMLprim value hemlock__c__liburing__ioring__register__files(value unit)             { (void)unit; return caml_copy_int64(IORING_REGISTER_FILES); }
CAMLprim value hemlock__c__liburing__ioring__unregister__files(value unit)           { (void)unit; return caml_copy_int64(IORING_UNREGISTER_FILES); }
CAMLprim value hemlock__c__liburing__ioring__register__eventfd(value unit)           { (void)unit; return caml_copy_int64(IORING_REGISTER_EVENTFD); }
CAMLprim value hemlock__c__liburing__ioring__unregister__eventfd(value unit)         { (void)unit; return caml_copy_int64(IORING_UNREGISTER_EVENTFD); }
CAMLprim value hemlock__c__liburing__ioring__register__files_update(value unit)      { (void)unit; return caml_copy_int64(IORING_REGISTER_FILES_UPDATE); }
CAMLprim value hemlock__c__liburing__ioring__register__eventfd_async(value unit)     { (void)unit; return caml_copy_int64(IORING_REGISTER_EVENTFD_ASYNC); }
CAMLprim value hemlock__c__liburing__ioring__register__probe(value unit)             { (void)unit; return caml_copy_int64(IORING_REGISTER_PROBE); }
CAMLprim value hemlock__c__liburing__ioring__register__personality(value unit)       { (void)unit; return caml_copy_int64(IORING_REGISTER_PERSONALITY); }
CAMLprim value hemlock__c__liburing__ioring__unregister__personality(value unit)     { (void)unit; return caml_copy_int64(IORING_UNREGISTER_PERSONALITY); }
CAMLprim value hemlock__c__liburing__ioring__register__restrictions(value unit)      { (void)unit; return caml_copy_int64(IORING_REGISTER_RESTRICTIONS); }
CAMLprim value hemlock__c__liburing__ioring__register__enable_rings(value unit)      { (void)unit; return caml_copy_int64(IORING_REGISTER_ENABLE_RINGS); }
CAMLprim value hemlock__c__liburing__ioring__register__files2(value unit)            { (void)unit; return caml_copy_int64(IORING_REGISTER_FILES2); }
CAMLprim value hemlock__c__liburing__ioring__register__files_update2(value unit)     { (void)unit; return caml_copy_int64(IORING_REGISTER_FILES_UPDATE2); }
CAMLprim value hemlock__c__liburing__ioring__register__buffers2(value unit)          { (void)unit; return caml_copy_int64(IORING_REGISTER_BUFFERS2); }
CAMLprim value hemlock__c__liburing__ioring__register__buffers_update(value unit)    { (void)unit; return caml_copy_int64(IORING_REGISTER_BUFFERS_UPDATE); }
CAMLprim value hemlock__c__liburing__ioring__register__iowq_aff(value unit)          { (void)unit; return caml_copy_int64(IORING_REGISTER_IOWQ_AFF); }
CAMLprim value hemlock__c__liburing__ioring__unregister__iowq_aff(value unit)        { (void)unit; return caml_copy_int64(IORING_UNREGISTER_IOWQ_AFF); }
CAMLprim value hemlock__c__liburing__ioring__register__iowq_max_workers(value unit)  { (void)unit; return caml_copy_int64(IORING_REGISTER_IOWQ_MAX_WORKERS); }
CAMLprim value hemlock__c__liburing__ioring__register__ring_fds(value unit)          { (void)unit; return caml_copy_int64(IORING_REGISTER_RING_FDS); }
CAMLprim value hemlock__c__liburing__ioring__unregister__ring_fds(value unit)        { (void)unit; return caml_copy_int64(IORING_UNREGISTER_RING_FDS); }
CAMLprim value hemlock__c__liburing__ioring__register__pbuf_ring(value unit)         { (void)unit; return caml_copy_int64(IORING_REGISTER_PBUF_RING); }
CAMLprim value hemlock__c__liburing__ioring__unregister__pbuf_ring(value unit)       { (void)unit; return caml_copy_int64(IORING_UNREGISTER_PBUF_RING); }
CAMLprim value hemlock__c__liburing__ioring__register__sync_cancel(value unit)       { (void)unit; return caml_copy_int64(IORING_REGISTER_SYNC_CANCEL); }
CAMLprim value hemlock__c__liburing__ioring__register__file_alloc_range(value unit)  { (void)unit; return caml_copy_int64(IORING_REGISTER_FILE_ALLOC_RANGE); }
CAMLprim value hemlock__c__liburing__ioring__register__pbuf_status(value unit)       { (void)unit; return caml_copy_int64(IORING_REGISTER_PBUF_STATUS); }
CAMLprim value hemlock__c__liburing__ioring__register__napi(value unit)              { (void)unit; return caml_copy_int64(IORING_REGISTER_NAPI); }
CAMLprim value hemlock__c__liburing__ioring__unregister__napi(value unit)            { (void)unit; return caml_copy_int64(IORING_UNREGISTER_NAPI); }
CAMLprim value hemlock__c__liburing__ioring__register__clock(value unit)             { (void)unit; return caml_copy_int64(IORING_REGISTER_CLOCK); }
CAMLprim value hemlock__c__liburing__ioring__register__clone_buffers(value unit)     { (void)unit; return caml_copy_int64(IORING_REGISTER_CLONE_BUFFERS); }
CAMLprim value hemlock__c__liburing__ioring__register__send_msg_rings(value unit)    { (void)unit; return caml_copy_int64(IORING_REGISTER_SEND_MSG_RINGS); }
CAMLprim value hemlock__c__liburing__ioring__register__last(value unit)              { (void)unit; return caml_copy_int64(IORING_REGISTER_LAST); }

/*****************************************************************************
 * Opcodes (IORING_OP_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__op__nop(value unit)              { (void)unit; return caml_copy_int64(IORING_OP_NOP); }
CAMLprim value hemlock__c__liburing__ioring__op__readv(value unit)            { (void)unit; return caml_copy_int64(IORING_OP_READV); }
CAMLprim value hemlock__c__liburing__ioring__op__writev(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_WRITEV); }
CAMLprim value hemlock__c__liburing__ioring__op__fsync(value unit)            { (void)unit; return caml_copy_int64(IORING_OP_FSYNC); }
CAMLprim value hemlock__c__liburing__ioring__op__read_fixed(value unit)       { (void)unit; return caml_copy_int64(IORING_OP_READ_FIXED); }
CAMLprim value hemlock__c__liburing__ioring__op__write_fixed(value unit)      { (void)unit; return caml_copy_int64(IORING_OP_WRITE_FIXED); }
CAMLprim value hemlock__c__liburing__ioring__op__poll_add(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_POLL_ADD); }
CAMLprim value hemlock__c__liburing__ioring__op__poll_remove(value unit)      { (void)unit; return caml_copy_int64(IORING_OP_POLL_REMOVE); }
CAMLprim value hemlock__c__liburing__ioring__op__sync_file_range(value unit)  { (void)unit; return caml_copy_int64(IORING_OP_SYNC_FILE_RANGE); }
CAMLprim value hemlock__c__liburing__ioring__op__sendmsg(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_SENDMSG); }
CAMLprim value hemlock__c__liburing__ioring__op__recvmsg(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_RECVMSG); }
CAMLprim value hemlock__c__liburing__ioring__op__timeout(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_TIMEOUT); }
CAMLprim value hemlock__c__liburing__ioring__op__timeout_remove(value unit)   { (void)unit; return caml_copy_int64(IORING_OP_TIMEOUT_REMOVE); }
CAMLprim value hemlock__c__liburing__ioring__op__accept(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_ACCEPT); }
CAMLprim value hemlock__c__liburing__ioring__op__async_cancel(value unit)     { (void)unit; return caml_copy_int64(IORING_OP_ASYNC_CANCEL); }
CAMLprim value hemlock__c__liburing__ioring__op__link_timeout(value unit)     { (void)unit; return caml_copy_int64(IORING_OP_LINK_TIMEOUT); }
CAMLprim value hemlock__c__liburing__ioring__op__connect(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_CONNECT); }
CAMLprim value hemlock__c__liburing__ioring__op__fallocate(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_FALLOCATE); }
CAMLprim value hemlock__c__liburing__ioring__op__openat(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_OPENAT); }
CAMLprim value hemlock__c__liburing__ioring__op__close(value unit)            { (void)unit; return caml_copy_int64(IORING_OP_CLOSE); }
CAMLprim value hemlock__c__liburing__ioring__op__files_update(value unit)     { (void)unit; return caml_copy_int64(IORING_OP_FILES_UPDATE); }
CAMLprim value hemlock__c__liburing__ioring__op__statx(value unit)            { (void)unit; return caml_copy_int64(IORING_OP_STATX); }
CAMLprim value hemlock__c__liburing__ioring__op__read(value unit)             { (void)unit; return caml_copy_int64(IORING_OP_READ); }
CAMLprim value hemlock__c__liburing__ioring__op__write(value unit)            { (void)unit; return caml_copy_int64(IORING_OP_WRITE); }
CAMLprim value hemlock__c__liburing__ioring__op__fadvise(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_FADVISE); }
CAMLprim value hemlock__c__liburing__ioring__op__madvise(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_MADVISE); }
CAMLprim value hemlock__c__liburing__ioring__op__send(value unit)             { (void)unit; return caml_copy_int64(IORING_OP_SEND); }
CAMLprim value hemlock__c__liburing__ioring__op__recv(value unit)             { (void)unit; return caml_copy_int64(IORING_OP_RECV); }
CAMLprim value hemlock__c__liburing__ioring__op__openat2(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_OPENAT2); }
CAMLprim value hemlock__c__liburing__ioring__op__epoll_ctl(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_EPOLL_CTL); }
CAMLprim value hemlock__c__liburing__ioring__op__splice(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_SPLICE); }
CAMLprim value hemlock__c__liburing__ioring__op__provide_buffers(value unit)  { (void)unit; return caml_copy_int64(IORING_OP_PROVIDE_BUFFERS); }
CAMLprim value hemlock__c__liburing__ioring__op__remove_buffers(value unit)   { (void)unit; return caml_copy_int64(IORING_OP_REMOVE_BUFFERS); }
CAMLprim value hemlock__c__liburing__ioring__op__tee(value unit)              { (void)unit; return caml_copy_int64(IORING_OP_TEE); }
CAMLprim value hemlock__c__liburing__ioring__op__shutdown(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_SHUTDOWN); }
CAMLprim value hemlock__c__liburing__ioring__op__renameat(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_RENAMEAT); }
CAMLprim value hemlock__c__liburing__ioring__op__unlinkat(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_UNLINKAT); }
CAMLprim value hemlock__c__liburing__ioring__op__mkdirat(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_MKDIRAT); }
CAMLprim value hemlock__c__liburing__ioring__op__symlinkat(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_SYMLINKAT); }
CAMLprim value hemlock__c__liburing__ioring__op__linkat(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_LINKAT); }
CAMLprim value hemlock__c__liburing__ioring__op__msg_ring(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_MSG_RING); }
CAMLprim value hemlock__c__liburing__ioring__op__fsetxattr(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_FSETXATTR); }
CAMLprim value hemlock__c__liburing__ioring__op__setxattr(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_SETXATTR); }
CAMLprim value hemlock__c__liburing__ioring__op__fgetxattr(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_FGETXATTR); }
CAMLprim value hemlock__c__liburing__ioring__op__getxattr(value unit)         { (void)unit; return caml_copy_int64(IORING_OP_GETXATTR); }
CAMLprim value hemlock__c__liburing__ioring__op__socket(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_SOCKET); }
CAMLprim value hemlock__c__liburing__ioring__op__uring_cmd(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_URING_CMD); }
CAMLprim value hemlock__c__liburing__ioring__op__send_zc(value unit)          { (void)unit; return caml_copy_int64(IORING_OP_SEND_ZC); }
CAMLprim value hemlock__c__liburing__ioring__op__sendmsg_zc(value unit)       { (void)unit; return caml_copy_int64(IORING_OP_SENDMSG_ZC); }
CAMLprim value hemlock__c__liburing__ioring__op__read_multishot(value unit)   { (void)unit; return caml_copy_int64(IORING_OP_READ_MULTISHOT); }
CAMLprim value hemlock__c__liburing__ioring__op__waitid(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_WAITID); }
CAMLprim value hemlock__c__liburing__ioring__op__futex_wait(value unit)       { (void)unit; return caml_copy_int64(IORING_OP_FUTEX_WAIT); }
CAMLprim value hemlock__c__liburing__ioring__op__futex_wake(value unit)       { (void)unit; return caml_copy_int64(IORING_OP_FUTEX_WAKE); }
CAMLprim value hemlock__c__liburing__ioring__op__futex_waitv(value unit)      { (void)unit; return caml_copy_int64(IORING_OP_FUTEX_WAITV); }
CAMLprim value hemlock__c__liburing__ioring__op__fixed_fd_install(value unit) { (void)unit; return caml_copy_int64(IORING_OP_FIXED_FD_INSTALL); }
CAMLprim value hemlock__c__liburing__ioring__op__ftruncate(value unit)        { (void)unit; return caml_copy_int64(IORING_OP_FTRUNCATE); }
CAMLprim value hemlock__c__liburing__ioring__op__bind(value unit)             { (void)unit; return caml_copy_int64(IORING_OP_BIND); }
CAMLprim value hemlock__c__liburing__ioring__op__listen(value unit)           { (void)unit; return caml_copy_int64(IORING_OP_LISTEN); }
CAMLprim value hemlock__c__liburing__ioring__op__last(value unit)             { (void)unit; return caml_copy_int64(IORING_OP_LAST); }

/*****************************************************************************
 * Fsync flags (IORING_FSYNC_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__fsync__datasync(value unit) { (void)unit; return caml_copy_int64(IORING_FSYNC_DATASYNC); }

/*****************************************************************************
 * Timeout flags (IORING_TIMEOUT_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__timeout__abs(value unit)           { (void)unit; return caml_copy_int64(IORING_TIMEOUT_ABS); }
CAMLprim value hemlock__c__liburing__ioring__timeout__update(value unit)        { (void)unit; return caml_copy_int64(IORING_TIMEOUT_UPDATE); }
CAMLprim value hemlock__c__liburing__ioring__timeout__boottime(value unit)      { (void)unit; return caml_copy_int64(IORING_TIMEOUT_BOOTTIME); }
CAMLprim value hemlock__c__liburing__ioring__timeout__realtime(value unit)      { (void)unit; return caml_copy_int64(IORING_TIMEOUT_REALTIME); }
CAMLprim value hemlock__c__liburing__ioring__timeout__link_update(value unit)   { (void)unit; return caml_copy_int64(IORING_LINK_TIMEOUT_UPDATE); }
CAMLprim value hemlock__c__liburing__ioring__timeout__etime_success(value unit) { (void)unit; return caml_copy_int64(IORING_TIMEOUT_ETIME_SUCCESS); }
CAMLprim value hemlock__c__liburing__ioring__timeout__multishot(value unit)     { (void)unit; return caml_copy_int64(IORING_TIMEOUT_MULTISHOT); }
CAMLprim value hemlock__c__liburing__ioring__timeout__clock_mask(value unit)    { (void)unit; return caml_copy_int64(IORING_TIMEOUT_CLOCK_MASK); }
CAMLprim value hemlock__c__liburing__ioring__timeout__update_mask(value unit)   { (void)unit; return caml_copy_int64(IORING_TIMEOUT_UPDATE_MASK); }

/*****************************************************************************
 * Async cancel flags (IORING_ASYNC_CANCEL_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__async_cancel__all(value unit)      { (void)unit; return caml_copy_int64(IORING_ASYNC_CANCEL_ALL); }
CAMLprim value hemlock__c__liburing__ioring__async_cancel__fd(value unit)       { (void)unit; return caml_copy_int64(IORING_ASYNC_CANCEL_FD); }
CAMLprim value hemlock__c__liburing__ioring__async_cancel__any(value unit)      { (void)unit; return caml_copy_int64(IORING_ASYNC_CANCEL_ANY); }
CAMLprim value hemlock__c__liburing__ioring__async_cancel__fd_fixed(value unit) { (void)unit; return caml_copy_int64(IORING_ASYNC_CANCEL_FD_FIXED); }
CAMLprim value hemlock__c__liburing__ioring__async_cancel__userdata(value unit) { (void)unit; return caml_copy_int64(IORING_ASYNC_CANCEL_USERDATA); }
CAMLprim value hemlock__c__liburing__ioring__async_cancel__op(value unit)       { (void)unit; return caml_copy_int64(IORING_ASYNC_CANCEL_OP); }

/*****************************************************************************
 * Recv/send flags (IORING_RECVSEND_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__recvsend__poll_first(value unit) { (void)unit; return caml_copy_int64(IORING_RECVSEND_POLL_FIRST); }
CAMLprim value hemlock__c__liburing__ioring__recvsend__fixed_buf(value unit)  { (void)unit; return caml_copy_int64(IORING_RECVSEND_FIXED_BUF); }
CAMLprim value hemlock__c__liburing__ioring__recvsend__bundle(value unit)     { (void)unit; return caml_copy_int64(IORING_RECVSEND_BUNDLE); }

/*****************************************************************************
 * Poll flags (IORING_POLL_ADD_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__poll__add_multi(value unit)        { (void)unit; return caml_copy_int64(IORING_POLL_ADD_MULTI); }
CAMLprim value hemlock__c__liburing__ioring__poll__update_events(value unit)    { (void)unit; return caml_copy_int64(IORING_POLL_UPDATE_EVENTS); }
CAMLprim value hemlock__c__liburing__ioring__poll__update_user_data(value unit) { (void)unit; return caml_copy_int64(IORING_POLL_UPDATE_USER_DATA); }
CAMLprim value hemlock__c__liburing__ioring__poll__add_level(value unit)        { (void)unit; return caml_copy_int64(IORING_POLL_ADD_LEVEL); }

/*****************************************************************************
 * Msg ring op types (IORING_MSG_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__msg__data(value unit)    { (void)unit; return caml_copy_int64(IORING_MSG_DATA); }
CAMLprim value hemlock__c__liburing__ioring__msg__send_fd(value unit) { (void)unit; return caml_copy_int64(IORING_MSG_SEND_FD); }

/*****************************************************************************
 * Send ZC flags (IORING_SEND_ZC_*)
 *****************************************************************************/

CAMLprim value hemlock__c__liburing__ioring__send_zc__report_usage(value unit) { (void)unit; return caml_copy_int64(IORING_SEND_ZC_REPORT_USAGE); }

/*****************************************************************************
 * Io_uring (struct io_uring)
 *****************************************************************************/

static void hemlock__c__liburing__io_uring__finalize(value v) {
    struct io_uring *ring = *((struct io_uring **)Data_custom_val(v));
    if (ring != NULL) {
        io_uring_queue_exit(ring);
        free(ring);
        *((struct io_uring **)Data_custom_val(v)) = NULL;
    }
}

static struct custom_operations hemlock__c__liburing__io_uring__ops = {
    "hemlock__c__liburing__io_uring",
    hemlock__c__liburing__io_uring__finalize,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

static value hemlock__c__liburing__io_uring__alloc(struct io_uring *ring) {
    value v = caml_alloc_custom(
        &hemlock__c__liburing__io_uring__ops, sizeof(struct io_uring *), 0, 1);
    *((struct io_uring **)Data_custom_val(v)) = ring;
    return v;
}

static struct io_uring *hemlock__c__liburing__io_uring__of_value(value v) {
    return *((struct io_uring **)Data_custom_val(v));
}

/* val queue_init: entries -> flags -> (t, int) result
 *
 * Allocates and initialises a struct io_uring on the heap.
 * Returns Ok ring or Error errno (positive). */
CAMLprim value
hemlock__c__liburing__io_uring__queue_init(value a_entries, value a_flags) {
    CAMLparam2(a_entries, a_flags);
    CAMLlocal2(v_ring, v_result);

    struct io_uring *ring = malloc(sizeof(struct io_uring));
    if (ring == NULL) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(12 /* ENOMEM */));
        CAMLreturn(v_result);
    }

    int ret = io_uring_queue_init(Int64_val(a_entries), ring, Int64_val(a_flags));
    if (ret < 0) {
        free(ring);
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(-ret));
        CAMLreturn(v_result);
    }

    v_ring = hemlock__c__liburing__io_uring__alloc(ring);
    v_result = caml_alloc(1, 0);
    Store_field(v_result, 0, v_ring);
    CAMLreturn(v_result);
}

/* val res: t -> (int, Errno.errno) result */
CAMLprim value
hemlock__c__liburing__io_uring__cqe__res(value a_cqe) {
    CAMLparam1(a_cqe);
    CAMLlocal1(v_result);
    struct io_uring_cqe *cqe = hemlock__c__liburing__io_uring__cqe__of_value(a_cqe);
    int res = cqe->res;
    if (res < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(-res));
    } else {
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, caml_copy_int64(res));
    }
    CAMLreturn(v_result);
}

/* val flags: t -> flags */
CAMLprim value
hemlock__c__liburing__io_uring__cqe__flags(value a_cqe) {
    struct io_uring_cqe *cqe = hemlock__c__liburing__io_uring__cqe__of_value(a_cqe);
    __u32 flags = cqe->flags;
    return caml_copy_int64(flags);
}

/* val get_data64: t -> user_data */
CAMLprim value
hemlock__c__liburing__io_uring__cqe__get_data64(value a_cqe) {
    struct io_uring_cqe *cqe = hemlock__c__liburing__io_uring__cqe__of_value(a_cqe);
    uint64_t data = io_uring_cqe_get_data64(cqe);
    return caml_copy_int64(data);
}

/*****************************************************************************
 * Io_uring continued
 *****************************************************************************/

/* val get_sqe: t -> Io_uring_sqe.t option */
CAMLprim value
hemlock__c__liburing__io_uring__get_sqe(value a_ring) {
    CAMLparam1(a_ring);
    CAMLlocal2(v_sqe, v_some);

    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    if (sqe == NULL) {
        CAMLreturn(Val_int(0)); /* None */
    }
    v_sqe = hemlock__c__liburing__io_uring__sqe__alloc(sqe);
    v_some = caml_alloc(1, 0);
    Store_field(v_some, 0, v_sqe);
    CAMLreturn(v_some);
}

/* val submit: t -> (int, int) result */
CAMLprim value
hemlock__c__liburing__io_uring__submit(value a_ring) {
    CAMLparam1(a_ring);
    CAMLlocal1(v_result);

    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    int ret = io_uring_submit(ring);
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(-ret));
    } else {
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, caml_copy_int64(ret));
    }
    CAMLreturn(v_result);
}

/* val submit_and_wait: wait_nr -> t -> (int, int) result */
CAMLprim value
hemlock__c__liburing__io_uring__submit_and_wait(value a_wait_nr, value a_ring) {
    CAMLparam2(a_wait_nr, a_ring);
    CAMLlocal1(v_result);

    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    int ret = io_uring_submit_and_wait(ring, Int64_val(a_wait_nr));
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(-ret));
    } else {
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, caml_copy_int64(ret));
    }
    CAMLreturn(v_result);
}

/* val wait_cqe: t -> (Io_uring_cqe.t, int) result */
CAMLprim value
hemlock__c__liburing__io_uring__wait_cqe(value a_ring) {
    CAMLparam1(a_ring);
    CAMLlocal2(v_cqe, v_result);

    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    struct io_uring_cqe *cqe = NULL;
    int ret = io_uring_wait_cqe(ring, &cqe);
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(-ret));
    } else {
        v_cqe = hemlock__c__liburing__io_uring__cqe__alloc(cqe);
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, v_cqe);
    }
    CAMLreturn(v_result);
}

/* val peek_cqe: t -> (Io_uring_cqe.t, int) result */
CAMLprim value
hemlock__c__liburing__io_uring__peek_cqe(value a_ring) {
    CAMLparam1(a_ring);
    CAMLlocal2(v_cqe, v_result);

    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    struct io_uring_cqe *cqe = NULL;
    int ret = io_uring_peek_cqe(ring, &cqe);
    if (ret < 0) {
        v_result = caml_alloc(1, 1);
        Store_field(v_result, 0, Val_int(-ret));
    } else {
        v_cqe = hemlock__c__liburing__io_uring__cqe__alloc(cqe);
        v_result = caml_alloc(1, 0);
        Store_field(v_result, 0, v_cqe);
    }
    CAMLreturn(v_result);
}

/* val cqe_seen: Io_uring_cqe.t -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__cqe__seen(value a_cqe, value a_ring) {
    CAMLparam2(a_cqe, a_ring);
    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    struct io_uring_cqe *cqe = hemlock__c__liburing__io_uring__cqe__of_value(a_cqe);
    io_uring_cqe_seen(ring, cqe);
    CAMLreturn(Val_unit);
}

/* val sq_ready: t -> int */
CAMLprim value
hemlock__c__liburing__io_uring__sq_ready(value a_ring) {
    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    unsigned int n = io_uring_sq_ready(ring);
    return caml_copy_int64(n);
}

/* val cq_ready: t -> int */
CAMLprim value
hemlock__c__liburing__io_uring__cq_ready(value a_ring) {
    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    unsigned int n = io_uring_cq_ready(ring);
    return caml_copy_int64(n);
}

/*****************************************************************************
 * Io_uring_sqe operations
 *****************************************************************************/

/* val set_data64: user_data -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__set_data64(value a_data, value a_sqe) {
    CAMLparam2(a_data, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_sqe_set_data64(sqe, (uint64_t)Int64_val(a_data));
    CAMLreturn(Val_unit);
}

/* val prep_nop: t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_nop(value a_sqe) {
    CAMLparam1(a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_nop(sqe);
    CAMLreturn(Val_unit);
}

/* val prep_read: offset -> nbytes -> buf -> fd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_read(
    value a_offset, value a_nbytes, value a_buf, value a_fd, value a_sqe) {
    CAMLparam5(a_offset, a_nbytes, a_buf, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_read(sqe, Int64_val(a_fd),
        Bytes_val(a_buf), Int64_val(a_nbytes), Int64_val(a_offset));
    CAMLreturn(Val_unit);
}

/* val prep_write: offset -> nbytes -> buf -> fd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_write(
    value a_offset, value a_nbytes, value a_buf, value a_fd, value a_sqe) {
    CAMLparam5(a_offset, a_nbytes, a_buf, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_write(sqe, Int64_val(a_fd),
        Bytes_val(a_buf), Int64_val(a_nbytes), Int64_val(a_offset));
    CAMLreturn(Val_unit);
}

/* val prep_openat: mode -> flags -> path -> dfd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_openat(
    value a_mode, value a_flags, value a_path, value a_dfd, value a_sqe) {
    CAMLparam5(a_mode, a_flags, a_path, a_dfd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_openat(sqe, Int64_val(a_dfd),
        String_val(a_path), Int64_val(a_flags), Int64_val(a_mode));
    CAMLreturn(Val_unit);
}

/* val prep_close: fd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_close(value a_fd, value a_sqe) {
    CAMLparam2(a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_close(sqe, Int64_val(a_fd));
    CAMLreturn(Val_unit);
}

/* val prep_fsync: fsync_flags -> fd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_fsync(value a_fsync_flags, value a_fd, value a_sqe) {
    CAMLparam3(a_fsync_flags, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_fsync(sqe, Int64_val(a_fd), Int64_val(a_fsync_flags));
    CAMLreturn(Val_unit);
}

/* val prep_poll_add: poll_mask -> fd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_poll_add(value a_poll_mask, value a_fd, value a_sqe) {
    CAMLparam3(a_poll_mask, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_poll_add(sqe, Int64_val(a_fd), Int64_val(a_poll_mask));
    CAMLreturn(Val_unit);
}

/* val prep_cancel: flags -> user_data -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_cancel64(value a_flags, value a_user_data, value a_sqe) {
    CAMLparam3(a_flags, a_user_data, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_cancel64(sqe, (uint64_t)Int64_val(a_user_data), Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val io_uring_prep_cancel_fd: flags -> fd -> io_uring_sqe -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_cancel_fd(value a_flags, value a_fd, value a_sqe) {
    CAMLparam3(a_flags, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_cancel_fd(sqe, Int64_val(a_fd), (unsigned int)Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_connect: Sockaddr.t -> fd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_connect(value a_sockaddr, value a_fd, value a_sqe) {
    CAMLparam3(a_sockaddr, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    struct hemlock_sockaddr *sa = hemlock__c__sockaddr__of_value(a_sockaddr);
    io_uring_prep_connect(sqe, Int64_val(a_fd),
        (const struct sockaddr *)sa->data, sa->len);
    CAMLreturn(Val_unit);
}

/* val prep_accept: flags -> Sockaddr.t -> fd -> t -> unit
 * Pass a value from Sockaddr.sockaddr_*_alloc; the kernel fills in the peer
 * address and updates sa->len.  Keep the Sockaddr.t value alive until the
 * CQE arrives, then read the address back with Sockaddr.sockaddr_*_* getters. */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_accept(
    value a_flags, value a_sockaddr, value a_fd, value a_sqe) {
    CAMLparam4(a_flags, a_sockaddr, a_fd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    struct hemlock_sockaddr *sa = hemlock__c__sockaddr__of_value(a_sockaddr);
    io_uring_prep_accept(sqe, Int64_val(a_fd),
        (struct sockaddr *)sa->data, &sa->len, Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_recv: flags -> len -> buf -> sockfd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_recv(
    value a_flags, value a_len, value a_buf, value a_sockfd, value a_sqe) {
    CAMLparam5(a_flags, a_len, a_buf, a_sockfd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_recv(sqe, Int64_val(a_sockfd),
        Bytes_val(a_buf), Int64_val(a_len), Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_send: flags -> len -> buf -> sockfd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_send(
    value a_flags, value a_len, value a_buf, value a_sockfd, value a_sqe) {
    CAMLparam5(a_flags, a_len, a_buf, a_sockfd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_send(sqe, Int64_val(a_sockfd),
        Bytes_val(a_buf), Int64_val(a_len), Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_timeout: flags -> count -> tv_nsec -> tv_sec -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_timeout(
    value a_flags, value a_count, value a_tv_nsec, value a_tv_sec, value a_sqe) {
    CAMLparam5(a_flags, a_count, a_tv_nsec, a_tv_sec, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    struct __kernel_timespec ts = {
        .tv_sec  = (long long)Int64_val(a_tv_sec),
        .tv_nsec = (long long)Int64_val(a_tv_nsec)
    };
    io_uring_prep_timeout(sqe, &ts, Int64_val(a_count), Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_link_timeout: flags -> tv_nsec -> tv_sec -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_link_timeout(
    value a_flags, value a_tv_nsec, value a_tv_sec, value a_sqe) {
    CAMLparam4(a_flags, a_tv_nsec, a_tv_sec, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    struct __kernel_timespec ts = {
        .tv_sec  = (long long)Int64_val(a_tv_sec),
        .tv_nsec = (long long)Int64_val(a_tv_nsec)
    };
    io_uring_prep_link_timeout(sqe, &ts, Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_splice:
 *   splice_flags -> nbytes -> off_out -> fd_out -> off_in -> fd_in -> t -> unit
 *
 * 7 arguments requires bytecode + native split. */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_splice_native(
    value a_splice_flags, value a_nbytes,
    value a_off_out, value a_fd_out,
    value a_off_in, value a_fd_in,
    value a_sqe) {
    CAMLparam5(a_splice_flags, a_nbytes, a_off_out, a_fd_out, a_off_in);
    CAMLxparam2(a_fd_in, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_splice(sqe,
        Int64_val(a_fd_in),  Int64_val(a_off_in),
        Int64_val(a_fd_out), Int64_val(a_off_out),
        Int64_val(a_nbytes), Int64_val(a_splice_flags));
    CAMLreturn(Val_unit);
}

CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_splice(value *argv, int argn) {
    (void)argn;
    return hemlock__c__liburing__io_uring__sqe__prep_splice_native(
        argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}

/* val prep_renameat:
 *   flags -> newpath -> newdirfd -> oldpath -> olddirfd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_renameat_native(
    value a_flags, value a_newpath, value a_newdirfd,
    value a_oldpath, value a_olddirfd, value a_sqe) {
    CAMLparam5(a_flags, a_newpath, a_newdirfd, a_oldpath, a_olddirfd);
    CAMLxparam1(a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_renameat(sqe,
        Int64_val(a_olddirfd), String_val(a_oldpath),
        Int64_val(a_newdirfd), String_val(a_newpath),
        Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_renameat(value *argv, int argn) {
    (void)argn;
    return hemlock__c__liburing__io_uring__sqe__prep_renameat_native(
        argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

/* val prep_unlinkat: flags -> path -> dfd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_unlinkat(
    value a_flags, value a_path, value a_dfd, value a_sqe) {
    CAMLparam4(a_flags, a_path, a_dfd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_unlinkat(sqe, Int64_val(a_dfd), String_val(a_path), Int64_val(a_flags));
    CAMLreturn(Val_unit);
}

/* val prep_mkdirat: mode -> path -> dfd -> t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__sqe__prep_mkdirat(
    value a_mode, value a_path, value a_dfd, value a_sqe) {
    CAMLparam4(a_mode, a_path, a_dfd, a_sqe);
    struct io_uring_sqe *sqe = hemlock__c__liburing__io_uring__sqe__of_value(a_sqe);
    io_uring_prep_mkdirat(sqe, Int64_val(a_dfd), String_val(a_path), Int64_val(a_mode));
    CAMLreturn(Val_unit);
}

/* val queue_exit: t -> unit */
CAMLprim value
hemlock__c__liburing__io_uring__queue_exit(value a_ring) {
    CAMLparam1(a_ring);
    struct io_uring *ring = hemlock__c__liburing__io_uring__of_value(a_ring);
    if (ring != NULL) {
        io_uring_queue_exit(ring);
        free(ring);
        *((struct io_uring **)Data_custom_val(a_ring)) = NULL;
    }
    CAMLreturn(Val_unit);
}

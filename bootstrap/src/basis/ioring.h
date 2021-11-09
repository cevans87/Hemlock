#pragma once
#include <linux/io_uring.h>
#include <sys/types.h>

#include "common.h"

typedef struct {
    struct io_uring_cqe cqe;
    union {
        uint8_t *buffer;
        uint8_t *pathname;
    };
    uint8_t opcode;
    uint8_t refcount;
} hm_user_data_t;
void hm_user_data_pp(int fd, int indent, hm_user_data_t *user_data);
void hm_user_data_decref(hm_user_data_t *user_data);

typedef struct {
    unsigned *head;
    unsigned *tail;
    unsigned *ring_entries;
    unsigned *ring_mask;
    unsigned *flags;
    unsigned *array;
    struct io_uring_sqe *sqes;
} hm_sqring_t;
void hm_sqring_pp(int fd, int indent, hm_sqring_t *sqring);

typedef struct {
    unsigned *head;
    unsigned *tail;
    unsigned *ring_entries;
    unsigned *ring_mask;
    struct io_uring_cqe *cqes;
} hm_cqring_t;
void hm_cqring_pp(int fd, int indent, hm_cqring_t *cqring);

typedef struct {
    struct io_uring_params params;
    int fd;
    void *vm;
    hm_sqring_t sqring;
    hm_cqring_t cqring;
} hm_ioring_t;
void hm_ioring_pp(int fd, int indent, hm_ioring_t *ioring);
hm_opt_error_t hm_ioring_setup(hm_ioring_t *ioring);
hm_opt_error_t hm_ioring_teardown(hm_ioring_t *ioring);
hm_opt_error_t hm_ioring_enter(uint32_t *n_complete, uint32_t min_complete, hm_ioring_t *ioring);
int hm_ioring_generic_complete(hm_user_data_t *user_data, hm_ioring_t *ioring);
hm_user_data_t *hm_ioring_nop_submit(hm_ioring_t *ioring);
hm_user_data_t * hm_ioring_open_submit(uint8_t * pathname, int flags, mode_t mode,
  hm_ioring_t * ioring);
hm_user_data_t * hm_ioring_close_submit(int fd, hm_ioring_t * ioring);

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/io_uring.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <threads.h>
#include <unistd.h>

#include "common.h"
#include "ioring.h"

// FIXME these need to be cross-platform.
#define rmb() __asm__ __volatile__("":::"memory")
#define wmb() __asm__ __volatile__("":::"memory")

int io_uring_setup(uint32_t entries, struct io_uring_params *p) {
    return syscall(__NR_io_uring_setup, entries, p);
}

int io_uring_enter(unsigned int fd, uint32_t to_submit, uint32_t min_complete, uint32_t flags) {
    return syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags, (size_t) NULL);
}

void hm_array_pp(int fd, int indent, unsigned len, unsigned * array) {
    bool well_formed = true;
    for (size_t i = 0; i < len && well_formed; i++) {
        if (array[i] != i) {
            well_formed = false;
        }
    }
    if (well_formed) {
        dprintf(fd, "%*sarray: [0 ... %u]\n" , indent, "", len - 1);
    } else {
        dprintf(fd, "%*sarray: [ %2u" , indent, "", array[0]);
        for (size_t i = 1; i < len; i++) {
            if (0 == i % 8) {
                dprintf(fd, "\n%*s", indent + 9, "");
            }
            dprintf(fd, ", %2u", array[i]);
        }
        dprintf(fd, " ]\n");
    }
}

void hm_opcode_pp(int fd, int indent, unsigned opcode) {
    switch (opcode) {
    case IORING_OP_NOP:
      dprintf(fd, "%*sopcode:   IORING_OP_NOP\n", indent, "");
      break;
    case IORING_OP_OPENAT:
      dprintf(fd, "%*sopcode:   IORING_OP_OPENAT\n", indent, "");
      break;
    case IORING_OP_CLOSE:
      dprintf(fd, "%*sopcode:   IORING_OP_CLOSE\n", indent, "");
      break;
    case IORING_OP_READ:
      dprintf(fd, "%*sopcode:   IORING_OP_READ\n", indent, "");
      break;
    case IORING_OP_WRITE:
      dprintf(fd, "%*sopcode:   IORING_OP_WRITE\n", indent, "");
      break;
    default:
      dprintf(fd, "%*sopcode:   %i\n", indent, "", opcode);
      break;
    };
}

void hm_pathname_pp(int fd, int indent,  uint8_t * pathname) {
    if (pathname == NULL) {
        dprintf(fd, "%*spathname: NULL\n", indent, "");
    } else {
        dprintf(fd, "%*spathname: \"%s\"\n", indent, "", pathname);
    }
}

void hm_sqe_pp(int fd, int indent, struct io_uring_sqe * sqe) {
    if (sqe == NULL) {
        dprintf(fd, "%*ssqe: NULL\n", indent, "");
    } else {
        dprintf(fd,
            "%*ssqe:\n"
            "%*s  flags:    %u\n"
            "%*s  ioprio:   %u\n"
            "%*s  fd:       %i\n"
            ,
            indent, "",
            indent, "", sqe->flags,
            indent, "", sqe->ioprio,
            indent, "", sqe->fd
        );
        hm_opcode_pp(fd, indent + 2, sqe->opcode);
        hm_user_data_pp(fd, indent + 2, (hm_user_data_t *)sqe->user_data);
    }
}

void hm_cqe_pp(int fd, int indent, struct io_uring_cqe * cqe) {
    if (cqe == NULL) {
        dprintf(fd, "%*scqe: NULL\n", indent, "");
    } else {
        dprintf(fd,
            "%*scqe:\n"
            "%*s  res:       %i\n"
            "%*s  flags:     %u\n"
            ,
            indent, "",
            indent, "", cqe->res,
            indent, "", cqe->flags
        );
        if (cqe->user_data != 0 &&
          cqe->user_data == ((hm_user_data_t *)cqe->user_data)->cqe.user_data) {
            dprintf(fd, "%*suser_data: <same as parent>\n", indent + 2, "");
        } else {
            hm_user_data_pp(fd, indent + 2, (hm_user_data_t *)cqe->user_data);
        }
    }
}

void hm_user_data_pp(int fd, int indent, hm_user_data_t * user_data) {
    if (user_data == NULL) {
        dprintf(fd, "%*suser_data: NULL\n", indent, "");
    } else {
        dprintf(fd,
            "%*suser_data:\n"
            "%*s  refcount: %u\n",
            indent, "",
            indent, "", user_data->refcount
        );
        switch (user_data->opcode) {
        case IORING_OP_OPENAT:
            hm_pathname_pp(fd, indent + 2, user_data->pathname);
            break;
        default:
            break;
        }
        hm_opcode_pp(fd, indent + 2, user_data->opcode);
        hm_cqe_pp(fd, indent + 2, &user_data->cqe);
    }
}

void hm_sqring_pp(int fd, int indent, hm_sqring_t * sqring) {
    if (sqring == NULL) {
        dprintf(fd, "%*ssqring: NULL\n", indent, "");
    } else {
        dprintf(fd,
            "%*ssqring:\n"
            "%*s  head:         %u\n"
            "%*s  tail:         %u\n"
            "%*s  ring_entries: %u\n"
            "%*s  ring_mask:    %u\n"
            "%*s  flags:        %u\n"
            ,
            indent, "",
            indent, "", *sqring->head,
            indent, "", *sqring->tail,
            indent, "", *sqring->ring_entries,
            indent, "", *sqring->ring_mask,
            indent, "", *sqring->flags
        );
        hm_array_pp(fd, indent + 2, *sqring->ring_entries, sqring->array);

        dprintf(fd, "%*s  sqes:\n", indent, "");
        for (unsigned head = *sqring->head; head < *sqring->tail; head++) {
            hm_sqe_pp(fd, indent + 4, &sqring->sqes[head & *sqring->ring_mask]);
        }
    }
}

void hm_cqring_pp(int fd, int indent, hm_cqring_t * cqring) {
    if (cqring == NULL) {
        dprintf(fd, "%*scqring: NULL\n", indent, "");
    } else {
        dprintf(fd,
            "%*scqring:\n"
            "%*s  head:         %u\n"
            "%*s  tail:         %u\n"
            "%*s  ring_entries: %u\n"
            "%*s  ring_mask:    %u\n"
            "%*s  cqes:\n"
            ,
            indent, "",
            indent, "", *cqring->head,
            indent, "", *cqring->tail,
            indent, "", *cqring->ring_entries,
            indent, "", *cqring->ring_mask,
            indent, ""
        );
        for (unsigned head = *cqring->head; head < *cqring->tail; head++) {
            hm_cqe_pp(fd, indent + 4, &cqring->cqes[head & *cqring->ring_mask]);
        }
    }
}

void
hm_ioring_pp(int fd, int indent, hm_ioring_t* ioring) {
    if (ioring == NULL) {
        dprintf(fd, "%*sioring: NULL\n", indent, "");
    } else {
        dprintf(fd,
            "%*sioring:\n"
            "%*s  fd:           %i\n"
            ,
            indent, "",
            indent, "", ioring->fd
        );
        hm_cqring_pp(fd, indent + 2, &ioring->cqring);
        hm_sqring_pp(fd, indent + 2, &ioring->sqring);
    }
}

hm_opt_error_t
hm_user_data_create(hm_user_data_t ** user_data) {
    hm_opt_error_t oe = HM_OE_NONE;
    HM_RES(*user_data, (hm_user_data_t *)calloc(1, sizeof(hm_user_data_t)));

    // Refs from kernel and ocaml.
    (*user_data)->refcount = 2;

OUT:
    return oe;
}

void
hm_user_data_decref(hm_user_data_t * user_data) {
    user_data->refcount--;
    if (0 == user_data->refcount) {
        free(user_data);
    }
}

void
hm_sqring_setup(void* vm, struct io_sqring_offsets const* offsets, hm_sqring_t* sqring) {
    sqring->head = vm + offsets->head;
    sqring->tail = vm + offsets->tail;
    sqring->ring_entries = vm + offsets->ring_entries;
    sqring->ring_mask = vm + offsets->ring_mask;
    sqring->flags = vm + offsets->flags;
    sqring->array = vm + offsets->array;
    for (size_t i = 0; i < *sqring->ring_entries; i++) {
        sqring->array[i] = i;
    }
}

void
hm_cqring_setup(void* vm, struct io_cqring_offsets const* offsets, hm_cqring_t* cqring) {
    cqring->head = vm + offsets->head;
    cqring->tail = vm + offsets->tail;
    cqring->ring_entries = vm + offsets->ring_entries;
    cqring->ring_mask = vm + offsets->ring_mask;
    cqring->cqes = vm + offsets->cqes;
}

hm_opt_error_t
hm_ioring_setup(hm_ioring_t* ioring) {
    hm_opt_error_t oe = HM_OE_NONE;

    memset(ioring, 0, sizeof(*ioring));
    wmb();
    HM_RES(ioring->fd, io_uring_setup(32, &ioring->params));
    rmb();

    assert(ioring->params.features & IORING_FEAT_SINGLE_MMAP);
    assert(ioring->params.features & IORING_FEAT_RW_CUR_POS);

    HM_RES(
        ioring->vm,
        mmap(
            0,
            ioring->params.sq_off.array + ioring->params.sq_entries * sizeof(uint32_t),
            PROT_READ|PROT_WRITE,
            MAP_SHARED|MAP_POPULATE,
            ioring->fd,
            IORING_OFF_SQ_RING
        )
    );
    HM_RES(
        ioring->sqring.sqes,
        (struct io_uring_sqe *) mmap(
            0,
            ioring->params.sq_entries * sizeof(struct io_uring_sqe),
            PROT_READ|PROT_WRITE,
            MAP_SHARED|MAP_POPULATE,
            ioring->fd,
            IORING_OFF_SQES
        )
    );

    hm_sqring_setup(ioring->vm, &ioring->params.sq_off, &ioring->sqring);
    hm_cqring_setup(ioring->vm, &ioring->params.cq_off, &ioring->cqring);

OUT:
    return oe;
}

hm_opt_error_t
hm_ioring_teardown(hm_ioring_t* ioring) {
    hm_opt_error_t oe = HM_OE_NONE;

    HM_RES(ioring->fd, close(ioring->fd));

OUT:
    return oe;
}

hm_opt_error_t
hm_ioring_flush_cqes(uint32_t min_complete, hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    hm_cqring_t * cqring = &ioring->cqring;

    assert(min_complete <= *cqring->ring_entries);

    rmb();
    uint32_t tail = *cqring->tail;
    uint32_t head = *cqring->head;
    if (tail - head < min_complete) {
        uint32_t n_complete_;
        HM_OE(oe, hm_ioring_enter(&n_complete_, min_complete, ioring));
    }
    for (tail = *cqring->tail; head < tail; head++) {
        struct io_uring_cqe* cqe = &cqring->cqes[head & *cqring->ring_mask];
        hm_user_data_t * user_data = (hm_user_data_t *)cqe->user_data;
        memcpy(&user_data->cqe, cqe, sizeof(struct io_uring_cqe));
        switch (user_data->opcode) {
        case IORING_OP_OPENAT:
            free(user_data->pathname);
            user_data->pathname = NULL;
            break;
        case IORING_OP_WRITE:
            free(user_data->buffer);
            user_data->buffer = NULL;
            break;
        default:
            break;
        };
        hm_user_data_decref(user_data);
    }
    *cqring->head = head;
    wmb();

OUT:
    return oe;
}

hm_opt_error_t
hm_ioring_flush_sqes(hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    int n_complete;
    HM_OE(oe, hm_ioring_enter(&n_complete, 0, ioring));
    if (n_complete > 0) {
        HM_OE(oe, hm_ioring_flush_cqes(0, ioring));
    }

OUT:
    return oe;
}

hm_opt_error_t
hm_ioring_get_sqe(struct io_uring_sqe ** sqe, hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;

    hm_sqring_t * sqring = &ioring->sqring;
    rmb();
    if (*sqring->tail - *sqring->head == *sqring->ring_entries) {
        HM_OE(oe, hm_ioring_flush_sqes(ioring));
    }

    *sqe = &sqring->sqes[*sqring->tail & *sqring->ring_mask];
    *sqring->tail += 1;
    memset(*sqe, 0, sizeof(struct io_uring_sqe));

OUT:
    return oe;
}

hm_opt_error_t
hm_ioring_enter(uint32_t* n_complete, uint32_t min_complete, hm_ioring_t* ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    wmb();
OUT:
    switch (oe) {
    case EBUSY:
        // In Hemlock, this is the point at which the actor suspends and requires the executor to
        // reap CQEs. If the final SQE has IOSQE_IO_LINK set, no other actors may submit I/O on this
        // ioring until the current actor finishes submitting its chain of SQEs.
        HM_OE(oe, hm_ioring_flush_cqes(1, ioring));
    case HM_OE_NONE:
        HM_RES(*n_complete, io_uring_enter(ioring->fd, *ioring->sqring.tail - *ioring->sqring.head,
          min_complete, IORING_ENTER_GETEVENTS));
        rmb();
        break;
    default:
        break;
    }

    return oe;
}

int
hm_ioring_generic_complete(hm_user_data_t * user_data, hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;

    while (user_data->cqe.user_data == 0) {
        HM_OE(oe, hm_ioring_flush_cqes(1, ioring));
    }

OUT:
    // io_uring_cqe res returns -errno in the res field if there are errors. We do the same.
    if (oe == HM_OE_NONE) {
        return user_data->cqe.res;
    } else if (oe == HM_OE_ERROR) {
        return -EIO;
    } else {
        // oe was initialized from errno.
        return -oe;
    }
}

hm_user_data_t *
hm_ioring_nop_submit(hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    struct io_uring_sqe * sqe;
    HM_OE(oe, hm_ioring_get_sqe(&sqe, ioring));

    hm_user_data_t * user_data;
    HM_OE(oe, hm_user_data_create(&user_data));
    user_data->opcode = IORING_OP_NOP;

    sqe->user_data = (uint64_t)user_data;
    sqe->opcode = IORING_OP_NOP;

OUT:
    return user_data;
}

hm_user_data_t *
hm_ioring_open_submit(uint8_t * pathname, int flags, mode_t mode, hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    struct io_uring_sqe * sqe;
    HM_OE(oe, hm_ioring_get_sqe(&sqe, ioring));

    hm_user_data_t * user_data;
    HM_OE(oe, hm_user_data_create(&user_data));
    user_data->opcode = IORING_OP_OPENAT;
    user_data->pathname = pathname;

    sqe->user_data = (uint64_t)user_data;
    sqe->opcode = IORING_OP_OPENAT;
    sqe->fd = AT_FDCWD;
    sqe->addr = (uint64_t)pathname;
    sqe->open_flags = flags;
    sqe->len = mode;

OUT:
    return user_data;
}

hm_user_data_t *
hm_ioring_close_submit(int fd, hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    struct io_uring_sqe * sqe;
    HM_OE(oe, hm_ioring_get_sqe(&sqe, ioring));

    hm_user_data_t * user_data;
    HM_OE(oe, hm_user_data_create(&user_data));
    user_data->opcode = IORING_OP_CLOSE;

    sqe->user_data = (uint64_t)user_data;
    sqe->opcode = IORING_OP_CLOSE;
    sqe->fd = fd;

OUT:
    return user_data;
}

hm_user_data_t *
hm_ioring_read_submit(int fd, uint8_t * buffer, uint64_t n, hm_ioring_t * ioring) {
    hm_opt_error_t oe = HM_OE_NONE;
    struct io_uring_sqe * sqe;
    HM_OE(oe, hm_ioring_get_sqe(&sqe, ioring));

    hm_user_data_t * user_data;
    HM_OE(oe, hm_user_data_create(&user_data));
    user_data->opcode = IORING_OP_READ;
    user_data->buffer = buffer;

    sqe->user_data = (uint64_t)user_data;
    sqe->opcode = IORING_OP_READ;
    sqe->off = -1;  // Use current file position.
    sqe->fd = fd;
    sqe->addr = (uint64_t)buffer;
    sqe->len = n;

OUT:
    return user_data;
}

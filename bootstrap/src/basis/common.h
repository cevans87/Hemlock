#pragma once
#include <errno.h>
#include <stdint.h>
#include <stdio.h>

typedef enum {
    HM_OE_ERROR = -1,
    HM_OE_NONE
    // All values > 0 are specific linux errno.
} hm_opt_error_t;


#define HM_OE(oe, statement) do { \
        oe = statement; \
        switch (oe == HM_OE_NONE) { \
        case true: \
          break; \
        case false: \
          fprintf(stderr, "Error %s:%i\n", __FILE__, __LINE__); \
          goto OUT; \
        }; \
    } while (0)

#define HM_RES(res, statement) do { \
        res = statement; \
        switch ((uint64_t)res == -1) { \
        case false: \
          break; \
        case true: \
          oe = errno; \
          fprintf(stderr, "Error %s:%i\n", __FILE__, __LINE__); \
          goto OUT; \
        }; \
    } while (0)

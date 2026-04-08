#define _GNU_SOURCE
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <poll.h>

/*****************************************************************************
 * Poll event masks (POLL*)
 *****************************************************************************/

CAMLprim value hemlock__c__poll__event__pollin(value unit)   { (void)unit; return caml_copy_int64(POLLIN); }
CAMLprim value hemlock__c__poll__event__pollout(value unit)  { (void)unit; return caml_copy_int64(POLLOUT); }
CAMLprim value hemlock__c__poll__event__pollerr(value unit)  { (void)unit; return caml_copy_int64(POLLERR); }
CAMLprim value hemlock__c__poll__event__pollhup(value unit)  { (void)unit; return caml_copy_int64(POLLHUP); }
CAMLprim value hemlock__c__poll__event__pollnval(value unit) { (void)unit; return caml_copy_int64(POLLNVAL); }
CAMLprim value hemlock__c__poll__event__pollpri(value unit)  { (void)unit; return caml_copy_int64(POLLPRI); }
CAMLprim value hemlock__c__poll__event__pollrdhup(value unit) { (void)unit; return caml_copy_int64(POLLRDHUP); }

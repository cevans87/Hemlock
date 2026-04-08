#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <sys/socket.h>
#include <netinet/in.h>

/*****************************************************************************
 * Socket types (SOCK_*)
 *****************************************************************************/

CAMLprim value hemlock__c__socket__sock__stream(value unit)    { (void)unit; return caml_copy_int64(SOCK_STREAM); }
CAMLprim value hemlock__c__socket__sock__dgram(value unit)     { (void)unit; return caml_copy_int64(SOCK_DGRAM); }
CAMLprim value hemlock__c__socket__sock__raw(value unit)       { (void)unit; return caml_copy_int64(SOCK_RAW); }
CAMLprim value hemlock__c__socket__sock__seqpacket(value unit) { (void)unit; return caml_copy_int64(SOCK_SEQPACKET); }
CAMLprim value hemlock__c__socket__sock__nonblock(value unit)  { (void)unit; return caml_copy_int64(SOCK_NONBLOCK); }
CAMLprim value hemlock__c__socket__sock__cloexec(value unit)   { (void)unit; return caml_copy_int64(SOCK_CLOEXEC); }

/*****************************************************************************
 * IP protocol constants (IPPROTO_*)
 *****************************************************************************/

CAMLprim value hemlock__c__socket__ipproto__ip(value unit)   { (void)unit; return caml_copy_int64(IPPROTO_IP); }
CAMLprim value hemlock__c__socket__ipproto__tcp(value unit)  { (void)unit; return caml_copy_int64(IPPROTO_TCP); }
CAMLprim value hemlock__c__socket__ipproto__udp(value unit)  { (void)unit; return caml_copy_int64(IPPROTO_UDP); }
CAMLprim value hemlock__c__socket__ipproto__ipv6(value unit) { (void)unit; return caml_copy_int64(IPPROTO_IPV6); }
CAMLprim value hemlock__c__socket__ipproto__raw(value unit)  { (void)unit; return caml_copy_int64(IPPROTO_RAW); }

/*****************************************************************************
 * Socket option levels (SOL_*)
 *****************************************************************************/

CAMLprim value hemlock__c__socket__sol__socket(value unit) { (void)unit; return caml_copy_int64(SOL_SOCKET); }

/*****************************************************************************
 * Socket options (SO_*)
 *****************************************************************************/

CAMLprim value hemlock__c__socket__so__reuseaddr(value unit) { (void)unit; return caml_copy_int64(SO_REUSEADDR); }
CAMLprim value hemlock__c__socket__so__reuseport(value unit) { (void)unit; return caml_copy_int64(SO_REUSEPORT); }
CAMLprim value hemlock__c__socket__so__keepalive(value unit) { (void)unit; return caml_copy_int64(SO_KEEPALIVE); }
CAMLprim value hemlock__c__socket__so__sndbuf(value unit)    { (void)unit; return caml_copy_int64(SO_SNDBUF); }
CAMLprim value hemlock__c__socket__so__rcvbuf(value unit)    { (void)unit; return caml_copy_int64(SO_RCVBUF); }
CAMLprim value hemlock__c__socket__so__linger(value unit)    { (void)unit; return caml_copy_int64(SO_LINGER); }
CAMLprim value hemlock__c__socket__so__error(value unit)     { (void)unit; return caml_copy_int64(SO_ERROR); }

/*****************************************************************************
 * Message flags (MSG_*)
 *****************************************************************************/

CAMLprim value hemlock__c__socket__msg__dontwait(value unit) { (void)unit; return caml_copy_int64(MSG_DONTWAIT); }
CAMLprim value hemlock__c__socket__msg__nosignal(value unit) { (void)unit; return caml_copy_int64(MSG_NOSIGNAL); }
CAMLprim value hemlock__c__socket__msg__more(value unit)     { (void)unit; return caml_copy_int64(MSG_MORE); }
CAMLprim value hemlock__c__socket__msg__waitall(value unit)  { (void)unit; return caml_copy_int64(MSG_WAITALL); }

/*****************************************************************************
 * Shutdown how (SHUT_*)
 *****************************************************************************/

CAMLprim value hemlock__c__socket__shut__rd(value unit)   { (void)unit; return caml_copy_int64(SHUT_RD); }
CAMLprim value hemlock__c__socket__shut__wr(value unit)   { (void)unit; return caml_copy_int64(SHUT_WR); }
CAMLprim value hemlock__c__socket__shut__rdwr(value unit) { (void)unit; return caml_copy_int64(SHUT_RDWR); }

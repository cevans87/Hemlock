#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/custom.h>

#include "sockaddr_stubs.h"
#include <arpa/inet.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

/*****************************************************************************
 * Sockaddr.t custom block
 *
 * Stores a pointer to a C-heap buffer: [ socklen_t len | char data[] ]
 * The data field holds the serialized sockaddr struct.  Using C heap (not
 * OCaml bytes) keeps the pointer stable across GC cycles, which is required
 * for prep_accept where the kernel writes back the accepted address
 * asynchronously after the SQE has been submitted.
 *****************************************************************************/

static void hemlock__c__sockaddr__finalize(value v) {
    struct hemlock_sockaddr *sa = *((struct hemlock_sockaddr **)Data_custom_val(v));
    if (sa != NULL) {
        free(sa);
        *((struct hemlock_sockaddr **)Data_custom_val(v)) = NULL;
    }
}

static struct custom_operations hemlock__c__sockaddr__ops = {
    "hemlock__c__sockaddr",
    hemlock__c__sockaddr__finalize,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

struct hemlock_sockaddr *hemlock__c__sockaddr__of_value(value v) {
    return *((struct hemlock_sockaddr **)Data_custom_val(v));
}

/* Allocate a zeroed buffer large enough for data_len bytes of sockaddr data,
 * wrap it in a custom block, and return the block.  Must be called with all
 * live OCaml values already registered via CAMLparam/CAMLlocal. */
static value hemlock__c__sockaddr__make(socklen_t data_len) {
    struct hemlock_sockaddr *sa =
        (struct hemlock_sockaddr *)malloc(sizeof(socklen_t) + (size_t)data_len);
    sa->len = data_len;
    memset(sa->data, 0, (size_t)data_len);
    value v = caml_alloc_custom(
        &hemlock__c__sockaddr__ops, sizeof(struct hemlock_sockaddr *), 0, 1);
    *((struct hemlock_sockaddr **)Data_custom_val(v)) = sa;
    return v;
}

/*****************************************************************************
 * Address families (AF_*)
 *****************************************************************************/

CAMLprim value hemlock__c__sockaddr__af_inet(value unit)  { (void)unit; return caml_copy_int64(AF_INET); }
CAMLprim value hemlock__c__sockaddr__af_inet6(value unit) { (void)unit; return caml_copy_int64(AF_INET6); }
CAMLprim value hemlock__c__sockaddr__af_unix(value unit)  { (void)unit; return caml_copy_int64(AF_UNIX); }

/*****************************************************************************
 * length : t -> int
 *****************************************************************************/

CAMLprim value
hemlock__c__sockaddr__length(value a_sockaddr) {
    socklen_t len = hemlock__c__sockaddr__of_value(a_sockaddr)->len;
    return caml_copy_int64(len);
}

/*****************************************************************************
 * sockaddr_in (IPv4, struct sockaddr_in from netinet/in.h)
 *****************************************************************************/

/* val sockaddr_in_make : port:int -> addr:int -> t
 * port and addr are both host byte order.
 * addr encoding: 0x7f000001 = 127.0.0.1, 0x00000000 = 0.0.0.0. */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in_make(value a_port, value a_addr) {
    CAMLparam2(a_port, a_addr);
    CAMLlocal1(v);
    v = hemlock__c__sockaddr__make((socklen_t)sizeof(struct sockaddr_in));
    struct sockaddr_in *sin =
        (struct sockaddr_in *)hemlock__c__sockaddr__of_value(v)->data;
    sin->sin_family      = AF_INET;
    sin->sin_port        = htons((uint16_t)Int64_val(a_port));
    sin->sin_addr.s_addr = htonl((uint32_t)Int64_val(a_addr));
    CAMLreturn(v);
}

/* val sockaddr_in_alloc : unit -> t
 * Allocates a zeroed sockaddr_in for use with prep_accept. */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in_alloc(value unit) {
    (void)unit;
    return hemlock__c__sockaddr__make((socklen_t)sizeof(struct sockaddr_in));
}

/* val sockaddr_in_port : t -> int  (host byte order) */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in_port(value a_sockaddr) {
    struct sockaddr_in *sin =
        (struct sockaddr_in *)hemlock__c__sockaddr__of_value(a_sockaddr)->data;
    uint16_t port = ntohs(sin->sin_port);
    return caml_copy_int64(port);
}

/* val sockaddr_in_addr : t -> int  (host byte order) */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in_addr(value a_sockaddr) {
    struct sockaddr_in *sin =
        (struct sockaddr_in *)hemlock__c__sockaddr__of_value(a_sockaddr)->data;
    uint32_t addr = ntohl(sin->sin_addr.s_addr);
    return caml_copy_int64(addr);
}

/*****************************************************************************
 * sockaddr_in6 (IPv6, struct sockaddr_in6 from netinet/in.h)
 *****************************************************************************/

/* val sockaddr_in6_make : port:int -> addr:bytes -> scope_id:int -> t
 * port is host byte order; addr is 16 bytes in network byte order. */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in6_make(value a_port, value a_addr, value a_scope_id) {
    CAMLparam3(a_port, a_addr, a_scope_id);
    CAMLlocal1(v);
    v = hemlock__c__sockaddr__make((socklen_t)sizeof(struct sockaddr_in6));
    struct sockaddr_in6 *sin6 =
        (struct sockaddr_in6 *)hemlock__c__sockaddr__of_value(v)->data;
    sin6->sin6_family   = AF_INET6;
    sin6->sin6_port     = htons((uint16_t)Int64_val(a_port));
    sin6->sin6_scope_id = (uint32_t)Int64_val(a_scope_id);
    memcpy(&sin6->sin6_addr, Bytes_val(a_addr), 16);
    CAMLreturn(v);
}

/* val sockaddr_in6_alloc : unit -> t */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in6_alloc(value unit) {
    (void)unit;
    return hemlock__c__sockaddr__make((socklen_t)sizeof(struct sockaddr_in6));
}

/* val sockaddr_in6_port : t -> int  (host byte order) */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in6_port(value a_sockaddr) {
    struct sockaddr_in6 *sin6 =
        (struct sockaddr_in6 *)hemlock__c__sockaddr__of_value(a_sockaddr)->data;
    uint16_t port = ntohs(sin6->sin6_port);
    return caml_copy_int64(port);
}

/* val sockaddr_in6_addr : t -> bytes  (16 bytes, network byte order) */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in6_addr(value a_sockaddr) {
    CAMLparam1(a_sockaddr);
    CAMLlocal1(v_bytes);
    /* Get C pointer before allocation; sa is C-heap so GC cannot move it. */
    struct hemlock_sockaddr *sa = hemlock__c__sockaddr__of_value(a_sockaddr);
    v_bytes = caml_alloc_string(16);
    memcpy(Bytes_val(v_bytes), &((struct sockaddr_in6 *)sa->data)->sin6_addr, 16);
    CAMLreturn(v_bytes);
}

/* val sockaddr_in6_scope_id : t -> int */
CAMLprim value
hemlock__c__sockaddr__sockaddr_in6_scope_id(value a_sockaddr) {
    struct sockaddr_in6 *sin6 =
        (struct sockaddr_in6 *)hemlock__c__sockaddr__of_value(a_sockaddr)->data;
    uint32_t scope_id = sin6->sin6_scope_id;
    return caml_copy_int64(scope_id);
}

/*****************************************************************************
 * sockaddr_un (Unix domain, struct sockaddr_un from sys/un.h)
 *****************************************************************************/

/* val sockaddr_un_make : path:string -> t
 * Buffer length = offsetof(sun_path) + strlen(path) + 1, per POSIX convention. */
CAMLprim value
hemlock__c__sockaddr__sockaddr_un_make(value a_path) {
    CAMLparam1(a_path);
    CAMLlocal1(v);
    size_t pathlen = caml_string_length(a_path);
    socklen_t data_len =
        (socklen_t)(offsetof(struct sockaddr_un, sun_path) + pathlen + 1);
    v = hemlock__c__sockaddr__make(data_len);
    struct sockaddr_un *sun =
        (struct sockaddr_un *)hemlock__c__sockaddr__of_value(v)->data;
    sun->sun_family = AF_UNIX;
    /* Re-read String_val after the allocation in case GC updated a_path. */
    memcpy(sun->sun_path, String_val(a_path), pathlen + 1);
    CAMLreturn(v);
}

/* val sockaddr_un_alloc : unit -> t */
CAMLprim value
hemlock__c__sockaddr__sockaddr_un_alloc(value unit) {
    (void)unit;
    return hemlock__c__sockaddr__make((socklen_t)sizeof(struct sockaddr_un));
}

/* val sockaddr_un_path : t -> string */
CAMLprim value
hemlock__c__sockaddr__sockaddr_un_path(value a_sockaddr) {
    CAMLparam1(a_sockaddr);
    struct sockaddr_un *sun =
        (struct sockaddr_un *)hemlock__c__sockaddr__of_value(a_sockaddr)->data;
    CAMLreturn(caml_copy_string(sun->sun_path));
}

type sockaddr
type af       = U16.t
type port     = U16.t
type addr     = U32.t
type addr6    = bytes
type scope_id = U32.t
type path     = string

external af_inet  : unit -> af = "hemlock__c__sockaddr__af_inet"
external af_inet6 : unit -> af = "hemlock__c__sockaddr__af_inet6"
external af_unix  : unit -> af = "hemlock__c__sockaddr__af_unix"

let af_inet  = af_inet ()
let af_inet6 = af_inet6 ()
let af_unix  = af_unix ()

external length : sockaddr -> U32.t = "hemlock__c__sockaddr__length"

(*****************************************************************************
 * sockaddr_in (IPv4)
 *****************************************************************************)

external sockaddr_in_make : port:port -> addr:addr -> sockaddr
  = "hemlock__c__sockaddr__sockaddr_in_make"

external sockaddr_in_alloc : unit -> sockaddr
  = "hemlock__c__sockaddr__sockaddr_in_alloc"

external sockaddr_in_port : sockaddr -> port = "hemlock__c__sockaddr__sockaddr_in_port"
external sockaddr_in_addr : sockaddr -> addr = "hemlock__c__sockaddr__sockaddr_in_addr"

(*****************************************************************************
 * sockaddr_in6 (IPv6)
 *****************************************************************************)

external sockaddr_in6_make : port:port -> addr:addr6 -> scope_id:scope_id -> sockaddr
  = "hemlock__c__sockaddr__sockaddr_in6_make"

external sockaddr_in6_alloc : unit -> sockaddr
  = "hemlock__c__sockaddr__sockaddr_in6_alloc"

external sockaddr_in6_port     : sockaddr -> port     = "hemlock__c__sockaddr__sockaddr_in6_port"
external sockaddr_in6_addr     : sockaddr -> addr6    = "hemlock__c__sockaddr__sockaddr_in6_addr"
external sockaddr_in6_scope_id : sockaddr -> scope_id = "hemlock__c__sockaddr__sockaddr_in6_scope_id"

(*****************************************************************************
 * sockaddr_un (Unix domain)
 *****************************************************************************)

external sockaddr_un_make : path:path -> sockaddr
  = "hemlock__c__sockaddr__sockaddr_un_make"

external sockaddr_un_alloc : unit -> sockaddr
  = "hemlock__c__sockaddr__sockaddr_un_alloc"

external sockaddr_un_path : sockaddr -> path = "hemlock__c__sockaddr__sockaddr_un_path"

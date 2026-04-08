type sockaddr
type af       = U16.t
type port     = U16.t
type addr     = U32.t
type addr6    = bytes
type scope_id = U32.t
type path     = string

val af_inet  : af
val af_inet6 : af
val af_unix  : af

val length : sockaddr -> U32.t

(*****************************************************************************
 * sockaddr_in (IPv4)
 *****************************************************************************)

(* [sockaddr_in_make ~port ~addr] creates an IPv4 socket address.
 * [port] and [addr] are in host byte order.
 * [addr] encoding: 0x7f000001 = 127.0.0.1, 0x00000000 = 0.0.0.0. *)
val sockaddr_in_make : port:port -> addr:addr -> sockaddr

(* [sockaddr_in_alloc ()] allocates a zeroed IPv4 sockaddr for use with
 * [Liburing.io_uring_prep_accept].  Fields are filled in by the kernel
 * when a connection arrives; read them back with the getters below. *)
val sockaddr_in_alloc : unit -> sockaddr

val sockaddr_in_port : sockaddr -> port  (* host byte order *)
val sockaddr_in_addr : sockaddr -> addr  (* host byte order *)

(*****************************************************************************
 * sockaddr_in6 (IPv6)
 *****************************************************************************)

(* [sockaddr_in6_make ~port ~addr ~scope_id] creates an IPv6 socket address.
 * [port] is host byte order; [addr] is 16 bytes in network byte order. *)
val sockaddr_in6_make : port:port -> addr:addr6 -> scope_id:scope_id -> sockaddr

val sockaddr_in6_alloc : unit -> sockaddr

val sockaddr_in6_port     : sockaddr -> port      (* host byte order *)
val sockaddr_in6_addr     : sockaddr -> addr6     (* 16 bytes, network byte order *)
val sockaddr_in6_scope_id : sockaddr -> scope_id

(*****************************************************************************
 * sockaddr_un (Unix domain)
 *****************************************************************************)

(* [sockaddr_un_make ~path] creates a Unix-domain socket address.
 * The buffer length is sized precisely for [path] per POSIX convention. *)
val sockaddr_un_make : path:path -> sockaddr

val sockaddr_un_alloc : unit -> sockaddr

val sockaddr_un_path : sockaddr -> path

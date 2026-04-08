module Sock : sig
  (*****************************************************************************
   * Socket types (SOCK_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val stream    : t (* SOCK_STREAM *)
  val dgram     : t (* SOCK_DGRAM *)
  val raw       : t (* SOCK_RAW *)
  val seqpacket : t (* SOCK_SEQPACKET *)
  val nonblock  : t (* SOCK_NONBLOCK *)
  val cloexec   : t (* SOCK_CLOEXEC *)
end

module Ipproto : sig
  (*****************************************************************************
   * IP protocol constants (IPPROTO_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val ip   : t (* IPPROTO_IP *)
  val tcp  : t (* IPPROTO_TCP *)
  val udp  : t (* IPPROTO_UDP *)
  val ipv6 : t (* IPPROTO_IPV6 *)
  val raw  : t (* IPPROTO_RAW *)
end

module Sol : sig
  (*****************************************************************************
   * Socket option levels (SOL_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val socket : t (* SOL_SOCKET *)
end

module So : sig
  (*****************************************************************************
   * Socket options (SO_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val reuseaddr : t (* SO_REUSEADDR *)
  val reuseport : t (* SO_REUSEPORT *)
  val keepalive : t (* SO_KEEPALIVE *)
  val sndbuf    : t (* SO_SNDBUF *)
  val rcvbuf    : t (* SO_RCVBUF *)
  val linger    : t (* SO_LINGER *)
  val error     : t (* SO_ERROR *)
end

module Msg : sig
  (*****************************************************************************
   * Message flags (MSG_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val dontwait : t (* MSG_DONTWAIT *)
  val nosignal : t (* MSG_NOSIGNAL *)
  val more     : t (* MSG_MORE *)
  val waitall  : t (* MSG_WAITALL *)
end

module Shut : sig
  (*****************************************************************************
   * Shutdown how (SHUT_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val rd   : t (* SHUT_RD *)
  val wr   : t (* SHUT_WR *)
  val rdwr : t (* SHUT_RDWR *)
end

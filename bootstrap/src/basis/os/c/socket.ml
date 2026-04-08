module Sock = struct
  (*****************************************************************************
   * Socket types (SOCK_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external stream    : unit -> t = "hemlock__c__socket__sock__stream"
  external dgram     : unit -> t = "hemlock__c__socket__sock__dgram"
  external raw       : unit -> t = "hemlock__c__socket__sock__raw"
  external seqpacket : unit -> t = "hemlock__c__socket__sock__seqpacket"
  external nonblock  : unit -> t = "hemlock__c__socket__sock__nonblock"
  external cloexec   : unit -> t = "hemlock__c__socket__sock__cloexec"

  let stream    = stream ()
  let dgram     = dgram ()
  let raw       = raw ()
  let seqpacket = seqpacket ()
  let nonblock  = nonblock ()
  let cloexec   = cloexec ()
end

module Ipproto = struct
  (*****************************************************************************
   * IP protocol constants (IPPROTO_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external ip   : unit -> t = "hemlock__c__socket__ipproto__ip"
  external tcp  : unit -> t = "hemlock__c__socket__ipproto__tcp"
  external udp  : unit -> t = "hemlock__c__socket__ipproto__udp"
  external ipv6 : unit -> t = "hemlock__c__socket__ipproto__ipv6"
  external raw  : unit -> t = "hemlock__c__socket__ipproto__raw"

  let ip   = ip ()
  let tcp  = tcp ()
  let udp  = udp ()
  let ipv6 = ipv6 ()
  let raw  = raw ()
end

module Sol = struct
  (*****************************************************************************
   * Socket option levels (SOL_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external socket : unit -> t = "hemlock__c__socket__sol__socket"

  let socket = socket ()
end

module So = struct
  (*****************************************************************************
   * Socket options (SO_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external reuseaddr : unit -> t = "hemlock__c__socket__so__reuseaddr"
  external reuseport : unit -> t = "hemlock__c__socket__so__reuseport"
  external keepalive : unit -> t = "hemlock__c__socket__so__keepalive"
  external sndbuf    : unit -> t = "hemlock__c__socket__so__sndbuf"
  external rcvbuf    : unit -> t = "hemlock__c__socket__so__rcvbuf"
  external linger    : unit -> t = "hemlock__c__socket__so__linger"
  external error     : unit -> t = "hemlock__c__socket__so__error"

  let reuseaddr = reuseaddr ()
  let reuseport = reuseport ()
  let keepalive = keepalive ()
  let sndbuf    = sndbuf ()
  let rcvbuf    = rcvbuf ()
  let linger    = linger ()
  let error     = error ()
end

module Msg = struct
  (*****************************************************************************
   * Message flags (MSG_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external dontwait : unit -> t = "hemlock__c__socket__msg__dontwait"
  external nosignal : unit -> t = "hemlock__c__socket__msg__nosignal"
  external more     : unit -> t = "hemlock__c__socket__msg__more"
  external waitall  : unit -> t = "hemlock__c__socket__msg__waitall"

  let dontwait = dontwait ()
  let nosignal = nosignal ()
  let more     = more ()
  let waitall  = waitall ()
end

module Shut = struct
  (*****************************************************************************
   * Shutdown how (SHUT_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external rd   : unit -> t = "hemlock__c__socket__shut__rd"
  external wr   : unit -> t = "hemlock__c__socket__shut__wr"
  external rdwr : unit -> t = "hemlock__c__socket__shut__rdwr"

  let rd   = rd ()
  let wr   = wr ()
  let rdwr = rdwr ()
end

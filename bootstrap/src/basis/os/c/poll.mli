module Event : sig
  (*****************************************************************************
   * Poll event masks (POLL*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val pollin   : t (* POLLIN *)
  val pollout  : t (* POLLOUT *)
  val pollerr  : t (* POLLERR *)
  val pollhup  : t (* POLLHUP *)
  val pollnval : t (* POLLNVAL *)
  val pollpri  : t (* POLLPRI *)
  val pollrdhup : t (* POLLRDHUP *)
end

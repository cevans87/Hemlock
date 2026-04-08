module Event = struct
  (*****************************************************************************
   * Poll event masks (POLL*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external pollin   : unit -> t = "hemlock__c__poll__event__pollin"
  external pollout  : unit -> t = "hemlock__c__poll__event__pollout"
  external pollerr  : unit -> t = "hemlock__c__poll__event__pollerr"
  external pollhup  : unit -> t = "hemlock__c__poll__event__pollhup"
  external pollnval : unit -> t = "hemlock__c__poll__event__pollnval"
  external pollpri  : unit -> t = "hemlock__c__poll__event__pollpri"
  external pollrdhup : unit -> t = "hemlock__c__poll__event__pollrdhup"

  let pollin   = pollin ()
  let pollout  = pollout ()
  let pollerr  = pollerr ()
  let pollhup  = pollhup ()
  let pollnval = pollnval ()
  let pollpri  = pollpri ()
  let pollrdhup = pollrdhup ()
end

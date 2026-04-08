module Mode = struct
  (*****************************************************************************
   * File mode bits (S_I*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external irusr : unit -> t = "hemlock__c__stat__mode__irusr"
  external iwusr : unit -> t = "hemlock__c__stat__mode__iwusr"
  external ixusr : unit -> t = "hemlock__c__stat__mode__ixusr"
  external irwxu : unit -> t = "hemlock__c__stat__mode__irwxu"
  external irgrp : unit -> t = "hemlock__c__stat__mode__irgrp"
  external iwgrp : unit -> t = "hemlock__c__stat__mode__iwgrp"
  external ixgrp : unit -> t = "hemlock__c__stat__mode__ixgrp"
  external irwxg : unit -> t = "hemlock__c__stat__mode__irwxg"
  external iroth : unit -> t = "hemlock__c__stat__mode__iroth"
  external iwoth : unit -> t = "hemlock__c__stat__mode__iwoth"
  external ixoth : unit -> t = "hemlock__c__stat__mode__ixoth"
  external irwxo : unit -> t = "hemlock__c__stat__mode__irwxo"
  external isuid : unit -> t = "hemlock__c__stat__mode__isuid"
  external isgid : unit -> t = "hemlock__c__stat__mode__isgid"
  external isvtx : unit -> t = "hemlock__c__stat__mode__isvtx"

  let irusr = irusr ()
  let iwusr = iwusr ()
  let ixusr = ixusr ()
  let irwxu = irwxu ()
  let irgrp = irgrp ()
  let iwgrp = iwgrp ()
  let ixgrp = ixgrp ()
  let irwxg = irwxg ()
  let iroth = iroth ()
  let iwoth = iwoth ()
  let ixoth = ixoth ()
  let irwxo = irwxo ()
  let isuid = isuid ()
  let isgid = isgid ()
  let isvtx = isvtx ()
end

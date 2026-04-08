module Mode : sig
  (*****************************************************************************
   * File mode bits (S_I*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val irusr : t (* S_IRUSR *)
  val iwusr : t (* S_IWUSR *)
  val ixusr : t (* S_IXUSR *)
  val irwxu : t (* S_IRWXU *)
  val irgrp : t (* S_IRGRP *)
  val iwgrp : t (* S_IWGRP *)
  val ixgrp : t (* S_IXGRP *)
  val irwxg : t (* S_IRWXG *)
  val iroth : t (* S_IROTH *)
  val iwoth : t (* S_IWOTH *)
  val ixoth : t (* S_IXOTH *)
  val irwxo : t (* S_IRWXO *)
  val isuid : t (* S_ISUID *)
  val isgid : t (* S_ISGID *)
  val isvtx : t (* S_ISVTX *)
end

module O : sig
  (*****************************************************************************
   * Open flags (O_*
   *****************************************************************************)

  type t = U32.t

  include Flags_intf.S with type t := t

  val rdonly    : t (* O_RDONLY *)
  val wronly    : t (* O_WRONLY *)
  val rdwr      : t (* O_RDWR *)
  val creat     : t (* O_CREAT *)
  val excl      : t (* O_EXCL *)
  val noctty    : t (* O_NOCTTY *)
  val trunc     : t (* O_TRUNC *)
  val append    : t (* O_APPEND *)
  val nonblock  : t (* O_NONBLOCK *)
  val dsync     : t (* O_DSYNC *)
  val sync      : t (* O_SYNC *)
  val directory : t (* O_DIRECTORY *)
  val nofollow  : t (* O_NOFOLLOW *)
  val cloexec   : t (* O_CLOEXEC *)
  val path      : t (* O_PATH *)
  val tmpfile   : t (* O_TMPFILE *)
end

module At : sig
  (*****************************************************************************
   * AT_* constants
   *****************************************************************************)

  type dfd = I32.t
  type t   = U32.t

  include Flags_intf.S with type t := t

  val fdcwd              : dfd (* AT_FDCWD *)
  val removedir          : t   (* AT_REMOVEDIR *)
  val symlink_nofollow   : t   (* AT_SYMLINK_NOFOLLOW *)
  val symlink_follow     : t   (* AT_SYMLINK_FOLLOW *)
  val empty_path         : t   (* AT_EMPTY_PATH *)
  val eaccess            : t   (* AT_EACCESS *)
end

module Splice : sig
  (*****************************************************************************
   * Splice flags (SPLICE_F_*
   *****************************************************************************)

  module F : sig
    type t = U32.t

    include Flags_intf.S with type t := t

    val move     : t (* SPLICE_F_MOVE *)
    val nonblock : t (* SPLICE_F_NONBLOCK *)
    val more     : t (* SPLICE_F_MORE *)
    val gift     : t (* SPLICE_F_GIFT *)
  end
end

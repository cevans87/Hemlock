type fd     = I32.t
type offset = I64.t
type nbytes = I64.t
type buf    = bytes

(*****************************************************************************
 * Standard file descriptors (STDIN_FILENO, STDOUT_FILENO, STDERR_FILENO)
 *****************************************************************************)

val stdin_fileno  : fd (* STDIN_FILENO *)
val stdout_fileno : fd (* STDOUT_FILENO *)
val stderr_fileno : fd (* STDERR_FILENO *)

module Seek : sig
  (*****************************************************************************
   * Seek whence constants (SEEK_SET, SEEK_CUR, SEEK_END)
   *****************************************************************************)

  type t = I32.t

  include Flags_intf.S with type t := t

  val set  : t (* SEEK_SET *)
  val cur  : t (* SEEK_CUR *)
  val end_ : t (* SEEK_END *)
end

(*****************************************************************************
 * lseek
 *****************************************************************************)

val lseek : offset -> Seek.t -> fd -> (offset, Errno.t) result
(** [lseek offset whence fd] repositions the file offset of [fd] to [offset]
    relative to [whence]. Returns the resulting offset from the beginning of the
    file, or an error. *)

(*****************************************************************************
 * write (synchronous)
 *****************************************************************************)

val write : buf -> nbytes -> fd -> (nbytes, Errno.t) result
(** [write buf n fd] writes up to [n] bytes from [buf] to [fd]. Returns the
    number of bytes written, or an error. *)

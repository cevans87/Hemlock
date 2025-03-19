type t =
  | O_RDONLY
  | O_RDWR
  | O_WRONLY
  (* Access mode flags. *)

  | O_CLOEXEC
  | O_CREAT
  | O_DIRECTORY
  | O_EXCL
  | O_NOCTTY
  | O_NOFOLLOW
  | O_TMPFILE
  | O_TRUNC
  (* File creation flags. These affect the semantics of the open operation itself. *)

  | O_APPEND
  | O_ASYNC
  | O_DIRECT
  | O_DSYNC
  | O_LARGEFILE
  | O_NDELAY
  | O_NOATIME
  | O_NONBLOCK
  | O_PATH
  | O_SYNC
  (* File status flags. These affect the semantics of I/O operations on opened file. *)

type ctype

val r: t array
(* Open for reading. Fail if file does not exist. *)
val w: t array
(* Open for writing. Truncate the file if it already exists. *)
val x: t array
(* Create new file and open it for writing. Fail if it already exists. *)
val a: t array
(* Open for writing. Append to the file if it already exists. *)
val rw: t array
(* Open for reading and writing. Truncate the file if it already exists. *)
val defaults: t array
(* Open for reading. Fail if file does not exist. *)

val of_ctype: ctype -> t
val to_ctype: t -> ctype
(* val to_string: t -> string  *)

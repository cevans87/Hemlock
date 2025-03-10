(** Standard C {!type.file}. *)
open Rudiments

type t
(** An internally immutable token backed by an external, mutable Unix file descriptor. *)

type ctype = sint
(** Raw return value for the `open(2)` system call. On successful call to `open(2)`, this is a
    valid file descriptor (a nonnegative integer). On error, -1 is returned and errno is set to
    indicate the error. *)

module Flag: sig
  type t =
    | R_O   (** Open existing file for read or fail if it does not exist. *)
    | W     (** Create new or truncate existing file and open for write. *)
    | W_A   (** Create new or append to existing file and open for write. *)
    | W_AO  (** Append to existing file and open for write, failing if it does not exist. *)
    | W_C   (** Create new file and open for write, failing if file exists *)
    | W_O   (** Truncate existing file and open for write, failing if file does not exist. *)
    | RW    (** Create new or truncate existing file and open for read and write. *)
    | RW_A  (** Create new or append to existing file and open for read and write. *)
    | RW_AO (** Append to existing file and open for read and write, failing if file does not exist.
            *)
    | RW_C  (** Create new file and open for read and write, failing if file exists. *)
    | RW_O  (** Truncate existing file and open for read and write, failing if file does not exist.
            *)
end

val stdin: t

val stdout: t

val stderr: t

val fd: t -> uns
(** [fd t] returns the Unix file descriptor corresponding to [t]. *)

(* See `open(2)` man-page for underlying Standard C system call interface. *)
module Open: sig
  type file = t
  type t
  (* An internally immutable token backed by an external I/O open completion data structure. *)

  module Flag2: sig
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

    val to_string: t -> string
  end

  module Mode: sig
    type t =
      | S_ISUID (* 0o4000 set-user-ID bit. *)
      | S_ISGID (* 0o2000 set-group-ID bit (see inode(7)). *)
      | S_ISVTX (* 0o1000 sticky bit (see inode(7)). *)

      | S_IRWXU (* 0o0700 user (file owner) has read, write, and execute permission. *)
      | S_IRUSR (* 0o0400 user has read permission. *)
      | S_IWUSR (* 0o0200 user has write permission. *)
      | S_IXUSR (* 0o0100 user has execute permission. *)

      | S_IRWXG (* 0o0070 group has read, write, and execute permission. *)
      | S_IRGRP (* 0o0040 group has read permission. *)
      | S_IWGRP (* 0o0020 group has write permission. *)
      | S_IXGRP (* 0o0010 group has execute permission. *)

      | S_IRWXO (* 0o0007 others have read, write, and execute permission. *)
      | S_IROTH (* 0o0004 others have read permission. *)
      | S_IWOTH (* 0o0002 others have write permission. *)
      | S_IXOTH (* 0o0001 others have execute permission. *)

    val defaults: t array
    (* 0o0660 user and group have read and write permission. *)
  end

  val submit: ?flag:Flag.t -> ?mode:uns -> Path.t -> (t, Errno.t) result
  (** [submit ~flag ~mode path] submits an open operation for a file at [path] with [flag] (default
      Flag.R_O) Unix file permissions and [mode] (default 0o660) Unix file permissions. This
      operation does not block. Returns a [t] to the open submission or an [Errno.t] if the open
      could not be submitted. *)

  val submit_hlt: ?flag:Flag.t -> ?mode:uns -> Path.t -> t
  (** [submit ~flag ~mode path] submits an open operation for a file at [path] with [flag] (default
      Flag.R_O) Unix file permissions and [mode] (default 0o660) Unix file permissions. This
      operation does not block. Returns a [t] to the open submission or halts if the open could
      not be submitted. *)

  val of_path: ?flag:Flag.t array -> ?mode: Mode.t array -> Path.t -> (t, Errno.t) result *)

  val complete: t -> (file, Errno.t) result
  (** [complete t] blocks until given [t] is complete. Returns a [file] or an [Errno.t] if the file
      could not be opened. *)

  val complete_hlt: t -> file
  (** [complete_hlt t] blocks until given [t] is complete. Returns a [file] or halts if the file
      could not be opened. *)
end

val of_path: ?flag:Flag.t -> ?mode:uns -> Path.t -> (t, Errno.t) result
(** [of_path ~flag ~mode path] opens or creates the file at [path] with [flag] (default Flag.R_O)
    Unix file permissions and [mode] (default 0o660) Unix file permissions and and returns the
    resulting [t] or an [Errno.t] if the file could not be opened. *)

val of_path_hlt: ?flag:Flag.t -> ?mode:uns -> Path.t -> t
(** [of_path_hlt ~flag ~mode path] opens or creates the file at [path] with [flag] (default
    Flag.R_O) Unix file permissions and [mode] (default 0o660) Unix file permissions and and returns
    the resulting [t] or halts if the file could not be opened. *)

module Close: sig
  type file = t
  type t
  (* An internally immutable token backed by an external I/O close completion data structure. *)

  val submit: file -> (t, Errno.t) result
  (** [submit file] submits a close for given [file]. This operation does not block. Returns a
      [t] to the close submission or an [Errno.t] if the close could not be submitted. *)

  val submit_hlt: file -> t
  (** [submit file] submits a close for given [file]. This operation does not block. Returns a
      [t] to the close submission or halts if the close could not be submitted. *)

  val complete: t -> Errno.t option
  (** [complete t] blocks until the given [t] is complete. Returns [None] or an [Errno.t] if file
      could not be closed. *)

  val complete_hlt: t -> unit
  (** [complete_hlt t] blocks until the given [t] is complete. Returns a [unit] or halts if file
      could not be closed. *)
end

val close: t -> Errno.t option
(** [close t] closes the external mutable Unix file descriptor associated with [t] and returns
    [None] or an [Errno.t] if it could not be closed. *)

val close_hlt: t -> unit
(** [close_hlt t] closes the external mutable Unix file descriptor associated with [t] and returns a
    [unit] or halts if it could not be closed. *)

module Read: sig
  type file = t
  type t
  (* An internally immutable token backed by an external I/O read completion data structure. *)

  val submit: ?count:uns -> ?buf:Bytes.Slice.t -> file -> (t, Errno.t) result
  (** [submit ?count ?buf file] submits a read for given [file]. If given, [count] is the maximum
      read size and 1024 otherwise. If given, [buf] is where read bytes are stored and the maximum
      read size is the minumum of [count] and the size of [buf]. If [buf] is not given, one will be
      created with size [count]. This operation does not block. Returns a [t] to the read submission
      or an [Errno.t] if the read could not be submitted. *)

  val submit_hlt: ?count:uns -> ?buf:Bytes.Slice.t -> file -> t
  (** [submit n buf file] submits a read for given [file]. If given, [count] is the maximum read
      size and 1024 otherwise. If given, [buf] is where read bytes are stored and the maximum read
      size is the minumum of [count] and the size of [buf]. If [buf] is not given, one will be
      created with size [count]. This operation does not block. Returns a [t] to the read submission
      or halts if the read could not be submitted. *)

  val complete: t -> (Bytes.Slice.t, Errno.t) result
  (** [complete t] blocks until the given [t] is complete. Returns the buffer into which bytes were
      read or an error if bytes could not be read. *)

  val complete_hlt: t -> Bytes.Slice.t
  (** [complete_hlt t] blocks until the given [t] is complete. Returns the buffer into which bytes
      were read or halts if bytes could not be read. *)
end

val read: ?count:uns -> ?buf:Bytes.Slice.t -> t -> (Bytes.Slice.t, Errno.t) result
(** [read ?count ?buf t] reads from given [t]. If given, [count] is the maximum read size and 1024
    otherwise. If given, [buf] is where read bytes are stored and the maximum read size is the
    minumum of [count] and the size of [buf]. If [buf] is not given, one will be created with size
    [count]. Returns the [Bytes.Slice.t] into which bytes were read or an [Errno.t] if bytes could
    not be read. *)

val read_hlt: ?count:uns -> ?buf:Bytes.Slice.t -> t -> Bytes.Slice.t
(** [read_hlt ?count ?buf t] reads from given [t]. If given, [count] is the maximum read size and
    1024 otherwise. If given, [buf] is where read bytes are stored and the maximum read size is the
    minumum of [count] and the size of [buf]. If [buf] is not given, one will be created with size
    [count]. Returns the [Bytes.Slice.t] into which bytes were read or halts if bytes could not be
    read. *)

module Write: sig
  type file = t
  type t
  (* An internally immutable token backed by an external I/O write completion data structure. *)

  val submit: Bytes.Slice.t -> file -> (t, Errno.t) result
  (** [submit bytes file] submits a write for of given [bytes] to given [file]. This operation does
      not block. Returns a [t] to the write submission or an [Errno.t] if the write could not be
      submitted. *)

  val submit_hlt: Bytes.Slice.t -> file -> t
  (** [submit bytes file] submits a write for of given [bytes] to given [file]. This operation
      does not block. Returns a [t] to the write submission or halts if the write could not be
      submitted. *)

  val complete: t ->  (Bytes.Slice.t, Errno.t) result
  (** [complete t] blocks until the given [t] is complete. Returns a [Bytes.Slice.t] of remaining
      bytes that were not written (typically empty) or an [Errno.t] if bytes could not be written.
  *)

  val complete_hlt: t -> Bytes.Slice.t
  (** [complete_hlt t] blocks until the given [t] is complete. Returns a [Bytes.Slice.t] of
      remaining bytes that were not written (typically empty) or halts if bytes could not be
      written. *)
end

val write: Bytes.Slice.t -> t -> Errno.t option
(** [write bytes t] writes [bytes] to [t] and returns [None] or an [Errno.t] if bytes could not be
    written. *)

val write_hlt: Bytes.Slice.t -> t -> unit
(** [write_hlt bytes t] writes [bytes] to [t] and returns a [unit] or halts if bytes could not be
    written. *)

val seek: sint -> t -> (uns, Errno.t) result
(** [seek i t] seeks the external mutable Unix file descriptor associated with [t] to point to the
    [i]th byte relative to the current byte position of the file. Returns an [uns] of the new byte
    index relative to the beginning of the file or an [Errno.t] if it could not be changed. *)

val seek_hlt: sint -> t -> uns
(** [seek_hlt i t] seeks the external mutable Unix file descriptor associated with [t] to point to
    the [i]th byte relative to the current byte position of the file. Returns an [uns] of the new
    byte index relative to the beginning of the file or halts if it could not be changed. *)

val seek_hd: sint -> t -> (uns, Errno.t) result
(** [seek_hd i t] seeks the external mutable Unix file descriptor associated with [t] to point to
    the [i]th byte relative to the head of the file. Returns an [uns] of the new byte index relative
    to the beginning of the file or an [Errno.t] if it could not be changed. *)

val seek_hd_hlt: sint -> t -> uns
(** [seek_hd_hlt i t] seeks the external mutable Unix file descriptor associated with [t] to point
    to the [i]th byte relative to the head of the file. Returns an [uns] of the new byte index
    relative to the beginning of the file or halts if it could not be changed. *)

val seek_tl: sint -> t -> (uns, Errno.t) result
(** [seek_tl i t] seeks the external mutable Unix file descriptor associated with [t] to point to
    the [i]th byte relative to the tail of the file. Returns an [uns] of the new byte index relative
    to the beginning of the file or an [Errno.t] if it could not be changed. *)

val seek_tl_hlt: sint -> t -> uns
(** [seek_tl_hlt i t] seeks the external mutable Unix file descriptor associated with [t] to point
    to the [i]th byte relative to the tail of the file. Returns an [uns] of the new byte index
    relative to the beginning of the file or halts if it could not be changed. *)

module Stream : sig
  type file = t

  type t = Bytes.Slice.t Stream.t

  val of_file: file -> t
  (** [of_file file] takes a [file] and returns a [t], a lazily initialized buffer stream that reads
      subsequent chunks of [file] into buffers when forced. *)

  val write: file -> t -> Errno.t option
  (** [write file t] takes an open [file] with write permissions and writes, in order, all buffers
      from [t] to it. Returns an error if not all bytes could be written. *)

  val write_hlt: file -> t -> unit
  (** [write_hlt file t] takes an open [file] with write permissions and writes, in order, all
      buffers from [t] to it. Halts if not all bytes could be written. *)
end

(** Formatters. *)
module Fmt : sig
  val bufsize_default: uns
  (** Default buffer size used by formatters created via [of_t]. *)

  val of_t: ?bufsize:uns -> t -> (module Fmt.Formatter)
  (** [of_t ~bufsize t] returns a buffered formatter which outputs to [t]. To disable buffering,
      specify [~bufsize:0]. *)

  val stdout: (module Fmt.Formatter)
  (** Buffered formatter which outputs to [stdout]. *)

  val stderr: (module Fmt.Formatter)
  (** Unbuffered formatter which outputs to [stderr]. *)

  val sink: (module Fmt.Formatter)
  (** Formatter which discards all input. *)
end

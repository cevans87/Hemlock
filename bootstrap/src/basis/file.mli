open Rudiments

module Error : sig
  type t
end

module Path = String

module Mode : sig
  type t =
  | R_O   (** open existing file for read, failing if it does not exist *)
  | W     (** create new or truncate existing file and open for write *)
  | W_A   (** create new or append to existing file and open for write *)
  | W_AO  (** append to existing file and open for write, failing if it does not
              exist *)
  | W_C   (** create new file and open for write, failing if file exists *)
  | W_O   (** truncate existing file and open for write, failing if file does
              not exist *)
  | RW    (** create new or truncate existing file and open for read and write *)
  | RW_A  (** create new append to existing file and open for read and write *)
  | RW_AO (** append to existing file and open for read and write, failing if
              file does not exist *)
  | RW_C  (** create new file and open for read and write, failing if file
              exists *)
  | RW_O  (** truncate existing file and open for read and write, failing if
              file does not exist *)
end

type t
(* mutable in Hemlock, as are any functions that take [t] *)

val of_path: ?mode:Mode.t -> Path.t -> (t, Error.t) Result.t

val of_path_hlt: ?mode:Mode.t -> Path.t -> t

val read: ?n:usize -> t -> (Bytes.t, Error.t) Result.t
val read_hlt: ?n:usize -> t -> Bytes.t

val write: ?i:usize -> ?n:usize -> Bytes.t -> t -> Error.t option
(*
val write_hlt: ?i:usize -> ?n:usize -> Bytes.t -> t -> unit
*)

val close: t -> Error.t option
(*
val close_hlt: t -> unit
*)
(*
val seek: t -> isize -> Error.t option
val seek_hlt: t -> isize -> unit
*)

module Stream : sig

  type outer = t
  type t = byte Stream.t

  (* mutable in Hemlock *)
  val of_file: outer -> t

  (* immutable in hemlock *)
  val of_path: Path.t -> (t, Error.t) Result.t
  (*)
  val of_path_hlt: Path.t -> t
  *)

  val write: outer -> t -> Error.t option
  val write_hlt: outer -> t -> unit
end

(** Byte array convenience functions.  {!type:string} can represent only
    well formed UTF-8-encoded {!type:codepoint} sequences, and ts
    provide a convenient less constrained representation for conversion to/from
    {!type:string}. *)

open Rudiments

type t = byte array

include Formattable_intf.S_mono with type t := t

val hash_fold: t -> Hash.State.t -> Hash.State.t
(** [hash_fold bytes] incorporates the hash of [bytes] into [state] and returns
    the resulting state. *)

val of_byte_stream: Byte.t Stream.t -> t
(** [of_byte_stream byte_stream] creates an array of bytes corresponding to the
    sequence of bytes in [byte_stream]. *)

val of_codepoint: codepoint -> t
(** [of_codepoint codepoint] creates an array of bytes corresponding to the
    UTF-8 encoding of [codepoint]. *)

val of_string: string -> t
(** [of_string string] creates an array of bytes corresponding to the UTF-8
    encoding of [string]. *)

val to_string: t -> string option
(** [to_string bytes] interprets [bytes] as a sequence of UTF-8 code points and
    returns a corresponding {!type:string}, or [None] if [bytes] is malformed.
*)

val to_string_hlt: t -> string
(** [to_string bytes] interprets [bytes] as a sequence of UTF-8 code points and
    returns a corresponding {!type:string}, or halts if [bytes] is malformed. *)

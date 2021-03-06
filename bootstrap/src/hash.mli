(** Hash type. *)

open Rudiments_int0

type t
(** Hash type.  All bits are i.i.d. uniform variables. *)

include Formattable_intf.S_mono with type t := t

module State : sig
  type t
  (** Hash state type. *)

  include Formattable_intf.S_mono with type t := t

  val empty: t
  (** Unseeded hash state (constant).  Note that no stateless hash functions
      exist, but they can be simulated.  For example, a stable {!type:usize}
      hash function can be implemented as [(fun u -> Usize.hash_fold u
      Hash.State.empty)]. *)

  val seed: t
  (** Return the seed state for this execution of the application.  The seed
      state is typically initialized using entropy bits provided by the
      operating system, but it can be explicitly initialized via the
      [HEMLOCK_ENTROPY] environment variable.  If [HEMLOCK_ENTROPY] is set,
      [seed] is set to the equivalent of [hash_fold_string HEMLOCK_ENTROPY
      empty]. *)

  val hash_fold_usize: usize -> t -> t
  (** [hash_fold_usize u state] incorporates the hash of [u] into [state] and
      returns the resulting state. *)

  val hash_fold_float: float -> t -> t
  (** [hash_fold_float f state] incorporates the hash of [f] into [state] and
      returns the resulting state. *)

  val hash_fold_string: string -> t -> t
  (** [hash_fold_string s state] incorporates the hash of [s] into [state] and
      returns the resulting state. *)
end

val t_of_state: State.t -> t
(** [t_of_state state] returns the hash value associated with [state]. *)

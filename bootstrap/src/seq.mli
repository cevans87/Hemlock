(** Functors for sequences. *)

open Seq_intf

(** Functor for definite monomorphic sequences. *)
module Make_def (T : I_mono_def) : S_mono_def with type t := T.t
                                               and type elm := T.elm

(** Functor for indefinite monomorphic sequences. *)
module Make_indef (T : I_mono_indef) : S_mono_indef with type t := T.t
                                                     and type elm := T.elm

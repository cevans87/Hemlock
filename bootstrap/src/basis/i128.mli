(* 128-bit signed integer.

    See {!module:ConvertIntf} for documentation on conversion functions. *)

type t
include IntwIntf.SFI with type t := t

val trunc_of_i512: I512.t -> t
val extend_to_i512: t -> I512.t
val narrow_of_i512_opt: I512.t -> t option
val narrow_of_i512_hlt: I512.t -> t

val trunc_of_u512: U512.t -> t
val narrow_of_u512_opt: U512.t -> t option
val widen_to_u512_opt: t -> U512.t option
val narrow_of_u512_hlt: U512.t -> t
val widen_to_u512_hlt: t -> U512.t

val trunc_of_i256: I256.t -> t
val extend_to_i256: t -> I256.t
val narrow_of_i256_opt: I256.t -> t option
val narrow_of_i256_hlt: I256.t -> t

val trunc_of_u256: U256.t -> t
val narrow_of_u256_opt: U256.t -> t option
val widen_to_u256_opt: t -> U256.t option
val narrow_of_u256_hlt: U256.t -> t
val widen_to_u256_hlt: t -> U256.t

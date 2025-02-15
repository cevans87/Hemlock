(* 256-bit unsigned integer.

    See {!module:ConvertIntf} for documentation on conversion functions. *)

type t
include IntwIntf.SFU with type t := t

val trunc_of_i512: I512.t -> t
val extend_to_i512: t -> I512.t
val narrow_of_i512_opt: I512.t -> t option
val narrow_of_i512_hlt: I512.t -> t

val trunc_of_u512: U512.t -> t
val extend_to_u512: t -> U512.t
val narrow_of_u512_opt: U512.t -> t option
val narrow_of_u512_hlt: U512.t -> t

val bits_of_i256: I256.t -> t
val bits_to_i256: t -> I256.t
val like_of_i256_opt: I256.t -> t option
val like_to_i256_opt: t -> I256.t option
val like_of_i256_hlt: I256.t -> t
val like_to_i256_hlt: t -> I256.t

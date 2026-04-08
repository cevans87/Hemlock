module type S = sig
  type t

  val bit_and : t -> t -> t
  val bit_or  : t -> t -> t
  val bit_xor : t -> t -> t
  val bit_not : t -> t
end

module U32 : S with type t = U32.t
module I32 : S with type t = I32.t

module type S = sig
  type t

  val bit_and : t -> t -> t
  val bit_or  : t -> t -> t
  val bit_xor : t -> t -> t
  val bit_not : t -> t
end

module U32 = struct
  type t = U32.t

  let bit_and = U32.bit_and
  let bit_or  = U32.bit_or
  let bit_xor = U32.bit_xor
  let bit_not = U32.bit_not
end

module I32 = struct
  type t = I32.t

  let bit_and = I32.bit_and
  let bit_or  = I32.bit_or
  let bit_xor = I32.bit_xor
  let bit_not = I32.bit_not
end

(* Partial Rudiments. *)
open RudimentsInt0

module T = struct
  module U = struct
    type t = uns
    let bit_length = 32L
  end
  include U
  include Intnb.MakeU(U)
end
include T

module UZ = Convert.Make_nbU_wZ(T)(Zint)
let trunc_of_zint = UZ.trunc_of_x
let extend_to_zint = UZ.extend_to_x
let narrow_of_zint_opt = UZ.narrow_of_x_opt
let narrow_of_zint_hlt = UZ.narrow_of_x_hlt

module UN = Convert.Make_nbU_wN(T)(Nat)
let trunc_of_nat = UN.trunc_of_u
let extend_to_nat = UN.extend_to_u
let narrow_of_nat_opt = UN.narrow_of_u_opt
let narrow_of_nat_hlt = UN.narrow_of_u_hlt

module UX512 = Convert.Make_nbU_wX(T)(I512)
let trunc_of_i512 = UX512.trunc_of_x
let extend_to_i512 = UX512.extend_to_x
let narrow_of_i512_opt = UX512.narrow_of_x_opt
let narrow_of_i512_hlt = UX512.narrow_of_x_hlt

module UU512 = Convert.Make_nbU_wU(T)(U512)
let trunc_of_u512 = UU512.trunc_of_u
let extend_to_u512 = UU512.extend_to_u
let narrow_of_u512_opt = UU512.narrow_of_u_opt
let narrow_of_u512_hlt = UU512.narrow_of_u_hlt

module UX256 = Convert.Make_nbU_wX(T)(I256)
let trunc_of_i256 = UX256.trunc_of_x
let extend_to_i256 = UX256.extend_to_x
let narrow_of_i256_opt = UX256.narrow_of_x_opt
let narrow_of_i256_hlt = UX256.narrow_of_x_hlt

module UU256 = Convert.Make_nbU_wU(T)(U256)
let trunc_of_u256 = UU256.trunc_of_u
let extend_to_u256 = UU256.extend_to_u
let narrow_of_u256_opt = UU256.narrow_of_u_opt
let narrow_of_u256_hlt = UU256.narrow_of_u_hlt

module UX128 = Convert.Make_nbU_wX(T)(I128)
let trunc_of_i128 = UX128.trunc_of_x
let extend_to_i128 = UX128.extend_to_x
let narrow_of_i128_opt = UX128.narrow_of_x_opt
let narrow_of_i128_hlt = UX128.narrow_of_x_hlt

module UU128 = Convert.Make_nbU_wU(T)(U128)
let trunc_of_u128 = UU128.trunc_of_u
let extend_to_u128 = UU128.extend_to_u
let narrow_of_u128_opt = UU128.narrow_of_u_opt
let narrow_of_u128_hlt = UU128.narrow_of_u_hlt

include Convert.Make_nbU(T)

module UI32 = Convert.Make_nbU_nbI(T)(I32)
let bits_of_i32 = UI32.bits_of_x
let bits_to_i32 = UI32.bits_to_x
let like_of_i32_opt = UI32.like_of_x_opt
let like_to_i32_opt = UI32.like_to_x_opt
let like_of_i32_hlt = UI32.like_of_x_hlt
let like_to_i32_hlt = UI32.like_to_x_hlt

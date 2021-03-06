(* Aliases. *)

module Isize = I63
module Usize = U63
module Codepoint = U21
module Byte = U8

(* Types. *)

type i63 = I63.t

type u63 = U63.t

type u21 = U21.t
type codepoint = Codepoint.t

type u8 = U8.t
type byte = Byte.t

include Rudiments_functions
include Rudiments_int

(* Partial Rudiments. *)
module Isize = I63
module Usize = U63
module Codepoint = U21
type codepoint = Codepoint.t
open Rudiments_int
open Rudiments_functions

module T = struct
  type t = usize
  let num_bits = 8
end
include T
include Intnb.Make_u(T)

let to_isize t =
  Usize.to_isize t

let of_isize x =
  narrow_of_signed x

let of_isize_hlt x =
  let t = of_isize x in
  let x' = to_isize t in
  match Isize.(x' = x) with
  | false -> halt "Lossy conversion"
  | true -> t

let kv x =
  narrow_of_unsigned x

let to_usize t =
  t

let of_usize x =
  narrow_of_unsigned x

let of_usize_hlt x =
  let t = of_usize x in
  let x' = to_usize t in
  match Usize.(x' = x) with
  | false -> halt "Lossy conversion"
  | true -> t

let of_char c =
  Stdlib.Char.code c

let to_codepoint t =
  Codepoint.of_usize (to_usize t)

let of_codepoint x =
  narrow_of_unsigned (Codepoint.to_usize x)

let of_codepoint_hlt x =
  let t = of_codepoint x in
  let x' = to_codepoint (to_usize t) in
  match Codepoint.(x' = x) with
  | false -> halt "Lossy conversion"
  | true -> t

(*******************************************************************************
 * Begin tests.
 *)

let%expect_test "pp,pp_x" =
  let open Format in
  let rec fn = function
  | [] -> ()
  | x :: xs' -> begin
      printf "%a %a\n" pp x pp_x x;
      fn xs'
    end
  in
  printf "@[<h>";
  fn [kv 0; kv 1; kv 42; kv 255];
  printf "@]";

  [%expect{|
0u8 0x00u8
1u8 0x01u8
42u8 0x2au8
255u8 0xffu8
    |}]

let%expect_test "limits" =
  let open Format in

  printf "num_bits=%a\n" Usize.pp num_bits;
  printf "min_value=%a\n" pp_x min_value;
  printf "max_value=%a\n" pp_x max_value;

  [%expect{|
    num_bits=8
    min_value=0x00u8
    max_value=0xffu8
    |}]

let%expect_test "rel" =
  let open Format in
  let fn x y = begin
    printf "cmp %a %a -> %a\n" pp_x x pp_x y Cmp.pp (cmp x y);
    printf "%a >= %a -> %b\n" pp_x x pp_x y (x >= y);
    printf "%a <= %a -> %b\n" pp_x x pp_x y (x <= y);
    printf "%a = %a -> %b\n" pp_x x pp_x y (x = y);
    printf "%a > %a -> %b\n" pp_x x pp_x y (x > y);
    printf "%a < %a -> %b\n" pp_x x pp_x y (x < y);
    printf "%a <> %a -> %b\n" pp_x x pp_x y (x <> y);
    printf "ascending %a %a -> %a\n" pp_x x pp_x y Cmp.pp (ascending x y);
    printf "descending %a %a -> %a\n" pp_x x pp_x y Cmp.pp (descending x y);
  end in
  fn (kv 0) (kv 0x80);
  printf "\n";
  fn (kv 0) (kv 0xff);
  printf "\n";
  fn (kv 0x80) (kv 0xff);
  let fn2 t min max = begin
    printf "\n";
    printf "clamp %a ~min:%a ~max:%a -> %a\n"
      pp_x t pp_x min pp_x max pp_x (clamp t ~min ~max);
    printf "between %a ~low:%a ~high:%a -> %b\n"
      pp_x t pp_x min pp_x max (between t ~low:min ~high:max);
  end in
  fn2 (kv 0x7e) (kv 0x7f) (kv 0x81);
  fn2 (kv 0x7f) (kv 0x7f) (kv 0x81);
  fn2 (kv 0x80) (kv 0x7f) (kv 0x81);
  fn2 (kv 0x81) (kv 0x7f) (kv 0x81);
  fn2 (kv 0x82) (kv 0x7f) (kv 0x81);

  [%expect{|
    cmp 0x00u8 0x80u8 -> Lt
    0x00u8 >= 0x80u8 -> false
    0x00u8 <= 0x80u8 -> true
    0x00u8 = 0x80u8 -> false
    0x00u8 > 0x80u8 -> false
    0x00u8 < 0x80u8 -> true
    0x00u8 <> 0x80u8 -> true
    ascending 0x00u8 0x80u8 -> Lt
    descending 0x00u8 0x80u8 -> Gt

    cmp 0x00u8 0xffu8 -> Lt
    0x00u8 >= 0xffu8 -> false
    0x00u8 <= 0xffu8 -> true
    0x00u8 = 0xffu8 -> false
    0x00u8 > 0xffu8 -> false
    0x00u8 < 0xffu8 -> true
    0x00u8 <> 0xffu8 -> true
    ascending 0x00u8 0xffu8 -> Lt
    descending 0x00u8 0xffu8 -> Gt

    cmp 0x80u8 0xffu8 -> Lt
    0x80u8 >= 0xffu8 -> false
    0x80u8 <= 0xffu8 -> true
    0x80u8 = 0xffu8 -> false
    0x80u8 > 0xffu8 -> false
    0x80u8 < 0xffu8 -> true
    0x80u8 <> 0xffu8 -> true
    ascending 0x80u8 0xffu8 -> Lt
    descending 0x80u8 0xffu8 -> Gt

    clamp 0x7eu8 ~min:0x7fu8 ~max:0x81u8 -> 0x7fu8
    between 0x7eu8 ~low:0x7fu8 ~high:0x81u8 -> false

    clamp 0x7fu8 ~min:0x7fu8 ~max:0x81u8 -> 0x7fu8
    between 0x7fu8 ~low:0x7fu8 ~high:0x81u8 -> true

    clamp 0x80u8 ~min:0x7fu8 ~max:0x81u8 -> 0x80u8
    between 0x80u8 ~low:0x7fu8 ~high:0x81u8 -> true

    clamp 0x81u8 ~min:0x7fu8 ~max:0x81u8 -> 0x81u8
    between 0x81u8 ~low:0x7fu8 ~high:0x81u8 -> true

    clamp 0x82u8 ~min:0x7fu8 ~max:0x81u8 -> 0x81u8
    between 0x82u8 ~low:0x7fu8 ~high:0x81u8 -> false
    |}]

let%expect_test "wraparound" =
  let open Format in
  let fifteen = (kv 15) in
  printf "max_value + %a -> %a\n" pp one pp_x (max_value + one);
  printf "min_value - %a -> %a\n" pp one pp_x (min_value - one);
  printf "max_value * %a -> %a\n" pp fifteen pp_x (max_value * fifteen);

  [%expect{|
    max_value + 1u8 -> 0x00u8
    min_value - 1u8 -> 0xffu8
    max_value * 15u8 -> 0xf1u8
    |}]

let%expect_test "conversion" =
  let open Format in
  let rec fn = function
    | [] -> ()
    | x :: xs' -> begin
        let i = isize_of_int x in
        let t = of_isize i in
        let i' = to_isize t in
        let t' = of_isize i' in
        printf "of_isize %a -> to_isize %a -> of_isize %a -> %a\n"
          Isize.pp_x i pp_x t Isize.pp i pp_x t';
        let t = of_usize (Usize.of_isize i) in
        let u = to_usize t in
        let t' = of_usize u in
        printf "of_usize %a -> to_usize %a -> of_usize %a -> %a\n"
          Isize.pp_x i pp_x t Usize.pp_x u pp_x t';

        let c = U21.of_usize (Usize.of_isize i) in
        let t = of_codepoint c in
        let c' = to_codepoint t in
        let t' = of_codepoint c' in
        printf ("Codepoint.of_usize %a -> of_codepoint %a -> " ^^
          "to_codepoint %a -> of_codepoint %a -> %a\n") Usize.pp_x x
          Codepoint.pp_x c pp_x t Codepoint.pp_x c' pp_x t';

        fn xs'
      end
  in
  fn [Usize.max_value; 0; 42; 127; 128; 255; 256; 257;
      Usize.of_isize Isize.max_value];

  [%expect{|
    of_isize 0x7fffffffffffffffi -> to_isize 0xffu8 -> of_isize -1i -> 0xffu8
    of_usize 0x7fffffffffffffffi -> to_usize 0xffu8 -> of_usize 0x00000000000000ff -> 0xffu8
    Codepoint.of_usize 0x7fffffffffffffff -> of_codepoint 0x1fffffu21 -> to_codepoint 0xffu8 -> of_codepoint 0x0000ffu21 -> 0xffu8
    of_isize 0x0000000000000000i -> to_isize 0x00u8 -> of_isize 0i -> 0x00u8
    of_usize 0x0000000000000000i -> to_usize 0x00u8 -> of_usize 0x0000000000000000 -> 0x00u8
    Codepoint.of_usize 0x0000000000000000 -> of_codepoint 0x000000u21 -> to_codepoint 0x00u8 -> of_codepoint 0x000000u21 -> 0x00u8
    of_isize 0x000000000000002ai -> to_isize 0x2au8 -> of_isize 42i -> 0x2au8
    of_usize 0x000000000000002ai -> to_usize 0x2au8 -> of_usize 0x000000000000002a -> 0x2au8
    Codepoint.of_usize 0x000000000000002a -> of_codepoint 0x00002au21 -> to_codepoint 0x2au8 -> of_codepoint 0x00002au21 -> 0x2au8
    of_isize 0x000000000000007fi -> to_isize 0x7fu8 -> of_isize 127i -> 0x7fu8
    of_usize 0x000000000000007fi -> to_usize 0x7fu8 -> of_usize 0x000000000000007f -> 0x7fu8
    Codepoint.of_usize 0x000000000000007f -> of_codepoint 0x00007fu21 -> to_codepoint 0x7fu8 -> of_codepoint 0x00007fu21 -> 0x7fu8
    of_isize 0x0000000000000080i -> to_isize 0x80u8 -> of_isize 128i -> 0x80u8
    of_usize 0x0000000000000080i -> to_usize 0x80u8 -> of_usize 0x0000000000000080 -> 0x80u8
    Codepoint.of_usize 0x0000000000000080 -> of_codepoint 0x000080u21 -> to_codepoint 0x80u8 -> of_codepoint 0x000080u21 -> 0x80u8
    of_isize 0x00000000000000ffi -> to_isize 0xffu8 -> of_isize 255i -> 0xffu8
    of_usize 0x00000000000000ffi -> to_usize 0xffu8 -> of_usize 0x00000000000000ff -> 0xffu8
    Codepoint.of_usize 0x00000000000000ff -> of_codepoint 0x0000ffu21 -> to_codepoint 0xffu8 -> of_codepoint 0x0000ffu21 -> 0xffu8
    of_isize 0x0000000000000100i -> to_isize 0x00u8 -> of_isize 256i -> 0x00u8
    of_usize 0x0000000000000100i -> to_usize 0x00u8 -> of_usize 0x0000000000000000 -> 0x00u8
    Codepoint.of_usize 0x0000000000000100 -> of_codepoint 0x000100u21 -> to_codepoint 0x00u8 -> of_codepoint 0x000000u21 -> 0x00u8
    of_isize 0x0000000000000101i -> to_isize 0x01u8 -> of_isize 257i -> 0x01u8
    of_usize 0x0000000000000101i -> to_usize 0x01u8 -> of_usize 0x0000000000000001 -> 0x01u8
    Codepoint.of_usize 0x0000000000000101 -> of_codepoint 0x000101u21 -> to_codepoint 0x01u8 -> of_codepoint 0x000001u21 -> 0x01u8
    of_isize 0x3fffffffffffffffi -> to_isize 0xffu8 -> of_isize 4611686018427387903i -> 0xffu8
    of_usize 0x3fffffffffffffffi -> to_usize 0xffu8 -> of_usize 0x00000000000000ff -> 0xffu8
    Codepoint.of_usize 0x3fffffffffffffff -> of_codepoint 0x1fffffu21 -> to_codepoint 0xffu8 -> of_codepoint 0x0000ffu21 -> 0xffu8
    |}]

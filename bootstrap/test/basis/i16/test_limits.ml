open! Basis.Rudiments
open! Basis
open I16
open Format

let test () =
  printf "bit_length=%a\n" Uns.xpp (bit_pop (bit_not zero));
  printf "min_value=%a %a\n" xpp min_value xpp_x min_value;
  printf "max_value=%a %a\n" xpp max_value xpp_x max_value

let _ = test ()

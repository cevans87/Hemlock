open! Basis.Rudiments
open! Basis
open U256
open Format

let test () =
  let fifteen = of_string "15" in
  printf "max_value + %a -> %a\n" pp one pp_x (max_value + one);
  printf "min_value - %a -> %a\n" pp one pp_x (min_value - one);
  printf "max_value * %a -> %a\n" pp fifteen pp_x (max_value * fifteen)

let _ = test ()

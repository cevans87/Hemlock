open! Basis.Rudiments
open! Basis
open N
open Format

let test () =
  let rec fn = function
    | [] -> ()
    | x :: xs' -> begin
        printf "%a %a %a %a\n" pp_b x pp_o x pp x pp_x x;
        fn xs'
      end
  in
  printf "@[<h>";
  fn [
    zero;
    one;
    of_string "42";
  ];
  printf "@]"

let _ = test ()

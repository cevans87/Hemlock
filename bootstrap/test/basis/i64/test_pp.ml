open! Basis.Rudiments
open! Basis
open I64
open Format

let test () =
  let rec fn = function
    | [] -> ()
    | x :: xs' -> begin
        printf "%a %a %a %a\n" xpp_b x xpp_o x xpp x xpp_x x;
        fn xs'
      end
  in
  printf "@[<h>";
  fn [
    zero;
    one;
    of_string "42";
    min_value;
    max_value;
  ];
  printf "@]"

let _ = test ()

open! Basis.Rudiments
open! Basis
open U8
open Format

let test () =
  printf "@[<h>";
  let rec print_xs xs = begin
    match xs with
    | [] -> ()
    | x :: xs' -> begin
        printf "%a, %a, %a, %a\n" pp_b x pp_o x pp x pp_x x;
        print_xs xs'
      end
  end in
  print_xs [
    min_value;
    kv 42L;
    max_value;
  ];
  printf "@]"

let test2 () =
  let rec fn = function
    | [] -> ()
    | x :: xs' -> begin
        printf "%a %a\n" pp x pp_x x;
        fn xs'
      end
  in
  printf "@[<h>";
  fn [kv 0L; kv 1L; kv 42L; kv 255L];
  printf "@]"

let _ = test ()
let _ = test2 ()

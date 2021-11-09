open! Basis.Rudiments
open! Basis
open Z
open Format

let test () =
  printf "@[<h>";
  let rec test_pairs = function
    | [] -> ()
    | (x, y) :: pairs' -> begin
        printf "min,max %a %a -> %a, %a\n"
          xpp_x x xpp_x y xpp_x (min x y) xpp_x (max x y);
        test_pairs pairs'
      end
  in
  let pairs = [
    (of_string "0", of_string "0");
    (of_string "0", of_string "1");
    (of_string "1", of_string "0");
    (of_string "1", of_string "1");
    (of_string "0", of_string
        "0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff");
  ] in
  test_pairs pairs;
  printf "@]"

let _ = test ()

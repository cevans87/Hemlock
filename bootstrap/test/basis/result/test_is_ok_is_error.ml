open! Basis.Rudiments
open! Basis
open Result
open Format

let test () =
  printf "@[<h>";
  List.iter [Ok "ok"; Error "error"] ~f:(fun result ->
    printf "is_ok %a -> %b\n" (pp String.pp String.pp) result (is_ok result);
    printf "is_error %a -> %b\n"
      (pp String.pp String.pp) result (is_error result);
  );
  printf "@]"

let _ = test ()

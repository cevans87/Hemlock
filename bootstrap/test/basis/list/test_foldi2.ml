open! Basis.Rudiments
open! Basis
open List
open Format

let test () =
  let list_pairs = [
    ([], []);

    ([100L], [200L]);
    ([100L; 110L], [200L; 210L]);
    ([100L; 110L; 120L], [200L; 210L; 220L]);
  ] in
  let f i accum a_elm b_elm = begin
    (i + a_elm + b_elm) :: accum
  end in
  printf "@[<h>";
  iter list_pairs ~f:(fun (a, b) ->
    printf "foldi2 %a %a -> %a\n"
      (pp Uns.pp) a
      (pp Uns.pp) b
      (pp Uns.pp) (foldi2 a b ~init:[] ~f)
    ;
  );
  printf "@]"

let _ = test ()

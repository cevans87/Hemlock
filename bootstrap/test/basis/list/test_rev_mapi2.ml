open! Basis.Rudiments
open! Basis
open List
open Format

let test () =
  let list_pairs = [
    ([], []);
    ([10L], [100L]);
    ([10L; 20L], [100L; 200L]);
    ([10L; 20L; 30L], [100L; 200L; 300L]);
  ] in
  let f i a b = (b + a + i + 1L) in
  printf "@[<h>";
  iter list_pairs ~f:(fun (a, b) ->
    printf "    mapi2 %a %a -> %a\n"
      (xpp Uns.xpp) a
      (xpp Uns.xpp) b
      (xpp Uns.xpp) (mapi2 a b ~f)
    ;

    printf "rev_mapi2 %a %a -> %a\n"
      (xpp Uns.xpp) a
      (xpp Uns.xpp) b
      (xpp Uns.xpp) (rev_mapi2 a b ~f)
  );
  printf "@]"

let _ = test ()

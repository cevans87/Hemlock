open! Basis.Rudiments
open! Basis
open MapTest
open Map
open Format

let test () =
  printf "@[";
  let test k map descr = begin
    validate map;
    printf "--- %s ---@\n" descr;
    let map' = remove_hlt k map in
    validate map';
    printf "@[<v>remove_hlt %a@;<0 2>@[<v>%a ->@,%a@]@]@\n"
      Uns.pp k (pp String.pp) map (pp String.pp) map'
  end in
  let test_tuples = [
    ([(0L, "0")], 0L,                       "Member, length 1 -> 0.");
    ([(0L, "0"); (1L, "1")], 1L,            "Member, length 2 -> 1.");
    ([(0L, "0"); (1L, "1"); (2L, "2")], 2L, "Member, length 3 -> 2.");
  ] in
  List.iter test_tuples ~f:(fun (kvs, k, descr) ->
    let map = of_alist (module UnsTestCmper) kvs in
    test k map descr
  );
  printf "@]"

let _ = test ()

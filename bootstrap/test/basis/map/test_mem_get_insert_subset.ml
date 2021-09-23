open! Basis.Rudiments
open! Basis
open MapTest
open Map

let test () =
  let rec test ks map = begin
    match ks with
    | [] -> ()
    | k :: ks' -> begin
        assert (not (mem k map));
        assert (Option.is_none (get k map));
        let v = k * 100L in
        let map' = insert ~k ~v map in
        validate map';
        assert (mem k map');
        assert ((get_hlt k map') = v);
        assert (subset veq map' map);
        assert (not (subset veq map map'));
        test ks' map'
      end
  end in
  let ks = [1L; 3L; 2L; 42L; 44L; 45L; 56L; 60L; 66L; 75L; 81L; 91L; 420L; 421L; 4200L] in
  test ks (empty (module UnsTestCmper))

let _ = test ()

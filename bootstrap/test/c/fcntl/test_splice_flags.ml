open Basis
open Os.C.Fcntl

let () =
  let flags = [|
    ("move",     Splice.F.move);
    ("nonblock", Splice.F.nonblock);
    ("more",     Splice.F.more);
    ("gift",     Splice.F.gift);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Splice.F.%s: %Ld\n" name (U32.extend_to_uns v)
  ) flags;

  Printf.printf "splice_flags: ok\n"

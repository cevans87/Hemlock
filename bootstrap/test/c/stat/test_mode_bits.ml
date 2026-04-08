open Basis
open Os.C.Stat

let () =
  let bits = [|
    ("irusr", Mode.irusr);
    ("iwusr", Mode.iwusr);
    ("ixusr", Mode.ixusr);
    ("irwxu", Mode.irwxu);
    ("irgrp", Mode.irgrp);
    ("iwgrp", Mode.iwgrp);
    ("ixgrp", Mode.ixgrp);
    ("irwxg", Mode.irwxg);
    ("iroth", Mode.iroth);
    ("iwoth", Mode.iwoth);
    ("ixoth", Mode.ixoth);
    ("irwxo", Mode.irwxo);
    ("isuid", Mode.isuid);
    ("isgid", Mode.isgid);
    ("isvtx", Mode.isvtx);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Mode.%s: %Ld\n" name (U32.extend_to_uns v)
  ) bits;

  (* irwxu = irusr | iwusr | ixusr *)
  assert U32.(Mode.irwxu = Mode.(irusr |> bit_or iwusr |> bit_or ixusr));
  (* irwxg = irgrp | iwgrp | ixgrp *)
  assert U32.(Mode.irwxg = Mode.(irgrp |> bit_or iwgrp |> bit_or ixgrp));
  (* irwxo = iroth | iwoth | ixoth *)
  assert U32.(Mode.irwxo = Mode.(iroth |> bit_or iwoth |> bit_or ixoth));

  Printf.printf "mode_bits: ok\n"

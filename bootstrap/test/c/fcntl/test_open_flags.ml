open Basis
open Os.C.Fcntl

let () =
  let flags = [|
    ("rdonly",    O.rdonly);
    ("wronly",    O.wronly);
    ("rdwr",      O.rdwr);
    ("creat",     O.creat);
    ("excl",      O.excl);
    ("noctty",    O.noctty);
    ("trunc",     O.trunc);
    ("append",    O.append);
    ("nonblock",  O.nonblock);
    ("dsync",     O.dsync);
    ("sync",      O.sync);
    ("directory", O.directory);
    ("nofollow",  O.nofollow);
    ("cloexec",   O.cloexec);
    ("path",      O.path);
    ("tmpfile",   O.tmpfile);
  |] in
  Array.iter ~f:(fun (name, v) ->
    Printf.printf "O.%s: %Ld\n" name (U32.extend_to_uns v)
  ) flags;

  (* Verify rdonly is 0, wronly and rdwr are distinct and non-zero *)
  assert U32.(O.rdonly = kv 0L);
  assert U32.(O.wronly > kv 0L);
  assert U32.(O.rdwr > kv 0L);
  assert U32.(O.wronly <> O.rdwr);

  (* Verify creat, trunc, append are distinct *)
  assert U32.(O.creat <> O.trunc);
  assert U32.(O.creat <> O.append);
  assert U32.(O.trunc <> O.append);

  Printf.printf "open_flags: ok\n"

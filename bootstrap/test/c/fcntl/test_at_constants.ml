open Basis
open Os.C.Fcntl

let () =
  Printf.printf "At.fdcwd: %Ld\n" (I32.extend_to_sint At.fdcwd);
  Printf.printf "At.removedir: %Ld\n" (U32.extend_to_uns At.removedir);
  Printf.printf "At.symlink_nofollow: %Ld\n" (U32.extend_to_uns At.symlink_nofollow);
  Printf.printf "At.symlink_follow: %Ld\n" (U32.extend_to_uns At.symlink_follow);
  Printf.printf "At.empty_path: %Ld\n" (U32.extend_to_uns At.empty_path);
  Printf.printf "At.eaccess: %Ld\n" (U32.extend_to_uns At.eaccess);

  (* AT_FDCWD is negative *)
  assert I32.(At.fdcwd < kv 0L);

  (* AT flags are distinct and non-zero *)
  assert U32.(At.removedir > kv 0L);
  assert U32.(At.symlink_nofollow > kv 0L);
  assert U32.(At.empty_path > kv 0L);
  assert U32.(At.removedir <> At.symlink_nofollow);

  Printf.printf "at_constants: ok\n"

open Basis
open Os.C.Sockaddr

let () =
  (* Create a Unix-domain socket address *)
  let path = "/tmp/hemlock_test.sock" in
  let sa = sockaddr_un_make ~path in

  let got_path = sockaddr_un_path sa in
  assert Stdlib.(got_path = path);
  Printf.printf "path: %s\n" got_path;

  (* Verify length is non-zero *)
  let len = length sa in
  assert U32.(len > kv 0L);
  Printf.printf "length: %Ld\n" (U32.extend_to_uns len);

  (* Test alloc: zeroed sockaddr_un should have empty path *)
  let sa0 = sockaddr_un_alloc () in
  let got_path0 = sockaddr_un_path sa0 in
  assert Stdlib.(got_path0 = "");
  Printf.printf "alloc path: \"%s\"\n" got_path0;

  Printf.printf "sockaddr_un: ok\n"

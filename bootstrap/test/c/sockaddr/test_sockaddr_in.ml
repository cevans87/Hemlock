open Basis
open Os.C.Sockaddr

let () =
  (* Create an IPv4 address for 127.0.0.1:8080 *)
  let port = U16.kv 8080L in
  let addr = U32.kv 0x7f000001L in
  let sa = sockaddr_in_make ~port ~addr in

  let got_port = sockaddr_in_port sa in
  let got_addr = sockaddr_in_addr sa in

  assert U16.(got_port = port);
  assert U32.(got_addr = addr);

  Printf.printf "port: %Ld\n" (U16.extend_to_uns got_port);
  Printf.printf "addr: 0x%08Lx\n" (U32.extend_to_uns got_addr);

  (* Verify length is non-zero *)
  let len = length sa in
  assert U32.(len > kv 0L);
  Printf.printf "length: %Ld\n" (U32.extend_to_uns len);

  (* Test alloc: zeroed sockaddr_in should have port=0, addr=0 *)
  let sa0 = sockaddr_in_alloc () in
  assert U16.(sockaddr_in_port sa0 = kv 0L);
  assert U32.(sockaddr_in_addr sa0 = kv 0L);
  Printf.printf "alloc port: %Ld\n" (U16.extend_to_uns (sockaddr_in_port sa0));
  Printf.printf "alloc addr: 0x%08Lx\n" (U32.extend_to_uns (sockaddr_in_addr sa0));

  Printf.printf "sockaddr_in: ok\n"

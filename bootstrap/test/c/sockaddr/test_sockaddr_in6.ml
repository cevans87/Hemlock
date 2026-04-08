open Basis
open Os.C.Sockaddr

let () =
  (* Create an IPv6 loopback address [::1]:9090 with scope_id=0 *)
  let port = U16.kv 9090L in
  let addr = Stdlib.Bytes.create 16 in
  Stdlib.Bytes.set addr 15 (Stdlib.Char.chr 1);  (* ::1 in network byte order *)
  let scope_id = U32.kv 0L in
  let sa = sockaddr_in6_make ~port ~addr ~scope_id in

  let got_port = sockaddr_in6_port sa in
  let got_addr = sockaddr_in6_addr sa in
  let got_scope = sockaddr_in6_scope_id sa in

  assert U16.(got_port = port);
  assert Stdlib.(Bytes.get got_addr 15 = Char.chr 1);
  assert U32.(got_scope = scope_id);

  Printf.printf "port: %Ld\n" (U16.extend_to_uns got_port);
  Printf.printf "addr[15]: %d\n" (Stdlib.Char.code (Stdlib.Bytes.get got_addr 15));
  Printf.printf "scope_id: %Ld\n" (U32.extend_to_uns got_scope);

  (* Verify length is non-zero *)
  let len = length sa in
  assert U32.(len > kv 0L);
  Printf.printf "length: %Ld\n" (U32.extend_to_uns len);

  (* Test alloc: zeroed sockaddr_in6 *)
  let sa0 = sockaddr_in6_alloc () in
  assert U16.(sockaddr_in6_port sa0 = kv 0L);
  assert U32.(sockaddr_in6_scope_id sa0 = kv 0L);
  Printf.printf "alloc port: %Ld\n" (U16.extend_to_uns (sockaddr_in6_port sa0));
  Printf.printf "alloc scope_id: %Ld\n" (U32.extend_to_uns (sockaddr_in6_scope_id sa0));

  Printf.printf "sockaddr_in6: ok\n"

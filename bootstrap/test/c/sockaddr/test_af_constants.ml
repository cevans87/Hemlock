open Basis
open Os.C.Sockaddr

let () =
  (* Verify address family constants are distinct and non-zero *)
  assert U16.(af_inet > kv 0L);
  assert U16.(af_inet6 > kv 0L);
  assert U16.(af_unix > kv 0L);
  assert U16.(af_inet <> af_inet6);
  assert U16.(af_inet <> af_unix);
  assert U16.(af_inet6 <> af_unix);

  Printf.printf "af_inet: %Ld\n" (U16.extend_to_uns af_inet);
  Printf.printf "af_inet6: %Ld\n" (U16.extend_to_uns af_inet6);
  Printf.printf "af_unix: %Ld\n" (U16.extend_to_uns af_unix);
  Printf.printf "af_constants: ok\n"

open Basis
open Os.C.Socket

let () =
  let protos = [|
    ("ip",   Ipproto.ip);
    ("tcp",  Ipproto.tcp);
    ("udp",  Ipproto.udp);
    ("ipv6", Ipproto.ipv6);
    ("raw",  Ipproto.raw);
  |] in
  Array.iter ~f:(fun (name, v) ->
    Printf.printf "Ipproto.%s: %Ld\n" name (U32.extend_to_uns v)
  ) protos;

  (* tcp and udp are distinct and non-zero *)
  assert U32.(Ipproto.tcp > kv 0L);
  assert U32.(Ipproto.udp > kv 0L);
  assert U32.(Ipproto.tcp <> Ipproto.udp);

  Printf.printf "ipproto: ok\n"

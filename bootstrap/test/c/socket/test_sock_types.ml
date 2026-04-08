open Basis
open Os.C.Socket

let () =
  let types = [|
    ("stream",    Sock.stream);
    ("dgram",     Sock.dgram);
    ("raw",       Sock.raw);
    ("seqpacket", Sock.seqpacket);
    ("nonblock",  Sock.nonblock);
    ("cloexec",   Sock.cloexec);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Sock.%s: %Ld\n" name (U32.extend_to_uns v)
  ) types;

  (* stream and dgram are distinct *)
  assert U32.(Sock.stream <> Sock.dgram);

  Printf.printf "sock_types: ok\n"

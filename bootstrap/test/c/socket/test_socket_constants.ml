open Basis
open Os.C.Socket

let () =
  (* Sol *)
  assert U32.(Sol.socket > kv 0L);
  Printf.printf "Sol.socket: %Ld\n" (U32.extend_to_uns Sol.socket);

  (* So *)
  let opts = [|
    ("reuseaddr", So.reuseaddr);
    ("reuseport", So.reuseport);
    ("keepalive", So.keepalive);
    ("sndbuf",    So.sndbuf);
    ("rcvbuf",    So.rcvbuf);
    ("linger",    So.linger);
    ("error",     So.error);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "So.%s: %Ld\n" name (U32.extend_to_uns v)
  ) opts;

  (* Msg *)
  let msg_flags = [|
    ("dontwait", Msg.dontwait);
    ("nosignal", Msg.nosignal);
    ("more",     Msg.more);
    ("waitall",  Msg.waitall);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Msg.%s: %Ld\n" name (U32.extend_to_uns v)
  ) msg_flags;

  (* Shut *)
  Printf.printf "Shut.rd: %Ld\n" (U32.extend_to_uns Shut.rd);
  Printf.printf "Shut.wr: %Ld\n" (U32.extend_to_uns Shut.wr);
  Printf.printf "Shut.rdwr: %Ld\n" (U32.extend_to_uns Shut.rdwr);
  assert U32.(Shut.rd <> Shut.wr);
  assert U32.(Shut.rd <> Shut.rdwr);
  assert U32.(Shut.wr <> Shut.rdwr);

  Printf.printf "socket_constants: ok\n"

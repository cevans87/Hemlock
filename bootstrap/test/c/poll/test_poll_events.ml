open Basis
open Os.C.Poll

let () =
  let events = [|
    ("pollin",   Event.pollin);
    ("pollout",  Event.pollout);
    ("pollerr",  Event.pollerr);
    ("pollhup",  Event.pollhup);
    ("pollnval", Event.pollnval);
    ("pollpri",  Event.pollpri);
    ("pollrdhup", Event.pollrdhup);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Event.%s: %Ld\n" name (U32.extend_to_uns v)
  ) events;

  (* pollin and pollout are distinct *)
  assert U32.(Event.pollin <> Event.pollout);

  Printf.printf "poll_events: ok\n"

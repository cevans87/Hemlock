open Basis.Rudiments
open Basis
open C.Liburing

let () =
  let entries = U32.kv 4L in
  let flags = U32.kv 0L in

  (* Set up a ring with 4 entries and no flags. *)
  let ring = match Io_uring.queue_init entries flags with
    | Error errno ->
      halt ("queue_init failed: errno=" ^ (C.String.strerror errno))
    | Ok ring -> ring
  in

  (* Verify the ring starts with no pending submissions or completions. *)
  let sq = Io_uring.sq_ready ring in
  let cq = Io_uring.cq_ready ring in
  assert U32.(sq = kv 0L);
  assert U32.(cq = kv 0L);

  (* Verify we can obtain an SQE from the ring. *)
  let _sqe = match Io_uring.get_sqe ring with
    | None -> halt "get_sqe returned None on fresh ring"
    | Some sqe -> sqe
  in

  (* After obtaining an SQE, sq_ready should report 1 pending. *)
  let sq = Io_uring.sq_ready ring in
  assert U32.(sq = kv 1L);

  Io_uring.queue_exit ring;
  Printf.printf "setup: ok\n"

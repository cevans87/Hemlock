open Basis.Rudiments
open Basis
open Os.C.Liburing

let () =
  (* Create default params and verify initial state *)
  let p = Io_uring.Params.make () in

  (* Fresh params should have zero flags *)
  let flags = Io_uring.Params.get_flags p in
  assert U32.(flags = kv 0L);
  Printf.printf "initial flags: %Ld\n" (U32.extend_to_uns flags);

  (* Set and verify flags *)
  Io_uring.Params.set_flags Ioring.Setup.clamp p;
  let flags = Io_uring.Params.get_flags p in
  assert U32.(flags = Ioring.Setup.clamp);
  Printf.printf "set flags (clamp): %Ld\n" (U32.extend_to_uns flags);

  (* Set sq_thread_cpu and sq_thread_idle *)
  Io_uring.Params.set_sq_thread_cpu (U32.kv 0L) p;
  Io_uring.Params.set_sq_thread_idle (U32.kv 1000L) p;

  (* Use setup syscall to fill in kernel-side fields *)
  Io_uring.Params.set_flags (U32.kv 0L) p;
  let ring = match Io_uring.queue_init (U32.kv 4L) (U32.kv 0L) with
    | Error errno -> halt ("queue_init failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok ring -> ring
  in

  (* sq_ready/cq_ready still work *)
  let sq = Io_uring.sq_ready ring in
  let cq = Io_uring.cq_ready ring in
  assert U32.(sq = kv 0L);
  assert U32.(cq = kv 0L);
  Printf.printf "sq_ready: %Ld, cq_ready: %Ld\n"
    (U32.extend_to_uns sq) (U32.extend_to_uns cq);

  Io_uring.queue_exit ring;
  Printf.printf "params: ok\n"

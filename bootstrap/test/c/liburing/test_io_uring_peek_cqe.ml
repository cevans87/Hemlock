open Basis.Rudiments
open Basis
open Os.C.Liburing

let () =
  let ring = match Io_uring.queue_init (U32.kv 4L) (U32.kv 0L) with
    | Error errno -> halt ("queue_init failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok ring -> ring
  in

  (* peek_cqe on an empty ring should return Error (EAGAIN) *)
  let peek_result = Io_uring.peek_cqe ring in
  (match peek_result with
    | Error _errno ->
      Printf.printf "peek empty: error (expected)\n"
    | Ok _cqe ->
      halt "peek_cqe should fail on empty ring"
  );

  (* Submit a NOP, then peek should succeed *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_nop sqe;
  Io_uring.Sqe.set_data64 99L sqe;

  (* Use submit_and_wait to ensure the CQE is ready *)
  let _n = match Io_uring.submit_and_wait (U32.kv 1L) ring with
    | Error errno -> halt ("submit_and_wait failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in

  (* Now peek should succeed *)
  let cqe = match Io_uring.peek_cqe ring with
    | Error errno -> halt ("peek_cqe failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("cqe_res error: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let data = Io_uring.Cqe.get_data64 cqe in
  let flags = Io_uring.Cqe.flags cqe in

  assert I32.(res = kv 0L);
  assert (data = 99L);

  Printf.printf "peek result: %Ld, data: %Ld, flags: %Ld\n"
    (I32.extend_to_sint res) data (U32.extend_to_uns flags);

  Io_uring.cqe_seen cqe ring;
  Io_uring.queue_exit ring;
  Printf.printf "peek_cqe: ok\n"

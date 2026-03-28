open Basis.Rudiments
open Basis
open C.Liburing

let () =
  let ring = match Io_uring.queue_init (U32.kv 4L) (U32.kv 0L) with
    | Error errno -> halt ("queue_init failed: errno=" ^ (C.String.strerror errno))
    | Ok ring -> ring
  in
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe available"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_nop sqe;
  Io_uring.Sqe.set_data64 42L sqe;
  let _submitted = match Io_uring.submit ring with
    | Error errno -> halt ("submit failed: errno=" ^ (C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe failed: errno=" ^ (C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("cqe_res error: errno=" ^ (C.String.strerror errno))
    | Ok n -> n
  in
  let data = Io_uring.Cqe.get_data64 cqe in
  Io_uring.cqe_seen cqe ring;
  Io_uring.queue_exit ring;
  assert I32.(res = kv 0L);
  assert (data = 42L);
  Printf.printf "nop result: %Ld, data: %Ld\n" (I32.extend_to_sint res) data

open C.Liburing

let () =
  let ring = match Io_uring.queue_init 4L 0L with
    | Error errno -> failwith (Printf.sprintf "queue_init failed: %d" (Errno.to_int errno))
    | Ok ring -> ring
  in
  let sqe = match Io_uring.get_sqe ring with
    | None -> failwith "no sqe available"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_nop sqe;
  Io_uring.Sqe.set_data64 42L sqe;
  let _submitted = match Io_uring.submit ring with
    | Error errno -> failwith (Printf.sprintf "submit failed: %d" (Errno.to_int errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> failwith (Printf.sprintf "wait_cqe failed: %d" (Errno.to_int errno))
    | Ok cqe -> cqe
  in
  let res = match Io_uring.Cqe.res cqe with
    | Error errno -> failwith (Printf.sprintf "cqe_res error: %d" (Errno.to_int errno))
    | Ok n -> n
  in
  let data = Io_uring.Cqe.get_data64 cqe in
  Io_uring.cqe_seen cqe ring;
  Io_uring.queue_exit ring;
  assert (res = 0L);
  assert (data = 42L);
  Printf.printf "nop result: %Ld, data: %Ld\n" res data

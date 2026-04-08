open Basis.Rudiments
open Basis
open Os.C.Liburing

let () =
  let ring = match Io_uring.queue_init (U32.kv 4L) (U32.kv 0L) with
    | Error errno -> halt ("queue_init failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok ring -> ring
  in

  let tmp = "/tmp/hemlock_test_fsync.tmp" in
  let open_flags = Os.C.Fcntl.O.(rdwr |> bit_or creat |> bit_or trunc) in

  (* Open a temp file *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  let mode = Os.C.Stat.Mode.(irusr |> bit_or iwusr |> bit_or irgrp |> bit_or iroth) in
  Io_uring.Sqe.prep_openat mode open_flags tmp Os.C.Fcntl.At.fdcwd sqe;
  Io_uring.Sqe.set_data64 1L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let file_fd = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("open failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;

  (* Write some data *)
  let buf = Stdlib.Bytes.of_string "fsync test data" in
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_write 0L (U32.kv 15L) buf file_fd sqe;
  Io_uring.Sqe.set_data64 2L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit write failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe write failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let _res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("write failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;

  (* Fsync with datasync flag *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_fsync Ioring.Fsync.datasync file_fd sqe;
  Io_uring.Sqe.set_data64 3L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit fsync failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe fsync failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let fsync_res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("fsync failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;
  Printf.printf "fsync result: %Ld\n" (I32.extend_to_sint fsync_res);

  (* Close *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_close file_fd sqe;
  Io_uring.Sqe.set_data64 4L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit close failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe close failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let _res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("close failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;

  (* Cleanup *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_unlinkat (U32.kv 0L) tmp Os.C.Fcntl.At.fdcwd sqe;
  Io_uring.Sqe.set_data64 5L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit unlink failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe unlink failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let _res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("unlink failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;

  Io_uring.queue_exit ring;
  Printf.printf "fsync: ok\n"

open Basis.Rudiments
open Basis
open Os.C.Liburing

let () =
  let ring = match Io_uring.queue_init (U32.kv 4L) (U32.kv 0L) with
    | Error errno -> halt ("queue_init failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok ring -> ring
  in

  let dir_path = "/tmp/hemlock_test_mkdirat" in

  (* mkdirat *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe for mkdirat"
    | Some sqe -> sqe
  in
  let mode = Os.C.Stat.Mode.(irusr |> bit_or iwusr |> bit_or ixusr
    |> bit_or irgrp |> bit_or ixgrp |> bit_or iroth |> bit_or ixoth) in
  Io_uring.Sqe.prep_mkdirat mode dir_path Os.C.Fcntl.At.fdcwd sqe;
  Io_uring.Sqe.set_data64 1L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit mkdirat failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe mkdirat failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let _res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("mkdirat failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;
  Printf.printf "mkdirat: ok\n";

  (* unlinkat with AT_REMOVEDIR to remove the directory *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe for unlinkat"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_unlinkat Os.C.Fcntl.At.removedir dir_path Os.C.Fcntl.At.fdcwd sqe;
  Io_uring.Sqe.set_data64 2L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit unlinkat failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe unlinkat failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let _res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("unlinkat failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;
  Printf.printf "unlinkat: ok\n";

  Io_uring.queue_exit ring;
  Printf.printf "mkdirat_unlinkat: ok\n"

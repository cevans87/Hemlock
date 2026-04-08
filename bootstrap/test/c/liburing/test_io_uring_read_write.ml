open Basis.Rudiments
open Basis
open Os.C.Liburing

let () =
  let ring = match Io_uring.queue_init (U32.kv 4L) (U32.kv 0L) with
    | Error errno -> halt ("queue_init failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok ring -> ring
  in

  (* Open a temp file for writing *)
  let tmp = "/tmp/hemlock_test_rw.tmp" in

  let open_flags = Os.C.Fcntl.O.(rdwr |> bit_or creat |> bit_or trunc) in
  let mode = Os.C.Stat.Mode.(irusr |> bit_or iwusr |> bit_or irgrp |> bit_or iroth) in

  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_openat mode open_flags tmp Os.C.Fcntl.At.fdcwd sqe;
  Io_uring.Sqe.set_data64 1L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit open failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe open failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let file_fd = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("open failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;
  Printf.printf "opened fd: %s\n"
    (match I32.(file_fd >= kv 0L) with true -> "yes" | false -> "no");

  (* Write "hello" to the file *)
  let write_buf = Stdlib.Bytes.of_string "hello" in
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe for write"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_write 0L (U32.kv 5L) write_buf file_fd sqe;
  Io_uring.Sqe.set_data64 2L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit write failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe write failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let write_res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("write failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;
  Printf.printf "write bytes: %Ld\n" (I32.extend_to_sint write_res);

  (* Read back from the file at offset 0 *)
  let read_buf = Stdlib.Bytes.create 5 in
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe for read"
    | Some sqe -> sqe
  in
  Io_uring.Sqe.prep_read 0L (U32.kv 5L) read_buf file_fd sqe;
  Io_uring.Sqe.set_data64 3L sqe;
  let _n = match Io_uring.submit ring with
    | Error errno -> halt ("submit read failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok n -> n
  in
  let cqe = match Io_uring.wait_cqe ring with
    | Error errno -> halt ("wait_cqe read failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok cqe -> cqe
  in
  let read_res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("read failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;
  Printf.printf "read bytes: %Ld\n" (I32.extend_to_sint read_res);
  Printf.printf "read data: %s\n" (Stdlib.Bytes.to_string read_buf);

  (* Close the file *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe for close"
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
  let _close_res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("close failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;

  (* Clean up temp file via unlinkat *)
  let sqe = match Io_uring.get_sqe ring with
    | None -> halt "no sqe for unlink"
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
  let _unlink_res = match Io_uring.Cqe.res cqe with
    | Error errno -> halt ("unlink failed: errno=" ^ (Os.C.String.strerror errno))
    | Ok res -> res
  in
  Io_uring.cqe_seen cqe ring;

  Io_uring.queue_exit ring;
  Printf.printf "read_write: ok\n"

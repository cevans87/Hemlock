open Rudiments

module type IFd = sig
  type fd
end

module type SRead = sig
  type fd
  (* fd type. Corresponds to `fd` in `man 2 read`. *)

  module Read: sig
    type t
    (* Read type. Corresponds to `(struct io_uring_sqe).user_data` in `man 7 io_uring`. *)

    type buf = Bytes.Slice.t
    (* Buffer type. Corresponds to `buf` in `man 2 read`. *)

    type count = uns
    (* Count type. Corresponds to `count` in `man 2 read`. *)

    val of_fd: ?count:count -> ?buf:buf -> fd -> (t, Errno.t) result
    val of_fd_hlt: ?count:count -> ?buf:buf -> fd -> t

    val to_bytes: t -> buf
    val to_bytes_hlt: t -> (buf, Errno.t) result

    val submit: ?n:uns -> ?buf:buf -> fd -> (t, Errno.t) result
    val submit_hlt: ?n:uns -> ?buf:buf -> fd -> t

    val complete: t -> (Bytes.Slice.t, Errno.t) result
    val complete_hlt: t -> Bytes.Slice.t
  end

  (*
  val read: ?count:Read.count -> ?buf:Read.buf -> fd -> (Read.buf, Errno.t) result
  (* [read ?Read.count ?Read.buf fd] *)

  val read_hlt: ?count:Read.Count -> ?buf:Read.buf -> fd -> Read.buf
  *)
  val read: ?n:uns -> ?buf:Bytes.Slice.t -> fd -> (Bytes.Slice.t, Errno.t) result
  (* [read ?Read.count ?Read.buf fd] *)

  val read_hlt: ?n:uns -> ?buf:Bytes.Slice.t -> fd -> Bytes.Slice.t

end

(*
module type SReadAt = sig
  type fd
  (* fd type. *)

  module ReadAt: sig

    type t
    (* Submitted read_at type. *)

    type offset = uns
    (* Offset type. Corresponds to `offset` in `man 2 pread`. *)

    type buf = Bytes.Slice.t
    (* Buffer type. Corresponds to `buf` in `man 2 read`. *)

    type count = uns
    (* Count type. Corresponds to `count` in `man 2 read`. *)

    val of_fd: ?count:count -> ?buf:Bytes.Slice.t -> offset -> fd -> (t, Errno.t) result
    val of_fd_hlt: ?count:count -> ?buf:Bytes.Slice.t -> -> off -> fd -> t

    val to_bytes: t -> Bytes.Slice.t
    val to_bytes_hlt: t -> (Bytes.Slice.t, Errno.t) result
  end

  val read: ?count:count -> ?buf:buf -> offset -> fd -> (Bytes.Slice.t, Errno.t) result
  val read_hlt: ?count:uns -> ?buf:Bytes.Slice.t -> fd -> Bytes.Slice.t
end

module type IFd = sig
  type t
end
*)

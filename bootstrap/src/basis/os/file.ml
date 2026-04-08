open Rudiments

let ring =
  match C.Liburing.Io_uring.queue_init (U32.kv 32L) (U32.kv 0L) with
  | Ok ring -> ring
  | Error _errno -> halt "File: io_uring queue_init failure"

module Flag = struct
  type t =
    | R_O
    | W
    | W_A
    | W_AO
    | W_C
    | W_O
    | RW
    | RW_A
    | RW_AO
    | RW_C
    | RW_O

  let to_fcntl_o t =
    let open C.Fcntl.O in
    match t with
    | R_O   -> rdonly
    | W     -> bit_or (bit_or wronly creat) trunc
    | W_A   -> bit_or (bit_or wronly append) creat
    | W_AO  -> bit_or wronly append
    | W_C   -> bit_or (bit_or wronly creat) excl
    | W_O   -> bit_or wronly trunc
    | RW    -> bit_or (bit_or rdwr creat) trunc
    | RW_A  -> bit_or (bit_or rdwr append) creat
    | RW_AO -> bit_or rdwr append
    | RW_C  -> bit_or (bit_or rdwr creat) excl
    | RW_O  -> bit_or rdwr trunc
end

type t = uns

let stdin =
  I32.extend_to_uns C.Unistd.stdin_fileno

let stdout =
  I32.extend_to_uns C.Unistd.stdout_fileno

let stderr =
  I32.extend_to_uns C.Unistd.stderr_fileno

let fd t =
  t

let bytes_of_slice slice =
  let base = (Bytes.Cursor.index (Bytes.Slice.base slice)) in
  let container = (Bytes.Slice.container slice) in
  Stdlib.Bytes.init (Int64.to_int (Bytes.Slice.length slice)) (fun i ->
    Char.chr (Uns.trunc_to_int (U8.extend_to_uns (Array.get (base + (Int64.of_int i))
      container)))
  )

let errno_string errno =
  C.String.strerrordesc_np errno

let get_sqe_hlt () =
  match C.Liburing.Io_uring.get_sqe ring with
  | Some sqe -> sqe
  | None -> begin
      let _ = C.Liburing.Io_uring.submit ring in
      match C.Liburing.Io_uring.get_sqe ring with
      | Some sqe -> sqe
      | None -> halt "File: io_uring SQ full after submit"
    end

let next_user_data = ref 1L

let gen_user_data () =
  let ud = !next_user_data in
  next_user_data := Uns.succ ud;
  ud

let submit_and_complete_wait ud =
  match C.Liburing.Io_uring.submit_and_wait (U32.kv 1L) ring with
  | Error errno -> Error errno
  | Ok _ -> begin
      let rec drain () = begin
        match C.Liburing.Io_uring.wait_cqe ring with
        | Error errno -> Error errno
        | Ok cqe -> begin
            let cqe_ud = C.Liburing.Io_uring.Cqe.get_data64 cqe in
            let res = C.Liburing.Io_uring.Cqe.res cqe in
            C.Liburing.Io_uring.cqe_seen cqe ring;
            match cqe_ud = ud with
            | true -> res
            | false -> drain ()
          end
      end in
      drain ()
    end

(* Buffer-safe C stubs *)
external prep_openat: C.Liburing.Io_uring.Sqe.t -> sint -> Stdlib.Bytes.t -> sint -> sint
  -> nativeint = "hemlock_os_file_prep_openat"
external prep_close: C.Liburing.Io_uring.Sqe.t -> sint -> unit = "hemlock_os_file_prep_close"
external prep_read: C.Liburing.Io_uring.Sqe.t -> sint -> sint -> nativeint
  = "hemlock_os_file_prep_read"
external prep_write: C.Liburing.Io_uring.Sqe.t -> sint -> Stdlib.Bytes.t -> sint -> nativeint
  = "hemlock_os_file_prep_write"
external read_copyback: nativeint -> Stdlib.Bytes.t -> sint -> unit
  = "hemlock_os_file_read_copyback"
external free_buf: nativeint -> unit = "hemlock_os_file_free_buf"

let errno_of_neg_res (res : C.Liburing.res) : C.Errno.t =
  let neg_sint : sint = Stdlib.Obj.magic res in
  Stdlib.Obj.magic (Uns.trunc_to_int (Uns.bits_of_sint (Sint.neg neg_sint)))

let res_to_errno res =
  let res_sint = I32.extend_to_sint res in
  match Sint.(res_sint < kv 0L) with
  | true -> Error (errno_of_neg_res res)
  | false -> Ok res_sint

module Open = struct
  type file = t
  type t = {
    user_data: uns;
    cbuf: nativeint;
  }

  let submit ?(flag=Flag.R_O) ?(mode=0o660L) path =
    let path_bytes = bytes_of_slice (Path.to_bytes path) in
    let sqe = get_sqe_hlt () in
    let ud = gen_user_data () in
    let flags = Flag.to_fcntl_o flag in
    let cbuf = prep_openat sqe
        (Uns.bits_to_sint (I32.extend_to_uns C.Fcntl.At.fdcwd))
        path_bytes
        (Uns.bits_to_sint (U32.extend_to_uns flags))
        (Uns.bits_to_sint mode) in
    C.Liburing.Io_uring.Sqe.set_data64 ud sqe;
    Ok {user_data=ud; cbuf}

  let submit_hlt ?(flag=Flag.R_O) ?(mode=0o660L) path =
    match submit ~flag ~mode path with
    | Error error -> halt (errno_string error)
    | Ok t -> t

  let complete t =
    match submit_and_complete_wait t.user_data with
    | Error errno -> begin
        free_buf t.cbuf;
        Error errno
      end
    | Ok res -> begin
        free_buf t.cbuf;
        match res_to_errno res with
        | Error errno -> Error errno
        | Ok res_sint -> Ok (Uns.bits_of_sint res_sint)
      end

  let complete_hlt t =
    match complete t with
    | Ok t -> t
    | Error error -> halt (errno_string error)
end

let of_path ?flag ?mode path =
  match Open.submit ?flag ?mode path with
  | Error error -> Error error
  | Ok open' -> Open.complete open'

let of_path_hlt ?flag ?mode path =
  Open.(submit_hlt ?flag ?mode path |> complete_hlt)

module Close = struct
  type file = t
  type t = {
    user_data: uns;
  }

  let submit file =
    let sqe = get_sqe_hlt () in
    let ud = gen_user_data () in
    prep_close sqe (Uns.bits_to_sint file);
    C.Liburing.Io_uring.Sqe.set_data64 ud sqe;
    Ok {user_data=ud}

  let submit_hlt file =
    match submit file with
    | Error error -> halt (errno_string error)
    | Ok t -> t

  let complete t =
    match submit_and_complete_wait t.user_data with
    | Error errno -> Some errno
    | Ok res -> begin
        match res_to_errno res with
        | Error errno -> Some errno
        | Ok _ -> None
      end

  let complete_hlt t =
    match complete t with
    | None -> ()
    | Some error -> halt (errno_string error)
end

let close t =
  match Close.submit t with
  | Error error -> Some error
  | Ok close -> Close.complete close

let close_hlt t =
  Close.(submit_hlt t |> complete_hlt)

module Read = struct
  type file = t
  type t = {
    user_data: uns;
    cbuf: nativeint;
    buffer: Bytes.Slice.t;
  }

  let default_n = 1024L

  let submit ?n ?buffer file =
    let n, buffer = begin
      match n with
      | None -> begin
          match buffer with
          | None -> default_n, Bytes.Slice.init (Array.init (0L =:< default_n)
            ~f:(fun _ -> Byte.kv 0L))
          | Some buffer -> Bytes.Slice.length buffer, buffer
        end
      | Some n -> begin
          match buffer with
          | None -> n, Bytes.Slice.init (Array.init (0L =:< n) ~f:(fun _ -> Byte.kv 0L))
          | Some buffer -> (Uns.min n (Bytes.Slice.length buffer)), buffer
        end
    end in
    let sqe = get_sqe_hlt () in
    let ud = gen_user_data () in
    let cbuf = prep_read sqe (Uns.bits_to_sint file) (Uns.bits_to_sint n) in
    C.Liburing.Io_uring.Sqe.set_data64 ud sqe;
    Ok {user_data=ud; cbuf; buffer}

  let submit_hlt ?n ?buffer file =
    match submit ?n ?buffer file with
    | Error error -> halt (errno_string error)
    | Ok t -> t

  let complete t =
    match submit_and_complete_wait t.user_data with
    | Error errno -> begin
        free_buf t.cbuf;
        Error errno
      end
    | Ok res -> begin
        match res_to_errno res with
        | Error errno -> begin
            free_buf t.cbuf;
            Error errno
          end
        | Ok res_sint -> begin
            let nbytes = Uns.bits_of_sint res_sint in
            let base = Bytes.(Cursor.index (Slice.base t.buffer)) in
            let bytes = Stdlib.Bytes.create (Int64.to_int nbytes) in
            read_copyback t.cbuf bytes (Uns.bits_to_sint nbytes);
            let container = Bytes.Slice.container t.buffer in
            let range = (base =:< (base + nbytes)) in
            Range.Uns.iter range ~f:(fun i ->
              Array.set_inplace i
                (U8.of_char (Stdlib.Bytes.get bytes (Int64.to_int (i - base))))
                container
            );
            Ok (Bytes.Slice.init ~range (Bytes.Slice.container t.buffer))
          end
      end

  let complete_hlt t =
    match complete t with
    | Ok buffer -> buffer
    | Error error -> halt (errno_string error)
end

let read ?n ?buffer t =
  match Read.submit ?n ?buffer t with
  | Error error -> Error error
  | Ok read -> Read.complete read

let read_hlt ?n ?buffer t =
  Read.(submit_hlt ?n ?buffer t |> complete_hlt)

module Write = struct
  type file = t
  type t = {
    user_data: uns;
    cbuf: nativeint;
    buffer: Bytes.Slice.t;
  }

  let submit buffer file =
    let bytes = bytes_of_slice buffer in
    let sqe = get_sqe_hlt () in
    let ud = gen_user_data () in
    let n = Stdlib.Bytes.length bytes in
    let cbuf = prep_write sqe (Uns.bits_to_sint file) bytes (Sint.kv (Int64.of_int n)) in
    C.Liburing.Io_uring.Sqe.set_data64 ud sqe;
    Ok {user_data=ud; cbuf; buffer}

  let submit_hlt buffer file =
    match submit buffer file with
    | Error error -> halt (errno_string error)
    | Ok t -> t

  let complete t =
    match submit_and_complete_wait t.user_data with
    | Error errno -> begin
        free_buf t.cbuf;
        Error errno
      end
    | Ok res -> begin
        free_buf t.cbuf;
        match res_to_errno res with
        | Error errno -> Error errno
        | Ok res_sint -> begin
            let base = Bytes.(Slice.base t.buffer
              |> Cursor.seek (Uns.bits_to_sint (Uns.bits_of_sint res_sint))) in
            let past = Bytes.Slice.past t.buffer in
            let buffer = Bytes.Slice.of_cursors ~base ~past in
            Ok buffer
          end
      end

  let complete_hlt t =
    match complete t with
    | Ok buffer -> buffer
    | Error error -> halt (errno_string error)
end

let write buffer t =
  let rec f buffer t = begin
    match Bytes.Slice.length buffer = 0L with
    | true -> None
    | false -> begin
        match Write.submit buffer t with
        | Error error -> Some error
        | Ok write -> begin
            match Write.complete write with
            | Error error -> Some error
            | Ok buffer -> f buffer t
          end
      end
  end in
  f buffer t

let write_hlt buffer t =
  let rec f buffer t = begin
    match Bytes.Slice.length buffer = 0L with
    | true -> ()
    | false -> f Write.(submit_hlt buffer t |> complete_hlt) t
  end in
  f buffer t

let seek_base whence rel_off t =
  let fd_i32 = I32.trunc_of_sint (Uns.bits_to_sint t) in
  match C.Unistd.lseek rel_off whence fd_i32 with
  | Error errno -> Error errno
  | Ok off -> Ok (Uns.bits_of_sint off)

let seek_hlt_base whence rel_off t =
  match seek_base whence rel_off t with
  | Ok base_off -> base_off
  | Error error -> begin
      let _ = close t in
      halt (errno_string error)
    end

let seek rel_off t =
  seek_base C.Unistd.Seek.cur rel_off t

let seek_hlt rel_off t =
  seek_hlt_base C.Unistd.Seek.cur rel_off t

let seek_hd rel_off t =
  seek_base C.Unistd.Seek.set rel_off t

let seek_hd_hlt rel_off t =
  seek_hlt_base C.Unistd.Seek.set rel_off t

let seek_tl rel_off t =
  seek_base C.Unistd.Seek.end_ rel_off t

let seek_tl_hlt rel_off t =
  seek_hlt_base C.Unistd.Seek.end_ rel_off t

module Stream = struct
  type file = t
  type t = Bytes.Slice.t Stream.t

  let of_file file =
    let f file = begin
      match read file with
      | Error _ -> None
      | Ok buffer -> begin
          match (Bytes.Slice.length buffer) > 0L with
          | false -> begin
              let _ = close file in
              None
            end
          | true -> Some (buffer, file)
        end
    end in
    Stream.init_indef file ~f

  let write file t =
    let rec fn file t = begin
      match Lazy.force t with
      | Stream.Nil -> None
      | Stream.Cons(buffer, t') -> begin
          match write buffer file with
          | Some error -> Some error
          | None -> fn file t'
        end
    end in
    fn file t

  let write_hlt file t =
    let rec fn file t = begin
      match Lazy.force t with
      | Stream.Nil -> ()
      | Stream.Cons(buffer, t') -> begin
          write_hlt buffer file;
          fn file t'
        end
    end in
    fn file t
end

module Fmt = struct
  let bufsize_default = 4096L

  let of_t ?(bufsize=bufsize_default) t : (module Fmt.Formatter) =
    (module struct
      type nonrec t = {
        file: t;
        bufsize: uns;
        mutable buf: Bytes.t option;
        mutable pos: Bytes.Cursor.t option;
      }

      let state = {
        file=t;
        bufsize;
        buf=None;
        pos=None;
      }

      let fmt s t =
        let slice = Bytes.Slice.of_string_slice (String.C.Slice.of_string s) in
        match Bytes.Slice.length slice, t.bufsize with
        | 0L, _ -> t
        | _, 0L -> begin
            write_hlt slice t.file;
            t
          end
        | _ -> begin
            let () = match t.buf with
              | None -> begin
                  let buf = Array.init (0L =:< bufsize) ~f:(fun _ -> U8.zero) in
                  t.buf <- Some buf;
                  t.pos <- Some (Bytes.Cursor.hd buf)
                end
              | Some _ -> ()
            in

            let rec fn t slice = begin
              match t.buf, t.pos with
              | Some buf, Some pos -> begin
                  let pos_index = Bytes.Cursor.index pos in
                  let buf_avail = t.bufsize - pos_index in
                  let slice_length = Bytes.Slice.length slice in
                  match (Bytes.Slice.length slice) < buf_avail with
                  | true -> begin
                      let buf_range = (pos_index =:< (pos_index + slice_length)) in
                      Array.Slice.blit (Array.Slice.init ~range:(Bytes.Slice.range slice)
                        (Bytes.Slice.container slice)) (Array.Slice.init ~range:buf_range buf);
                      t.pos <- Some (Bytes.Cursor.seek (Uns.bits_to_sint slice_length) pos);
                      t
                    end
                  | false -> begin
                      let slice_base = Bytes.Slice.base slice in
                      let slice_mid = Bytes.Cursor.seek (Uns.bits_to_sint buf_avail) slice_base in
                      let slice_range =
                        (Bytes.Cursor.index slice_base =:< Bytes.Cursor.index slice_mid) in
                      let buf_range = (pos_index =:< t.bufsize) in
                      Array.Slice.blit
                        (Array.Slice.init ~range:slice_range (Bytes.Slice.container slice))
                        (Array.Slice.init ~range:buf_range buf);
                      write_hlt (Bytes.Slice.init ~range:(0L =:< t.bufsize) buf) t.file;

                      let slice' = Bytes.Slice.of_cursors ~base:slice_mid
                          ~past:(Bytes.Slice.past slice) in
                      t.pos <- Some (Bytes.Cursor.hd buf);
                      fn t slice'
                    end
                end
              | _ -> not_reached ()
            end in
            fn t slice
          end

      let sync t =
        let () = match t.buf, t.pos with
          | Some buf, Some pos -> begin
              if (Bytes.Cursor.index pos) > 0L then begin
                write_hlt (Bytes.Slice.init ~range:(0L =:< Bytes.Cursor.index pos) buf) t.file;
                t.pos <- Some (Bytes.Cursor.hd buf);
              end;
              ()
            end
          | _ -> ()
        in
        Fmt.Synced t
    end)

  let stdout = of_t stdout

  let stderr = of_t ~bufsize:0L stderr

  let sink : (module Fmt.Formatter) =
    (module struct
      type t = unit
      let state = ()
      let fmt _s t =
        t
      let sync t =
        Fmt.Synced t
    end)

  let teardown () =
    let _ = Fmt.flush stdout in
    ()
end

let () = Stdlib.at_exit (fun () ->
  let _ = Fmt.teardown () in
  C.Liburing.Io_uring.queue_exit ring
)

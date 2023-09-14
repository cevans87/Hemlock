open Rudiments

let error_of_neg_errno neg_errno =
  Errno.of_uns_hlt (Uns.bits_of_sint (Sint.neg neg_errno))

module Flag = struct
  (* Modifications to Flag.t must be reflected in file.c. *)
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
end

module Fd = struct
  type t = uns
end

module Offset = struct
  type t = sint
end

module Mode = struct
  type t = uns
end

module UserData = struct
  type t = uns
  external decref: t -> unit = "hemlock_executor_user_data_decref"
  external complete: uns -> uns = "hemlock_executor_user_data_complete"

  let register_finalizer user_data =
    match user_data = 0L with
    | true -> user_data
    | false -> begin
        let () = Stdlib.Gc.finalise decref user_data in
        user_data
      end
end

type t = {
  fd: Fd.t;
  offset: Offset.t;
}

let fd t =
  t.fd

let bytes_of_slice slice =
  let base = (Bytes.Cursor.index (Bytes.Slice.base slice)) in
  let container = (Bytes.Slice.container slice) in
  Stdlib.Bytes.init (Int64.to_int (Bytes.Slice.length slice)) (fun i ->
    Char.chr (Uns.trunc_to_int (U8.extend_to_uns (Array.get (base + (Int64.of_int i)) container)))
  )

external stdin_inner: unit -> Fd.t = "hemlock_file_stdin"

let stdin =
  {fd=stdin_inner (); offset=(-1L)}

external stdout_inner: unit -> Fd.t = "hemlock_file_stdout"

let stdout =
  {fd=stdout_inner (); offset=(-1L)}

external stderr_inner: unit -> Fd.t = "hemlock_file_stderr"

let stderr =
  {fd=stderr_inner (); offset=(-1L)}

(*external complete_inner: uns -> sint = "hemlock_executor_user_data_complete"*)

module Open = struct
  type file = t
  type t = {
    user_data: UserData.t;
    offset: Offset.t;
  }

  external submit_inner: Flag.t -> Mode.t -> Stdlib.Bytes.t -> (uns * UserData.t) =
    "hemlock_file_open_submit"

  let submit ?(flag=Flag.R_O) ?(mode=0o660L) path =
    let path_bytes = bytes_of_slice (Path.to_bytes path) in
    let errno, user_data = submit_inner flag mode path_bytes in
    let user_data = UserData.register_finalizer user_data in
    match Errno.of_uns errno with
    | Some errno -> Error errno
    | None -> begin
      let open Flag in
      let offset = begin
        match flag with
        | W_A
        | W_AO
        | RW_A
        | RW_AO -> -1L
        | R_O
        | W
        | W_C
        | W_O
        | RW
        | RW_C
        | RW_O -> 0L
      end in 
      Ok {user_data; offset}
    end

  let submit_hlt ?(flag=Flag.R_O) ?(mode=0o660L) path =
    match submit ~flag ~mode path with
    | Error errno -> halt (Errno.to_string errno)
    | Ok t -> t

  external complete_inner: UserData.t -> (uns * Fd.t) = "hemlock_file_open_complete"

  let complete t =
    let error, fd = complete_inner t.user_data in
    match Errno.of_uns error with
    | Some errno -> Error errno
    | None -> Ok {fd; offset=t.offset}

  let complete_hlt t =
    match complete t with
    | Ok t -> t
    | Error errno -> halt (Errno.to_string errno)
end

let of_path ?flag ?mode path =
  match Open.submit ?flag ?mode path with
  | Error error -> Error error
  | Ok open' -> Open.complete open'

let of_path_hlt ?flag ?mode path =
  Open.(submit_hlt ?flag ?mode path |> complete_hlt)

module Close = struct
  type file = t
  type t = UserData.t

  external submit_inner: Fd.t -> (uns * UserData.t) = "hemlock_file_close_submit"

  let submit file =
    let value, t = submit_inner file.fd in
    let t = UserData.register_finalizer t in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok t

  let submit_hlt file =
    match submit file with
    | Error error -> halt (Errno.to_string error)
    | Ok t -> t

  let complete t =
    let value = UserData.complete t in
    match Sint.(value < kv 0L) with
    | true -> Some (error_of_neg_errno value)
    | false -> None

  let complete_hlt t =
    match complete t with
    | None -> ()
    | Some error -> halt (Errno.to_string error)
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
    user_data: UserData.t;
    buffer: Bytes.Slice.t;
  }

  let default_n = 1024L

  external submit_inner: uns -> Fd.t -> (uns * UserData.t) = "hemlock_file_read_submit"

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
    let error, user_data = submit_inner n file.fd in
    let user_data = UserData.register_finalizer user_data in
    match Errno.of_uns error with
    | Some errno -> Error errno
    | None -> Ok {user_data; buffer}

  let submit_hlt ?n ?buffer file =
    match submit ?n ?buffer file with
    | Error errno -> halt (Errno.to_string errno)
    | Ok t -> t

  external complete_inner: Stdlib.Bytes.t -> UserData.t -> (uns * uns) =
    "hemlock_file_read_complete"

  let complete t =
    let base = Bytes.(Cursor.index (Slice.base t.buffer)) in
    let bytes = Stdlib.Bytes.create (Int64.to_int (Bytes.Slice.length t.buffer)) in
    let error, n = complete_inner bytes t.user_data in
    match Errno.of_uns error with
    | Some errno -> Error errno
    | None -> begin
        let range = (base =:< (base + n)) in
        let container = Bytes.Slice.container t.buffer in
        Range.Uns.iter range ~f:(fun i ->
          Array.set_inplace i (U8.of_char (Stdlib.Bytes.get bytes (Int64.to_int (i - base))))
            container
        );
        Ok (Bytes.Slice.init ~range (Bytes.Slice.container t.buffer))
      end

  let complete_hlt t =
    match complete t with
    | Ok buffer -> buffer
    | Error errno -> halt (Errno.to_string errno)
end

let read ?n ?buffer t =
  match Read.submit ?n ?buffer t with
  | Error errno -> Error errno
  | Ok read -> Read.complete read

let read_hlt ?n ?buffer t =
  Read.(submit_hlt ?n ?buffer t |> complete_hlt)

module Write = struct
  type file = t
  type t = {
    user_data: UserData.t;
    buffer: Bytes.Slice.t;
  }

  external submit_inner: Stdlib.Bytes.t -> Fd.t -> Offset.t -> (uns * UserData.t) =
    "hemlock_file_write_submit"

  let submit buffer file =
    let bytes = bytes_of_slice buffer in
    let error, user_data = submit_inner bytes file.fd file.offset in
    let user_data = UserData.register_finalizer user_data in
    match Errno.of_uns error with
    | Some errno -> Error errno
    | None -> Ok {user_data; buffer}

  let submit_hlt buffer file =
    match submit buffer file with
    | Error error -> halt (Errno.to_string error)
    | Ok t -> t

  external complete_inner: UserData.t -> (uns * uns) = "hemlock_file_write_complete"

  let complete t =
    let error, n = complete_inner t.user_data in
    match Errno.of_uns error with
    | Some errno -> Error errno
    | None -> begin
        let base = Bytes.(Slice.base t.buffer |> Cursor.seek n) in
        let past = Bytes.Slice.past t.buffer in
        let buffer = Bytes.Slice.of_cursors ~base ~past in
        Ok buffer
      end

  let complete_hlt t =
    match complete t with
    | Ok buffer -> buffer
    | Error error -> halt (Errno.to_string error)
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

let seek offset t =
  Ok {fd=t.fd; offset=t.offset + offset}

let seek_hlt offset t = 
  match seek offset t with
  | Error errno -> halt (Errno.to_string errno)
  | Ok t -> t

let seek_hd offset t =
  Ok {fd=t.fd; offset=offset}

let seek_hd_hlt offset t = 
  match seek_hd offset t with
  | Error errno -> halt (Errno.to_string errno)
  | Ok t -> t

let seek_tl offset t =
  Ok {fd=t.fd; offset=offset - 1L}

let seek_tl_hlt offset t = 
  match seek_tl offset t with
  | Error errno -> halt (Errno.to_string errno)
  | Ok t -> t

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
        | 0L, _ -> t (* No-op. *)
        | _, 0L -> begin
            (* Unbuffered. *)
            write_hlt slice t.file;
            t
          end
        | _ -> begin
            (* Initialize buf/pos if this is the first write. *)
            let () = match t.buf with
              | None -> begin
                  let buf = Array.init (0L =:< bufsize) ~f:(fun _ -> U8.zero) in
                  t.buf <- Some buf;
                  t.pos <- Some (Bytes.Cursor.hd buf)
                end
              | Some _ -> ()
            in

            (* Fill/flush buf repeatedly until it is not full. *)
            let rec fn t slice = begin
              match t.buf, t.pos with
              | Some buf, Some pos -> begin
                  let pos_index = Bytes.Cursor.index pos in
                  let buf_avail = t.bufsize - pos_index in
                  let slice_length = Bytes.Slice.length slice in
                  match (Bytes.Slice.length slice) < buf_avail with
                  | true -> begin
                      (* Partial fill. *)
                      let buf_range = (pos_index =:< (pos_index + slice_length)) in
                      Array.Slice.blit (Array.Slice.init ~range:(Bytes.Slice.range slice)
                        (Bytes.Slice.container slice)) (Array.Slice.init ~range:buf_range buf);
                      t.pos <- Some (Bytes.Cursor.seek (Uns.bits_to_sint slice_length) pos);
                      t
                    end
                  | false -> begin
                      (* Complete fill. *)
                      let slice_base = Bytes.Slice.base slice in
                      let slice_mid = Bytes.Cursor.seek (Uns.bits_to_sint buf_avail) slice_base in
                      let slice_range =
                        (Bytes.Cursor.index slice_base =:< Bytes.Cursor.index slice_mid) in
                      let buf_range = (pos_index =:< t.bufsize) in
                      Array.Slice.blit
                        (Array.Slice.init ~range:slice_range (Bytes.Slice.container slice))
                        (Array.Slice.init ~range:buf_range buf);
                      (* Flush. *)
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

end

module Executor = struct
  external setup: unit -> sint = "hemlock_executor_setup_inner"
end

let () = begin
  match Executor.setup () = 0L with
  | false -> halt "Setup failure"
  | true -> ()
end

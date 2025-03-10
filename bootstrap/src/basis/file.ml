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

type t = uns

let bytes_of_slice slice =
  let base = (Bytes.Cursor.index (Bytes.Slice.base slice)) in
  let container = (Bytes.Slice.container slice) in
  Stdlib.Bytes.init (Int64.to_int (Bytes.Slice.length slice)) (fun i ->
    Char.chr (Uns.trunc_to_int (U8.extend_to_uns (Array.get (base + (Int64.of_int i)) container)))
  )

external stdin_inner: unit -> t = "hemlock_basis_file_stdin_inner"

let stdin =
  stdin_inner ()

external stdout_inner: unit -> t = "hemlock_basis_file_stdout_inner"

let stdout =
  stdout_inner ()

external stderr_inner: unit -> t = "hemlock_basis_file_stderr_inner"

let stderr =
  stderr_inner ()

let fd t =
  t

external user_data_decref: uns -> unit = "hemlock_basis_executor_user_data_decref"
external complete_inner: uns -> sint = "hemlock_basis_executor_complete_inner"

let register_user_data_finalizer user_data =
  match user_data = 0L with
  | true -> user_data
  | false -> begin
      let () = Stdlib.Gc.finalise user_data_decref user_data in
      user_data
    end

module Open = struct
  type file = t
  type t = uns

  module Flag2 = struct
    type t =
      | O_RDONLY
      | O_RDWR
      | O_WRONLY

      | O_CLOEXEC
      | O_CREAT
      | O_DIRECTORY
      | O_EXCL
      | O_NOCTTY
      | O_NOFOLLOW
      | O_TMPFILE
      | O_TRUNC

      | O_APPEND
      | O_ASYNC
      | O_DIRECT
      | O_DSYNC
      | O_LARGEFILE
      | O_NDELAY
      | O_NOATIME
      | O_NONBLOCK
      | O_PATH
      | O_SYNC

    type ctype = uns

    let r = [| O_RDONLY |]
    let w = [| O_WRONLY; O_CREAT; O_TRUNC |]
    let x = [| O_WRONLY; O_CREAT; O_EXCL |]
    let a = [| O_WRONLY; O_APPEND; O_CREAT |]
    let rw = [| O_RDWR; O_CREAT; O_TRUNC |]
    let defaults = r

    external _O_RDONLY: ctype = "hemlock_basis_file_open_flag_t_O_RDONLY"
    external _O_RDWR: ctype = "hemlock_basis_file_open_flag_t_O_RDWR"
    external _O_WRONLY: ctype = "hemlock_basis_file_open_flag_t_O_WRONLY"

    external _O_CLOEXEC: ctype = "hemlock_basis_file_open_flag_t_O_CLOEXEC"
    external _O_CREAT: ctype = "hemlock_basis_file_open_flag_t_O_CREAT"
    external _O_DIRECTORY: ctype = "hemlock_basis_file_open_flag_t_O_DIRECTORY"
    external _O_EXCL: ctype = "hemlock_basis_file_open_flag_t_O_EXCL"
    external _O_NOCTTY: ctype = "hemlock_basis_file_open_flag_t_O_NOCTTY"
    external _O_NOFOLLOW: ctype = "hemlock_basis_file_open_flag_t_O_NOFOLLOW"
    external _O_TMPFILE: ctype = "hemlock_basis_file_open_flag_t_O_TMPFILE"
    external _O_TRUNC: ctype = "hemlock_basis_file_open_flag_t_O_TRUNC"

    external _O_APPEND: ctype = "hemlock_basis_file_open_flag_t_O_APPEND"
    external _O_ASYNC: ctype = "hemlock_basis_file_open_flag_t_O_ASYNC"
    external _O_DIRECT: ctype = "hemlock_basis_file_open_flag_t_O_DIRECT"
    external _O_DSYNC: ctype = "hemlock_basis_file_open_flag_t_O_DSYNC"
    external _O_LARGEFILE: ctype = "hemlock_basis_file_open_flag_t_O_LARGEFILE"
    external _O_NDELAY: ctype = "hemlock_basis_file_open_flag_t_O_NDELAY"
    external _O_NOATIME: ctype = "hemlock_basis_file_open_flag_t_O_NOATIME"
    external _O_NONBLOCK: ctype = "hemlock_basis_file_open_flag_t_O_NONBLOCK"
    external _O_PATH: ctype = "hemlock_basis_file_open_flag_t_O_PATH"
    external _O_SYNC: ctype = "hemlock_basis_file_open_flag_t_O_SYNC"

    let to_ctype t =
      match t with
      | O_RDONLY -> _O_RDONLY
      | O_RDWR -> _O_RDWR
      | O_WRONLY -> _O_WRONLY

      | O_CLOEXEC -> _O_CLOEXEC
      | O_CREAT -> _O_CREAT
      | O_DIRECTORY -> _O_DIRCTORY
      | O_EXCL -> _O_EXCL
      | O_NOCTTY -> _O_NOCTTY
      | O_NOFOLLOW -> _O_NOFOLLOW
      | O_TMPFILE -> _O_TMPFILE
      | O_TRUNC -> _O_TRUNC

      | O_APPEND -> _O_APPEND
      | O_ASYNC -> _O_ASYNC
      | O_DIRECT -> _O_DIRECT
      | O_DSYNC -> _O_DSYNC
      | O_LARGEFILE -> _O_LARGEFILE
      | O_NDELAY -> _O_NDELAY
      | O_NOATIME -> _O_NOATIME
      | O_NONBLOCK -> _O_NONBLOCK
      | O_PATH -> _O_PATH
      | O_SYNC -> _O_SYNC

  let of_ctype ctype =
    (* FIXME this should return a t array. *)
    match ctype with
      | _O_RDONLY -> O_RDONLY
      | _O_RDWR -> O_RDWR
      | _O_WRONLY -> O_WRONLY

      | _O_CLOEXEC -> O_CLOEXEC
      | _O_CREAT -> O_CREAT
      | _O_DIRECTORY -> O_DIRCTORY
      | _O_EXCL -> O_EXCL
      | _O_NOCTTY -> O_NOCTTY
      | _O_NOFOLLOW -> O_NOFOLLOW
      | _O_TMPFILE -> O_TMPFILE
      | _O_TRUNC -> O_TRUNC

      | _O_APPEND -> O_APPEND
      | _O_ASYNC -> O_ASYNC
      | _O_DIRECT -> O_DIRECT
      | _O_DSYNC -> O_DSYNC
      | _O_LARGEFILE -> O_LARGEFILE
      | _O_NDELAY -> O_NDELAY
      | _O_NOATIME -> O_NOATIME
      | _O_NONBLOCK -> O_NONBLOCK
      | _O_PATH -> O_PATH
      | _O_SYNC -> O_SYNC

      | _ -> halt (Uns.to_string ctype)
  end

  module Mode = struct
    type t =
      | S_ISUID
      | S_ISGID
      | S_ISVTX

      | S_IRWXU
      | S_IRUSR
      | S_IWUSR
      | S_IXUSR

      | S_IRWXG
      | S_IRGRP
      | S_IWGRP
      | S_IXGRP

      | S_IRWXO
      | S_IROTH
      | S_IWOTH
      | S_IXOTH

    type ctype = uns

    let defaults = [| S_IRUSR; S_IWUSR; S_IRGRP; S_IWGRP |]

    external _S_ISUID: ctype = "hemlock_basis_file_open_mode_t_S_ISUID"
    external _S_ISGID: ctype = "hemlock_basis_file_open_mode_t_S_ISGID"
    external _S_ISVTX: ctype = "hemlock_basis_file_open_mode_t_S_ISVTX"

    external _S_IRWXU: ctype = "hemlock_basis_file_open_mode_t_S_IRWXU"
    external _S_IRUSR: ctype = "hemlock_basis_file_open_mode_t_S_IRUSR"
    external _S_IWUSR: ctype = "hemlock_basis_file_open_mode_t_S_IWUSR"
    external _S_IXUSR: ctype = "hemlock_basis_file_open_mode_t_S_IXUSR"

    external _S_IRWXG: ctype = "hemlock_basis_file_open_mode_t_S_IRWXG"
    external _S_IRGRP: ctype = "hemlock_basis_file_open_mode_t_S_IWGRP"
    external _S_IWGRP: ctype = "hemlock_basis_file_open_mode_t_S_IWGRP"
    external _S_IXGRP: ctype = "hemlock_basis_file_open_mode_t_S_IXGRP"

    external _S_IRWXO: ctype = "hemlock_basis_file_open_mode_t_S_IRWXO"
    external _S_IROTH: ctype = "hemlock_basis_file_open_mode_t_S_IROTH"
    external _S_IWOTH: ctype = "hemlock_basis_file_open_mode_t_S_IWOTH"
    external _S_IXOTH: ctype = "hemlock_basis_file_open_mode_t_S_IXOTH"

    let to_ctype t =
      match t with
      | S_ISUID -> _S_ISUID
      | S_ISGID -> _S_ISGID
      | S_ISVTX -> _S_ISVTX

      | S_IRWXU -> _S_IRWXU
      | S_IRUSR -> _S_IRUSR
      | S_IWUSR -> _S_IWUSR
      | S_IXUSR -> _S_IXUSR

      | S_IRWXG -> _S_IRWXG
      | S_IRGRP -> _S_IRGRP
      | S_IWGRP -> _S_IWGRP
      | S_IXGRP -> _S_IXGRP

      | S_IRWXO -> _S_IRWXO
      | S_IROTH -> _S_IROTH
      | S_IWOTH -> _S_IWOTH
      | S_IXOTH -> _S_IXOTH

    let of_ctype ctype =
      (* FIXME this should return a t array. *)
      match ctype with
      | _S_ISUID -> S_ISUID
      | _S_ISGID -> S_ISGID
      | _S_ISVTX -> S_ISVTX

      | _S_IRWXU -> S_IRWXU
      | _S_IRUSR -> S_IRUSR
      | _S_IWUSR -> S_IWUSR
      | _S_IXUSR -> S_IXUSR

      | _S_IRWXG -> S_IRWXG
      | _S_IRGRP -> S_IRGRP
      | _S_IWGRP -> S_IWGRP
      | _S_IXGRP -> S_IXGRP

      | _S_IRWXO -> S_IRWXO
      | _S_IROTH -> S_IROTH
      | _S_IWOTH -> S_IWOTH
      | _S_IXOTH -> S_IXOTH

      | _ -> halt (Uns.to_string ctype)

    let to_string t =
      match t with
      | S_ISUID -> "S_ISUID"
      | S_ISGID -> "S_ISGID"
      | S_ISVTX -> "S_ISVTX"

      | S_IRWXU -> "S_IRWXU"
      | S_IRUSR -> "S_IRUSR"
      | S_IWUSR -> "S_IWUSR"
      | S_IXUSR -> "S_IXUSR"

      | S_IRWXG -> "S_IRWXG"
      | S_IRGRP -> "S_IRGRP"
      | S_IWGRP -> "S_IWGRP"
      | S_IXGRP -> "S_IXGRP"

      | S_IRWXO -> "S_IRWXO"
      | S_IROTH -> "S_IROTH"
      | S_IWOTH -> "S_IWOTH"
      | S_IXOTH -> "S_IXOTH"
  end

  external submit_inner: Flag.t -> uns -> Stdlib.Bytes.t -> (sint * t) =
    "hemlock_basis_file_open_submit_inner"

  let submit ?(flag=Flag.R_O) ?(mode=0o660L) path =
    let path_bytes = bytes_of_slice (Path.to_bytes path) in
    let value, t = submit_inner flag mode path_bytes in
    let t = register_user_data_finalizer t in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok t

  external _of_path: Flag.ctype -> Mode.ctype -> Path.ctype -> (Errno.ctype * File.ctype) =
    "hemlock_basis_file_open_of_path"

  let submit2 ?(flags=Flag.defaults) ?(modes=Mode.defaults) path =
    let path_bytes = bytes_of_slice (Path.to_bytes path) in
    let flags_ctype = Array.fold ~init:0 ~f:Uns.bit_or flags in
    lot modes_ctype = Array.fold ~init:0 ~f:Uns.bit_or modes in

    let value, t = submit_inner flag mode path_bytes in
    let t = register_user_data_finalizer t in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok t

  let submit_hlt ?(flag=Flag.R_O) ?(mode=0o660L) path =
    match submit ~flag ~mode path with
    | Error error -> halt (Errno.to_string error)
    | Ok t -> t

  let complete t =
    let value = complete_inner t in
    match Sint.(value < 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok (Uns.bits_of_sint value)

  let complete_hlt t =
    match complete t with
    | Ok t -> t
    | Error error -> halt (Errno.to_string error)
end

let of_path ?flag ?mode path =
  match Open.submit ?flag ?mode path with
  | Error error -> Error error
  | Ok open' -> Open.complete open'

let of_path_hlt ?flag ?mode path =
  Open.(submit_hlt ?flag ?mode path |> complete_hlt)

module Close = struct
  type file = t
  type t = uns

  external submit_inner: file -> (sint * t) = "hemlock_basis_file_close_submit_inner"

  let submit file =
    let value, t = submit_inner file in
    let t = register_user_data_finalizer t in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok t

  let submit_hlt file =
    match submit file with
    | Error error -> halt (Errno.to_string error)
    | Ok t -> t

  let complete t =
    let value = complete_inner t in
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
  type inner = uns
  type t = {
    inner: inner;
    buf: Bytes.Slice.t;
  }

  let default_n = 1024L

  external submit_inner: uns -> file -> (sint * inner) = "hemlock_basis_file_read_submit_inner"

  let submit ?count ?buf file =
    let count, buf = begin
      match count with
      | None -> begin
          match buf with
          | None -> default_n, Bytes.Slice.init (Array.init (0L =:< default_n)
            ~f:(fun _ -> Byte.kv 0L))
          | Some buf -> Bytes.Slice.length buf, buf
        end
      | Some count -> begin
          match buf with
          | None -> count, Bytes.Slice.init (Array.init (0L =:< count) ~f:(fun _ -> Byte.kv 0L))
          | Some buf -> (Uns.min count (Bytes.Slice.length buf)), buf
        end
    end in
    let value, inner = submit_inner count file in
    let inner = register_user_data_finalizer inner in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok {inner; buf}

  let submit_hlt ?count ?buf file =
    match submit ?count ?buf file with
    | Error error -> halt (Errno.to_string error)
    | Ok t -> t

  external complete_inner: Stdlib.Bytes.t -> inner -> sint =
    "hemlock_basis_file_read_complete_inner"

  let complete t =
    let base = Bytes.(Cursor.index (Slice.base t.buf)) in
    let bytes = Stdlib.Bytes.create (Int64.to_int (Bytes.Slice.length t.buf)) in
    let value = complete_inner bytes t.inner in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> begin
        let range = (base =:< (base + (Uns.bits_of_sint value))) in
        let container = Bytes.Slice.container t.buf in
        Range.Uns.iter range ~f:(fun i ->
          Array.set_inplace i (U8.of_char (Stdlib.Bytes.get bytes (Int64.to_int (i - base))))
            container
        );
        Ok (Bytes.Slice.init ~range (Bytes.Slice.container t.buf))
      end

  let complete_hlt t =
    match complete t with
    | Ok buf -> buf
    | Error error -> halt (Errno.to_string error)
end

let read ?count ?buf t =
  match Read.submit ?count ?buf t with
  | Error error -> Error error
  | Ok read -> Read.complete read

let read_hlt ?count ?buf t =
  Read.(submit_hlt ?count ?buf t |> complete_hlt)

module Write = struct
  type file = t
  type inner = uns
  type t = {
    inner: inner;
    buf: Bytes.Slice.t;
  }

  external submit_inner: Stdlib.Bytes.t -> file -> (sint * inner) =
    "hemlock_basis_file_write_submit_inner"

  let submit buf file =
    let bytes = bytes_of_slice buf in
    let value, inner = submit_inner bytes file in
    let inner = register_user_data_finalizer inner in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> Ok {inner; buf}

  let submit_hlt buf file =
    match submit buf file with
    | Error error -> halt (Errno.to_string error)
    | Ok t -> t

  let complete t =
    let value = complete_inner t.inner in
    match Sint.(value < kv 0L) with
    | true -> Error (error_of_neg_errno value)
    | false -> begin
        let base = Bytes.(Slice.base t.buf |> Cursor.seek (Uns.bits_of_sint value)) in
        let past = Bytes.Slice.past t.buf in
        let buf = Bytes.Slice.of_cursors ~base ~past in
        Ok buf
      end

  let complete_hlt t =
    match complete t with
    | Ok buf -> buf
    | Error error -> halt (Errno.to_string error)
end

let write buf t =
  let rec f buf t = begin
    match Bytes.Slice.length buf = 0L with
    | true -> None
    | false -> begin
        match Write.submit buf t with
        | Error error -> Some error
        | Ok write -> begin
            match Write.complete write with
            | Error error -> Some error
            | Ok buf -> f buf t
          end
      end
  end in
  f buf t

let write_hlt buf t =
  let rec f buf t = begin
    match Bytes.Slice.length buf = 0L with
    | true -> ()
    | false -> f Write.(submit_hlt buf t |> complete_hlt) t
  end in
  f buf t

let seek_base inner rel_off t =
  let value = inner rel_off t in
  match Sint.(value < kv 0L) with
  | false -> Ok (Uns.bits_of_sint value)
  | true -> Error (error_of_neg_errno value)

let seek_hlt_base inner rel_off t =
  match seek_base inner rel_off t with
  | Ok base_off -> base_off
  | Error error -> begin
      let _ = close t in
      halt (Errno.to_string error)
    end

external seek_inner: sint -> t -> sint = "hemlock_basis_file_seek_inner"

let seek = seek_base seek_inner

let seek_hlt = seek_hlt_base seek_inner

external seek_hd_inner: sint -> t -> sint = "hemlock_basis_file_seek_hd_inner"

let seek_hd = seek_base seek_hd_inner

let seek_hd_hlt = seek_hlt_base seek_hd_inner

external seek_tl_inner: sint -> t -> sint = "hemlock_basis_file_seek_tl_inner"

let seek_tl = seek_base seek_tl_inner

let seek_tl_hlt = seek_hlt_base seek_tl_inner

module Stream = struct
  type file = t
  type t = Bytes.Slice.t Stream.t

  let of_file file =
    let f file = begin
      match read file with
      | Error _ -> None
      | Ok buf -> begin
          match (Bytes.Slice.length buf) > 0L with
          | false -> begin
              let _ = close file in
              None
            end
          | true -> Some (buf, file)
        end
    end in
    Stream.init_indef file ~f

  let write file t =
    let rec fn file t = begin
      match Lazy.force t with
      | Stream.Nil -> None
      | Stream.Cons(buf, t') -> begin
          match write buf file with
          | Some error -> Some error
          | None -> fn file t'
        end
    end in
    fn file t

  let write_hlt file t =
    let rec fn file t = begin
      match Lazy.force t with
      | Stream.Nil -> ()
      | Stream.Cons(buf, t') -> begin
          write_hlt buf file;
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

  let teardown () =
    let _ = Fmt.flush stdout in
    ()
end

external setup_inner: unit -> sint = "hemlock_basis_executor_setup_inner"

let () = begin
  match setup_inner () = 0L with
  | false -> halt "Setup failure"
  | true -> ()
end

external teardown_inner: unit -> unit = "hemlock_basis_executor_teardown_inner"

let () = Stdlib.at_exit (fun () ->
  let _ = Fmt.teardown () in
  let _ = teardown_inner () in
  ()
)

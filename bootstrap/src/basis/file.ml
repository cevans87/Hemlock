open Rudiments

external setup: unit -> u64 = "hm_basis_file_setup"
external teardown: unit -> u64 = "hm_basis_file_setup"
external user_data_decref: t -> unit = "hm_basis_file_user_data_decref"

(* TODO deal with the errors *)
let _ = setup ()
let _ = Stdlib.at_exit (fun () -> let _ = teardown () in ())

module Error = struct
  type t = uns

  (* external to_string_get_length: t -> uns *)
  external to_string_get_length: t -> uns = "hm_basis_file_error_to_string_get_length"

  (* external to_string_inner: uns -> !&bytes -> t >os-> unit *)
  external to_string_inner: uns -> Stdlib.Bytes.t -> t -> unit =
    "hm_basis_file_error_to_string_inner"

  let of_value value =
    Uns.bits_of_sint Sint.(neg value)

  let to_string t =
    let n = to_string_get_length t in
    let bytes = Stdlib.Bytes.create (Int64.to_int n) in
    let () = to_string_inner n bytes t in
    Stdlib.Bytes.to_string bytes
end

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

let bytes_of_slice slice =
  let base = (Bytes.Cursor.index (Bytes.Slice.base slice)) in
  let container = (Bytes.Slice.container slice) in
  Stdlib.Bytes.init (Int64.to_int (Bytes.Slice.length slice)) (fun i ->
    Char.chr (Uns.trunc_to_int (U8.extend_to_uns (Array.get (base + (Int64.of_int i)) container)))
  )

type t = uns

(* external stdin_inner: uns *)
external stdin_inner: unit -> t = "hm_basis_file_stdin_inner"

let stdin =
  stdin_inner ()

(* external stdout_inner: uns *)
external stdout_inner: unit -> t = "hm_basis_file_stdout_inner"

let stdout =
  stdout_inner ()

(* external stderr_inner: uns *)
external stderr_inner: unit -> t = "hm_basis_file_stderr_inner"

let stderr =
  stderr_inner ()

module Open = struct
  type file = t
  type t = uns

  external submit_inner: Flag.t -> uns -> Stdlib.Bytes.t -> t = "hm_basis_file_open_submit_inner"

  let submit ?(flag=Flag.R_O) ?(mode=0o660L) path =
    let path_bytes = bytes_of_slice path in
    let t = submit_inner flag mode path_bytes in
    Stdlib.Gc.finalise user_data_decref t;
    t

  external complete_inner: t -> i64 = "hm_basis_file_generic_complete_inner"

  let complete t =
    let value = complete_inner t in
    match (value < 0L) with
    | false -> Ok (Uns.bits_of_sint value)
    | true -> Error (Uns.bits_of_sint Sint.(neg value))

  let complete_hlt t =
    match complete t with
    | Ok t -> t
    | Error error -> halt (Error.to_string error)

end

let of_path ?flag ?mode path =
  Open.(submit ?flag ?mode path |> complete)

let of_path_hlt ?flag ?mode path =
  Open.(submit ?flag ?mode path |> complete_hlt)

module Close = struct
  type file = t
  type t = uns

  external submit_inner: file -> uns = "hm_basis_file_close_submit_inner"

  let submit file =
    let t = submit_inner file in
    Stdlib.Gc.finalise user_data_decref t;
    t

  external complete_inner: uns -> i64 = "hm_basis_file_generic_complete_inner"

  let complete t =
    let value = complete_inner t in
    match (value < 0L) with
    | false -> None
    | true -> Some (Error.of_value value)

  let complete_hlt t =
    match complete t with
    | None -> ()
    | Some error -> halt (Error.to_string error)

end

let close t =
  Close.(submit t |> complete)

let close_hlt t =
  Close.(submit t |> complete_hlt)

module Read = struct
  type file = t
  type t = {
    t: uns;
    buffer: Bytes.Slice.t;
  }

  let default_n = 1024L

  external submit_inner: uns -> file ->  uns = "hm_basis_file_read_submit_inner"

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
    let t = submit_inner n file in
    Stdlib.Gc.finalise user_data_decref t;
    { t; buffer }

  external complete_inner: Stdlib.Bytes.t -> uns -> i64 = "hm_basis_file_read_complete_inner"

  let complete t =
    let base = Bytes.(Cursor.index (Slice.base t.buffer)) in
    let bytes = Stdlib.Bytes.create (Int64.to_int (Bytes.Slice.length t.buffer)) in
    let value = complete_inner bytes t.t in
    match Sint.(value < kv 0L) with
    | true -> Error (Uns.bits_of_sint Sint.(neg value))
    | false -> begin
        let range = (base =:< (base + (Uns.bits_of_sint value))) in
        let container = Bytes.Slice.container t.buffer in
        Range.iter range ~f:(fun i ->
          Array.set_inplace i (U8.of_char (Stdlib.Bytes.get bytes (Int64.to_int (i - base))))
            container
        );
        Ok (Bytes.Slice.init ~range (Bytes.Slice.container t.buffer))
      end

  let complete_hlt t =
    match complete t with
    | Ok buffer -> buffer
    | Error error -> halt (Error.to_string error)

end

let read ?n t =
  Read.(submit ?n t |> complete)

let read_hlt ?n t =
  Read.(submit ?n t |> complete_hlt)

let read_into buffer t =
  match Read.(submit ~buffer t |> complete) with
  | Ok _ -> None
  | Error error -> Some error

let read_into_hlt buffer t =
  let _ = Read.(submit ~buffer t |> complete_hlt) in
  ()

module Write = struct
  type file = t
  type t = uns

  external submit_inner: Stdlib.Bytes.t -> file -> t = "hm_basis_file_write_submit_inner"

  let submit buffer file =
    let bytes = bytes_of_slice buffer in
    let t = submit_inner bytes file in
    Stdlib.Gc.finalise user_data_decref t;
    t

  external complete_inner: t -> i64 = "hm_basis_file_generic_complete_inner"

  let complete t =
    let value = complete_inner t in
    match (value < 0L) with
    | false -> None
    | true -> Some (Error.of_value value)

  let complete_hlt t =
    match complete t with
    | None -> ()
    | Some error -> halt (Error.to_string error)

end

let write buffer t =
  Write.(submit buffer t |> complete)

let write_hlt buffer t =
  Write.(submit buffer t |> complete_hlt)

let seek_base inner rel_off t =
  let value = inner rel_off t in
  match Sint.(value < kv 0L) with
  | false -> Ok (Uns.bits_of_sint value)
  | true -> Error (Error.of_value value)

let seek_hlt_base inner rel_off t =
  match seek_base inner rel_off t with
  | Ok base_off -> base_off
  | Error error -> begin
      let _ = close t in
      halt (Error.to_string error)
    end

(* external seek_inner: int -> t >os-> int *)
external seek_inner: sint -> t -> sint = "hm_basis_file_seek_inner"

let seek = seek_base seek_inner

let seek_hlt = seek_hlt_base seek_inner

(* external seek_hd_inner: int -> t >os-> int *)
external seek_hd_inner: sint -> t -> sint = "hm_basis_file_seek_hd_inner"

let seek_hd = seek_base seek_hd_inner

let seek_hd_hlt = seek_hlt_base seek_hd_inner

(* external seek_tl_inner: int -> t >os-> int *)
external seek_tl_inner: sint -> t -> sint = "hm_basis_file_seek_tl_inner"

let seek_tl = seek_base seek_tl_inner

let seek_tl_hlt = seek_hlt_base seek_tl_inner

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

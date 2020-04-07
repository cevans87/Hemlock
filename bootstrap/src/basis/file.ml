open Rudiments
open Result

type t = Unix.file_descr

let buflen = 10

module Error = struct
  type t = Unix.error * string * string

  let to_string t =
    let error_code, fn_name, reason = t in
    let error_message = Unix.error_message error_code in
    String.concat ~sep:"\n" [error_message; fn_name; reason]
end

module Path = String

module Mode = struct
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

  let to_flags t =
    let open Unix in
    match t with
    | R_O   -> [O_RDONLY]
    | W     -> [O_WRONLY; O_CREAT]
    | W_A   -> [O_WRONLY; O_APPEND; O_CREAT]
    | W_AO  -> [O_WRONLY; O_APPEND]
    | W_C   -> [O_WRONLY; O_CREAT; O_EXCL]
    | W_O   -> [O_WRONLY]
    | RW    -> [O_RDWR; O_CREAT]
    | RW_A  -> [O_RDWR; O_APPEND; O_CREAT]
    | RW_AO -> [O_RDWR; O_APPEND]
    | RW_C  -> [O_RDWR; O_CREAT; O_EXCL]
    | RW_O  -> [O_RDWR]

end

let of_path ?(mode=Mode.RW) path =
  let open Unix in
  let flags = Mode.to_flags mode in
  try
    Ok (openfile path flags 0o640)
  with
  | Unix_error (errno, fn_name, param) -> Error(errno, fn_name, param)
  | _ -> not_reached ()

let of_path_hlt ?mode path =
  let t_res = of_path ?mode path in
  match t_res with
  | Error error -> halt (Error.to_string error)
  | Ok(t) -> t

let read ?(n=buflen) t =
  let chars = Stdlib.Bytes.create n in
  let chars_read_res = begin
    try
      let chars_read = Unix.read t chars 0 n in
      Ok(chars_read)
    with
    | Unix.Unix_error (errno, fn_name, param) -> Error(errno, fn_name, param)
    | _ -> not_reached ()
  end in
  match chars_read_res with
  | Error error -> Error error
  | Ok chars_read -> begin
    let f = fun i -> Byte.of_char(Stdlib.Bytes.get chars i) in
    let buf = Array.init chars_read ~f in
    Ok(buf)
  end

let read_hlt ?n t =
  match read ?n t with
  | Error error -> halt (Error.to_string error)
  | Ok bytes -> bytes

let write ?i ?n (bytes: Bytes.t) t =
  let rec fn i n chars t = begin
    let n_res = begin
      try
        Ok (Unix.write t chars i n)
      with
      | Unix.Unix_error (errno, fn_name, param) -> Error(errno, fn_name, param)
      | _ -> not_reached ()
    end in
    match n_res with
    | Error error -> Some error
    | Ok n' -> begin
      match n' < n with
      | false -> None
      | true -> fn (i + n') (n - n') chars t
    end
  end in
  let i = begin
     match i with
    | None -> 0
    | Some i -> Usize.max i (Array.length bytes)
  end in
  let n = begin
    match n with
    | None -> (Array.length bytes - i)
    | Some n -> Usize.min n (Array.length bytes - i)
  end in
  let f j = Stdlib.char_of_int (Byte.to_usize (Array.get (i + j) bytes)) in
  let chars = Stdlib.Bytes.init n f in
  fn 0 n chars t

let close t =
  let open Unix in
  try
    close t;
    None
  with
  | Unix_error (errno, fn_name, param) -> Some (errno, fn_name, param)
  | _ -> not_reached ()

module Stream = struct

  type outer = t
  type t = Byte.t Stream.t

  let of_file file =
    let rec fn i bytes file = lazy begin
      match  i < Array.length bytes with
      | false -> begin
        let bytes_res = read ~n:buflen file in
        match bytes_res with
        | Error _
        | Ok [||] -> begin
          let _ = close file in
          Stream.Nil
        end
        | Ok bytes' -> Lazy.force (fn 0 bytes' file)
      end
      | true -> begin 
        let elm = Array.get i bytes in
        let i' = succ i in
        let byte_stream = fn i' bytes file in
        Stream.Cons(elm, byte_stream)
      end
    end in
    fn 0 [||] file

  let of_path path =
    let file_res = of_path ~mode:Mode.R_O path in
    match file_res with
    | Error error -> Error error
    | Ok file -> Ok (of_file file)

  let of_path_hlt path =
    let t_res = of_path path in
    match t_res with
    | Error error -> halt (Error.to_string error)
    | Ok(t) -> t

  let write file t =
    let rec fn file t = begin
      match t with
      | lazy Stream.Nil -> None
      | lazy (Cons(_, _)) -> begin
        let t', t'' = Stream.split buflen t in
        let bytes = Bytes.of_byte_stream t' in
        let error_opt = write bytes file in
        match error_opt with
        | None -> fn file t''
        | Some error -> Some error
      end
    end in
    fn file t

  let write_hlt file t =
    match write file t with
    | Some error -> halt (Error.to_string error)
    | None -> ()

end

let%expect_test "Stream.of_path_hlt" =
  let open Format in
  printf "@[<h>";
  let s = Stream.of_path_hlt "/home/cevans/test.txt"
    |> Bytes.of_byte_stream
    |> Bytes.to_string_hlt
  in
  printf "t = %a\n" String.pp s;
  printf "@]";

  [%expect{|
    t = "The quick brown fox jumped over the red fence.\n"
    |}]

let%expect_test "Stream.of_path_hlt" =
  let open Format in
  printf "@[<h>";
  let _ = Stream.of_path_hlt "/home/cevans/test.txt"
    |> Stream.write_hlt (of_path_hlt ~mode:Mode.W_O "/home/cevans/test2.txt")
   in
  printf "@]";

  [%expect{| |}]

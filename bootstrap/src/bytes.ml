open Rudiments

let pp ppf bytes =
  Array.pp Byte.pp_x ppf bytes

let hash_fold bytes state =
  state
  |> Array.hash_fold Byte.hash_fold bytes

let of_codepoint cp =
  Array.of_list (Utf8.to_bytes (Utf8.of_codepoint cp))

module Array_seq = struct
  module T = struct
    type t = {
      string: string;
      cursor: String.Cursor.t;
      bindex: usize;
      rem_bytes: byte list;
    }
    type elm = byte

    let init t =
      {
          string=t;
          cursor=(String.Cursor.at t ~bindex:0);
          bindex=0;
          rem_bytes=[];
      }

    let length t =
      (String.blength t.string) - t.bindex

    let next t =
      assert (length t > 0);
      match t.rem_bytes with
      | b :: rem_bytes' -> begin
          let t' = {t with
                    bindex=(Usize.succ t.bindex);
                    rem_bytes=rem_bytes'
                   } in
          b, t'
        end
      | [] -> begin
          let codepoint = String.Cursor.rget t.cursor in
          let bytes = Utf8.(to_bytes (of_codepoint codepoint)) in
          let b, rem_bytes = match bytes with
            | b :: bytes' -> b, bytes'
            | [] -> not_reached ()
          in
          let t' = {t with
                    cursor=(String.Cursor.succ t.cursor);
                    bindex=(Usize.succ t.bindex);
                    rem_bytes} in
          b, t'
        end
  end
  include T
  include Array.Seq.Make_mono(T)
end

let of_string s =
  Array_seq.to_array (Array_seq.init s)

module Utf8_seq = struct
  module T = struct
    type t = {
      bytes: byte array;
      bindex: usize;
    }

    let init t =
      {bytes=t; bindex=0}

    let length t =
      (Array.length t.bytes) - t.bindex

    let next t =
      match (length t) = 0 with
      | true -> None
      | false -> begin
          let b = Array.get t.bytes t.bindex in
          let t' = {t with bindex=(Usize.succ t.bindex)} in
          Some (b, t')
        end
  end
  include T
  include Utf8.Seq.Make(T)
end

module String_seq = struct
  module U = struct
    include Utf8_seq

    let next t =
      match to_utf8_hlt t with
      | Some (utf8, t') -> (Utf8.to_codepoint utf8), t'
      | None -> not_reached ()
  end
  include U
  include String.Seq.Codepoint.Make(U)
end

let to_string bytes =
  let rec validate seq = begin
    match Utf8_seq.to_utf8 seq with
    | None -> false
    | Some (Ok _, seq') -> validate seq'
    | Some (Error _, _) -> true
  end in
  let invalid = validate (Utf8_seq.init bytes) in
  match invalid with
  | true -> None
  | false -> Some (String_seq.(to_string (init bytes)))

let to_string_hlt bytes =
  match to_string bytes with
  | None -> halt "Invalid utf8 sequence"
  | Some s -> s

(*******************************************************************************
 * Begin tests.
 *)

let%expect_test "hash_fold" =
  let open Format in
  printf "@[<h>";
  let rec fn strs = begin
    match strs with
    | [] -> ()
    | s :: strs' -> begin
        let bytes = of_string s in
        printf "hash_fold %a (%a) -> %a\n"
          pp bytes
          String.pp s
          Hash.pp (Hash.t_of_state
            (hash_fold bytes Hash.State.empty));
        fn strs'
      end
  end in
  let strs = [""; "hello"; "<"; "«"; "‡"; "𐆗"] in
  fn strs;
  printf "@]";

  [%expect{|
    hash_fold [||] ("") -> 0x0000000000000000
    hash_fold [|0x68u8; 0x65u8; 0x6cu8; 0x6cu8; 0x6fu8|] ("hello") -> 0x00000000162388c9
    hash_fold [|0x3cu8|] ("<") -> 0x000000001488bab4
    hash_fold [|0xc2u8; 0xabu8|] ("«") -> 0x000000003dab6a53
    hash_fold [|0xe2u8; 0x80u8; 0xa1u8|] ("‡") -> 0x000000002ca36e99
    hash_fold [|0xf0u8; 0x90u8; 0x86u8; 0x97u8|] ("𐆗") -> 0x00000000238f8ef8
    |}]

let%expect_test "of_codepoint" =
  let open Format in
  let strs = [
    "<";
    "«";
    "‡";
    "𐆗";
  ] in
  let cps = List.fold_right strs ~init:[] ~f:(fun s cps ->
    String.Cursor.(rget (hd s)) :: cps
  ) in
  printf "@[<h>";
  List.iter cps ~f:(fun cp ->
    let bytes = of_codepoint cp in
    printf "'%s' -> %a -> %a\n"
      (String.of_codepoint cp)
      pp bytes
      String.pp (to_string_hlt bytes)
  );
  printf "@]";

  [%expect{|
    '<' -> [|0x3cu8|] -> "<"
    '«' -> [|0xc2u8; 0xabu8|] -> "«"
    '‡' -> [|0xe2u8; 0x80u8; 0xa1u8|] -> "‡"
    '𐆗' -> [|0xf0u8; 0x90u8; 0x86u8; 0x97u8|] -> "𐆗"
    |}]

let%expect_test "of_string" =
  let open Format in
  let strs = [
    "";
    "<_>«‡𐆗»[_]";
  ] in
  printf "@[<h>";
  List.iter strs ~f:(fun s ->
    let bytes = of_string s in
    printf "%a -> %a -> %a\n"
      String.pp s
      pp bytes
      String.pp (to_string_hlt bytes)
  );
  printf "@]";

  [%expect{|
    "" -> [||] -> ""
    "<_>«‡𐆗»[_]" -> [|0x3cu8; 0x5fu8; 0x3eu8; 0xc2u8; 0xabu8; 0xe2u8; 0x80u8; 0xa1u8; 0xf0u8; 0x90u8; 0x86u8; 0x97u8; 0xc2u8; 0xbbu8; 0x5bu8; 0x5fu8; 0x5du8|] -> "<_>«‡𐆗»[_]"
    |}]

let%expect_test "to_string" =
  let open Format in
  let test_to_string (bytes_list:byte list) = begin
    let bytes = Array.of_list bytes_list in
    printf "to_string %a -> %s\n"
      pp bytes
      (match to_string bytes with
        | None -> "None"
        | Some s -> "\"" ^ s ^ "\""
      )
  end in
  let open Byte in
  printf "@[<h>";
  test_to_string [kv 0x61];
  test_to_string [(kv 0xf0); (kv 0x80); (kv 0x80)];
  test_to_string [(kv 0xe0); (kv 0x80)];
  test_to_string [(kv 0xc0)];
  test_to_string [(kv 0xf0); (kv 0x80); (kv 0x80); (kv 0xf0)];
  test_to_string [(kv 0xe0); (kv 0x80); (kv 0xe0)];
  test_to_string [(kv 0xc0); (kv 0xc0)];
  test_to_string [kv 0x80];
  test_to_string [(kv 0x80); (kv 0x80); (kv 0x80); (kv 0x80)];
  printf "@]";

  [%expect{|
    to_string [|0x61u8|] -> "a"
    to_string [|0xf0u8; 0x80u8; 0x80u8|] -> None
    to_string [|0xe0u8; 0x80u8|] -> None
    to_string [|0xc0u8|] -> None
    to_string [|0xf0u8; 0x80u8; 0x80u8; 0xf0u8|] -> None
    to_string [|0xe0u8; 0x80u8; 0xe0u8|] -> None
    to_string [|0xc0u8; 0xc0u8|] -> None
    to_string [|0x80u8|] -> None
    to_string [|0x80u8; 0x80u8; 0x80u8; 0x80u8|] -> None
    |}]

open! Basis.Rudiments
open! Basis
open Os
open Bytes

let test () =
  let strs = [
    "<";
    "«";
    "‡";
    "𐆗";
  ] in
  let cps = List.fold_right strs ~init:[] ~f:(fun cps s ->
    String.C.Cursor.(rget (hd s)) :: cps
  ) in
  List.iter cps ~f:(fun cp ->
    let bytes = of_codepoint cp in
    File.Fmt.stdout
    |> Codepoint.pp cp
    |> Fmt.fmt " -> "
    |> pp bytes
    |> Fmt.fmt " -> "
    |> String.pp (to_string_hlt bytes)
    |> Fmt.fmt "\n"
    |> ignore
  )

let _ = test ()

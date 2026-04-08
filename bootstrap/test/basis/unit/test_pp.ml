open! Basis.Rudiments
open! Basis
open Os
open Unit

let test () =
  File.Fmt.stdout
  |> Fmt.fmt "pp "
  |> Fmt.fmt (to_string ())
  |> Fmt.fmt " -> "
  |> pp ()
  |> Fmt.fmt "\n"
  |> ignore

let _ = test ()

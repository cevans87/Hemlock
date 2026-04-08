open! Basis.Rudiments
open! Basis
open Os
open Result

let test () =
  File.Fmt.stdout
  |> Fmt.fmt "Ok 42 -> "
  |> (pp Uns.pp String.pp) (Ok 42L)
  |> Fmt.fmt "\nError \"bang\" -> "
  |> (pp Uns.pp String.pp) (Error "bang")
  |> Fmt.fmt "\n"
  |> ignore

let _ = test ()

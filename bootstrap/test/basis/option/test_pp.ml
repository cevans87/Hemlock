open! Basis.Rudiments
open! Basis
open Os
open Option

let test () =
  File.Fmt.stdout
  |> Fmt.fmt "Some 42 -> "
  |> (pp Uns.pp) (Some 42L)
  |> Fmt.fmt "\nNone -> "
  |> (pp Uns.pp) None
  |> Fmt.fmt "\n"
  |> ignore

let _ = test ()

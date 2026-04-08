open! Basis.Rudiments
open! Basis
open Os
open Either

let test () =
  let rec fn = function
    | [] -> ()
    | either :: eithers' -> begin
        File.Fmt.stdout
        |> Fmt.fmt "is_first " |> (pp Uns.pp Uns.pp) either |> Fmt.fmt " -> "
        |> Bool.pp (is_first either) |> Fmt.fmt "\n"
        |> Fmt.fmt "is_first " |> (pp Uns.pp Uns.pp) either |> Fmt.fmt " -> "
        |> Bool.pp (is_second either) |> Fmt.fmt "\n"
        |> ignore;
        fn eithers'
      end
  in
  let eithers = [
    First 0L;
    Second 0L;
  ] in
  fn eithers

let _ = test ()

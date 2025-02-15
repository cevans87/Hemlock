open Rudiments0

module T = struct
  type t = bool

  let to_uns t =
    match t with
    | false -> 0L
    | true -> 1L

  let hash_fold t state =
    state
    |> Uns.hash_fold (to_uns t)

  let cmp t0 t1 =
    let open Cmp in
    match t0, t1 with
    | false, true -> Lt
    | false, false
    | true, true -> Eq
    | true, false -> Gt

  let pp ppf t =
    Format.fprintf ppf (
      match t with
      | false -> "false"
      | true -> "true"
    )

  let of_string s =
    match s with
    | "false" -> false
    | "true" -> true
    | _ -> not_reached ()

  let to_string t =
    match t with
    | false -> "false"
    | true -> "true"
end
include T
include Identifiable.Make(T)

let of_uns x =
  match x with
  | 0L -> false
  | _ -> true

let not = not

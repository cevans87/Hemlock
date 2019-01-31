type t =
| Neg
| Zero
| Pos
[@@deriving sexp]

let of_int x =
  match x with
  | -1 -> Neg
  | 0 -> Zero
  | 1 -> Pos
  | _ -> assert false

let to_int t =
  match t with
  | Neg -> ~-1
  | Zero -> 0
  | Pos -> 1

let to_float t =
  match t with
  | Neg -> -1.
  | Zero -> 0.
  | Pos -> 1.

let flip t =
  match t with
  | Neg -> Pos
  | Zero -> Zero
  | Pos -> Neg

let ( * ) t0 t1 =
  match t0, t1 with
  | Neg, Pos
  | Pos, Neg -> Neg
  | Zero, _
  | _, Zero -> Zero
  | Neg, Neg
  | Pos, Pos -> Pos

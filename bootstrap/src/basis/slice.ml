open Rudiments
open Slice_intf

module Make_mono (Cursor : Cursor_intf.S_mono) : S_mono with type container := Cursor.container
                                                         and type cursor := Cursor.t
                                                         and type elm := Cursor.elm =
struct
  type t = {
      base: Cursor.t;
      past: Cursor.t;
  }

  let of_cursors ~base ~past =
    {base; past}

  let to_cursors t =
    (t.base, t.past)

  let container t =
    Cursor.container t.base

  let base t =
    t.base

  let past t =
    t.past

  let of_container container =
    let base = Cursor.hd container in
    let past = Cursor.tl container in
    of_cursors ~base ~past

  let to_container t =
    Cursor.container t.base

  let base_seek coffset t =
    let base' = Cursor.seek coffset t.base in
    {t with base=base'}

  let base_succ t =
    let base' = Cursor.succ t.base in
    {t with base=base'}

  let base_pred t =
    let base' = Cursor.pred t.base in
    {t with base=base'}

  let past_seek coffset t =
    let past' = Cursor.seek coffset t.past in
    {t with past=past'}

  let past_succ t =
    let past' = Cursor.succ t.past in
    {t with past=past'}

  let past_pred t =
    let past' = Cursor.pred t.past in
    {t with past=past'}

  let get coffset t =
    let cursor = Cursor.seek (sint_of_uns coffset) t.base in
    match Cursor.(cursor > t.past) with
    | false -> halt "Out of bounds"
    | true -> Cursor.rget cursor
end
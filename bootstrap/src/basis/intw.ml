open RudimentsFunctions
open IntwIntf
type real = float

let uns_max a b =
  match Stdlib.(Int64.(unsigned_compare a b) >= 0) with
  | true -> a
  | false -> b

module type IVCommon = sig
  include IV
  val signed: bool
end

module type SVCommon = sig
  type t

  include SVCommon with type t := t
  include SSigned with type t := t
end

module MakeVCommon (T : IVCommon) : SVCommon with type t := T.t = struct
  module U = struct
    type t = T.t

    let min_word_length = T.min_word_length

    let max_word_length = T.max_word_length

    let word_length = T.word_length

    let init = T.init

    let get = T.get

    let bit_length t =
      Int64.(mul (T.word_length t) 64L)

    let of_arr a =
      init (Stdlib.(Int64.of_int (Stdlib.Array.length a))) ~f:(fun i ->
        Stdlib.Array.get a (Int64.to_int i))

    let to_arr t =
      Stdlib.Array.init (Stdlib.Int64.to_int (word_length t)) (fun i ->
        get (Stdlib.Int64.of_int i) t
      )

    let hash_fold t state =
      Hash.State.Gen.init state
      |> Hash.State.Gen.fold_u64 (word_length t) ~f:(fun i -> get i t)
      |> Hash.State.Gen.fini

    external intw_icmp: int64 array -> int64 array -> Cmp.t = "hm_basis_intw_icmp"
    external intw_ucmp: int64 array -> int64 array -> Cmp.t = "hm_basis_intw_ucmp"

    let cmp t0 t1 =
      match T.signed with
      | true -> intw_icmp (to_arr t0) (to_arr t1)
      | false -> intw_ucmp (to_arr t0) (to_arr t1)

    let zero =
      init T.min_word_length ~f:(fun _ -> Int64.zero)

    let one =
      init (uns_max T.min_word_length 1L) ~f:(fun i -> match i with
        | 0L -> Int64.one
        | _ -> Int64.zero
      )

    let neg_one =
      init (uns_max T.min_word_length 1L) ~f:(fun _ -> Int64.minus_one)

    let is_neg t =
      T.signed && (Int64.(compare (get (sub (word_length t) 1L) t) zero)) < 0

    let to_u64 t =
      match word_length t with
      | 0L -> Int64.zero
      | _ -> get 0L t

    let to_u64_opt t =
      let rec fn i t = begin
        match Stdlib.(Int64.(unsigned_compare i (word_length t)) < 0) with
        | false -> false
        | true -> begin
            let u = get i t in
            match Stdlib.(Int64.(unsigned_compare u zero) <> 0) with
            | true -> true
            | false -> fn (Int64.succ i) t
          end
      end in
      match fn 1L t with
      | true -> None
      | false -> Some (to_u64 t)

    let to_u64_hlt t =
      match to_u64_opt t with
      | None -> halt "Lossy conversion"
      | Some u -> u

    let of_u64 u =
      match Stdlib.(Int64.(unsigned_compare u zero) = 0), T.min_word_length with
      | true, 0L -> init 0L ~f:(fun _ -> Int64.zero)
      | _ -> begin
          let n = match T.signed && Stdlib.(Int64.(unsigned_compare u 0x8000_0000_0000_0000L) >= 0)
            with
            | true -> 2L
            | false -> 1L
          in
          init (uns_max T.min_word_length n) ~f:(fun i -> match i with
            | 0L -> u
            | _ -> Int64.zero
          )
        end

    let to_uns = to_u64

    let to_uns_opt = to_u64_opt

    let to_uns_hlt = to_u64_hlt

    let of_uns = of_u64

    external intw_ubit_and: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_bit_and"
    external intw_ibit_and: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_bit_and"

    let bit_and t0 t1 =
      of_arr (
        match T.signed with
        | true -> intw_ibit_and (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false -> intw_ubit_and (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_ubit_or: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_bit_or"
    external intw_ibit_or: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_bit_or"

    let bit_or t0 t1 =
      of_arr (
        match T.signed with
        | true -> intw_ibit_or (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false -> intw_ubit_or (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_ubit_xor: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_bit_xor"
    external intw_ibit_xor: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_bit_xor"

    let bit_xor t0 t1 =
      of_arr (
        match T.signed with
        | true -> intw_ibit_xor (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false -> intw_ubit_xor (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_bit_unot: int64 array -> uns -> uns -> int64 array = "hm_basis_intw_u_bit_not"
    external intw_bit_inot: int64 array -> uns -> uns -> int64 array = "hm_basis_intw_i_bit_not"

    let bit_not t =
      of_arr (
        match T.signed with
        | true -> intw_bit_inot (to_arr t) T.min_word_length T.max_word_length
        | false -> intw_bit_unot (to_arr t) T.min_word_length T.max_word_length
      )

    external intw_bit_usl: uns -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_bit_sl"
    external intw_bit_isl: uns -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_bit_sl"

    let bit_sl ~shift t =
      of_arr (
        match T.signed with
        | true -> intw_bit_isl shift (to_arr t) T.min_word_length T.max_word_length
        | false -> intw_bit_usl shift (to_arr t) T.min_word_length T.max_word_length
      )

    external intw_bit_usr: uns -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_bit_usr"

    let bit_usr ~shift t =
      of_arr (intw_bit_usr shift (to_arr t) T.min_word_length T.max_word_length)

    external intw_bit_ssr: uns -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_bit_ssr"

    let bit_ssr ~shift t =
      of_arr (intw_bit_ssr shift (to_arr t) T.min_word_length T.max_word_length)

    external intw_bit_pop: int64 array -> uns = "hm_basis_intw_bit_pop"

    let bit_pop t =
      intw_bit_pop (to_arr t)

    external intw_bit_clz: int64 array -> uns = "hm_basis_intw_bit_clz"

    let bit_clz t =
      intw_bit_clz (to_arr t)

    external intw_bit_ctz: int64 array -> uns = "hm_basis_intw_bit_ctz"

    let bit_ctz t =
      intw_bit_ctz (to_arr t)

    external intw_uadd: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_add"
    external intw_iadd: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_add"

    let ( + ) t0 t1 =
      of_arr (
        match T.signed with
        | true -> intw_iadd (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false -> intw_uadd (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_usub: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_sub"
    external intw_isub: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_sub"

    let ( - ) t0 t1 =
      of_arr (
        match T.signed with
        | true -> intw_isub (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false -> intw_usub (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_umul: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_mul"
    external intw_imul: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_mul"

    let ( * ) t0 t1 =
      of_arr (
        match T.signed with
        | true -> intw_imul (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false -> intw_umul (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_udiv: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_div"
    external intw_idiv: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_div"

    let ( / ) t0 t1 =
      of_arr (
        match t1 = zero, T.signed with
        | true, _ -> halt "Division by 0"
        | false, true -> intw_idiv (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false, false -> intw_udiv (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_umod: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_u_mod"
    external intw_imod: int64 array -> int64 array -> uns -> uns -> int64 array =
      "hm_basis_intw_i_mod"

    let ( % ) t0 t1 =
      of_arr (
        match t1 = zero, T.signed with
        | true, _ -> halt "Division by 0"
        | false, true -> intw_imod (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
        | false, false -> intw_umod (to_arr t0) (to_arr t1) T.min_word_length T.max_word_length
      )

    external intw_neg: int64 array -> uns -> uns -> int64 array = "hm_basis_intw_i_neg"

    let ( ~- ) t =
      of_arr (intw_neg (to_arr t) T.min_word_length T.max_word_length)

    let ( ~+ ) t =
      t

    let neg = ( ~- )

    external intw_abs: int64 array -> uns -> uns -> int64 array = "hm_basis_intw_i_abs"

    let abs t =
      match T.signed with
      | true -> of_arr (intw_abs (to_arr t) T.min_word_length T.max_word_length)
      | false -> t

    let ( ** ) t0 t1 =
      (* Decompose the exponent to limit algorithmic complexity. *)
      let neg, n = if T.signed && t1 < zero then
          true, ~-t1
        else
          false, t1
      in
      let rec fn r p n = begin
        match n = zero with
        | true -> r
        | false -> begin
            let r' =
              match (bit_and n one) = zero with
              | true -> r
              | false -> r * p
            in
            let p' = p * p in
            let n' = bit_usr ~shift:1L n in
            fn r' p' n'
          end
      end in
      let r = fn one t0 n in
      match neg with
      | false -> r
      | true -> one / r

    let succ t =
      t + one

    let pred t =
      t - one

    let to_i64 t =
      assert T.signed;
      match word_length t with
      | 0L -> Int64.zero
      | _ -> get 0L t

    let min_i64 = bit_sl ~shift:63L one
    let max_i64 = pred (bit_sl ~shift:63L one)

    let to_i64_opt t =
      assert T.signed;
      match t < min_i64 || t > max_i64 with
      | false -> Some (to_i64 t)
      | true -> None

    let to_i64_hlt t =
      assert T.signed;
      match to_i64_opt t with
      | None -> halt "Lossy conversion"
      | Some u -> u

    let of_i64 x =
      assert T.signed;
      match Stdlib.(Int64.(compare x zero) = 0), T.min_word_length with
      | true, 0L -> init 0L ~f:(fun _ -> Int64.zero)
      | _ -> begin
          let ws = match Stdlib.(Int64.(compare x 0L) < 0) with
            | true -> 0xffff_ffff_ffff_ffffL
            | false -> 0L
          in
          init (uns_max T.min_word_length 1L) ~f:(fun i -> match i with
            | 0L -> x
            | _ -> ws
          )
        end

    let to_sint = to_i64

    let to_sint_opt = to_i64_opt

    let to_sint_hlt = to_i64_hlt

    let of_sint = of_i64

    external intw_i_of_real: real -> uns -> uns -> int64 array = "hm_basis_intw_i_of_real"
    external intw_u_of_real: real -> uns -> uns -> int64 array = "hm_basis_intw_u_of_real"

    let of_real r =
      match Float.is_nan r with
      | true -> halt "Not a number"
      | false -> begin
          of_arr (
            match T.signed with
            | true -> intw_i_of_real r T.min_word_length T.max_word_length
            | false -> intw_u_of_real r T.min_word_length T.max_word_length
          )
        end

    external intw_i_to_real: int64 array -> real = "hm_basis_intw_i_to_real"
    external intw_u_to_real: int64 array -> real = "hm_basis_intw_u_to_real"

    let to_real t =
      match T.signed with
      | true -> intw_i_to_real (to_arr t)
      | false -> intw_u_to_real (to_arr t)

    let ( // ) t0 t1 =
      (to_real t0) /. (to_real t1)

    let pp_suffix ppf t =
      match Stdlib.(Int64.(unsigned_compare T.min_word_length T.max_word_length) = 0) with
      | false -> ()
      | true -> begin
          Format.fprintf ppf "%s%u"
            (if T.signed then "i" else "u")
            (Int64.(to_int (mul (T.word_length t) 64L)))
        end

    let pp ppf t =
      let ten = of_uns 10L in
      let rec fn t i = begin
        match cmp t zero with
        | Cmp.Eq -> ()
        | Cmp.Lt | Cmp.Gt -> begin
            let t' = t / ten in
            let () = fn t' (Int64.succ i) in

            let digit = match is_neg t with
              | true -> neg (t % ten)
              | false -> t % ten
            in
            let digit_w0 = match Cmp.is_eq (cmp digit zero) with
              | true -> Int64.zero
              | false -> get 0L digit
            in
            Format.fprintf ppf "%Lu" digit_w0;
            if Stdlib.(Int64.(unsigned_compare (unsigned_rem i 3L) 0L) = 0) &&
               Stdlib.(Int64.(unsigned_compare i 0L) > 0) then
              Format.fprintf ppf "_";
            ()
          end
      end in
      match Cmp.is_eq (cmp t zero) with
      | true -> Format.fprintf ppf "0%a" pp_suffix t
      | false -> begin
          let () = Format.fprintf ppf "%s" (if is_neg t then "-" else "") in
          let _ = fn t 0L in
          Format.fprintf ppf "%a" pp_suffix t
        end

    let pp_b ppf t =
      let rec fn x shift = begin
        match shift with
        | 0L -> ()
        | _ -> begin
            if Stdlib.(Int64.(unsigned_compare (unsigned_rem shift 8L) 0L) = 0 &&
                       Int64.(unsigned_compare shift 64L) < 0) then Format.fprintf ppf "_";
            let shift' = Int64.pred shift in
            let bit = Int64.(logand (shift_right_logical x (to_int shift')) 0x1L) in
            Format.fprintf ppf "%Ld" bit;
            fn x shift'
          end
      end in
      Format.fprintf ppf "0b";
      let () = match word_length t with
        | 0L -> fn Int64.zero 64L
        | _ -> begin
            let rec fn2 i = begin
              let elm = get i t in
              if Stdlib.(Int64.(unsigned_compare i (pred (word_length t))) < 0) then
                Format.fprintf ppf "_";
              fn elm 64L;
              match i with
              | 0L -> ()
              | _ -> fn2 (Int64.pred i)
            end in
            fn2 (Int64.pred (word_length t))
          end
      in
      Format.fprintf ppf "%a" pp_suffix t

    let pp_o ppf t =
      let rec fn x shift = begin
        assert Stdlib.(Int64.(unsigned_compare (unsigned_rem shift 3L) 0L) = 0);
        match shift with
        | 0L -> ()
        | _ -> begin
            let shift' = Int64.(sub shift 3L) in
            let digit = bit_and (bit_usr ~shift:shift' x) (of_uns 0x7L) in
            Format.fprintf ppf "%a" pp digit;
            fn x shift'
          end
      end in
      Format.fprintf ppf "0o";
      let () = match word_length t with
        | 0L -> Format.fprintf ppf "0"
        | _ -> begin
            let padded_shift = Int64.(add (bit_length t) 2L) in
            let shift = Int64.(sub padded_shift (unsigned_rem padded_shift 3L)) in
            fn t shift
          end
      in
      Format.fprintf ppf "%a" pp_suffix t

    let pp_x ppf t =
      let rec fn x shift = begin
        match shift with
        | 0L -> ()
        | _ -> begin
            if Stdlib.(Int64.(unsigned_compare shift 64L) < 0) then Format.fprintf ppf "_";
            let shift' = Int64.sub shift 16L in
            Format.fprintf ppf "%04Lx" Int64.(logand (shift_right_logical x (to_int shift'))
              0xffffL);
            fn x shift'
          end
      end in
      Format.fprintf ppf "0x";
      let () = match word_length t with
        | 0L -> Format.fprintf ppf "0000_0000_0000_0000"
        | _ -> begin
            let rec fn2 i = begin
              let elm = get i t in
              if Stdlib.(Int64.(unsigned_compare i (pred (word_length t))) < 0) then
                Format.fprintf ppf "_";
              fn elm 64L;
              match i with
              | 0L -> ()
              | _ -> fn2 (Int64.pred i)
            end in
            fn2 (Int64.pred (word_length t))
          end
      in
      Format.fprintf ppf "%a" pp_suffix t

    let of_string s =
      let getc_opt s i len = begin
        match i < len with
        | false -> None
        | true -> Some ((Stdlib.String.get s (Int64.to_int i)), Int64.(succ i))
      end in
      let getc s i len = begin
        match getc_opt s i len with
        | None -> halt "Malformed string"
        | Some (c, i') -> c, i'
      end in
      let d_of_c c = begin
        match c with
        | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ->
          of_uns Int64.(of_int Stdlib.(Char.(code c - code '0')))
        | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' ->
          of_uns Int64.(of_int Stdlib.(10 + Char.(code c - code 'a')))
        | _ -> not_reached ()
      end in
      let suffix s i len = begin
        let rec fn s i j len = begin
          let c, j' = getc s j len in
          match c with
          | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> begin
              match j' < len with
              | true -> fn s i j' len
              | false -> begin
                  let suf = Stdlib.String.sub s Int64.(to_int i) Int64.(to_int (sub j' i)) in
                  let nbits = Int64.of_int (int_of_string suf) in
                  match Stdlib.(Int64.(unsigned_compare T.min_word_length T.max_word_length) = 0 &&
                                Int64.(unsigned_compare nbits (mul T.min_word_length 64L)) = 0) with
                  | false -> halt "Malformed string"
                  | true -> j'
                end
            end
          | _ -> halt "Malformed string"
        end in
        fn s i i len
      end in
      let rec hexadecimal s i ndigits len = begin
        match getc_opt s i len with
        | None -> begin
            match ndigits with
            | 0L -> halt "Malformed string" (* "0x" *)
            | _ -> zero, one
          end
        | Some (c, i') -> begin
            match c with
            | '_' -> hexadecimal s i' ndigits len
            | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
            | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' -> begin
                let ndigits' = Int64.succ ndigits in
                let accum, mult = hexadecimal s i' ndigits' len in
                let accum' = accum + mult * (d_of_c c) in
                let mult' = mult * (of_uns 16L) in
                accum', mult'
              end
            | 'i' | 'u' -> begin
                match (T.signed && c = 'i') || ((not T.signed) && c = 'u') with
                | false -> halt "Malformed string"
                | true -> begin
                    let i'' = suffix s i' len in
                    hexadecimal s i'' ndigits len
                  end
              end
            | _ -> halt "Malformed string"
          end
      end in
      let rec decimal s i len = begin
        match getc_opt s i len with
        | None -> zero, one
        | Some (c, i') -> begin
            match c with
            | '_' -> decimal s i' len
            | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> begin
                let accum, mult = decimal s i' len in
                let accum' = accum + mult * (d_of_c c) in
                let mult' = mult * (of_uns 10L) in
                accum', mult'
              end
            | 'i' | 'u' -> begin
                match (T.signed && c = 'i') || ((not T.signed) && c = 'u') with
                | false -> halt "Malformed string"
                | true -> begin
                    let i'' = suffix s i' len in
                    decimal s i'' len
                  end
              end
            | _ -> halt "Malformed string"
          end
      end in
      let rec binary s i ndigits len = begin
        match getc_opt s i len with
        | None -> begin
            match ndigits with
            | 0L -> halt "Malformed string" (* "0b" *)
            | _ -> zero, one
          end
        | Some (c, i') -> begin
            match c with
            | '_' -> binary s i' ndigits len
            | '0' | '1' -> begin
                let ndigits' = Int64.succ ndigits in
                let accum, mult = binary s i' ndigits' len in
                let accum' = accum + mult * (d_of_c c) in
                let mult' = mult * (of_uns 2L) in
                accum', mult'
              end
            | 'i' | 'u' -> begin
                match (T.signed && c = 'i') || ((not T.signed) && c = 'u') with
                | false -> halt "Malformed string"
                | true -> begin
                    let i'' = suffix s i' len in
                    binary s i'' ndigits len
                  end
              end
            | _ -> halt "Malformed string"
          end
      end in
      let prefix1 s i len = begin
        match getc_opt s i len with
        | None -> zero
        | Some (c, i') -> begin
            match c with
            | 'b' -> begin
                let accum, _ = binary s i' 0L len in
                accum
              end
            | 'x' -> begin
                let accum, _ = hexadecimal s i' 0L len in
                accum
              end
            | '_' -> begin
                let accum, _ = decimal s i' len in
                accum
              end
            | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ->
              let accum, mult = decimal s i' len in
              accum + mult * (d_of_c c)
            | 'i' | 'u' -> begin
                match (T.signed && c = 'i') || ((not T.signed) && c = 'u') with
                | false -> halt "Malformed string"
                | true -> begin
                    let _ = suffix s i' len in
                    zero
                  end
              end
            | _ -> halt "Malformed string"
          end
      end in
      let prefix0 s i len = begin
        let c, i' = getc s i len in
        match c with
        | '0' -> prefix1 s i' len
        | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> begin
            let accum, mult = decimal s i' len in
            accum + mult * (d_of_c c)
          end
        | '+' -> begin
            match T.signed with
            | true -> let accum, _ = decimal s i' len in accum
            | false -> halt "Malformed string"
          end
        | '-' -> begin
            match T.signed with
            | true -> let accum, _ = decimal s i' len in neg accum
            | false -> halt "Malformed string"
          end
        | _ -> halt "Malformed string"
      end in
      prefix0 s 0L (Int64.of_int (Stdlib.String.length s))

    let to_string t =
      Format.asprintf "%a" pp t
  end
  include U
  include Identifiable.Make(U)
  include Cmpable.MakeZero(U)

  (* Intnb.MakeDerived() cannot be used here because `bit_length` isn't constant. It would be
   * possible to adapt the `bit_length` provided via the input module interface such that all other
   * users ignore the value parameter, but the API ripple effects would be rather difficult to
   * recognize as valid/intentional. *)

  let is_pow2 t =
    match t > zero with
    | false -> false
    | true -> Stdlib.(Int64.(unsigned_compare (bit_pop t) 1L) = 0)

  let floor_pow2 t =
    match cmp t one with
    | Lt -> halt "Invalid input"
    | Eq -> t
    | Gt -> begin
        let nb = bit_length t in let lz = bit_clz t in
        bit_sl ~shift:Int64.(pred (sub nb lz)) one
      end

  let ceil_pow2 t =
    match cmp t one with
    | Lt -> halt "Invalid input"
    | Eq -> t
    | Gt -> begin
        let pred_t = t - one in
        match Stdlib.(Int64.(unsigned_compare T.min_word_length T.max_word_length) = 0),
          bit_clz pred_t with
        | true, 0L -> zero
        | _, lz -> bit_sl ~shift:Int64.(sub (bit_length pred_t) lz) one
      end

  let floor_lg_opt t =
    match cmp t zero with
    | Lt | Eq -> None
    | Gt -> begin
        let nb = bit_length t in
        let lz = bit_clz t in
        Some (of_uns Int64.(pred (sub nb lz)))
      end

  let floor_lg t =
    match floor_lg_opt t with
    | None -> halt "Invalid input"
    | Some x -> x

  let ceil_lg t =
    match floor_lg_opt t with
    | None -> halt "Invalid input"
    | Some x -> (x + (if is_pow2 t then zero else one))

  let min t0 t1 =
    if t0 <= t1 then t0 else t1

  let max t0 t1 =
    if t0 < t1 then t1 else t0
end

module MakeVI (T : IV) : SVI with type t := T.t = struct
  module U = struct
    include T
    let signed = true
  end
  include U
  include MakeVCommon(U)
end

module MakeVU (T : IV) : SVU with type t := T.t = struct
  module U = struct
    include T
    let signed = false
  end
  include U
  include MakeVCommon(U)
end

module type IFCommon = sig
  include IF
  val signed: bool
end

module MakeFCommon (T : IFCommon) : SFI with type t := T.t = struct
  module U = struct
    module V = struct
      include T
      let min_word_length = T.word_length
      let max_word_length = T.word_length
      let init n ~f =
        assert (n = T.word_length);
        T.init ~f
      let word_length _t =
        T.word_length
      let get = T.get
    end
    include V
    include MakeVCommon(V)
  end
  include U

  let init = T.init
  let word_length = T.word_length
  let bit_length = Int64.mul word_length 64L

  let max_value =
    match T.signed with
    | true -> bit_usr ~shift:1L (bit_not zero)
    | false -> bit_not zero

  let min_value =
    match T.signed with
    | true -> bit_sl ~shift:Int64.(pred (mul word_length 64L)) one
    | false -> zero
end

module MakeFI (T : IF) : SFI with type t := T.t = struct
  module U = struct
    include T
    let signed = true
  end
  include U
  include MakeFCommon(U)
end

module MakeFU (T : IF) : SFU with type t := T.t = struct
  module U = struct
    include T
    let signed = false
  end
  include U
  include MakeFCommon(U)
end

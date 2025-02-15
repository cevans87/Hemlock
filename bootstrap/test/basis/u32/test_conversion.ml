open! Basis.Rudiments
open! Basis
open U32
open Format

let test () =
  let rec fn = function
    | [] -> ()
    | x :: xs' -> begin
        let i = x in
        let t = trunc_of_sint i in
        let i' = extend_to_sint t in
        let t' = trunc_of_sint i' in
        printf "trunc_of_sint %a -> extend_to_sint %a -> trunc_of_sint %a -> %a\n"
          Sint.pp_x i pp_x t Sint.pp_x i' pp_x t';
        let t = trunc_of_uns (Uns.bits_of_sint i) in
        let u = extend_to_uns t in
        let t' = trunc_of_uns u in
        printf "trunc_of_uns %a -> extend_to_uns %a -> trunc_of_uns %a -> %a\n"
          Uns.pp_x x pp_x t Uns.pp_x u pp_x t';
        fn xs'
      end
  in
  fn [Uns.max_value; 0L; 42L; 0x1f_ffffL; 0x20_0000L; 0x20_0001L; Uns.bits_of_sint Sint.max_value]

let _ = test ()

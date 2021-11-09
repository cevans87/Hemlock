open Basis.Rudiments
open Basis

external nop_submit: unit -> u64 = "hm_basis_file_nop_submit_inner"
external user_data_decref: u64 -> unit = "hm_basis_file_user_data_decref"

external user_data_pp: File.Open.t -> unit = "hm_basis_file_user_data_pp"
external sqring_pp: unit -> unit = "hm_basis_file_sqring_pp"
external ioring_pp: unit -> unit = "hm_basis_file_ioring_pp"

let () =
  let rec submit_nops i n = begin
    match i < n with
    | false -> ()
    | true -> let _ = user_data_decref (nop_submit ()) in
      submit_nops (i + 1L) n
  end in
  submit_nops 0L 32L;
  sqring_pp ();
  let s = File.Open.submit ~flag:File.Flag.RW (Bytes.Slice.of_string_slice
      (String.C.Slice.of_string "file")) in
  user_data_pp s;
  ioring_pp ();
  let _ = File.Open.complete_hlt s in
  user_data_pp s;
  sqring_pp ();
  ()
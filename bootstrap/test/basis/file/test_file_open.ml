open Basis

external user_data_pp: File.Open.t -> unit = "hm_basis_file_user_data_pp"
external sqring_pp: unit -> unit = "hm_basis_file_sqring_pp"

let () =
  let s = File.Open.submit ~flag:File.Flag.RW (Bytes.Slice.of_string_slice
      (String.C.Slice.of_string "file")) in
  user_data_pp s;
  sqring_pp ();
  let _ = File.Open.complete_hlt s in
  user_data_pp s;
  sqring_pp ();
  ()
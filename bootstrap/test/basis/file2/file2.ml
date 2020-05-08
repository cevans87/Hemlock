open Basis

let bytes = Bytes.of_string "
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.
"

let () =
  let _ = File.of_path_hlt (Bytes.of_string "foo")
  |> File.write_hlt bytes
  |> File.seek_hd_hlt
  |> File.Stream.of_file
  |> (File.Stream.write_hlt (File.of_stdout_hlt ())) in
  ()


  (*
  let path = Bytes.of_string "file2.input" in
  let _ = File.Stream.of_path_hlt path 
  |> File.Stream.write_hlt File.stderr in
  ()
  |> File.Stream.write_hlt (File.of_path_hlt bar_file_name) in
  Format.printf "4\n";
  File.Stream.of_path_hlt ~buflen:10 bar_file_name
  |> print_stream
  *)

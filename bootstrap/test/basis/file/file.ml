open Basis

let () =
  let bytes = Bytes.of_string "these are the file contents" in
  let n, bytes, _ = File.of_path_hlt (Bytes.of_string "foo")
  |> File.write_hlt bytes
  |> File.seek_hd_hlt
  |> File.read_hlt in
  let bytes = Array.init n ~f:(fun i -> Array.get i bytes) in
  let string = Bytes.to_string_hlt bytes in
  Format.printf "File contents: %a" String.pp string
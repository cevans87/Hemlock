open Basis

let () =
  let file = File.of_path_hlt ~flag:File.Flag.RW (Path.of_string "file") in
  let _ = File.write_hlt (Bytes.Slice.of_string_slice (String.C.Slice.of_string
      "these are the file contents")) file in
  let _ = File.seek_hd_hlt (Sint.kv 0L) file in
  let buf = File.read_hlt file in
  let _ = File.close_hlt file in
  File.write_hlt buf File.stdout

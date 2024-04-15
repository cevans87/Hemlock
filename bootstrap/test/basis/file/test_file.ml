open Basis

let contents = Bytes.Slice.of_string_slice (String.C.Slice.of_string
       "these are the file contents")

let () =
  let (buffer, file) = File.of_path_hlt ~flag:File.Flag.RW (Path.of_string "file")
    |> File.write_hlt contents
    |> File.seek_hd_hlt (Sint.kv 0L)
    |> File.read_hlt
  in
  let _ = File.write_hlt buffer File.stdout in
  File.close_hlt file

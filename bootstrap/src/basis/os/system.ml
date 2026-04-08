open Rudiments

let argv = Array.map Stdlib.Sys.argv ~f:(fun arg ->
  Bytes.of_string_slice (String.C.Slice.of_string arg))

external mkdirat_inner: sint -> string -> sint -> C.Errno.t option = "hemlock_os_mkdirat"

let mkdirat ?dir ?(mode=0o755L) path =
  let dirfd = match dir with
    | None -> I32.extend_to_uns C.Fcntl.At.fdcwd
    | Some dir -> File.fd dir
  in
  mkdirat_inner (Uns.bits_to_sint dirfd) (Path.to_string_replace path) (Uns.bits_to_sint mode)

open Basis.Rudiments
open Basis

type t =
  | O_RDONLY
  | O_RDWR
  | O_WRONLY

  | O_CLOEXEC
  | O_CREAT
  | O_DIRECTORY
  | O_EXCL
  | O_NOCTTY
  | O_NOFOLLOW
  | O_TMPFILE
  | O_TRUNC

  | O_APPEND
  | O_ASYNC
  | O_DIRECT
  | O_DSYNC
  | O_LARGEFILE
  | O_NDELAY
  | O_NOATIME
  | O_NONBLOCK
  | O_PATH
  | O_SYNC

type ctype = uns

let r = [| O_RDONLY |]
let w = [| O_WRONLY; O_CREAT; O_TRUNC |]
let x = [| O_WRONLY; O_CREAT; O_EXCL |]
let a = [| O_WRONLY; O_APPEND; O_CREAT |]
let rw = [| O_RDWR; O_CREAT; O_TRUNC |]
let defaults = r

external get_O_RDONLY: unit -> ctype = "hemlock_os_linux_open_flag_get_O_RDONLY"
external get_O_RDWR: unit -> ctype = "hemlock_os_linux_open_flag_get_O_RDWR"
external get_O_WRONLY: unit -> ctype = "hemlock_os_linux_open_flag_get_O_WRONLY"

external get_O_CLOEXEC: unit -> ctype = "hemlock_os_linux_open_flag_get_O_CLOEXEC"
external get_O_CREAT: unit -> ctype = "hemlock_os_linux_open_flag_get_O_CREAT"
external get_O_DIRECTORY: unit -> ctype = "hemlock_os_linux_open_flag_get_O_DIRECTORY"
external get_O_EXCL: unit -> ctype = "hemlock_os_linux_open_flag_get_O_EXCL"
external get_O_NOCTTY: unit -> ctype = "hemlock_os_linux_open_flag_get_O_NOCTTY"
external get_O_NOFOLLOW: unit -> ctype = "hemlock_os_linux_open_flag_get_O_NOFOLLOW"
external get_O_TMPFILE: unit -> ctype = "hemlock_os_linux_open_flag_get_O_TMPFILE"
external get_O_TRUNC: unit -> ctype = "hemlock_os_linux_open_flag_get_O_TRUNC"

external get_O_APPEND: unit -> ctype = "hemlock_os_linux_open_flag_get_O_APPEND"
external get_O_ASYNC: unit -> ctype = "hemlock_os_linux_open_flag_get_O_ASYNC"
external get_O_DIRECT: unit -> ctype = "hemlock_os_linux_open_flag_get_O_DIRECT"
external get_O_DSYNC: unit -> ctype = "hemlock_os_linux_open_flag_get_O_DSYNC"
external get_O_LARGEFILE: unit -> ctype = "hemlock_os_linux_open_flag_get_O_LARGEFILE"
external get_O_NDELAY: unit -> ctype = "hemlock_os_linux_open_flag_get_O_NDELAY"
external get_O_NOATIME: unit -> ctype = "hemlock_os_linux_open_flag_get_O_NOATIME"
external get_O_NONBLOCK: unit -> ctype = "hemlock_os_linux_open_flag_get_O_NONBLOCK"
external get_O_PATH: unit -> ctype = "hemlock_os_linux_open_flag_get_O_PATH"
external get_O_SYNC: unit -> ctype = "hemlock_os_linux_open_flag_get_O_SYNC"

let _O_RDONLY = get_O_RDONLY ()
let _O_RDWR = get_O_RDWR ()
let _O_WRONLY = get_O_WRONLY ()

let _O_CLOEXEC = get_O_CLOEXEC ()
let _O_CREAT = get_O_CREAT ()
let _O_DIRECTORY = get_O_DIRECTORY ()
let _O_EXCL = get_O_EXCL ()
let _O_NOCTTY = get_O_NOCTTY ()
let _O_NOFOLLOW = get_O_NOFOLLOW ()
let _O_TMPFILE = get_O_TMPFILE ()
let _O_TRUNC = get_O_TRUNC ()

let _O_APPEND = get_O_APPEND ()
let _O_ASYNC = get_O_ASYNC ()
let _O_DIRECT = get_O_DIRECT ()
let _O_DSYNC = get_O_DSYNC ()
let _O_LARGEFILE = get_O_LARGEFILE ()
let _O_NDELAY = get_O_NDELAY ()
let _O_NOATIME = get_O_NOATIME ()
let _O_NONBLOCK = get_O_NONBLOCK ()
let _O_PATH = get_O_PATH ()
let _O_SYNC = get_O_SYNC ()

let to_ctype t =
  match t with
  | O_RDONLY -> _O_RDONLY
  | O_RDWR -> _O_RDWR
  | O_WRONLY -> _O_WRONLY

  | O_CLOEXEC -> _O_CLOEXEC
  | O_CREAT -> _O_CREAT
  | O_DIRECTORY -> _O_DIRECTORY
  | O_EXCL -> _O_EXCL
  | O_NOCTTY -> _O_NOCTTY
  | O_NOFOLLOW -> _O_NOFOLLOW
  | O_TMPFILE -> _O_TMPFILE
  | O_TRUNC -> _O_TRUNC

  | O_APPEND -> _O_APPEND
  | O_ASYNC -> _O_ASYNC
  | O_DIRECT -> _O_DIRECT
  | O_DSYNC -> _O_DSYNC
  | O_LARGEFILE -> _O_LARGEFILE
  | O_NDELAY -> _O_NDELAY
  | O_NOATIME -> _O_NOATIME
  | O_NONBLOCK -> _O_NONBLOCK
  | O_PATH -> _O_PATH
  | O_SYNC -> _O_SYNC

let of_ctype ctype =
(* FIXME this should return a t array. *)
  match ctype with
  | _O_RDONLY -> O_RDONLY
  | _O_RDWR -> O_RDWR
  | _O_WRONLY -> O_WRONLY

  | _O_CLOEXEC -> O_CLOEXEC
  | _O_CREAT -> O_CREAT
  | _O_DIRECTORY -> O_DIRECTORY
  | _O_EXCL -> O_EXCL
  | _O_NOCTTY -> O_NOCTTY
  | _O_NOFOLLOW -> O_NOFOLLOW
  | _O_TMPFILE -> O_TMPFILE
  | _O_TRUNC -> O_TRUNC

  | _O_APPEND -> O_APPEND
  | _O_ASYNC -> O_ASYNC
  | _O_DIRECT -> O_DIRECT
  | _O_DSYNC -> O_DSYNC
  | _O_LARGEFILE -> O_LARGEFILE
  | _O_NDELAY -> O_NDELAY
  | _O_NOATIME -> O_NOATIME
  | _O_NONBLOCK -> O_NONBLOCK
  | _O_PATH -> O_PATH
  | _O_SYNC -> O_SYNC

  | _ -> halt (Uns.to_string ctype)

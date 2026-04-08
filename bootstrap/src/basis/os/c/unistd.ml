type fd     = I32.t
type offset = I64.t
type nbytes = I64.t
type buf    = bytes

(*****************************************************************************
 * Standard file descriptors (STDIN_FILENO, STDOUT_FILENO, STDERR_FILENO)
 *****************************************************************************)

external stdin_fileno  : unit -> fd = "hemlock__c__unistd__stdin_fileno"
external stdout_fileno : unit -> fd = "hemlock__c__unistd__stdout_fileno"
external stderr_fileno : unit -> fd = "hemlock__c__unistd__stderr_fileno"

let stdin_fileno  = stdin_fileno ()
let stdout_fileno = stdout_fileno ()
let stderr_fileno = stderr_fileno ()

module Seek = struct
  (*****************************************************************************
   * Seek whence constants (SEEK_SET, SEEK_CUR, SEEK_END)
   *****************************************************************************)

  type t = I32.t

  include (Flags_intf.I32 : Flags_intf.S with type t := t)

  external set : unit -> t = "hemlock__c__unistd__seek_set"
  external cur : unit -> t = "hemlock__c__unistd__seek_cur"
  external end_ : unit -> t = "hemlock__c__unistd__seek_end"

  let set = set ()
  let cur = cur ()
  let end_ = end_ ()
end

(*****************************************************************************
 * lseek
 *****************************************************************************)

external lseek : offset -> Seek.t -> fd -> (offset, Errno.t) result
  = "hemlock__c__unistd__lseek"

(*****************************************************************************
 * write (synchronous)
 *****************************************************************************)

external write : buf -> nbytes -> fd -> (nbytes, Errno.t) result
  = "hemlock__c__unistd__write"

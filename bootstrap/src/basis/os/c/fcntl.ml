module O = struct
  (*****************************************************************************
   * Open flags (O_*
   *****************************************************************************)

  type t = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external rdonly    : unit -> t = "hemlock__c__fcntl__open__rdonly"
  external wronly    : unit -> t = "hemlock__c__fcntl__open__wronly"
  external rdwr      : unit -> t = "hemlock__c__fcntl__open__rdwr"
  external creat     : unit -> t = "hemlock__c__fcntl__open__creat"
  external excl      : unit -> t = "hemlock__c__fcntl__open__excl"
  external noctty    : unit -> t = "hemlock__c__fcntl__open__noctty"
  external trunc     : unit -> t = "hemlock__c__fcntl__open__trunc"
  external append    : unit -> t = "hemlock__c__fcntl__open__append"
  external nonblock  : unit -> t = "hemlock__c__fcntl__open__nonblock"
  external dsync     : unit -> t = "hemlock__c__fcntl__open__dsync"
  external sync      : unit -> t = "hemlock__c__fcntl__open__sync"
  external directory : unit -> t = "hemlock__c__fcntl__open__directory"
  external nofollow  : unit -> t = "hemlock__c__fcntl__open__nofollow"
  external cloexec   : unit -> t = "hemlock__c__fcntl__open__cloexec"
  external path      : unit -> t = "hemlock__c__fcntl__open__path"
  external tmpfile   : unit -> t = "hemlock__c__fcntl__open__tmpfile"

  let rdonly    = rdonly ()
  let wronly    = wronly ()
  let rdwr      = rdwr ()
  let creat     = creat ()
  let excl      = excl ()
  let noctty    = noctty ()
  let trunc     = trunc ()
  let append    = append ()
  let nonblock  = nonblock ()
  let dsync     = dsync ()
  let sync      = sync ()
  let directory = directory ()
  let nofollow  = nofollow ()
  let cloexec   = cloexec ()
  let path      = path ()
  let tmpfile   = tmpfile ()
end

module At = struct
  (*****************************************************************************
   * AT_* constants
   *****************************************************************************)

  type dfd = I32.t
  type t   = U32.t

  include (Flags_intf.U32 : Flags_intf.S with type t := t)

  external fdcwd              : unit -> dfd = "hemlock__c__fcntl__at__fdcwd"
  external removedir          : unit -> t   = "hemlock__c__fcntl__at__removedir"
  external symlink_nofollow   : unit -> t   = "hemlock__c__fcntl__at__symlink_nofollow"
  external symlink_follow     : unit -> t   = "hemlock__c__fcntl__at__symlink_follow"
  external empty_path         : unit -> t   = "hemlock__c__fcntl__at__empty_path"
  external eaccess            : unit -> t   = "hemlock__c__fcntl__at__eaccess"

  let fdcwd              = fdcwd ()
  let removedir          = removedir ()
  let symlink_nofollow   = symlink_nofollow ()
  let symlink_follow     = symlink_follow ()
  let empty_path         = empty_path ()
  let eaccess            = eaccess ()
end

module Splice = struct
  (*****************************************************************************
   * Splice flags (SPLICE_F_*
   *****************************************************************************)

  module F = struct
    type t = U32.t

    include (Flags_intf.U32 : Flags_intf.S with type t := t)

    external move     : unit -> t = "hemlock__c__fcntl__splice__move"
    external nonblock : unit -> t = "hemlock__c__fcntl__splice__nonblock"
    external more     : unit -> t = "hemlock__c__fcntl__splice__more"
    external gift     : unit -> t = "hemlock__c__fcntl__splice__gift"

    let move     = move ()
    let nonblock = nonblock ()
    let more     = more ()
    let gift     = gift ()
  end
end

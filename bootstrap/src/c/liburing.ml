type errno = Errno.t

module Iosqe = struct
  (*****************************************************************************
   * SQE flags IOSQE_*
   *****************************************************************************)

  type t = Basis.U32.t

  external fixed_file       : unit -> t = "hemlock__c__liburing__iosqe__fixed_file"
  external io_drain         : unit -> t = "hemlock__c__liburing__iosqe__io_drain"
  external io_link          : unit -> t = "hemlock__c__liburing__iosqe__io_link"
  external io_hardlink      : unit -> t = "hemlock__c__liburing__iosqe__io_hardlink"
  external async            : unit -> t = "hemlock__c__liburing__iosqe__async"
  external buffer_select    : unit -> t = "hemlock__c__liburing__iosqe__buffer_select"
  external cqe_skip_success : unit -> t = "hemlock__c__liburing__iosqe__cqe_skip_success"

  let fixed_file       = fixed_file ()
  let io_drain         = io_drain ()
  let io_link          = io_link ()
  let io_hardlink      = io_hardlink ()
  let async            = async ()
  let buffer_select    = buffer_select ()
  let cqe_skip_success = cqe_skip_success ()
end

module Ioring = struct
  module Setup = struct
    (*****************************************************************************
     * Setup flags IORING_SETUP_*
     *****************************************************************************)

    type t = Basis.U32.t

    external iopoll             : unit -> t = "hemlock__c__liburing__ioring__setup__iopoll"
    external sqpoll             : unit -> t = "hemlock__c__liburing__ioring__setup__sqpoll"
    external sq_aff             : unit -> t = "hemlock__c__liburing__ioring__setup__sq_aff"
    external cqsize             : unit -> t = "hemlock__c__liburing__ioring__setup__cqsize"
    external clamp              : unit -> t = "hemlock__c__liburing__ioring__setup__clamp"
    external attach_wq          : unit -> t = "hemlock__c__liburing__ioring__setup__attach_wq"
    external r_disabled         : unit -> t = "hemlock__c__liburing__ioring__setup__r_disabled"
    external submit_all         : unit -> t = "hemlock__c__liburing__ioring__setup__submit_all"
    external coop_taskrun       : unit -> t = "hemlock__c__liburing__ioring__setup__coop_taskrun"
    external taskrun_flag       : unit -> t = "hemlock__c__liburing__ioring__setup__taskrun_flag"
    external sqe128             : unit -> t = "hemlock__c__liburing__ioring__setup__sqe128"
    external cqe32              : unit -> t = "hemlock__c__liburing__ioring__setup__cqe32"
    external single_issuer      : unit -> t = "hemlock__c__liburing__ioring__setup__single_issuer"
    external defer_taskrun      : unit -> t = "hemlock__c__liburing__ioring__setup__defer_taskrun"
    external no_mmap            : unit -> t = "hemlock__c__liburing__ioring__setup__no_mmap"
    external registered_fd_only : unit -> t = "hemlock__c__liburing__ioring__setup__registered_fd_only"
    external no_sqarray         : unit -> t = "hemlock__c__liburing__ioring__setup__no_sqarray"

    let iopoll             = iopoll ()
    let sqpoll             = sqpoll ()
    let sq_aff             = sq_aff ()
    let cqsize             = cqsize ()
    let clamp              = clamp ()
    let attach_wq          = attach_wq ()
    let r_disabled         = r_disabled ()
    let submit_all         = submit_all ()
    let coop_taskrun       = coop_taskrun ()
    let taskrun_flag       = taskrun_flag ()
    let sqe128             = sqe128 ()
    let cqe32              = cqe32 ()
    let single_issuer      = single_issuer ()
    let defer_taskrun      = defer_taskrun ()
    let no_mmap            = no_mmap ()
    let registered_fd_only = registered_fd_only ()
    let no_sqarray         = no_sqarray ()
  end

  module Feat = struct
    (*****************************************************************************
     * Feature flags IORING_FEAT_*
     *****************************************************************************)

    type t = Basis.U32.t

    external single_mmap     : unit -> t = "hemlock__c__liburing__ioring__feat__single_mmap"
    external nodrop          : unit -> t = "hemlock__c__liburing__ioring__feat__nodrop"
    external submit_stable   : unit -> t = "hemlock__c__liburing__ioring__feat__submit_stable"
    external rw_cur_pos      : unit -> t = "hemlock__c__liburing__ioring__feat__rw_cur_pos"
    external cur_personality : unit -> t = "hemlock__c__liburing__ioring__feat__cur_personality"
    external fast_poll       : unit -> t = "hemlock__c__liburing__ioring__feat__fast_poll"
    external poll_32bits     : unit -> t = "hemlock__c__liburing__ioring__feat__poll_32bits"
    external sqpoll_nonfixed : unit -> t = "hemlock__c__liburing__ioring__feat__sqpoll_nonfixed"
    external ext_arg         : unit -> t = "hemlock__c__liburing__ioring__feat__ext_arg"
    external native_workers  : unit -> t = "hemlock__c__liburing__ioring__feat__native_workers"
    external rsrc_tags       : unit -> t = "hemlock__c__liburing__ioring__feat__rsrc_tags"
    external cqe_skip        : unit -> t = "hemlock__c__liburing__ioring__feat__cqe_skip"
    external linked_file     : unit -> t = "hemlock__c__liburing__ioring__feat__linked_file"
    external reg_reg_ring    : unit -> t = "hemlock__c__liburing__ioring__feat__reg_reg_ring"
    external recvsend_bundle : unit -> t = "hemlock__c__liburing__ioring__feat__recvsend_bundle"
    external min_timeout     : unit -> t = "hemlock__c__liburing__ioring__feat__min_timeout"

    let single_mmap     = single_mmap ()
    let nodrop          = nodrop ()
    let submit_stable   = submit_stable ()
    let rw_cur_pos      = rw_cur_pos ()
    let cur_personality = cur_personality ()
    let fast_poll       = fast_poll ()
    let poll_32bits     = poll_32bits ()
    let sqpoll_nonfixed = sqpoll_nonfixed ()
    let ext_arg         = ext_arg ()
    let native_workers  = native_workers ()
    let rsrc_tags       = rsrc_tags ()
    let cqe_skip        = cqe_skip ()
    let linked_file     = linked_file ()
    let reg_reg_ring    = reg_reg_ring ()
    let recvsend_bundle = recvsend_bundle ()
    let min_timeout     = min_timeout ()
  end

  module Cqe_f = struct
    (*****************************************************************************
     * CQE flags IORING_CQE_F_*
     *****************************************************************************)

    type t = Basis.U32.t

    external buffer        : unit -> t = "hemlock__c__liburing__ioring__cqe_f__buffer"
    external more          : unit -> t = "hemlock__c__liburing__ioring__cqe_f__more"
    external sock_nonempty : unit -> t = "hemlock__c__liburing__ioring__cqe_f__sock_nonempty"
    external notif         : unit -> t = "hemlock__c__liburing__ioring__cqe_f__notif"

    let buffer        = buffer ()
    let more          = more ()
    let sock_nonempty = sock_nonempty ()
    let notif         = notif ()
  end

  module Op = struct
    (*****************************************************************************
     * Opcodes IORING_OP_*
     *****************************************************************************)

    type t = Basis.U32.t

    external nop              : unit -> t = "hemlock__c__liburing__ioring__op__nop"
    external readv            : unit -> t = "hemlock__c__liburing__ioring__op__readv"
    external writev           : unit -> t = "hemlock__c__liburing__ioring__op__writev"
    external fsync            : unit -> t = "hemlock__c__liburing__ioring__op__fsync"
    external read_fixed       : unit -> t = "hemlock__c__liburing__ioring__op__read_fixed"
    external write_fixed      : unit -> t = "hemlock__c__liburing__ioring__op__write_fixed"
    external poll_add         : unit -> t = "hemlock__c__liburing__ioring__op__poll_add"
    external poll_remove      : unit -> t = "hemlock__c__liburing__ioring__op__poll_remove"
    external sync_file_range  : unit -> t = "hemlock__c__liburing__ioring__op__sync_file_range"
    external sendmsg          : unit -> t = "hemlock__c__liburing__ioring__op__sendmsg"
    external recvmsg          : unit -> t = "hemlock__c__liburing__ioring__op__recvmsg"
    external timeout          : unit -> t = "hemlock__c__liburing__ioring__op__timeout"
    external timeout_remove   : unit -> t = "hemlock__c__liburing__ioring__op__timeout_remove"
    external accept           : unit -> t = "hemlock__c__liburing__ioring__op__accept"
    external async_cancel     : unit -> t = "hemlock__c__liburing__ioring__op__async_cancel"
    external link_timeout     : unit -> t = "hemlock__c__liburing__ioring__op__link_timeout"
    external connect          : unit -> t = "hemlock__c__liburing__ioring__op__connect"
    external fallocate        : unit -> t = "hemlock__c__liburing__ioring__op__fallocate"
    external openat           : unit -> t = "hemlock__c__liburing__ioring__op__openat"
    external close            : unit -> t = "hemlock__c__liburing__ioring__op__close"
    external files_update     : unit -> t = "hemlock__c__liburing__ioring__op__files_update"
    external statx            : unit -> t = "hemlock__c__liburing__ioring__op__statx"
    external read             : unit -> t = "hemlock__c__liburing__ioring__op__read"
    external write            : unit -> t = "hemlock__c__liburing__ioring__op__write"
    external fadvise          : unit -> t = "hemlock__c__liburing__ioring__op__fadvise"
    external madvise          : unit -> t = "hemlock__c__liburing__ioring__op__madvise"
    external send             : unit -> t = "hemlock__c__liburing__ioring__op__send"
    external recv             : unit -> t = "hemlock__c__liburing__ioring__op__recv"
    external openat2          : unit -> t = "hemlock__c__liburing__ioring__op__openat2"
    external epoll_ctl        : unit -> t = "hemlock__c__liburing__ioring__op__epoll_ctl"
    external splice           : unit -> t = "hemlock__c__liburing__ioring__op__splice"
    external provide_buffers  : unit -> t = "hemlock__c__liburing__ioring__op__provide_buffers"
    external remove_buffers   : unit -> t = "hemlock__c__liburing__ioring__op__remove_buffers"
    external tee              : unit -> t = "hemlock__c__liburing__ioring__op__tee"
    external shutdown         : unit -> t = "hemlock__c__liburing__ioring__op__shutdown"
    external renameat         : unit -> t = "hemlock__c__liburing__ioring__op__renameat"
    external unlinkat         : unit -> t = "hemlock__c__liburing__ioring__op__unlinkat"
    external mkdirat          : unit -> t = "hemlock__c__liburing__ioring__op__mkdirat"
    external symlinkat        : unit -> t = "hemlock__c__liburing__ioring__op__symlinkat"
    external linkat           : unit -> t = "hemlock__c__liburing__ioring__op__linkat"
    external msg_ring         : unit -> t = "hemlock__c__liburing__ioring__op__msg_ring"
    external fsetxattr        : unit -> t = "hemlock__c__liburing__ioring__op__fsetxattr"
    external setxattr         : unit -> t = "hemlock__c__liburing__ioring__op__setxattr"
    external fgetxattr        : unit -> t = "hemlock__c__liburing__ioring__op__fgetxattr"
    external getxattr         : unit -> t = "hemlock__c__liburing__ioring__op__getxattr"
    external socket           : unit -> t = "hemlock__c__liburing__ioring__op__socket"
    external uring_cmd        : unit -> t = "hemlock__c__liburing__ioring__op__uring_cmd"
    external send_zc          : unit -> t = "hemlock__c__liburing__ioring__op__send_zc"
    external sendmsg_zc       : unit -> t = "hemlock__c__liburing__ioring__op__sendmsg_zc"
    external read_multishot   : unit -> t = "hemlock__c__liburing__ioring__op__read_multishot"
    external waitid           : unit -> t = "hemlock__c__liburing__ioring__op__waitid"
    external futex_wait       : unit -> t = "hemlock__c__liburing__ioring__op__futex_wait"
    external futex_wake       : unit -> t = "hemlock__c__liburing__ioring__op__futex_wake"
    external futex_waitv      : unit -> t = "hemlock__c__liburing__ioring__op__futex_waitv"
    external fixed_fd_install : unit -> t = "hemlock__c__liburing__ioring__op__fixed_fd_install"
    external ftruncate        : unit -> t = "hemlock__c__liburing__ioring__op__ftruncate"
    external bind             : unit -> t = "hemlock__c__liburing__ioring__op__bind"
    external listen           : unit -> t = "hemlock__c__liburing__ioring__op__listen"
    external last             : unit -> t = "hemlock__c__liburing__ioring__op__last"

    let nop              = nop ()
    let readv            = readv ()
    let writev           = writev ()
    let fsync            = fsync ()
    let read_fixed       = read_fixed ()
    let write_fixed      = write_fixed ()
    let poll_add         = poll_add ()
    let poll_remove      = poll_remove ()
    let sync_file_range  = sync_file_range ()
    let sendmsg          = sendmsg ()
    let recvmsg          = recvmsg ()
    let timeout          = timeout ()
    let timeout_remove   = timeout_remove ()
    let accept           = accept ()
    let async_cancel     = async_cancel ()
    let link_timeout     = link_timeout ()
    let connect          = connect ()
    let fallocate        = fallocate ()
    let openat           = openat ()
    let close            = close ()
    let files_update     = files_update ()
    let statx            = statx ()
    let read             = read ()
    let write            = write ()
    let fadvise          = fadvise ()
    let madvise          = madvise ()
    let send             = send ()
    let recv             = recv ()
    let openat2          = openat2 ()
    let epoll_ctl        = epoll_ctl ()
    let splice           = splice ()
    let provide_buffers  = provide_buffers ()
    let remove_buffers   = remove_buffers ()
    let tee              = tee ()
    let shutdown         = shutdown ()
    let renameat         = renameat ()
    let unlinkat         = unlinkat ()
    let mkdirat          = mkdirat ()
    let symlinkat        = symlinkat ()
    let linkat           = linkat ()
    let msg_ring         = msg_ring ()
    let fsetxattr        = fsetxattr ()
    let setxattr         = setxattr ()
    let fgetxattr        = fgetxattr ()
    let getxattr         = getxattr ()
    let socket           = socket ()
    let uring_cmd        = uring_cmd ()
    let send_zc          = send_zc ()
    let sendmsg_zc       = sendmsg_zc ()
    let read_multishot   = read_multishot ()
    let waitid           = waitid ()
    let futex_wait       = futex_wait ()
    let futex_wake       = futex_wake ()
    let futex_waitv      = futex_waitv ()
    let fixed_fd_install = fixed_fd_install ()
    let ftruncate        = ftruncate ()
    let bind             = bind ()
    let listen           = listen ()
    let last             = last ()
  end

  module Fsync = struct
    (*****************************************************************************
     * Fsync flags (IORING_FSYNC_*
     *****************************************************************************)

    type t = Basis.U32.t

    external datasync : unit -> t = "hemlock__c__liburing__ioring__fsync__datasync"

    let datasync = datasync ()
  end

  module Timeout = struct
    (*****************************************************************************
     * Timeout flags (IORING_TIMEOUT_*
     *****************************************************************************)

    type t = Basis.U32.t

    external abs           : unit -> t = "hemlock__c__liburing__ioring__timeout__abs"
    external update        : unit -> t = "hemlock__c__liburing__ioring__timeout__update"
    external boottime      : unit -> t = "hemlock__c__liburing__ioring__timeout__boottime"
    external realtime      : unit -> t = "hemlock__c__liburing__ioring__timeout__realtime"
    external link_update   : unit -> t = "hemlock__c__liburing__ioring__timeout__link_update"
    external etime_success : unit -> t = "hemlock__c__liburing__ioring__timeout__etime_success"
    external multishot     : unit -> t = "hemlock__c__liburing__ioring__timeout__multishot"
    external clock_mask    : unit -> t = "hemlock__c__liburing__ioring__timeout__clock_mask"
    external update_mask   : unit -> t = "hemlock__c__liburing__ioring__timeout__update_mask"

    let abs           = abs ()
    let update        = update ()
    let boottime      = boottime ()
    let realtime      = realtime ()
    let link_update   = link_update ()
    let etime_success = etime_success ()
    let multishot     = multishot ()
    let clock_mask    = clock_mask ()
    let update_mask   = update_mask ()
  end

  module Async_cancel = struct
    (*****************************************************************************
     * Async cancel flags (IORING_ASYNC_CANCEL_*
     *****************************************************************************)

    type t = Basis.U32.t

    external all      : unit -> t = "hemlock__c__liburing__ioring__async_cancel__all"
    external fd       : unit -> t = "hemlock__c__liburing__ioring__async_cancel__fd"
    external any      : unit -> t = "hemlock__c__liburing__ioring__async_cancel__any"
    external fd_fixed : unit -> t = "hemlock__c__liburing__ioring__async_cancel__fd_fixed"
    external userdata : unit -> t = "hemlock__c__liburing__ioring__async_cancel__userdata"
    external op       : unit -> t = "hemlock__c__liburing__ioring__async_cancel__op"

    let all      = all ()
    let fd       = fd ()
    let any      = any ()
    let fd_fixed = fd_fixed ()
    let userdata = userdata ()
    let op       = op ()
  end

  module Recvsend = struct
    (*****************************************************************************
     * Recv/send flags (IORING_RECVSEND_*
     *****************************************************************************)

    type t = Basis.U32.t

    external poll_first : unit -> t = "hemlock__c__liburing__ioring__recvsend__poll_first"
    external fixed_buf  : unit -> t = "hemlock__c__liburing__ioring__recvsend__fixed_buf"
    external bundle     : unit -> t = "hemlock__c__liburing__ioring__recvsend__bundle"

    let poll_first = poll_first ()
    let fixed_buf  = fixed_buf ()
    let bundle     = bundle ()
  end

  module Poll = struct
    (*****************************************************************************
     * Poll flags (IORING_POLL_ADD_*
     *****************************************************************************)

    type t = Basis.U32.t

    external add_multi        : unit -> t = "hemlock__c__liburing__ioring__poll__add_multi"
    external update_events    : unit -> t = "hemlock__c__liburing__ioring__poll__update_events"
    external update_user_data : unit -> t = "hemlock__c__liburing__ioring__poll__update_user_data"
    external add_level        : unit -> t = "hemlock__c__liburing__ioring__poll__add_level"

    let add_multi        = add_multi ()
    let update_events    = update_events ()
    let update_user_data = update_user_data ()
    let add_level        = add_level ()
  end

  module Msg = struct
    (*****************************************************************************
     * Msg ring op types (IORING_MSG_*
     *****************************************************************************)

    type t = Basis.U32.t

    external data    : unit -> t = "hemlock__c__liburing__ioring__msg__data"
    external send_fd : unit -> t = "hemlock__c__liburing__ioring__msg__send_fd"

    let data    = data ()
    let send_fd = send_fd ()
  end

  module Send_zc = struct
    (*****************************************************************************
     * Send ZC flags (IORING_SEND_ZC_*
     *****************************************************************************)

    type t = Basis.U32.t

    external report_usage : unit -> t = "hemlock__c__liburing__ioring__send_zc__report_usage"

    let report_usage = report_usage ()
  end

  module Enter = struct
    (*****************************************************************************
     * Enter flags (IORING_ENTER_*
     *****************************************************************************)

    type t = Basis.U32.t

    external getevents       : unit -> t = "hemlock__c__liburing__ioring__enter__getevents"
    external sq_wakeup       : unit -> t = "hemlock__c__liburing__ioring__enter__sq_wakeup"
    external sq_wait         : unit -> t = "hemlock__c__liburing__ioring__enter__sq_wait"
    external ext_arg         : unit -> t = "hemlock__c__liburing__ioring__enter__ext_arg"
    external registered_ring : unit -> t = "hemlock__c__liburing__ioring__enter__registered_ring"

    let getevents       = getevents ()
    let sq_wakeup       = sq_wakeup ()
    let sq_wait         = sq_wait ()
    let ext_arg         = ext_arg ()
    let registered_ring = registered_ring ()
  end

  module Register = struct
    (*****************************************************************************
     * Register opcodes (IORING_REGISTER_*
     *****************************************************************************)

    type t = Basis.U32.t

    external buffers          : unit -> t = "hemlock__c__liburing__ioring__register__buffers"
    external files            : unit -> t = "hemlock__c__liburing__ioring__register__files"
    external eventfd          : unit -> t = "hemlock__c__liburing__ioring__register__eventfd"
    external files_update     : unit -> t = "hemlock__c__liburing__ioring__register__files_update"
    external eventfd_async    : unit -> t = "hemlock__c__liburing__ioring__register__eventfd_async"
    external probe            : unit -> t = "hemlock__c__liburing__ioring__register__probe"
    external personality      : unit -> t = "hemlock__c__liburing__ioring__register__personality"
    external restrictions     : unit -> t = "hemlock__c__liburing__ioring__register__restrictions"
    external enable_rings     : unit -> t = "hemlock__c__liburing__ioring__register__enable_rings"
    external files2           : unit -> t = "hemlock__c__liburing__ioring__register__files2"
    external files_update2    : unit -> t = "hemlock__c__liburing__ioring__register__files_update2"
    external buffers2         : unit -> t = "hemlock__c__liburing__ioring__register__buffers2"
    external buffers_update   : unit -> t = "hemlock__c__liburing__ioring__register__buffers_update"
    external iowq_aff         : unit -> t = "hemlock__c__liburing__ioring__register__iowq_aff"
    external iowq_max_workers : unit -> t = "hemlock__c__liburing__ioring__register__iowq_max_workers"
    external ring_fds         : unit -> t = "hemlock__c__liburing__ioring__register__ring_fds"
    external pbuf_ring        : unit -> t = "hemlock__c__liburing__ioring__register__pbuf_ring"
    external sync_cancel      : unit -> t = "hemlock__c__liburing__ioring__register__sync_cancel"
    external file_alloc_range : unit -> t = "hemlock__c__liburing__ioring__register__file_alloc_range"
    external pbuf_status      : unit -> t = "hemlock__c__liburing__ioring__register__pbuf_status"
    external napi             : unit -> t = "hemlock__c__liburing__ioring__register__napi"
    external clock            : unit -> t = "hemlock__c__liburing__ioring__register__clock"
    external clone_buffers    : unit -> t = "hemlock__c__liburing__ioring__register__clone_buffers"
    external send_msg_rings   : unit -> t = "hemlock__c__liburing__ioring__register__send_msg_rings"
    external last             : unit -> t = "hemlock__c__liburing__ioring__register__last"

    let buffers          = buffers ()
    let files            = files ()
    let eventfd          = eventfd ()
    let files_update     = files_update ()
    let eventfd_async    = eventfd_async ()
    let probe            = probe ()
    let personality      = personality ()
    let restrictions     = restrictions ()
    let enable_rings     = enable_rings ()
    let files2           = files2 ()
    let files_update2    = files_update2 ()
    let buffers2         = buffers2 ()
    let buffers_update   = buffers_update ()
    let iowq_aff         = iowq_aff ()
    let iowq_max_workers = iowq_max_workers ()
    let ring_fds         = ring_fds ()
    let pbuf_ring        = pbuf_ring ()
    let sync_cancel      = sync_cancel ()
    let file_alloc_range = file_alloc_range ()
    let pbuf_status      = pbuf_status ()
    let napi             = napi ()
    let clock            = clock ()
    let clone_buffers    = clone_buffers ()
    let send_msg_rings   = send_msg_rings ()
    let last             = last ()
  end

  module Unregister = struct
    (*****************************************************************************
     * Unregister opcodes (IORING_UNREGISTER_*
     *****************************************************************************)

    type t = Register.t

    external buffers     : unit -> t = "hemlock__c__liburing__ioring__unregister__buffers"
    external files       : unit -> t = "hemlock__c__liburing__ioring__unregister__files"
    external eventfd     : unit -> t = "hemlock__c__liburing__ioring__unregister__eventfd"
    external personality : unit -> t = "hemlock__c__liburing__ioring__unregister__personality"
    external iowq_aff   : unit -> t = "hemlock__c__liburing__ioring__unregister__iowq_aff"
    external ring_fds    : unit -> t = "hemlock__c__liburing__ioring__unregister__ring_fds"
    external pbuf_ring   : unit -> t = "hemlock__c__liburing__ioring__unregister__pbuf_ring"
    external napi        : unit -> t = "hemlock__c__liburing__ioring__unregister__napi"

    let buffers     = buffers ()
    let files       = files ()
    let eventfd     = eventfd ()
    let personality = personality ()
    let iowq_aff   = iowq_aff ()
    let ring_fds    = ring_fds ()
    let pbuf_ring   = pbuf_ring ()
    let napi        = napi ()
  end
end

type entries      = Basis.U32.t
type res          = Basis.I32.t
type flags        = Basis.U32.t
type wait_nr      = Basis.U32.t
type fd           = Basis.I32.t
type buf          = bytes
type nbytes       = Basis.U32.t
type offset       = Basis.U64.t
type dfd          = Basis.I32.t
type path         = string
type mode         = Basis.U32.t
type poll_mask    = Basis.U32.t
type user_data    = Basis.U64.t
type sockfd       = Basis.I32.t
type len          = Basis.U32.t
type count        = Basis.U32.t
type tv_sec       = Basis.I64.t
type tv_nsec      = Basis.I64.t
type fd_in        = Basis.I32.t
type off_in       = Basis.I64.t
type fd_out       = Basis.I32.t
type off_out      = Basis.I64.t
type splice_flags = Basis.U32.t
type olddirfd     = Basis.I32.t
type oldpath      = string
type newdirfd     = Basis.I32.t
type newpath      = string
type nr_args      = Basis.U32.t

module Io_uring = struct
  type t

  module Sqe = struct
    type t

    external set_data64: user_data -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__set_data64"

    external prep_nop: t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_nop"

    external prep_read: offset -> nbytes -> buf -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_read"

    external prep_write: offset -> nbytes -> buf -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_write"

    external prep_openat: mode -> flags -> path -> dfd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_openat"

    external prep_close: fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_close"

    external prep_fsync: Ioring.Fsync.t -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_fsync"

    external prep_poll_add: poll_mask -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_poll_add"

    external prep_cancel64: flags -> user_data -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_cancel64"

    external prep_cancel_fd: flags -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_cancel_fd"

    external prep_connect: Sockaddr.sockaddr -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_connect"

    external prep_accept: flags -> Sockaddr.sockaddr -> fd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_accept"

    external prep_recv: flags -> len -> buf -> sockfd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_recv"

    external prep_send: flags -> len -> buf -> sockfd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_send"

    external prep_timeout: flags -> count -> tv_nsec -> tv_sec -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_timeout"

    external prep_link_timeout: flags -> tv_nsec -> tv_sec -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_link_timeout"

    external prep_splice:
      splice_flags -> nbytes -> off_out -> fd_out -> off_in -> fd_in -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_splice"
        "hemlock__c__liburing__io_uring__sqe__prep_splice_native"

    external prep_renameat:
      flags -> newpath -> newdirfd -> oldpath -> olddirfd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_renameat"
        "hemlock__c__liburing__io_uring__sqe__prep_renameat_native"

    external prep_unlinkat: flags -> path -> dfd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_unlinkat"

    external prep_mkdirat: mode -> path -> dfd -> t -> unit
      = "hemlock__c__liburing__io_uring__sqe__prep_mkdirat"
  end

  module Cqe = struct
    type t

    external res: t -> (res, errno) result
      = "hemlock__c__liburing__io_uring__cqe__res"

    external flags: t -> Ioring.Cqe_f.t
      = "hemlock__c__liburing__io_uring__cqe__flags"

    external get_data64: t -> user_data
      = "hemlock__c__liburing__io_uring__cqe__get_data64"
  end

  module Params = struct
    (*****************************************************************************
     * Params (struct io_uring_params)
     *****************************************************************************)

    type t

    external make : unit -> t
      = "hemlock__c__liburing__io_uring__params__make"

    external set_flags          : Ioring.Setup.t -> t -> unit
      = "hemlock__c__liburing__io_uring__params__set_flags"
    external set_sq_thread_cpu  : Basis.U32.t -> t -> unit
      = "hemlock__c__liburing__io_uring__params__set_sq_thread_cpu"
    external set_sq_thread_idle : Basis.U32.t -> t -> unit
      = "hemlock__c__liburing__io_uring__params__set_sq_thread_idle"
    external set_wq_fd          : fd -> t -> unit
      = "hemlock__c__liburing__io_uring__params__set_wq_fd"

    external get_sq_entries : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_entries"
    external get_cq_entries : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_entries"
    external get_flags      : t -> Ioring.Setup.t
      = "hemlock__c__liburing__io_uring__params__flags"
    external get_features   : t -> Ioring.Feat.t
      = "hemlock__c__liburing__io_uring__params__features"

    external get_sq_off_head         : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_head"
    external get_sq_off_tail         : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_tail"
    external get_sq_off_ring_mask    : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_ring_mask"
    external get_sq_off_ring_entries : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_ring_entries"
    external get_sq_off_flags        : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_flags"
    external get_sq_off_dropped      : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_dropped"
    external get_sq_off_array        : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__sq_off_array"
    external get_sq_off_user_addr    : t -> Basis.U64.t
      = "hemlock__c__liburing__io_uring__params__sq_off_user_addr"

    external get_cq_off_head         : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_head"
    external get_cq_off_tail         : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_tail"
    external get_cq_off_ring_mask    : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_ring_mask"
    external get_cq_off_ring_entries : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_ring_entries"
    external get_cq_off_overflow     : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_overflow"
    external get_cq_off_cqes         : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_cqes"
    external get_cq_off_flags        : t -> Basis.U32.t
      = "hemlock__c__liburing__io_uring__params__cq_off_flags"
    external get_cq_off_user_addr    : t -> Basis.U64.t
      = "hemlock__c__liburing__io_uring__params__cq_off_user_addr"
  end

  (*****************************************************************************
   * Syscalls
   *****************************************************************************)

  external setup    : Basis.U32.t -> Params.t -> (fd, errno) result
    = "hemlock__c__liburing__io_uring__setup"
  external enter    : fd -> Basis.U32.t -> Basis.U32.t -> Ioring.Enter.t -> (res, errno) result
    = "hemlock__c__liburing__io_uring__enter"
  external register : fd -> Ioring.Register.t -> buf option -> nr_args -> (res, errno) result
    = "hemlock__c__liburing__io_uring__register"

  (*****************************************************************************
   * Liburing wrapper functions
   *****************************************************************************)

  external queue_init: entries -> flags -> (t, errno) result
    = "hemlock__c__liburing__io_uring__queue_init"

  external queue_exit: t -> unit
    = "hemlock__c__liburing__io_uring__queue_exit"

  external get_sqe: t -> Sqe.t option
    = "hemlock__c__liburing__io_uring__get_sqe"

  external submit: t -> (entries, errno) result
    = "hemlock__c__liburing__io_uring__submit"

  external submit_and_wait: wait_nr -> t -> (entries, errno) result
    = "hemlock__c__liburing__io_uring__submit_and_wait"

  external wait_cqe: t -> (Cqe.t, errno) result
    = "hemlock__c__liburing__io_uring__wait_cqe"

  external peek_cqe: t -> (Cqe.t, errno) result
    = "hemlock__c__liburing__io_uring__peek_cqe"

  external cqe_seen: Cqe.t -> t -> unit
    = "hemlock__c__liburing__io_uring__cqe__seen"

  external sq_ready: t -> entries = "hemlock__c__liburing__io_uring__sq_ready"
  external cq_ready: t -> entries = "hemlock__c__liburing__io_uring__cq_ready"

end

module Iosqe : sig
  (*****************************************************************************
   * SQE flags (IOSQE_*
   *****************************************************************************)

  type t = Basis.U32.t

  val fixed_file       : t (* IOSQE_FIXED_FILE *)
  val io_drain         : t (* IOSQE_IO_DRAIN *)
  val io_link          : t (* IOSQE_IO_LINK *)
  val io_hardlink      : t (* IOSQE_IO_HARDLINK *)
  val async            : t (* IOSQE_ASYNC *)
  val buffer_select    : t (* IOSQE_BUFFER_SELECT *)
  val cqe_skip_success : t (* IOSQE_CQE_SKIP_SUCCESS *)
end

module Ioring : sig
  module Setup : sig
    (*****************************************************************************
     * Setup flags (IORING_SETUP_*
     *****************************************************************************)

    type t = Basis.U32.t

    val iopoll             : t (* IORING_SETUP_IOPOLL *)
    val sqpoll             : t (* IORING_SETUP_SQPOLL *)
    val sq_aff             : t (* IORING_SETUP_SQ_AFF *)
    val cqsize             : t (* IORING_SETUP_CQSIZE *)
    val clamp              : t (* IORING_SETUP_CLAMP *)
    val attach_wq          : t (* IORING_SETUP_ATTACH_WQ *)
    val r_disabled         : t (* IORING_SETUP_R_DISABLED *)
    val submit_all         : t (* IORING_SETUP_SUBMIT_ALL *)
    val coop_taskrun       : t (* IORING_SETUP_COOP_TASKRUN *)
    val taskrun_flag       : t (* IORING_SETUP_TASKRUN_FLAG *)
    val sqe128             : t (* IORING_SETUP_SQE128 *)
    val cqe32              : t (* IORING_SETUP_CQE32 *)
    val single_issuer      : t (* IORING_SETUP_SINGLE_ISSUER *)
    val defer_taskrun      : t (* IORING_SETUP_DEFER_TASKRUN *)
    val no_mmap            : t (* IORING_SETUP_NO_MMAP *)
    val registered_fd_only : t (* IORING_SETUP_REGISTERED_FD_ONLY *)
    val no_sqarray         : t (* IORING_SETUP_NO_SQARRAY *)
  end

  module Feat : sig
    (*****************************************************************************
     * Feature flags (IORING_FEAT_*
     *****************************************************************************)

    type t = Basis.U32.t

    val single_mmap     : t (* IORING_FEAT_SINGLE_MMAP *)
    val nodrop          : t (* IORING_FEAT_NODROP *)
    val submit_stable   : t (* IORING_FEAT_SUBMIT_STABLE *)
    val rw_cur_pos      : t (* IORING_FEAT_RW_CUR_POS *)
    val cur_personality : t (* IORING_FEAT_CUR_PERSONALITY *)
    val fast_poll       : t (* IORING_FEAT_FAST_POLL *)
    val poll_32bits     : t (* IORING_FEAT_POLL_32BITS *)
    val sqpoll_nonfixed : t (* IORING_FEAT_SQPOLL_NONFIXED *)
    val ext_arg         : t (* IORING_FEAT_EXT_ARG *)
    val native_workers  : t (* IORING_FEAT_NATIVE_WORKERS *)
    val rsrc_tags       : t (* IORING_FEAT_RSRC_TAGS *)
    val cqe_skip        : t (* IORING_FEAT_CQE_SKIP *)
    val linked_file     : t (* IORING_FEAT_LINKED_FILE *)
    val reg_reg_ring    : t (* IORING_FEAT_REG_REG_RING *)
    val recvsend_bundle : t (* IORING_FEAT_RECVSEND_BUNDLE *)
    val min_timeout     : t (* IORING_FEAT_MIN_TIMEOUT *)
  end

  module Cqe_f : sig
    (*****************************************************************************
     * CQE flags (IORING_CQE_F_*
     *****************************************************************************)

    type t = Basis.U32.t

    val buffer        : t (* IORING_CQE_F_BUFFER *)
    val more          : t (* IORING_CQE_F_MORE *)
    val sock_nonempty : t (* IORING_CQE_F_SOCK_NONEMPTY *)
    val notif         : t (* IORING_CQE_F_NOTIF *)
  end

  module Op : sig
    (*****************************************************************************
     * Opcodes (IORING_OP_*
     *****************************************************************************)

    type t = Basis.U32.t

    val nop              : t (* IORING_OP_NOP *)
    val readv            : t (* IORING_OP_READV *)
    val writev           : t (* IORING_OP_WRITEV *)
    val fsync            : t (* IORING_OP_FSYNC *)
    val read_fixed       : t (* IORING_OP_READ_FIXED *)
    val write_fixed      : t (* IORING_OP_WRITE_FIXED *)
    val poll_add         : t (* IORING_OP_POLL_ADD *)
    val poll_remove      : t (* IORING_OP_POLL_REMOVE *)
    val sync_file_range  : t (* IORING_OP_SYNC_FILE_RANGE *)
    val sendmsg          : t (* IORING_OP_SENDMSG *)
    val recvmsg          : t (* IORING_OP_RECVMSG *)
    val timeout          : t (* IORING_OP_TIMEOUT *)
    val timeout_remove   : t (* IORING_OP_TIMEOUT_REMOVE *)
    val accept           : t (* IORING_OP_ACCEPT *)
    val async_cancel     : t (* IORING_OP_ASYNC_CANCEL *)
    val link_timeout     : t (* IORING_OP_LINK_TIMEOUT *)
    val connect          : t (* IORING_OP_CONNECT *)
    val fallocate        : t (* IORING_OP_FALLOCATE *)
    val openat           : t (* IORING_OP_OPENAT *)
    val close            : t (* IORING_OP_CLOSE *)
    val files_update     : t (* IORING_OP_FILES_UPDATE *)
    val statx            : t (* IORING_OP_STATX *)
    val read             : t (* IORING_OP_READ *)
    val write            : t (* IORING_OP_WRITE *)
    val fadvise          : t (* IORING_OP_FADVISE *)
    val madvise          : t (* IORING_OP_MADVISE *)
    val send             : t (* IORING_OP_SEND *)
    val recv             : t (* IORING_OP_RECV *)
    val openat2          : t (* IORING_OP_OPENAT2 *)
    val epoll_ctl        : t (* IORING_OP_EPOLL_CTL *)
    val splice           : t (* IORING_OP_SPLICE *)
    val provide_buffers  : t (* IORING_OP_PROVIDE_BUFFERS *)
    val remove_buffers   : t (* IORING_OP_REMOVE_BUFFERS *)
    val tee              : t (* IORING_OP_TEE *)
    val shutdown         : t (* IORING_OP_SHUTDOWN *)
    val renameat         : t (* IORING_OP_RENAMEAT *)
    val unlinkat         : t (* IORING_OP_UNLINKAT *)
    val mkdirat          : t (* IORING_OP_MKDIRAT *)
    val symlinkat        : t (* IORING_OP_SYMLINKAT *)
    val linkat           : t (* IORING_OP_LINKAT *)
    val msg_ring         : t (* IORING_OP_MSG_RING *)
    val fsetxattr        : t (* IORING_OP_FSETXATTR *)
    val setxattr         : t (* IORING_OP_SETXATTR *)
    val fgetxattr        : t (* IORING_OP_FGETXATTR *)
    val getxattr         : t (* IORING_OP_GETXATTR *)
    val socket           : t (* IORING_OP_SOCKET *)
    val uring_cmd        : t (* IORING_OP_URING_CMD *)
    val send_zc          : t (* IORING_OP_SEND_ZC *)
    val sendmsg_zc       : t (* IORING_OP_SENDMSG_ZC *)
    val read_multishot   : t (* IORING_OP_READ_MULTISHOT *)
    val waitid           : t (* IORING_OP_WAITID *)
    val futex_wait       : t (* IORING_OP_FUTEX_WAIT *)
    val futex_wake       : t (* IORING_OP_FUTEX_WAKE *)
    val futex_waitv      : t (* IORING_OP_FUTEX_WAITV *)
    val fixed_fd_install : t (* IORING_OP_FIXED_FD_INSTALL *)
    val ftruncate        : t (* IORING_OP_FTRUNCATE *)
    val bind             : t (* IORING_OP_BIND *)
    val listen           : t (* IORING_OP_LISTEN *)
    val last             : t (* IORING_OP_LAST *)
  end

  module Fsync : sig
    (*****************************************************************************
     * Fsync flags (IORING_FSYNC_*
     *****************************************************************************)

    type t = Basis.U32.t

    val datasync : t (* IORING_FSYNC_DATASYNC *)
  end

  module Timeout : sig
    (*****************************************************************************
     * Timeout flags (IORING_TIMEOUT_*
     *****************************************************************************)

    type t = Basis.U32.t

    val abs           : t (* IORING_TIMEOUT_ABS *)
    val update        : t (* IORING_TIMEOUT_UPDATE *)
    val boottime      : t (* IORING_TIMEOUT_BOOTTIME *)
    val realtime      : t (* IORING_TIMEOUT_REALTIME *)
    val link_update   : t (* IORING_LINK_TIMEOUT_UPDATE *)
    val etime_success : t (* IORING_TIMEOUT_ETIME_SUCCESS *)
    val multishot     : t (* IORING_TIMEOUT_MULTISHOT *)
    val clock_mask    : t (* IORING_TIMEOUT_CLOCK_MASK *)
    val update_mask   : t (* IORING_TIMEOUT_UPDATE_MASK *)
  end

  module Async_cancel : sig
    (*****************************************************************************
     * Async cancel flags (IORING_ASYNC_CANCEL_*
     *****************************************************************************)

    type t = Basis.U32.t

    val all      : t (* IORING_ASYNC_CANCEL_ALL *)
    val fd       : t (* IORING_ASYNC_CANCEL_FD *)
    val any      : t (* IORING_ASYNC_CANCEL_ANY *)
    val fd_fixed : t (* IORING_ASYNC_CANCEL_FD_FIXED *)
    val userdata : t (* IORING_ASYNC_CANCEL_USERDATA *)
    val op       : t (* IORING_ASYNC_CANCEL_OP *)
  end

  module Recvsend : sig
    (*****************************************************************************
     * Recv/send flags (IORING_RECVSEND_*
     *****************************************************************************)

    type t = Basis.U32.t

    val poll_first : t (* IORING_RECVSEND_POLL_FIRST *)
    val fixed_buf  : t (* IORING_RECVSEND_FIXED_BUF *)
    val bundle     : t (* IORING_RECVSEND_BUNDLE *)
  end

  module Poll : sig
    (*****************************************************************************
     * Poll flags (IORING_POLL_ADD_*
     *****************************************************************************)

    type t = Basis.U32.t

    val add_multi        : t (* IORING_POLL_ADD_MULTI *)
    val update_events    : t (* IORING_POLL_UPDATE_EVENTS *)
    val update_user_data : t (* IORING_POLL_UPDATE_USER_DATA *)
    val add_level        : t (* IORING_POLL_ADD_LEVEL *)
  end

  module Msg : sig
    (*****************************************************************************
     * Msg ring op types (IORING_MSG_*
     *****************************************************************************)

    type t = Basis.U32.t

    val data    : t (* IORING_MSG_DATA *)
    val send_fd : t (* IORING_MSG_SEND_FD *)
  end

  module Send_zc : sig
    (*****************************************************************************
     * Send ZC flags (IORING_SEND_ZC_*
     *****************************************************************************)

    type t = Basis.U32.t

    val report_usage : t (* IORING_SEND_ZC_REPORT_USAGE *)
  end

  module Enter : sig
    (*****************************************************************************
     * Enter flags (IORING_ENTER_*
     *****************************************************************************)

    type t = Basis.U32.t

    val getevents       : t (* IORING_ENTER_GETEVENTS *)
    val sq_wakeup       : t (* IORING_ENTER_SQ_WAKEUP *)
    val sq_wait         : t (* IORING_ENTER_SQ_WAIT *)
    val ext_arg         : t (* IORING_ENTER_EXT_ARG *)
    val registered_ring : t (* IORING_ENTER_REGISTERED_RING *)
  end

  module Register : sig
    (*****************************************************************************
     * Register opcodes (IORING_REGISTER_*
     *****************************************************************************)

    type t = Basis.U32.t

    val buffers          : t (* IORING_REGISTER_BUFFERS *)
    val files            : t (* IORING_REGISTER_FILES *)
    val eventfd          : t (* IORING_REGISTER_EVENTFD *)
    val files_update     : t (* IORING_REGISTER_FILES_UPDATE *)
    val eventfd_async    : t (* IORING_REGISTER_EVENTFD_ASYNC *)
    val probe            : t (* IORING_REGISTER_PROBE *)
    val personality      : t (* IORING_REGISTER_PERSONALITY *)
    val restrictions     : t (* IORING_REGISTER_RESTRICTIONS *)
    val enable_rings     : t (* IORING_REGISTER_ENABLE_RINGS *)
    val files2           : t (* IORING_REGISTER_FILES2 *)
    val files_update2    : t (* IORING_REGISTER_FILES_UPDATE2 *)
    val buffers2         : t (* IORING_REGISTER_BUFFERS2 *)
    val buffers_update   : t (* IORING_REGISTER_BUFFERS_UPDATE *)
    val iowq_aff         : t (* IORING_REGISTER_IOWQ_AFF *)
    val iowq_max_workers : t (* IORING_REGISTER_IOWQ_MAX_WORKERS *)
    val ring_fds         : t (* IORING_REGISTER_RING_FDS *)
    val pbuf_ring        : t (* IORING_REGISTER_PBUF_RING *)
    val sync_cancel      : t (* IORING_REGISTER_SYNC_CANCEL *)
    val file_alloc_range : t (* IORING_REGISTER_FILE_ALLOC_RANGE *)
    val pbuf_status      : t (* IORING_REGISTER_PBUF_STATUS *)
    val napi             : t (* IORING_REGISTER_NAPI *)
    val clock            : t (* IORING_REGISTER_CLOCK *)
    val clone_buffers    : t (* IORING_REGISTER_CLONE_BUFFERS *)
    val send_msg_rings   : t (* IORING_REGISTER_SEND_MSG_RINGS *)
    val last             : t (* IORING_REGISTER_LAST *)
  end

  module Unregister : sig
    (*****************************************************************************
     * Unregister opcodes (IORING_UNREGISTER_*
     *****************************************************************************)

    type t = Register.t

    val buffers     : t (* IORING_UNREGISTER_BUFFERS *)
    val files       : t (* IORING_UNREGISTER_FILES *)
    val eventfd     : t (* IORING_UNREGISTER_EVENTFD *)
    val personality : t (* IORING_UNREGISTER_PERSONALITY *)
    val iowq_aff    : t (* IORING_UNREGISTER_IOWQ_AFF *)
    val ring_fds    : t (* IORING_UNREGISTER_RING_FDS *)
    val pbuf_ring   : t (* IORING_UNREGISTER_PBUF_RING *)
    val napi        : t (* IORING_UNREGISTER_NAPI *)
  end
end

(*****************************************************************************
 * Type aliases
 *****************************************************************************)

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

module Io_uring : sig
  type t

  module Sqe : sig
    type t

    val set_data64 : user_data -> t -> unit (* io_uring_sqe_set_data64 *)
    val prep_nop    : t -> unit (* io_uring_prep_nop *)
    val prep_read   : offset -> nbytes -> buf -> fd -> t -> unit (* io_uring_prep_read *)
    val prep_write  : offset -> nbytes -> buf -> fd -> t -> unit (* io_uring_prep_write *)
    val prep_openat : mode -> flags -> path -> dfd -> t -> unit (* io_uring_prep_openat *)
    val prep_close  : fd -> t -> unit (* io_uring_prep_close *)
    val prep_fsync    : Ioring.Fsync.t -> fd -> t -> unit (* io_uring_prep_fsync *)
    val prep_poll_add : poll_mask -> fd -> t -> unit (* io_uring_prep_poll_add *)
    val prep_cancel64  : flags -> user_data -> t -> unit (* io_uring_prep_cancel64 *)
    val prep_cancel_fd : flags -> fd -> t -> unit (* io_uring_prep_cancel_fd *)
    val prep_connect : Sockaddr.sockaddr -> fd -> t -> unit (* io_uring_prep_connect *)
    val prep_accept  : flags -> Sockaddr.sockaddr -> fd -> t -> unit (* io_uring_prep_accept *)
    val prep_recv     : flags -> len -> buf -> sockfd -> t -> unit (* io_uring_prep_recv *)
    val prep_send     : flags -> len -> buf -> sockfd -> t -> unit (* io_uring_prep_send *)
    val prep_timeout      : flags -> count -> tv_nsec -> tv_sec -> t -> unit (* io_uring_prep_timeout *)
    val prep_link_timeout : flags -> tv_nsec -> tv_sec -> t -> unit (* io_uring_prep_link_timeout *)
    val prep_splice : (* io_uring_prep_splice *)
      splice_flags -> nbytes -> off_out -> fd_out -> off_in -> fd_in -> t -> unit
    val prep_renameat : (* io_uring_prep_renameat *)
      flags -> newpath -> newdirfd -> oldpath -> olddirfd -> t -> unit
    val prep_unlinkat : flags -> path -> dfd -> t -> unit (* io_uring_prep_unlinkat *)
    val prep_mkdirat  : mode -> path -> dfd -> t -> unit (* io_uring_prep_mkdirat *)
  end

  module Cqe : sig
    type t

    val res        : t -> (res, Errno.t) result (* io_uring_cqe.res *)
    val flags      : t -> Ioring.Cqe_f.t (* io_uring_cqe.flags *)
    val get_data64 : t -> user_data (* io_uring_cqe_get_data64 *)
  end

  module Params : sig
    (*****************************************************************************
     * Params (struct io_uring_params)
     *****************************************************************************)

    type t

    val make : unit -> t (* struct io_uring_params *)

    val set_flags          : Ioring.Setup.t -> t -> unit (* io_uring_params.flags *)
    val set_sq_thread_cpu  : Basis.U32.t -> t -> unit (* io_uring_params.sq_thread_cpu *)
    val set_sq_thread_idle : Basis.U32.t -> t -> unit (* io_uring_params.sq_thread_idle *)
    val set_wq_fd          : fd -> t -> unit (* io_uring_params.wq_fd *)

    val get_sq_entries : t -> Basis.U32.t (* io_uring_params.sq_entries *)
    val get_cq_entries : t -> Basis.U32.t (* io_uring_params.cq_entries *)
    val get_flags      : t -> Ioring.Setup.t (* io_uring_params.flags *)
    val get_features   : t -> Ioring.Feat.t (* io_uring_params.features *)

    val get_sq_off_head         : t -> Basis.U32.t (* io_uring_params.sq_off.head *)
    val get_sq_off_tail         : t -> Basis.U32.t (* io_uring_params.sq_off.tail *)
    val get_sq_off_ring_mask    : t -> Basis.U32.t (* io_uring_params.sq_off.ring_mask *)
    val get_sq_off_ring_entries : t -> Basis.U32.t (* io_uring_params.sq_off.ring_entries *)
    val get_sq_off_flags        : t -> Basis.U32.t (* io_uring_params.sq_off.flags *)
    val get_sq_off_dropped      : t -> Basis.U32.t (* io_uring_params.sq_off.dropped *)
    val get_sq_off_array        : t -> Basis.U32.t (* io_uring_params.sq_off.array *)
    val get_sq_off_user_addr    : t -> Basis.U64.t (* io_uring_params.sq_off.user_addr *)

    val get_cq_off_head         : t -> Basis.U32.t (* io_uring_params.cq_off.head *)
    val get_cq_off_tail         : t -> Basis.U32.t (* io_uring_params.cq_off.tail *)
    val get_cq_off_ring_mask    : t -> Basis.U32.t (* io_uring_params.cq_off.ring_mask *)
    val get_cq_off_ring_entries : t -> Basis.U32.t (* io_uring_params.cq_off.ring_entries *)
    val get_cq_off_overflow     : t -> Basis.U32.t (* io_uring_params.cq_off.overflow *)
    val get_cq_off_cqes         : t -> Basis.U32.t (* io_uring_params.cq_off.cqes *)
    val get_cq_off_flags        : t -> Basis.U32.t (* io_uring_params.cq_off.flags *)
    val get_cq_off_user_addr    : t -> Basis.U64.t (* io_uring_params.cq_off.user_addr *)
  end

  (*****************************************************************************
   * Syscalls
   *****************************************************************************)

  val setup    : Basis.U32.t -> Params.t -> (fd, Errno.t) result (* io_uring_setup *)
  val enter    : fd -> Basis.U32.t -> Basis.U32.t -> Ioring.Enter.t -> (res, Errno.t) result (* io_uring_enter *)
  val register : fd -> Ioring.Register.t -> buf option -> nr_args -> (res, Errno.t) result (* io_uring_register *)

  (*****************************************************************************
   * Liburing wrapper functions
   *****************************************************************************)

  val queue_init      : entries -> flags -> (t, Errno.t) result (* io_uring_queue_init *)
  val queue_exit      : t -> unit (* io_uring_queue_exit *)
  val get_sqe         : t -> Sqe.t option (* io_uring_get_sqe *)
  val submit          : t -> (entries, Errno.t) result (* io_uring_submit *)
  val submit_and_wait : wait_nr -> t -> (entries, Errno.t) result (* io_uring_submit_and_wait *)
  val wait_cqe        : t -> (Cqe.t, Errno.t) result (* io_uring_wait_cqe *)
  val peek_cqe        : t -> (Cqe.t, Errno.t) result (* io_uring_peek_cqe *)
  val cqe_seen        : Cqe.t -> t -> unit (* io_uring_cqe_seen *)
  val sq_ready        : t -> entries (* io_uring_sq_ready *)
  val cq_ready        : t -> entries (* io_uring_cq_ready *)
end

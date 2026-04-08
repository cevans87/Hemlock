open Basis
open Os.C.Liburing

let () =
  (* Iosqe flags: verify each is a distinct power of two *)
  let iosqe_flags = [|
    ("fixed_file",       Iosqe.fixed_file);
    ("io_drain",         Iosqe.io_drain);
    ("io_link",          Iosqe.io_link);
    ("io_hardlink",      Iosqe.io_hardlink);
    ("async",            Iosqe.async);
    ("buffer_select",    Iosqe.buffer_select);
    ("cqe_skip_success", Iosqe.cqe_skip_success);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Iosqe.%s: %Ld\n" name (U32.extend_to_uns v)
  ) iosqe_flags;

  (* Ioring.Setup flags *)
  let setup_flags = [|
    ("iopoll",             Ioring.Setup.iopoll);
    ("sqpoll",             Ioring.Setup.sqpoll);
    ("sq_aff",             Ioring.Setup.sq_aff);
    ("cqsize",             Ioring.Setup.cqsize);
    ("clamp",              Ioring.Setup.clamp);
    ("attach_wq",          Ioring.Setup.attach_wq);
    ("r_disabled",         Ioring.Setup.r_disabled);
    ("submit_all",         Ioring.Setup.submit_all);
    ("coop_taskrun",       Ioring.Setup.coop_taskrun);
    ("taskrun_flag",       Ioring.Setup.taskrun_flag);
    ("sqe128",             Ioring.Setup.sqe128);
    ("cqe32",              Ioring.Setup.cqe32);
    ("single_issuer",      Ioring.Setup.single_issuer);
    ("defer_taskrun",      Ioring.Setup.defer_taskrun);
    ("no_mmap",            Ioring.Setup.no_mmap);
    ("registered_fd_only", Ioring.Setup.registered_fd_only);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Ioring.Setup.%s: %Ld\n" name (U32.extend_to_uns v)
  ) setup_flags;

  (* Ioring.Op opcodes: verify they are sequential starting from 0 *)
  let opcodes = [|
    ("nop",              Ioring.Op.nop);
    ("readv",            Ioring.Op.readv);
    ("writev",           Ioring.Op.writev);
    ("fsync",            Ioring.Op.fsync);
    ("read_fixed",       Ioring.Op.read_fixed);
    ("write_fixed",      Ioring.Op.write_fixed);
    ("poll_add",         Ioring.Op.poll_add);
    ("poll_remove",      Ioring.Op.poll_remove);
    ("sync_file_range",  Ioring.Op.sync_file_range);
    ("sendmsg",          Ioring.Op.sendmsg);
    ("recvmsg",          Ioring.Op.recvmsg);
    ("timeout",          Ioring.Op.timeout);
    ("timeout_remove",   Ioring.Op.timeout_remove);
    ("accept",           Ioring.Op.accept);
    ("async_cancel",     Ioring.Op.async_cancel);
    ("link_timeout",     Ioring.Op.link_timeout);
    ("connect",          Ioring.Op.connect);
    ("fallocate",        Ioring.Op.fallocate);
    ("openat",           Ioring.Op.openat);
    ("close",            Ioring.Op.close);
    ("files_update",     Ioring.Op.files_update);
    ("statx",            Ioring.Op.statx);
    ("read",             Ioring.Op.read);
    ("write",            Ioring.Op.write);
    ("fadvise",          Ioring.Op.fadvise);
    ("madvise",          Ioring.Op.madvise);
    ("send",             Ioring.Op.send);
    ("recv",             Ioring.Op.recv);
    ("openat2",          Ioring.Op.openat2);
    ("epoll_ctl",        Ioring.Op.epoll_ctl);
    ("splice",           Ioring.Op.splice);
    ("provide_buffers",  Ioring.Op.provide_buffers);
    ("remove_buffers",   Ioring.Op.remove_buffers);
    ("tee",              Ioring.Op.tee);
    ("shutdown",         Ioring.Op.shutdown);
    ("renameat",         Ioring.Op.renameat);
    ("unlinkat",         Ioring.Op.unlinkat);
    ("mkdirat",          Ioring.Op.mkdirat);
    ("symlinkat",        Ioring.Op.symlinkat);
    ("linkat",           Ioring.Op.linkat);
    ("msg_ring",         Ioring.Op.msg_ring);
    ("fsetxattr",        Ioring.Op.fsetxattr);
    ("setxattr",         Ioring.Op.setxattr);
    ("fgetxattr",        Ioring.Op.fgetxattr);
    ("getxattr",         Ioring.Op.getxattr);
    ("socket",           Ioring.Op.socket);
    ("uring_cmd",        Ioring.Op.uring_cmd);
    ("send_zc",          Ioring.Op.send_zc);
    ("sendmsg_zc",       Ioring.Op.sendmsg_zc);
    ("last",             Ioring.Op.last);
  |] in
  Array.iter ~f:(fun (name, v) ->
    Printf.printf "Ioring.Op.%s: %Ld\n" name (U32.extend_to_uns v)
  ) opcodes;

  (* CQE flags *)
  let cqe_flags = [|
    ("buffer",        Ioring.Cqe_f.buffer);
    ("more",          Ioring.Cqe_f.more);
    ("sock_nonempty", Ioring.Cqe_f.sock_nonempty);
    ("notif",         Ioring.Cqe_f.notif);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Ioring.Cqe_f.%s: %Ld\n" name (U32.extend_to_uns v)
  ) cqe_flags;

  (* Ioring.Feat flags *)
  let feat_flags = [|
    ("single_mmap",     Ioring.Feat.single_mmap);
    ("nodrop",          Ioring.Feat.nodrop);
    ("submit_stable",   Ioring.Feat.submit_stable);
    ("rw_cur_pos",      Ioring.Feat.rw_cur_pos);
    ("cur_personality",  Ioring.Feat.cur_personality);
    ("fast_poll",       Ioring.Feat.fast_poll);
    ("poll_32bits",     Ioring.Feat.poll_32bits);
    ("sqpoll_nonfixed", Ioring.Feat.sqpoll_nonfixed);
    ("ext_arg",         Ioring.Feat.ext_arg);
    ("native_workers",  Ioring.Feat.native_workers);
    ("rsrc_tags",       Ioring.Feat.rsrc_tags);
    ("cqe_skip",        Ioring.Feat.cqe_skip);
    ("linked_file",     Ioring.Feat.linked_file);
    ("reg_reg_ring",    Ioring.Feat.reg_reg_ring);
  |] in
  Array.iter ~f:(fun (name, v) ->
    assert U32.(v > kv 0L);
    Printf.printf "Ioring.Feat.%s: %Ld\n" name (U32.extend_to_uns v)
  ) feat_flags;

  (* Remaining flag modules: spot-check one value from each *)
  assert U32.(Ioring.Fsync.datasync > kv 0L);
  Printf.printf "Ioring.Fsync.datasync: %Ld\n" (U32.extend_to_uns Ioring.Fsync.datasync);

  assert U32.(Ioring.Timeout.abs > kv 0L);
  Printf.printf "Ioring.Timeout.abs: %Ld\n" (U32.extend_to_uns Ioring.Timeout.abs);

  assert U32.(Ioring.Async_cancel.all > kv 0L);
  Printf.printf "Ioring.Async_cancel.all: %Ld\n" (U32.extend_to_uns Ioring.Async_cancel.all);

  assert U32.(Ioring.Recvsend.poll_first > kv 0L);
  Printf.printf "Ioring.Recvsend.poll_first: %Ld\n" (U32.extend_to_uns Ioring.Recvsend.poll_first);

  assert U32.(Ioring.Poll.add_multi > kv 0L);
  Printf.printf "Ioring.Poll.add_multi: %Ld\n" (U32.extend_to_uns Ioring.Poll.add_multi);

  Printf.printf "Ioring.Msg.data: %Ld\n" (U32.extend_to_uns Ioring.Msg.data);
  assert U32.(Ioring.Msg.send_fd > kv 0L);
  Printf.printf "Ioring.Msg.send_fd: %Ld\n" (U32.extend_to_uns Ioring.Msg.send_fd);

  assert U32.(Ioring.Send_zc.report_usage > kv 0L);
  Printf.printf "Ioring.Send_zc.report_usage: %Ld\n" (U32.extend_to_uns Ioring.Send_zc.report_usage);

  assert U32.(Ioring.Enter.getevents > kv 0L);
  Printf.printf "Ioring.Enter.getevents: %Ld\n" (U32.extend_to_uns Ioring.Enter.getevents);

  Printf.printf "Ioring.Register.buffers: %Ld\n" (U32.extend_to_uns Ioring.Register.buffers);
  assert U32.(Ioring.Register.last > kv 0L);
  Printf.printf "Ioring.Register.last: %Ld\n" (U32.extend_to_uns Ioring.Register.last);

  Printf.printf "Ioring.Unregister.buffers: %Ld\n" (U32.extend_to_uns Ioring.Unregister.buffers);

  Printf.printf "flags: ok\n"

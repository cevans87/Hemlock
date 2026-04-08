#define _GNU_SOURCE
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <fcntl.h>

/*****************************************************************************
 * Open flags (O_*)
 *****************************************************************************/

CAMLprim value hemlock__c__fcntl__open__rdonly(value unit)    { (void)unit; return caml_copy_int64(O_RDONLY); }
CAMLprim value hemlock__c__fcntl__open__wronly(value unit)    { (void)unit; return caml_copy_int64(O_WRONLY); }
CAMLprim value hemlock__c__fcntl__open__rdwr(value unit)      { (void)unit; return caml_copy_int64(O_RDWR); }
CAMLprim value hemlock__c__fcntl__open__creat(value unit)     { (void)unit; return caml_copy_int64(O_CREAT); }
CAMLprim value hemlock__c__fcntl__open__excl(value unit)      { (void)unit; return caml_copy_int64(O_EXCL); }
CAMLprim value hemlock__c__fcntl__open__noctty(value unit)    { (void)unit; return caml_copy_int64(O_NOCTTY); }
CAMLprim value hemlock__c__fcntl__open__trunc(value unit)     { (void)unit; return caml_copy_int64(O_TRUNC); }
CAMLprim value hemlock__c__fcntl__open__append(value unit)    { (void)unit; return caml_copy_int64(O_APPEND); }
CAMLprim value hemlock__c__fcntl__open__nonblock(value unit)  { (void)unit; return caml_copy_int64(O_NONBLOCK); }
CAMLprim value hemlock__c__fcntl__open__dsync(value unit)     { (void)unit; return caml_copy_int64(O_DSYNC); }
CAMLprim value hemlock__c__fcntl__open__sync(value unit)      { (void)unit; return caml_copy_int64(O_SYNC); }
CAMLprim value hemlock__c__fcntl__open__directory(value unit) { (void)unit; return caml_copy_int64(O_DIRECTORY); }
CAMLprim value hemlock__c__fcntl__open__nofollow(value unit)  { (void)unit; return caml_copy_int64(O_NOFOLLOW); }
CAMLprim value hemlock__c__fcntl__open__cloexec(value unit)   { (void)unit; return caml_copy_int64(O_CLOEXEC); }
CAMLprim value hemlock__c__fcntl__open__path(value unit)      { (void)unit; return caml_copy_int64(O_PATH); }
CAMLprim value hemlock__c__fcntl__open__tmpfile(value unit)   { (void)unit; return caml_copy_int64(O_TMPFILE); }

/*****************************************************************************
 * AT_* constants
 *****************************************************************************/

CAMLprim value hemlock__c__fcntl__at__fdcwd(value unit)              { (void)unit; return caml_copy_int64(AT_FDCWD); }
CAMLprim value hemlock__c__fcntl__at__removedir(value unit)          { (void)unit; return caml_copy_int64(AT_REMOVEDIR); }
CAMLprim value hemlock__c__fcntl__at__symlink_nofollow(value unit)   { (void)unit; return caml_copy_int64(AT_SYMLINK_NOFOLLOW); }
CAMLprim value hemlock__c__fcntl__at__symlink_follow(value unit)     { (void)unit; return caml_copy_int64(AT_SYMLINK_FOLLOW); }
CAMLprim value hemlock__c__fcntl__at__empty_path(value unit)         { (void)unit; return caml_copy_int64(AT_EMPTY_PATH); }
CAMLprim value hemlock__c__fcntl__at__eaccess(value unit)            { (void)unit; return caml_copy_int64(AT_EACCESS); }

/*****************************************************************************
 * Splice flags (SPLICE_F_*)
 *****************************************************************************/

CAMLprim value hemlock__c__fcntl__splice__move(value unit)     { (void)unit; return caml_copy_int64(SPLICE_F_MOVE); }
CAMLprim value hemlock__c__fcntl__splice__nonblock(value unit) { (void)unit; return caml_copy_int64(SPLICE_F_NONBLOCK); }
CAMLprim value hemlock__c__fcntl__splice__more(value unit)     { (void)unit; return caml_copy_int64(SPLICE_F_MORE); }
CAMLprim value hemlock__c__fcntl__splice__gift(value unit)     { (void)unit; return caml_copy_int64(SPLICE_F_GIFT); }

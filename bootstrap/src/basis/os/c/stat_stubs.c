#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <sys/stat.h>

/*****************************************************************************
 * File mode bits (S_I*)
 *****************************************************************************/

CAMLprim value hemlock__c__stat__mode__irusr(value unit) { (void)unit; return caml_copy_int64(S_IRUSR); }
CAMLprim value hemlock__c__stat__mode__iwusr(value unit) { (void)unit; return caml_copy_int64(S_IWUSR); }
CAMLprim value hemlock__c__stat__mode__ixusr(value unit) { (void)unit; return caml_copy_int64(S_IXUSR); }
CAMLprim value hemlock__c__stat__mode__irwxu(value unit) { (void)unit; return caml_copy_int64(S_IRWXU); }
CAMLprim value hemlock__c__stat__mode__irgrp(value unit) { (void)unit; return caml_copy_int64(S_IRGRP); }
CAMLprim value hemlock__c__stat__mode__iwgrp(value unit) { (void)unit; return caml_copy_int64(S_IWGRP); }
CAMLprim value hemlock__c__stat__mode__ixgrp(value unit) { (void)unit; return caml_copy_int64(S_IXGRP); }
CAMLprim value hemlock__c__stat__mode__irwxg(value unit) { (void)unit; return caml_copy_int64(S_IRWXG); }
CAMLprim value hemlock__c__stat__mode__iroth(value unit) { (void)unit; return caml_copy_int64(S_IROTH); }
CAMLprim value hemlock__c__stat__mode__iwoth(value unit) { (void)unit; return caml_copy_int64(S_IWOTH); }
CAMLprim value hemlock__c__stat__mode__ixoth(value unit) { (void)unit; return caml_copy_int64(S_IXOTH); }
CAMLprim value hemlock__c__stat__mode__irwxo(value unit) { (void)unit; return caml_copy_int64(S_IRWXO); }
CAMLprim value hemlock__c__stat__mode__isuid(value unit) { (void)unit; return caml_copy_int64(S_ISUID); }
CAMLprim value hemlock__c__stat__mode__isgid(value unit) { (void)unit; return caml_copy_int64(S_ISGID); }
CAMLprim value hemlock__c__stat__mode__isvtx(value unit) { (void)unit; return caml_copy_int64(S_ISVTX); }

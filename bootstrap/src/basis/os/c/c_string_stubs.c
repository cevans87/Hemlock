#define _GNU_SOURCE
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <string.h>

CAMLprim value hemlock__c__string__strerror(value v_errno) {
    return caml_copy_string(strerror(Int_val(v_errno)));
}

CAMLprim value hemlock__c__string__strerrorname_np(value v_errno) {
    const char *s = strerrorname_np(Int_val(v_errno));
    return caml_copy_string(s ? s : "unknown");
}

CAMLprim value hemlock__c__string__strerrordesc_np(value v_errno) {
    const char *s = strerrordesc_np(Int_val(v_errno));
    return caml_copy_string(s ? s : "unknown");
}

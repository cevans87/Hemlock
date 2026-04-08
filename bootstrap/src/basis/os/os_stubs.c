#define CAML_NAME_SPACE
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>

#include <errno.h>
#include <sys/stat.h>

/* hemlock_os_mkdirat: sint -> string -> sint -> C.Errno.t option
 *
 * Returns Val_int(0) for None (success), or Some(errno) for failure.
 */
CAMLprim value
hemlock_os_mkdirat(value a_dirfd, value a_pathname, value a_mode) {
    CAMLparam3(a_dirfd, a_pathname, a_mode);
    CAMLlocal1(v_some);
    int dirfd = (int)Int64_val(a_dirfd);
    const char *pathname = String_val(a_pathname);
    mode_t mode = (mode_t)Int64_val(a_mode);

    if (mkdirat(dirfd, pathname, mode) != 0) {
        v_some = caml_alloc(1, 0);
        Store_field(v_some, 0, Val_int(errno));
        CAMLreturn(v_some);
    }

    CAMLreturn(Val_int(0)); /* None */
}

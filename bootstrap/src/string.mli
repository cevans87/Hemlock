(** UTF-8-encoded immutable {!type:string}.

    A {!type:string} is an immutable {!type:byte} sequence that is restricted to
    contain a well-formed concatenation of UTF-8-encoded {!type:codepoint}
    values.  Indexed {!type:byte} access is O(1), but indexed {!type:codepoint}
    access is O(n).  The {!String.Cursor} module provides {!type:codepoint}
    access without tracking {!type:codepoint} index; for atypical cases that
    actually require {!type:codepoint} indexing, use the {!String.Cursori}
    module instead.

    The {!String.Slice} module provides an API similar to that of the {!String}
    module, but it applies to a narrowed view -- {!type:slice} -- of the
    containing {!type:string}.  Slices avoid copying, which makes them both
    convenient and efficient.
*)

open Rudiments

type t = string

include Identifiable_intf.S with type t := t
include Stringable_intf.S with type t := t

(** Cursor that supports O(1) arbitrary access to codepoints, given byte
    index.  The codepoint index is not tracked. *)
module Cursor : sig
  type outer = t

  type t
  include Identifiable_intf.S with type t := t
  include Cursor_intf.S_mono with type container := outer
                              and type elm := codepoint
                              and type t := t

  val index: t -> usize [@@ocaml.deprecated "Use bindex instead"]
  (** @deprecated Use {!bindex} instead.
      @raise halt Not implemented. *)

  val bindex: t -> usize
  (** Return current {!type:byte} index. *)

  val cindex: t -> usize [@@ocaml.deprecated "Do not use; O(n)"]
  (** @deprecated Use {!Cursori.cindex} instead.
      @raise halt Not implemented. *)

  val at: outer -> bindex:usize -> t
  (** Return {!type:Cursor.t} at [bindex], or halt if not at {!type:codepoint}
      boundary. *)

  val near: outer -> bindex:usize -> t
  (** Return {!type:Cursor.t} at or before [bindex]. *)
end

(** Cursor that tracks codepoint index.  Arbitrary codepoint access via [at] is
    O(n), unlike [Cursor.at].  Prefer [Cursor] unless {!type:codepoint} index is
    needed. *)
module Cursori : sig
  type outer = t

  type t
  include Identifiable_intf.S with type t := t
  include Cursor_intf.S_mono with type container := outer
                              and type elm := codepoint
                              and type t := t

  val index: t -> usize [@@ocaml.deprecated "Use [bc]index instead"]
  (** @deprecated Use {!bindex} or {!cindex} instead.
      @raise halt Not implemented. *)

  val bindex: t -> usize
  (** Return current {!type:byte} index. *)

  val cindex: t -> usize
  (** Return Current {!type:codepoint} index. *)

  val cursor: t -> Cursor.t
  (** Return encapsulated {!type:Cursor.t}. *)

  val at: outer -> cindex:usize -> t
  (** Return {!type:Cursori.t} at {!type:codepoint} index [cindex]. *)
end

type slice
module Slice : sig
  type outer = t
  type t = slice
  include Identifiable_intf.S with type t := t

  val of_cursors: base:Cursor.t -> past:Cursor.t -> t
  (** [of_cursors ~base ~past] creates a slice with contents \[[base .. past)].
      *)

  val to_cursors: t -> Cursor.t * Cursor.t
  (** Return the cursors comprising the slice. *)

  val string: t -> outer
  (** [string t] returns the unsliced string underlying [t]. *)

  val base: t -> Cursor.t
  (** Return the cursor at the base of the slice. *)

  val past: t -> Cursor.t
  (** Return the cursor past the end of the slice. *)

  val of_string: outer -> t
  (** [of_string s] returns a slice enclosing the entirety of [s]. *)

  val to_string: t -> outer
  (** Return a string with contents equivalent to those of the slice. *)

  val base_seek: t -> isize -> t
  (** [base_seek t i] returns a derivative slice with its [base] cursor
      initialized by seeking [t]'s [base] cursor [i] codepoints
      forward/backward. *)

  val base_succ: t -> t
  (** [base_succ t] returns a derivative slice with its [base] cursor
      initialized to the successor of [t]'s [base] cursor. *)

  val base_pred: t -> t
  (** [base_pred t] returns a derivative slice with its [base] cursor
      initialized to the predecessor of [t]'s [base] cursor. *)

  val past_seek: t -> isize -> t
  (** [past_seek t i] returns a derivative slice with its [past] cursor
      initialized by seeking [t]'s [past] cursor [i] codepoints
      forward/backward. *)

  val past_succ: t -> t
  (** [past_succ t] returns a derivative slice with its [past] cursor
      initialized to the successor of [t]'s [past] cursor. *)

  val past_pred: t -> t
  (** [past_pred t] returns a derivative slice with its [past] cursor
      initialized to the predecessor of [t]'s [past] cursor. *)

  val blength: t -> usize
  (** Length of the slice in bytes. *)

  val clength: t -> usize
  (** Length of the slice in codepoints.  O(n) time complexity. *)

  val get: t -> usize -> byte
  (** [get t i] returns the bytes at offset [i] from the [base] of the slice. *)

  val init: ?blength:usize -> usize -> f:(usize -> codepoint) -> t
  (** [init ~blength clength ~f] creates a slice of given byte length and
      codepoint length using ~f to determine the values of the codepoints at
      each index.  [blength] must be accurate if specified. *)

  val of_codepoint: codepoint -> t
  (** Create a slice containing a single codepoint. *)

  val of_list: ?blength:usize -> ?clength:usize -> codepoint list -> t
  (** [of_list ~blength ~clength codepoints] creates a slice of given byte
      length and codepoint length containing the ordered [codepoints].
      [blength]/[clength] must be accurate if specified. *)

  val of_list_rev: ?blength:usize -> ?clength:usize -> codepoint list -> t
  (** [of_list_rev ~blength ~clength codepoints] creates a slice of given byte
      length and codepoint length containing the reverse-ordered [codepoints].
      [blength]/[clength] must be accurate if specified. *)

  (* In Container_intf.S_mono: val to_list: t -> codepoint list *)
  (* In Container_intf.S_mono: val to_list_rev: t -> codepoint list *)

  val of_array: ?blength:usize -> codepoint array -> t
  (** [of_array ~blength codepoints] creates a slice of given byte length
      containing the ordered [codepoints].  [blength] must be accurate if
      specified. *)

  (* In Container_intf.S_mono: val to_array: t -> codepoint array *)

  include Container_intf.S_mono with type t := t and type elm := codepoint

  val length: t -> usize [@@ocaml.deprecated "Use blength instead"]
  (** Use {!blength} instead of [length], to keep the difference between byte
      length and codepoint length explicit. *)

  val map: t -> f:(codepoint -> codepoint) -> t
  (** [map t ~f] creates a slice with codepoints mapped from [t]'s codepoints.
      *)

  val mapi: t -> f:(usize -> codepoint -> codepoint) -> t
  (** [map t ~f] creates a slice with codepoints mapped from [t]'s codepoints.
      Codepoint index within [t] is provided to [f]. *)

  val tr: target:codepoint -> replacement:codepoint -> t -> t
  (** [tr ~target ~replacement t] creates a slice with select codepoints
      translated from [t]'s codepoints.  [target] is translated to
      [replacement]; all other codepoints are copied without translation. *)

  val filter: t -> f:(codepoint -> bool) -> t
  (** [filter t ~f] creates a slice from [t]'s codepoints filtered by [f].  Only
      codepoints for which [f] returns [true] are incorporated into the result.
      *)

  val concat: ?sep:t -> t list -> t
  (** [concat ~sep slices] creates a slice comprised of the concatenation of the
      [slices] list, with [sep] interposed between the inputs. *)

  val concat_rev: ?sep:t -> t list -> t
  (** [concat_rev ~sep slices] creates a slice comprised of the concatenation of
      reversed [slices] list, with [sep] interposed between the inputs. *)

  val concat_map: ?sep:t -> t -> f:(codepoint -> t) -> t
  (** [concat_map ~sep t ~f] creates a slice which is the concatenation of
      applying [f] to convert each codepoint to a slice.  This is more general
      (and more expensive) than {!map}, because each input codepoint can be
      mapped to any length of output. *)

  val escaped: t -> t
  (** Convert all unprintable or special ASCII characters to their
      backslash-escaped forms, such that the result represents a syntactically
      valid source code string. *)

  val rev: t -> t
  (** [rev t] creates a slice with the codepoint ordering reversed relative to
      [t]. *)

  val lfind: t -> codepoint -> Cursor.t option
  (** [lfind t cp] returns a cursor to the leftmost instance of [cp] in [t], or
      [None] if [cp] is absent. *)

  val lfind_hlt: t -> codepoint -> Cursor.t
  (** [lfind_hlt t cp] returns a cursor to the leftmost instance of [cp] in [t],
      or halts if [cp] is absent. *)

  val contains: t -> codepoint -> bool
  (** [contains t cp] returns [true] if [t] contains [cp], [false] otherwise. *)

  val rfind: t -> codepoint -> Cursor.t option
  (** [rfind t cp] returns a cursor to the rightmost instance of [cp] in [t], or
      [None] if [cp] is absent. *)

  val rfind_hlt: t -> codepoint -> Cursor.t
  (** [rfind_hlt t cp] returns a cursor to the rightmost instance of [cp] in
      [t], or halts if [cp] is absent. *)

(** Simple but efficient pattern matching, based on the {{:
    https://en.wikipedia.org/wiki/Knuth-Morris-Pratt_algorithm}
    Knuth-Morris-Pratt algorithm}.  Patterns are uninterpreted codepoint
    sequences.  Searches require at most a single pass over the input,
    regardless of whether finding one or more (optionally overlapping) matches.
    *)
  module Pattern : sig
    type outer = t

    type t
    (** Compiled pattern. *)

    val create: outer -> t
    (** [create s] creates a compiled pattern corresponding to [s]. *)

    val find: t -> in_:outer -> Cursor.t option
    (** [find t ~in_] returns a cursor to the leftmost match in [in_], or [None]
        if no match exists. *)

    val find_hlt: t -> in_:outer -> Cursor.t
    (** [find_hlt t ~in_] returns a cursor to the leftmost match in [in_], or
        halts if no match exists. *)

    val find_all: t -> may_overlap:bool -> in_:outer -> Cursor.t list
    (** [find_all t ~may_overlap ~in_] returns a list of cursors to the matches
        in [in_].  Non-leftmost overlapping matches are excluded if
        [may_overlap] is [false]. *)

    val replace_first: t -> in_:outer -> with_:outer -> outer
    (** [replace_first t ~in_ ~with_] returns a slice with the first match in
        [in_], if any, replaced with [with_] in the result. *)

    val replace_all: t -> in_:outer -> with_:outer -> outer
    (** [replace_all t ~in_ ~with_] returns a slice with all matches in [in_],
        if any, replaced with [with_] in the result. *)
  end

  val is_prefix: t -> prefix:t -> bool
  (** [is_prefix t ~prefix] returns true if [prefix] is a prefix of [t]. *)

  val is_suffix: t -> suffix:t -> bool
  (** [is_suffix t ~suffix] returns true if [suffix] is a suffix of [t]. *)

  val prefix: t -> usize -> t
  (** [prefix t i] returns the prefix of [t] comprising [i] codepoints. *)

  val suffix: t -> usize -> t
  (** [suffix t i] returns the suffix of [t] comprising [i] codepoints. *)

  val chop_prefix: t -> prefix:t -> t option
  (** [chop_prefix t ~prefix] returns [t] absent [prefix], or [None] if [prefix]
      is not a valid prefix of [t]. *)

  val chop_prefix_hlt: t -> prefix:t -> t
  (** [chop_prefix_hlt t ~prefix] returns [t] absent [prefix], or halts if
      [prefix] is not a valid prefix of [t]. *)

  val chop_suffix: t -> suffix:t -> t option
  (** [chop_suffix t ~suffix] returns [t] absent [suffix], or [None] if [suffix]
      is not a valid suffix of [t]. *)

  val chop_suffix_hlt: t -> suffix:t -> t
  (** [chop_suffix_hlt t ~suffix] returns [t] absent [suffix], or halts if
      [suffix] is not a valid suffix of [t]. *)

  val lstrip: ?drop:(codepoint -> bool) -> t -> t
  (** [lstrip ~drop t] returns [t] absent the prefix codepoints for which [drop]
      returns [true].  The default [drop] strips tab (['\t']), newline (['\n']),
      carriage return (['\r']), and space ([' ']). *)

  val rstrip: ?drop:(codepoint -> bool) -> t -> t
  (** [rstrip ~drop t] returns [t] absent the suffix codepoints for which [drop]
      returns [true].  The default [drop] strips tab (['\t']), newline (['\n']),
      carriage return (['\r']), and space ([' ']). *)

  val strip: ?drop:(codepoint -> bool) -> t -> t
  (** [strip ~drop t] returns [t] absent the prefix and suffix codepoints for
      which [drop] returns [true].  The default [drop] strips tab (['\t']),
      newline (['\n']), carriage return (['\r']), and space ([' ']). *)

  val split_fold_until: t -> init:'accum -> on:(codepoint -> bool)
    -> f:('accum -> slice -> 'accum * bool) -> 'accum
  (** [split_fold_until t ~init ~on ~f] splits [t] on [on] into slices, which
      [f] folds in left to right order based on initial value [init], until [f]
      returns [accum, true], or until all slices have been folded. *)

  val split_fold_right_until: t -> init:'accum -> on:(codepoint -> bool)
    -> f:(slice -> 'accum -> 'accum * bool) -> 'accum
  (** [split_fold_right_until t ~init ~on ~f] splits [t] on [on] into slices,
      which [f] folds in right to left order based on initial value [init],
      until [f] returns [accum, true], or until all slices have been folded. *)

  val split_fold: t -> init:'accum -> on:(codepoint -> bool)
    -> f:('accum -> slice -> 'accum) -> 'accum
  (** [split_fold t ~init ~on ~f] splits [t] on [on] into slices, which
      [f] folds in left to right order based on initial value [init]. *)

  val split_fold_right: t -> init:'accum -> on:(codepoint -> bool)
    -> f:(slice -> 'accum -> 'accum) -> 'accum
  (** [split_fold_right t ~init ~on ~f] splits [t] on [on] into slices, which
      [f] folds in right to left order based on initial value [init]. *)

  val lines_fold: t -> init:'accum -> f:('accum -> slice -> 'accum) -> 'accum
  (** [lines_fold t ~init ~f] splits [t] into lines separated by ["\r\n"] or
      ["\n"], which [f] folds in left to right order based on initial value
      [init]. *)

  val lines_fold_right: t -> init:'accum -> f:(slice -> 'accum -> 'accum)
    -> 'accum
  (** [lines_fold_right t ~init ~f] splits [t] into lines separated by ["\r\n"]
      or ["\n"], which [f] folds in right to left order based on initial value
      [init]. *)

  val lsplit2: t -> on:codepoint -> (t * t) option
  (** [lsplit2 t ~on] splits [t] into two slices at the leftmost codepoint for
      which [on] returns [true], or returns [None] if [on] never returns [true].
      *)

  val lsplit2_hlt: t -> on:codepoint -> t * t
  (** [lsplit2_hlt t ~on] splits [t] into two slices at the leftmost codepoint
      for which [on] returns [true], or halts if [on] never returns [true]. *)

  val rsplit2: t -> on:codepoint -> (t * t) option
  (** [rsplit2 t ~on] splits [t] into two slices at the rightmost codepoint for
      which [on] returns [true], or returns [None] if [on] never returns [true].
      *)

  val rsplit2_hlt: t -> on:codepoint -> t * t
  (** [rsplit2_hlt t ~on] splits [t] into two slices at the rightmost codepoint
      for which [on] returns [true], or halts if [on] never returns [true]. *)

  (** Slice comparison operators. *)
  module O : sig
    type nonrec t = t

    include Cmpable_intf.S_mono_infix with type t := t
  end
end

(** Functors for converting various sequences to strings. *)
module Seq : sig
  type outer = t
  module type S = sig
    type t
    val to_string: t -> outer
  end

  (** Efficiently convert a codepoint sequence with known blength to a string.
      The length function returns blength of the remaining sequence; the next
      function returns the next codepoint which is converted to bytes in
      to_string. *)
  module Codepoint : sig
    module Make (T : Seq_intf.I_mono_def with type elm := codepoint) :
      S with type t := T.t
    module Make_rev (T : Seq_intf.I_mono_def with type elm := codepoint) :
      S with type t := T.t
  end

  (** Efficiently convert a string slice sequence with known blength to a
      string.  The length function returns blength of the remaining sequence;
      the next function returns (base, past) cursors for the next string slice
      which is copied into to_string. *)
  module Slice : sig
    module Make (T : Seq_intf.I_mono_def with type elm := slice) :
      S with type t := T.t
    module Make_rev (T : Seq_intf.I_mono_def with type elm := slice) :
      S with type t := T.t
  end

  (** Efficiently convert a string sequence with known blength to a string.  The
      length function returns blength of the remaining sequence; the next
      function returns the next string which is copied into to_string. *)
  module String : sig
    module Make (T : Seq_intf.I_mono_def with type elm := string) :
      S with type t := T.t
    module Make_rev (T : Seq_intf.I_mono_def with type elm := string) :
      S with type t := T.t
  end
end

val blength: t -> usize
(** Byte length. *)

val clength: t -> usize
(** Codepoint length. *)

val get: t -> usize -> byte
(** Get byte at index. *)

val init: ?blength:usize -> usize -> f:(usize -> codepoint) -> t
(** [init ~blength clength ~f] creates a string of given byte length and
    codepoint length using ~f to determine the values of the codepoints at each
    index.  [blength] must be accurate if specified. *)

val of_codepoint: codepoint -> t
(** Create a string containing a single codepoint. *)

val of_list: ?blength:usize -> ?clength:usize -> codepoint list -> t
(** [of_list ~blength ~clength codepoints] creates a string of given byte length
    and codepoint length containing the ordered [codepoints].
    [blength]/[clength] must be accurate if specified. *)

val of_list_rev: ?blength:usize -> ?clength:usize -> codepoint list -> t
(** [of_list_rev ~blength ~clength codepoints] creates a string of given byte
    length and codepoint length containing the reverse-ordered [codepoints].
    [blength]/[clength] must be accurate if specified. *)

(* In Container_intf.S_mono: val to_list: t -> codepoint list *)
(* In Container_intf.S_mono: val to_list_rev: t -> codepoint list *)

val of_array: ?blength:usize -> codepoint array -> t
(** [of_array ~blength codepoints] creates a string of given byte length
    containing the ordered [codepoints].  [blength] must be accurate if
    specified. *)

(* In Container_intf.S_mono: val to_array: t -> codepoint array *)

include Container_intf.S_mono with type t := t and type elm := codepoint

val length: t -> usize [@@ocaml.deprecated "Use [bc]length instead"]
(** Use {!blength} instead of [length], to keep the difference between byte
    length and codepoint length explicit. *)

val map: t -> f:(codepoint -> codepoint) -> t
(** [map t ~f] creates a string with codepoints mapped from [t]'s codepoints. *)

val mapi: t -> f:(usize -> codepoint -> codepoint) -> t
(** [map t ~f] creates a string with codepoints mapped from [t]'s codepoints.
    Codepoint index within [t] is provided to [f]. *)

val tr: target:codepoint -> replacement:codepoint -> t -> t
(** [tr ~target ~replacement t] creates a string with select codepoints
    translated from [t]'s codepoints.  [target] is translated to [replacement];
    all other codepoints are copied without translation. *)

val filter: t -> f:(codepoint -> bool) -> t
(** [filter t ~f] creates a string from [t]'s codepoints filtered by [f].  Only
    codepoints for which [f] returns [true] are incorporated into the result. *)

val concat: ?sep:t -> t list -> t
  (** [concat ~sep strings] creates a string comprised of the concatenation of
      the [strings] list, with [sep] interposed between the inputs. *)

val concat_rev: ?sep:t -> t list -> t
(** [concat_rev ~sep strings] creates a string comprised of the concatenation of
    reversed [strings] list, with [sep] interposed between the inputs. *)

val concat_map: ?sep:t -> t -> f:(codepoint -> t) -> t
(** [concat_map ~sep t ~f] creates a string which is the concatenation of
    applying [f] to convert each codepoint to a string.  This is more general
    (and more expensive) than {!map}, because each input codepoint can be mapped
    to any length of output. *)

val escaped: t -> t
(** Convert all unprintable or special ASCII characters to their
    backslash-escaped forms, such that the result represents a syntactically
    valid source code string. *)

val rev: t -> t
(** [rev t] creates a string with the codepoint ordering reversed relative to
    [t]. *)

val ( ^ ): t -> t -> t
(** [s0 ^ s1] is equivalent to [concat [a; b]]. *)

val lfind: ?base:Cursor.t -> ?past:Cursor.t -> t -> codepoint
  -> Cursor.t option
(** [lfind t cp] returns a cursor to the leftmost instance of [cp] in [t], or
    [None] if [cp] is absent. *)

val lfind_hlt: ?base:Cursor.t -> ?past:Cursor.t -> t -> codepoint -> Cursor.t
(** [lfind_hlt t cp] returns a cursor to the leftmost instance of [cp] in [t],
    or halts if [cp] is absent. *)

val contains: ?base:Cursor.t -> ?past:Cursor.t -> t -> codepoint -> bool
(** [contains t cp] returns [true] if [t] contains [cp], [false] otherwise. *)

val rfind: ?base:Cursor.t -> ?past:Cursor.t -> t -> codepoint
  -> Cursor.t option
(** [rfind t cp] returns a cursor to the rightmost instance of [cp] in [t], or
    [None] if [cp] is absent. *)

val rfind_hlt: ?base:Cursor.t -> ?past:Cursor.t -> t -> codepoint -> Cursor.t
(** [rfind_hlt t cp] returns a cursor to the rightmost instance of [cp] in
    [t], or halts if [cp] is absent. *)

val substr_find: ?base:Cursor.t -> t -> pattern:t -> Cursor.t option
(** [substr_find ~base t ~pattern] returns a cursor to the leftmost [pattern]
    match past [base] in [t], or [None] if no match exists.  [base] defaults to
    the beginning of [t]. *)

val substr_find_hlt: ?base:Cursor.t -> t -> pattern:t -> Cursor.t
(** [substr_find_hlt ~base t ~pattern] returns a cursor to the leftmost
    [pattern] match past [base] in [t], or halts if no match exists.  [base]
    defaults to the beginning of [t]. *)

val substr_find_all: t -> may_overlap:bool -> pattern:t -> Cursor.t list
(** [substr_find_all t ~may_overlap ~pattern] returns a list of cursors to the
    [pattern] matches in [t].  Non-leftmost overlapping matches are excluded if
    [may_overlap] is [false]. *)

val substr_replace_first: ?base:Cursor.t -> t -> pattern:t -> with_:t -> t
(** [subst_replace_first ~base t ~pattern ~with_] returns a string with the
    first [pattern] match past [base] in [t], if any, replaced with [with_] in
    the result.  [base] defaults to the beginning of [t]. *)

val substr_replace_all: t -> pattern:t -> with_:t -> t
(** [substr_replace_all t ~pattern ~with_] returns a string with all [pattern]
    matches in [t], if any, replaced with [with_] in the result. *)

val is_prefix: t -> prefix:t -> bool
(** [is_prefix t ~prefix] returns true if [prefix] is a prefix of [t]. *)

val is_suffix: t -> suffix:t -> bool
(** [is_suffix t ~suffix] returns true if [suffix] is a suffix of [t]. *)

val pare: base:Cursor.t -> past:Cursor.t -> t
(** [pare ~base ~past] returns a string comprised of the codepoint sequence in
    [\[base .. past)]. *)

val prefix: t -> usize -> t
(** [prefix t i] returns the prefix of [t] comprising [i] codepoints. *)

val suffix: t -> usize -> t
(** [suffix t i] returns the suffix of [t] comprising [i] codepoints. *)

val chop_prefix: t -> prefix:t -> t option
(** [chop_prefix t ~prefix] returns [t] absent [prefix], or [None] if [prefix]
    is not a valid prefix of [t]. *)

val chop_prefix_hlt: t -> prefix:t -> t
(** [chop_prefix_hlt t ~prefix] returns [t] absent [prefix], or halts if
    [prefix] is not a valid prefix of [t]. *)

val chop_suffix: t -> suffix:t -> t option
(** [chop_suffix t ~suffix] returns [t] absent [suffix], or [None] if [suffix]
    is not a valid suffix of [t]. *)

val chop_suffix_hlt: t -> suffix:t -> t
(** [chop_suffix_hlt t ~suffix] returns [t] absent [suffix], or halts if
    [suffix] is not a valid suffix of [t]. *)

val lstrip: ?drop:(codepoint -> bool) -> t -> t
(** [lstrip ~drop t] returns [t] absent the prefix codepoints for which [drop]
    returns [true].  The default [drop] strips tab (['\t']), newline (['\n']),
    carriage return (['\r']), and space ([' ']). *)

val rstrip: ?drop:(codepoint -> bool) -> t -> t
(** [rstrip ~drop t] returns [t] absent the suffix codepoints for which [drop]
    returns [true].  The default [drop] strips tab (['\t']), newline (['\n']),
    carriage return (['\r']), and space ([' ']). *)

val strip: ?drop:(codepoint -> bool) -> t -> t
(** [strip ~drop t] returns [t] absent the prefix and suffix codepoints for
    which [drop] returns [true].  The default [drop] strips tab (['\t']),
    newline (['\n']), carriage return (['\r']), and space ([' ']). *)

val split: t -> f:(codepoint -> bool) -> t list
(** [split t ~f] splits [t] on codepoints for which [f] returns true, into a
    list of strings. *)

val split_rev: t -> f:(codepoint -> bool) -> t list
(** [split_rev t ~f] splits [t] on codepoints for which [f] returns true, into a
    reversed list of strings. *)

val split_lines: t -> t list
(** [split_lines t] splits [t] by ["\r\n"] or ["\n"] into a list of lines. *)

val split_lines_rev: t -> t list
(** [split_lines_rev t] splits [t] by ["\r\n"] or ["\n"] into a reversed list of
    lines. *)

val lsplit2: t -> on:codepoint -> (t * t) option
(** [lsplit2 t ~on] splits [t] into two strings at the leftmost codepoint for
    which [on] returns [true], or returns [None] if [on] never returns [true].
    *)

val lsplit2_hlt: t -> on:codepoint -> t * t
(** [lsplit2_hlt t ~on] splits [t] into two strings at the leftmost codepoint
    for which [on] returns [true], or halts if [on] never returns [true]. *)

val rsplit2: t -> on:codepoint -> (t * t) option
(** [rsplit2 t ~on] splits [t] into two strings at the rightmost codepoint for
    which [on] returns [true], or returns [None] if [on] never returns [true].
    *)

val rsplit2_hlt: t -> on:codepoint -> t * t
(** [rsplit2_hlt t ~on] splits [t] into two strings at the rightmost codepoint
    for which [on] returns [true], or halts if [on] never returns [true]. *)

(** String comparison operators. *)
module O : sig
  type nonrec t = t

  include Cmpable_intf.S_mono_infix with type t := t
end

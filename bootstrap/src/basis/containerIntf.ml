(** Container functor signatures. *)

open RudimentsInt0

(** Iterating functor input interface for monomorphic containers, e.g. {!type:string}. *)
module type IMonoIter = sig
  type t
  (** Container type. *)

  type elm
  (** Element type. *)

  module Cursor : sig
    include CursorIntf.SMonoIter
      with type container := t
      with type elm := elm
  end
end

(** Indexing functor input interface for monomorphic containers, e.g. {!type:string}. *)
module type IMonoIndex = sig
  include IMonoIter

  val length: t -> uns
  (** Container length. *)
end

(** Length-related functor output signature for monomorphic containers, e.g. {!type:string}. *)
module type SMonoLength = sig
  type t
  (** Container type. *)

  type elm
  (** Element type. *)

  val length: t -> uns
  (** [length t] returns the number of elements in [t]. *)

  val is_empty: t -> bool
  (** [is_empty t] returns [true] if [t] has no elements; [false] otherwise. *)
end

(** Folding-related functor output signature for monomorphic containers, e.g. {!type:string}.
    Operations rely on cursor iterators, which should be implemented with O(1) iteration to avoid
    e.g. O(n^2) folding overhead. *)
module type SMonoIter = sig
  type t
  (** Container type. *)

  type elm
  (** Element type. *)

  val fold_until: init:'accum -> f:('accum -> elm -> 'accum * bool) -> t -> 'accum
  (** [fold_until ~init ~f t] folds [t] from left to right, using [init] as the initial accumulator
      value, continuing until [f] returns [accum, true], or until folding is complete if [f] always
      returns [accum, false]. *)

  val fold_right_until: init:'accum -> f:(elm -> 'accum -> 'accum * bool) -> t -> 'accum
  (** [fold_right_until ~init ~f t] folds [t] from right to left, using [init] as the initial
      accumulator value, continuing until [f] returns [accum, true], or until folding is complete if
      [f] always returns [accum, false]. *)

  val foldi_until: init:'accum -> f:(uns -> 'accum -> elm -> 'accum * bool) -> t -> 'accum
  (** [foldi_until ~init ~f t] folds [t] with index provided to [f] from left to right, using [init]
      as the initial accumulator value, continuing until [f] returns [accum, true], or until folding
      is complete if [f] always returns [accum, false]. *)

  val fold: init:'accum -> f:('accum -> elm -> 'accum) -> t -> 'accum
  (** [fold ~init ~f t] folds [t] from left to right, using [init] as the initial accumulator value.
  *)

  val fold_right: init:'accum -> f:(elm -> 'accum -> 'accum) -> t -> 'accum
  (** [fold_right ~init ~f t] folds [t] from left to right, using [init] as the initial accumulator
      value. *)

  val foldi: init:'accum -> f:(uns -> 'accum -> elm -> 'accum) -> t -> 'accum
  (** [foldi ~init ~f t] folds [t] with index provided to [f] from left to right, using [init] as
      the initial accumulator value. *)

  val iter: f:(elm -> unit) -> t -> unit
  (** [iter ~f t] iterates from left to right over [t]. *)

  val iter_right: f:(elm -> unit) -> t -> unit
  (** [iter_right ~f t] iterates from right to left over [t]. *)

  val iteri: f:(uns -> elm -> unit) -> t -> unit
  (** [iteri ~f t] iterates with index provided from left to right over [t]. *)

  val count: f:(elm -> bool) -> t -> uns
  (** [count ~f t] iterates over [t] and returns the number of times [f] returns [true]. *)

  val for_any: f:(elm -> bool) -> t -> bool
  (** [for_any ~f t] iterates from left to right over [t] and returns [true] if any invocation of
      [f] returns [true]. *)

  val for_all: f:(elm -> bool) -> t -> bool
  (** [for_all ~f t] iterates from left to right over [t] and returns [true] if all invocations of
      [f] return [true]. *)

  val find: f:(elm -> bool) -> t -> elm option
  (** [find ~f t] iterates from left to right over [t] and returns [Some a] for the first element
      which [f] returns [true], or [None] if [f] always returns [false]. *)

  val find_map: f:(elm -> 'a option) -> t -> 'a option
  (** [find_map ~f t] iterates over [t] and returns [Some a] for an element which [f] returns [Some
      a], or [None] if [f] always returns [None]. *)

  val findi: f:(uns -> elm -> bool) -> t -> elm option
  (** [findi ~f t] iterates from left to right over [t] with index provided to [f] and returns [Some
      a] for an element which [f] returns [true], or [None] if [f] always returns [false]. *)

  val findi_map: f:(uns -> elm -> 'a option) -> t -> 'a option
  (** [findi_map ~f t] iterates from left to right over [t] with index provided to [f] and returns
      [Some a] for an element which [f] returns [Some a], or [None] if [f] always returns [None]. *)

  val min_elm: cmp:(elm -> elm -> Cmp.t) -> t -> elm option
  (** [min_elm ~f t] iterates from left to right over [t] and returns [Some a] for the leftmost
      element which always compares as [Cmp.Lt] or [Cmp.Eq], or [None] if [t] is empty. *)

  val max_elm: cmp:(elm -> elm -> Cmp.t) -> t -> elm option
  (** [max_elm ~f t] iterates from left to right over [t] and returns [Some a] for the leftmost
      element which always compares as [Cmp.Eq] or [Cmp.Gt], or [None] if [t] is empty. *)

  val to_list: t -> elm list
  (** [to_list t] folds [t] from right to left as a {!type:elm list}. *)

  val to_list_rev: t -> elm list
  (** [to_list_rev t] folds [t] from left to right as a {!type:elm list}. *)
end

(** Array-related functor output signature for monomorphic containers, e.g. {!type:string}. *)
module type SMonoArray = sig
  type t
  (** Container type. *)

  type elm
  (** Element type. *)

  val to_array: t -> elm array
  (** [to_array t] converts [t] to an array. *)
end

(** Monomorphic indexing container, e.g. {!type:string}. *)
module type SMonoIndex = sig
  include SMonoIter
  include SMonoLength with type t := t with type elm := elm
  include SMonoArray with type t := t with type elm := elm
end

(** Membership-related functor input interface for monomorphic containers, e.g. {!type:string}. *)
module type IMonoMem = sig
  include IMonoIter

  val cmp_elm: elm -> elm -> Cmp.t
  (** Compare two elements. *)
end

module type SMonoMem = sig
  type t
  (** Container type. *)

  type elm
  (** Element type. *)

  val mem: elm -> t -> bool
  (** [mem elm t] returns [true] if [elm] is a member of [t]; [false] otherwise. *)
end

(** Iterating functor input interface for polymorphic containers, e.g. {!type:'a list}. *)
module type IPolyIter = sig
  type 'a t
  (** Container type. *)

  type 'a elm
  (** Element type. *)

  module Cursor : sig
    include CursorIntf.SPolyIter
      with type 'a container := 'a t
      with type 'a elm := 'a elm
  end
end

(** Length-related functor output signature for polymorphic containers, e.g. {!type:'a list}. *)
module type SPolyLength = sig
  type 'a t
  (** Container type. *)

  val length: 'a t -> uns
  (** [length t] returns the number of elements in [t]. *)

  val is_empty: 'a t -> bool
  (** [is_empty t] returns [true] if [t] has no elements; [false] otherwise. *)
end

(** {!module:SPolyLengthGen} is equivalent to {!module:SPolyLength}, except that {!type:'a elm} is
    explicit. This near-identical signature exists exclusively to enable functor implementation. *)
module type SPolyLengthGen = sig
  type 'a t
  type 'a elm
  val length: 'a t -> uns
  val is_empty: 'a t -> bool
end

(** Folding-related functor output signature for polymorphic containers, e.g. {!type:'a list}.
    Operations rely on cursor iterators, which should be implemented with O(1) iteration to avoid
    e.g. O(n^2) folding overhead. *)
module type SPolyIter = sig
  type 'a t
  (** Container type. *)

  val fold_until: init:'accum -> f:('accum -> 'a -> 'accum * bool) -> 'a t -> 'accum
  (** [fold_until ~init ~f t] folds [t] from left to right, using [init] as the initial accumulator
      value, continuing until [f] returns [accum, true], or until folding is complete if [f] always
      returns [accum, false]. *)

  val fold_right_until: init:'accum -> f:('a -> 'accum -> 'accum * bool) -> 'a t -> 'accum
  (** [fold_right_until ~init ~f t] folds [t] from right to left, using [init] as the initial
      accumulator value, continuing until [f] returns [accum, true], or until folding is complete if
      [f] always returns [accum, false]. *)

  val foldi_until: init:'accum -> f:(uns -> 'accum -> 'a -> 'accum * bool) -> 'a t -> 'accum
  (** [foldi_until ~init ~f t] folds [t] with index provided to [f] from left to right, using [init]
      as the initial accumulator value, continuing until [f] returns [accum, true], or until folding
      is complete if [f] always returns [accum, false]. *)

  val fold: init:'accum -> f:('accum -> 'a -> 'accum) -> 'a t -> 'accum
  (** [fold ~init ~f t] folds [t] from left to right, using [init] as the initial accumulator value.
  *)

  val fold_right: init:'accum -> f:('a -> 'accum -> 'accum) -> 'a t -> 'accum
  (** [fold_right ~init ~f t] folds [t] from left to right, using [init] as the initial accumulator
      value. *)

  val foldi: init:'accum -> f:(uns -> 'accum -> 'a -> 'accum) -> 'a t -> 'accum
  (** [foldi ~init ~f t] folds [t] with index provided to [f] from left to right, using [init] as
      the initial accumulator value. *)

  val iter: f:('a -> unit) -> 'a t -> unit
  (** [iter ~f t] iterates from left to right over [t]. *)

  val iter_right: f:('a -> unit) -> 'a t -> unit
  (** [iter_right ~f t] iterates from right to left over [t]. *)

  val iteri: f:(uns -> 'a -> unit) -> 'a t -> unit
  (** [iteri ~f t] iterates with index provided from left to right over [t]. *)

  val count: f:('a -> bool) -> 'a t -> uns
  (** [count ~f t] iterates over [t] and returns the number of times [f] returns [true]. *)

  val for_any: f:('a -> bool) -> 'a t -> bool
  (** [for_any ~f t] iterates from left to right over [t] and returns [true] if any invocation of
      [f] returns [true]. *)

  val for_all: f:('a -> bool) -> 'a t -> bool
  (** [for_all ~f t] iterates from left to right over [t] and returns [true] if all invocations of
      [f] return [true]. *)

  val find: f:('a -> bool) -> 'a t -> 'a option
  (** [find ~f t] iterates from left to right over [t] and returns [Some a] for the first element
      which [f] returns [true], or [None] if [f] always returns [false]. *)

  val find_map: f:('a -> 'b option) -> 'a t -> 'b option
  (** [find_map ~f t] iterates over [t] and returns [Some b] for an element which [f] returns [Some
      b], or [None] if [f] always returns [None]. *)

  val findi: f:(uns -> 'a -> bool) -> 'a t -> 'a option
  (** [findi ~f t] iterates from left to right over [t] with index provided to [f] and returns [Some
      a] for an element which [f] returns [true], or [None] if [f] always returns [false]. *)

  val findi_map: f:(uns -> 'a -> 'b option) -> 'a t -> 'b option
  (** [findi_map ~f t] iterates from left to right over [t] with index provided to [f] and returns
      [Some b] for an element which [f] returns [Some b], or [None] if [f] always returns [None]. *)

  val min_elm: cmp:('a -> 'a -> Cmp.t) -> 'a t -> 'a option
  (** [min_elm ~f t] iterates from left to right over [t] and returns [Some a] for the first element
      which always compares as [Cmp.Lt] or [Cmp.Eq], or [None] if [t] is empty. *)

  val max_elm: cmp:('a -> 'a -> Cmp.t) -> 'a t -> 'a option
  (** [max_elm ~f t] iterates from left to right over [t] and returns [Some a] for the first element
      which compares as [Cmp.Eq] or [Cmp.Gt], or [None] if [t] is empty. *)

  val to_list: 'a t -> 'a list
  (** [to_list t] folds [t] from right to left as a {!type:'a list}. *)

  val to_list_rev: 'a t -> 'a list
  (** [to_list_rev t] folds [t] from left to right as a {!type:'a list}. *)
end

(** {!module:SPolyIterGen} is equivalent to {!module:SPolyIter}, except that {!type:'a elm} is
    explicit. This near-identical signature exists exclusively to enable functor implementation. *)
module type SPolyIterGen = sig
  type 'a t
  type 'a elm
  val fold_until: init:'accum -> f:('accum -> 'a elm -> 'accum * bool) -> 'a t -> 'accum
  val fold_right_until: init:'accum -> f:('a elm -> 'accum -> 'accum * bool) -> 'a t -> 'accum
  val foldi_until: init:'accum -> f:(uns -> 'accum -> 'a elm -> 'accum * bool) -> 'a t -> 'accum
  val fold: init:'accum -> f:('accum -> 'a elm -> 'accum) -> 'a t -> 'accum
  val fold_right: init:'accum -> f:('a elm -> 'accum -> 'accum) -> 'a t -> 'accum
  val foldi: init:'accum -> f:(uns -> 'accum -> 'a elm -> 'accum) -> 'a t -> 'accum
  val iter: f:('a elm -> unit) -> 'a t -> unit
  val iter_right: f:('a elm -> unit) -> 'a t -> unit
  val iteri: f:(uns -> 'a elm -> unit) -> 'a t -> unit
  val count: f:('a elm -> bool) -> 'a t -> uns
  val for_any: f:('a elm -> bool) -> 'a t -> bool
  val for_all: f:('a elm -> bool) -> 'a t -> bool
  val find: f:('a elm -> bool) -> 'a t -> 'a elm option
  val find_map: f:('a elm -> 'b option) -> 'a t -> 'b option
  val findi: f:(uns -> 'a elm -> bool) -> 'a t -> 'a elm option
  val findi_map: f:(uns -> 'a elm -> 'b option) -> 'a t -> 'b option
  val min_elm: cmp:('a elm -> 'a elm -> Cmp.t) -> 'a t -> 'a elm option
  val max_elm: cmp:('a elm -> 'a elm -> Cmp.t) -> 'a t -> 'a elm option
  val to_list: 'a t -> 'a elm list
  val to_list_rev: 'a t -> 'a elm list
end

(** Array-related functor output signature for polymorphic containers, e.g. {!type:'a list}. *)
module type SPolyArray = sig
  type 'a t
  (** Container type. *)

  val to_array: 'a t -> 'a array
  (** [to_array t] converts the elements of [t] from left to right, to an array. *)
end

(** {!module:SPolyArrayGen} is equivalent to {!module:SPolyArray}, except that {!type:'a elm} is
    explicit. This near-identical signature exists exclusively to enable functor implementation. *)
module type SPolyArrayGen = sig
  type 'a t
  type 'a elm
  val to_array: 'a t -> 'a elm array
end

(** Indexing functor input interface for polymorphic containers, e.g. {!type:'a list}. *)
module type IPolyIndex = sig
  include IPolyIter

  val length: 'a t -> uns
  (** Container length. *)
end

(** Polymorphic indexing container, e.g. {!type:'a list}. *)
module type SPolyIndex = sig
  include SPolyIter
  include SPolyLength with type 'a t := 'a t
  include SPolyArray with type 'a t := 'a t
end

(** {!module:SPolyIndexGen} is equivalent to {!module:SPolyIndex}, except that {!type:'a elm} is
    explicit. This near-identical signature exists exclusively to enable functor implementation. *)
module type SPolyIndexGen = sig
  include SPolyIterGen
  include SPolyLengthGen with type 'a t := 'a t with type 'a elm := 'a elm
  include SPolyArrayGen with type 'a t := 'a t with type 'a elm := 'a elm
end

(** Membership-related functor input interface for polymorphic iterating containers, e.g. {!type:'a
    list}. *)
module type IPolyMem = sig
  include IPolyIter

  val cmp_elm: 'a elm -> 'a elm -> Cmp.t
  (** Compare two elements. *)
end

(** Membership-related functor output signature for polymorphic containers, e.g. {!type:'a list}. *)
module type SPolyMem = sig
  type 'a t
  (** Container type. *)

  val mem: 'a -> 'a t -> bool
  (** [mem a t] returns [true] if [a] is a member of [t]; [false] otherwise. *)
end

(** {!module:SPolyMemGen} is equivalent to {!module:SPolyMem}, except that {!type:'a elm} is
    explicit. This near-identical signature exists exclusively to enable functor implementation. *)
module type SPolyMemGen = sig
  type 'a t
  type 'a elm
  val mem: 'a elm -> 'a t -> bool
end

(** Iterating functor input interface for polymorphic containers, e.g. {!type:('a, 'cmp) Ordset}. *)
module type IPoly2Iter = sig
  type ('a, 'cmp) t
  (** Container type. *)

  type 'a elm
  (** Element type. *)

  module Cursor : sig
    include CursorIntf.SPoly2Iter
      with type ('a, 'cmp) container := ('a, 'cmp) t
      with type 'a elm := 'a elm
  end
end

(** Array-related functor input interface for polymorphic containers, e.g. {!type:('a, 'cmp)
    Ordset}. *)
module type IPoly2Index = sig
  include IPoly2Iter

  val length: ('a, 'cmp) t -> uns
  (** Container length. *)
end

(** Array-related functor output signature for polymorphic containers, e.g. {!type:('a, 'cmp)
    Ordset}. *)
module type SPoly2Index = sig
  type ('a, 'cmp) t
  (** Container type. *)

  val to_array: ('a, 'cmp) t -> 'a array
  (** [to_array t] converts the elements of [t] from left to right, to an array. *)
end

(** {!module:SPoly2ArrayGen} is equivalent to {!module:SPoly2Array}, except that {!type:'a elm} is
    explicit. This near-identical signature exists exclusively to enable functor implementation. *)
module type SPoly2IndexGen = sig
  type ('a, 'cmp) t
  type 'a elm
  val to_array: ('a, 'cmp) t -> 'a elm array
end

(** Iterating functor input interface for polymorphic containers, e.g. {!type:('k, 'v, 'cmp)
    Ordmap}. *)
module type IPoly3Iter = sig
  type ('k, 'v, 'cmp) t
  (** Container type. *)

  type 'k key
  (** Key type. *)

  type 'v value
  (** Value type. *)

  module Cursor : sig
    include CursorIntf.SPoly3Iter
      with type ('k, 'v, 'cmp) container := ('k, 'v, 'cmp) t
      with type 'k key := 'k key
      with type 'v value := 'v value
  end
end

(** Indexing functor input interface for polymorphic containers, e.g. {!type:('k, 'v, 'cmp) Ordmap}.
*)
module type IPoly3Index = sig
  include IPoly3Iter

  val length: ('k, 'v, 'cmp) t -> uns
  (** Container length. *)
end

(** Indexing functor output signature for polymorphic containers, e.g. {!type:('k, 'v, 'cmp)
    Ordmap}. *)
module type SPoly3Index = sig
  type ('k, 'v, 'cmp) t
  (** Container type. *)

  val to_array: ('k, 'v, 'cmp) t -> ('k * 'v) array
  (** [to_array t] converts the elements of [t] from left to right, to an array. *)
end

(** {!module:SPoly3IndexGen} is equivalent to {!module:SPoly3Index}, except that {!type:'k key} and
    {!type:'v value} are explicit. This near-identical signature exists exclusively to enable
    functor implementation. *)
module type SPoly3IndexGen = sig
  type ('k, 'v, 'cmp) t
  type 'k key
  type 'v value
  val to_array: ('k, 'v, 'cmp) t -> ('k key * 'v value) array
end

open Rudiments0

module type S_mono_fwd = sig
  type container
  type cursor
  type elm
  type t

  val of_cursors: base:cursor -> past:cursor -> t

  val to_cursors: t -> cursor * cursor

  val container: t -> container

  val base: t -> cursor

  val past: t -> cursor

  val of_container: container -> t

  val to_container: t -> container

  val base_seek_fwd: uns -> t -> t

  val base_succ: t -> t

  val past_seek_fwd: uns -> t -> t

  val past_succ: t -> t

  val get: uns -> t -> elm
end

module type S_mono = sig
  include S_mono_fwd

  val base_seek: sint -> t -> t

  val base_pred: t -> t

  val past_seek: sint -> t -> t

  val past_pred: t -> t

  val get: uns -> t -> elm
end

module type S_poly = sig
  type 'a container
  type 'a cursor
  type 'a elm
  type 'a t

  val of_cursors: base:'a cursor -> past:'a cursor -> 'a t

  val to_cursors: 'a t -> 'a cursor * 'a cursor

  val container: 'a t -> 'a container

  val base: 'a t -> 'a cursor

  val past: 'a t -> 'a cursor

  val of_container: 'a container -> 'a t

  val to_container: 'a t -> 'a container

  val base_seek: sint -> 'a t -> 'a t

  val base_succ: 'a t -> 'a t

  val base_pred: 'a t -> 'a t

  val past_seek: sint -> 'a t -> 'a t

  val past_succ: 'a t -> 'a t

  val past_pred: 'a t -> 'a t

  val get: uns -> 'a t -> 'a elm
end
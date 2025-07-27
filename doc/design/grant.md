# Signatures

Signatures are much like Ocaml signatures. The following signature is valid in both languages.

```ocaml
sig foo: a -> b -> c -> d
```

The above function can then be called.

```ocaml
m: a
n: b
o: c
let p = foo m n o
```
## Parameters

Parameters Are similar 

# Morphisms
## (`->`) Pure
## (`~>`) Effectful
## (`-*a/b>`) Pure, with specific overrides
## (`~+c-d>`) Effectful, with specific overrides
# Effects
## (`+`) Modified
## (`-`) Unmodified
## (`&`) Aliased
## (`*`) Captured
## (`/`) Released



Hemlock also supports the sigils `+-&*/` in function signatures before each parameter to convey side effects on the input.

```ocaml
sig foo: @h:Halt.g -> @g:`g -> /a ~> &b -> c:+c -+c> d  ~+h> e
(*       1            2     3  4  5  6  7  8    9    10 11      12 *)
```

Getting a grant.
```ocaml
sig narrow_of_g: @g:&`g ~> unit -> g

sig g_of_unit: @g:`g ~> unit -> g
sig g_of_g: `g -> g
```

The parts of the above signature specify the following.
1.

This signature specifies the following.
1. `/a` indicates the impore morphism will release (`/`) all references to the input (`a`).
2. The impure morpism causes all the effects specified-

- Note that the immediately-following morphism is impure.
- `&b
-
-
# (`grant`) Grants

## `iota`

```ocaml
grant g: iota
```

## Basics

Grants are a basic type in Hemlock.
The have similar traits to `unit`, `set` and sum types.
Like the `unit` type, a `grant` do not represent data at runtime.
Like a set, `grant`s can created as unions, intersections, subtractions, and additions of other `grant`s.
Like sum types, grants can be matched against their elements.
Unlike the `unit`, `grant`s do represent relationships to other `grant`s at compile time.

The unique items held by the grants are `iota`s.

### `iota`

An `iota` is instantiated via `()`. Every `iota` is distinct.

```ocaml
val foo: iota
let foo = ()

assert (foo != ())
```

This is different than `unit`, which is is represented by `()`. There is only one `unit`.

```ocaml
val bar: unit
let bar = ()
assert (bar = ())
```

In the absense of context, `()` is a `unit`.

### `grant`s containing `grant`s

Grants may contain other grants.

```ocaml
mod Syscall:
    mod Open:
    	iota i
    mod Read:
    	iota i
    mod Write:
    	iota i
    mod Close:
    	iota i

    grant g: Open.i | Read.i | Write.i | Close.i
```

Matching rules treat grants as a flat set of all contained grants.

```ocaml
let rec enforce `z =
    match `z with
      | Open.g(_) | Read.g(_) | Write.g(_) | Close.g(_)  | _ -> ()
      | _ -> halt "{`g} is not sufficent for {g}."
```

Often, a given `grant` is sufficient to fulfil another grant, but the function requires a monomorphic
`grant` input.
In this case, a similar function to the one above is useful to provide the correct grant.
```ocaml
grant g
sig narrow: *`z -> g
let narrow `z =
    match `z with
      | g(g) | _ -> g
      | _ -> halt "{`z} is not sufficent for {g}."
```

Similarly, polymorphic grants may enable different features based on the input.

```ocaml

sig my_function: `z -> +t -> unit
val my_function `z t =
    match `z with
      | Log.g(g) | _ -> Log.info "logging is enabled on this function."
      | _ -> ()
    do_something_with_t 'z t
    ()

```

## Grants in signatures

A grant looks like any other user-specified type in a function signature.

```ocaml

grant g: iota
sig id: *g -> g
sig of_g g -> g
```

The implementation would look as follows.

```ocaml
g = ()
let id g = g
let of_g g = ()
```

Some morphisms require a `grant` to execute.

_granted_ the ability do any operation associated with the grant.
Any usage of the grant must be reported.

## Affects at compile time
## Affects At import time

### At run time

### Narrowing



Grants are a basic type in Hemlock.
They propagate additional information through the type system, enabling Hemlock work stealing.

```ocaml


mod Actor:
    mod Heap:
        grant g: iota
    mod Mailbox:
        grant g: iota

    (* Having all the component grants is suffucient to g. *)
    grant g: Heap.g | Mailbox.g

    (* A `g` can be copied. There is no aliasing between the input and output. *)
    sig of_g: g -> g

    (* If you have a grant sufficient for `g`, you can narrow it. The `\`z` is aliased in `g`. *)
    sig of_z: &`z -> g


module Server:
    grant g: iota | Host.g

    g: g

    sig of_g g -> g

    let of_g g =
        () | Host.(of_g g.host)

module Client:

module Host:
    grant g =
      ()
      | Cpu.g
      | Hdd.g
      | Nic.g
      | Usb.g
```
# Narrowing a grant with subset destructuring


```ocaml

sig narrow_of_z: *`z ~> g
let narrow_of_z `z =
    match `z with
      | g(g) | _ -> () | g
      | _ -> halt "Given grant {`z} is not sufficient to for {g}."
```

The type system requires that the specific grant match exactly.



# Parametric grants

# Crazy ideas
## Automatic Memoization

Every morphism that is purely a function of its inputs

## Compile-time optimizations
###

```ocaml

module Fd =
    type t
    grant g: iota | Actor.g

    grant g = () | Actor.(of_unit ())

    of_g: g -> g

    let of_unit ~g
   
    type buf = Buf.t
    type fd = Fd.t

    sig open: ~g: g
      -> flags
      -> mode
      -> path
      -*+g> (t, Error.t) result

    external linux_read: flags -> mode -> path -+Os.Linux.Fd.m> t = "hemlock__os__linux__read"
    external mac_os_read: flags -> mode -> path -+Os.Linux.Fd.m> t = "hemlock__os__mac_os__read"

    let open ~g flags mode path =
	let t = match g
	    | Os.Linux.Fd.g | g -> linux_read flags mode path
	    | Os.MacOs.Fd.g | g -> mac_os_read (flags | {SOME_SILLY_MAC_OS_FLAG}) mode path
        let _ = match Grant.(trace <= grant)
            | true -> Trace.write "Tracing is statically enabled in this function."
            | false -> ()
        t



    sig read: ~g=g
      -> buf
      -> +t
      -+> unit

    sig write: ~f=Fd.f
      -> Buf.t
      -> !t
      -!f> unit

```ocaml
sig logged_write: ~e=Os.e/ -/> Io.buf? -e!> void

let logged_write ~e buf t =
    let _ = conceal Debug.Trace.e!
    	Debug.Trace.info
    Socket.write socket

```

# A basic typed, effected,

Os.e
Ubuntu.e
MacOs.e

# Pros and cons

## Pros

- Effects use the exact same laws as types in our type system.
- It makes it possible (and easy, we claim) to express extremely complex effects in a easy-to-debug manner.
- Creating effects is exactly as easy as

## Cons

- Code astronaughts could model the whole external world with effects.
- Syntax of creating effectful module

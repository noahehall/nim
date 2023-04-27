## runtime memory operations
## =========================


##[
## TLDR
- continues where userDefinedTypes.nim and asyncPar.nim ends
- stack types
  - arent garbage collected
  - are immutable, always passed by value
- heap types
  - are garbage collected
  - need to be initialized before used
  - are mutable, the ref always points to the same memory location
- declaring variables as var
  - give value types heap semantics
  - if declared globally (module scoped) are stored in the executables data section (not the stack)

links
-----
- [atomics](https://github.com/nim-lang/Nim/blob/devel/lib/pure/concurrency/atomics.nim)
- [lifetime-tracking hooks](https://nim-lang.org/docs/destructors.html#lifetimeminustracking-hooks)
- [gc common](https://github.com/nim-lang/Nim/blob/devel/lib/system/gc_common.nim)
- [ref and pointer types](https://nim-lang.org/docs/manual.html#types-reference-and-pointer-types)

TODOs
-----
- [] is the dereferencing sign
  - [see elegantbeefs response here](https://forum.nim-lang.org/t/10111)
- reference all the ptr/ref/locks stuff in here
- add a test file
- hmm

## garbage collector safety

- each thread
  - has an isolated memory heap; no sharing occurs
    - prevents race conditions and improves efficiency
  - has its own garbage collector
    - threads dont wait on other threads for the GC like in other languages
- spawned procedures cannot safely handle var parameters
- race conditions: when 2/more threads read/write to a heap type at the same time
  - using {.thread.} guards against this as the compiler will throw
  - passing data through channels guards against this
  - sharing heap types requires manual memory management procedures


## unsafe Nim features
- unsafe: i.e. you have to manage memory yourself, e.g. pointers & bit casts
- generally required when directly consuming foreign functions outside of a wrapper
  - a wrapper would manage the memory for you

## effective memory utilization
- its all about knowing when to mutate, and not
- memory waste (i.e. slow programs) in nim often the result of over allocation and deallocation
  - i.e. creating too many vars to store ephemeral/short-lived data
- using var to pass by reference is more efficient than passing stack values
  - particularly important in loops/procs, when allocating new vars to store strings/ints/etc
- `.setLen` to reset loop counters > over reassigning to 0 reuses existing memory
- when dealing with parallel programs
  - try to find the right size chunk/fragment of data to slice and send to each thread

## ref synchronization across threads
- ensures shared resources are consumed synchronously to prevent race conditions

locks and guards
----------------
- lock: limits access to a single var by preventing r/w while another thread has acquired it
- guard: assigning a var to a lock forces the compiler to route all r/w through the lock
- useful when mutating global variables, or sharing many distinct resources between many threads

channels
--------
- FIFO message passing between threads
- useful when locks & guards are overkill

## types

stack (value) types
-------------------
- array
- float
- int
- object
- set (system)

heap (ref) types
----------------
- addr
- ptr/pointer untraced refs pointing to manually allocated objects, required for low-level ops
- ref point to garbage-collected heap objects
- seq
- sets (hashSets)
- sink
- string
- unsafeAddr

procs
-----
- alloc
- dealloc
- allocShared memory for a heap variable to pass between threads
- [] must be empty to deReferenceThisVar[]
- addr returns the untraced address of an objec

pragmas
-------
- gcsafe
- guard attachs a lock to a var, compiler ensures lock is acquired before r/w attempted

errors/warnings/hints
---------------------
- GC-Safe error: accessing/mutating/assigning a heap-type variable owned by another thread
- Performance hint:
  - using immutable procs on vars that introduce an implicit copy, e.g. seqVar & @[1,2]
]##

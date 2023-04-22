## runtime memory operations
## =========================


##[
## TLDR
- continue where userDefinedTypes.nim and asyncPar.nim ends
  - but focus on dealing with objects in memory
- stack types
  - arent garbage collected
  - are immutable, always passed by value
- heap types
  - are garbage collected
  - need to be initialized before used
  - are mutable, the ref always points to the same memory location

links
-----
- [atomics](https://github.com/nim-lang/Nim/blob/devel/lib/pure/concurrency/atomics.nim)
- [lifetime-tracking hooks](https://nim-lang.org/docs/destructors.html#lifetimeminustracking-hooks)
- [gc common](https://github.com/nim-lang/Nim/blob/devel/lib/system/gc_common.nim)

todos
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
- ptr/pointer
- ref
- seq
- sets (hashSets)
- sink
- string
- unsafeAddr

procs
-----
- alloc
- dealloc

pragmas
-------
- gcsafe

errors/warnings
---------------
- GC-Safe error: accessing/mutating/assigning a variable owned by another thread

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
]##

## runtime memory operations
## =========================


##[
## TLDR
- come back later
  - this should continue where userDefinedTypes.nim ends
  - ^ but focus on dealing with objects in memory
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

## unsafe Nim features
- unsafe: i.e. you have to manage memory yourself, e.g. pointers & bit casts
- generally required when directly consuming foreign functions outside of a wrapper
  - a wrapper would manage the memory for you
]##

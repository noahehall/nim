##
## runtime memory operations
## =========================


##[
## TLDR
- stack types arent garbage collected, only heap types
- heap types also need to be initialized before used

links
-----
- [atomics](https://github.com/nim-lang/Nim/blob/devel/lib/pure/concurrency/atomics.nim)

todos
-----
- [] is the dereferencing sign
  - [see elegantbeefs response here](https://forum.nim-lang.org/t/10111)
- reference all the ptr/ref/locks stuff in here
- add a test file

## types

stack (value) types
-------------------
- array
- float
- int
- set (system)

heap (ref) types
----------------
- string
- seq
- sink
- ref
- ptr
- pointer
- addr
- unsafeAddr
- sets (hashSets)

procs
-----
- alloc
- dealloc

pragmas
-------
- gcsafe
]##

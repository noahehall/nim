##
## concurrency and parallelism (V2)
## ================================


##[
## TLDR
- continues where asyncPar.nim finishes and focuses on nim v2
- changes in v2
  - system.thread types moved to std/private/threadtypes
  - system.thread logic upgraded and moved to std/typedthreads
  - system.threads still works in v2, but you should prefer import std/typedthreads

links
-----
- [std/typedthreads](https://github.com/nim-lang/Nim/blob/devel/lib/std/typedthreads.nim)

## threads

typedthreads
------------
- introduced in v2 ? seems to just be the system.threads module (which was deleted?)


]##

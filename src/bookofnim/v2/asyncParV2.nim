##
## concurrency and parallelism (V2)
## ================================


##[
## TLDR
- continues where asyncPar.nim finishes and focuses on nim v2
- changes in v2
  - system.thread types moved to std/private/threadtypes
  - system.thread logic upgraded and moved to std/typedthreads
  - system.threads still works in v2, but you should prefer std/typedthreads

links
-----
- [std/typedthreads](https://github.com/nim-lang/Nim/blob/devel/lib/std/typedthreads.nim)

## threads

typedthreads procs
------------
- running true if thread is executing
- handle of thread
- joinThreads back to main thread
- joinThread back to main thread
- destroyThread is a potentially dangerous action
- createThread and start execution
- pinThread to a cpu & set its affinity
-

]##

{.push warning[UnusedImport]:off .}


import std/typedthreads

echo "typedthreads!"

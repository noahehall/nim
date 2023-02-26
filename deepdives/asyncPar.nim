##
## concurrency and parallelism
## ===========================
## [bookmark](https://nim-lang.org/docs/channels_builtin.html#example)
# https://nim-lang.org/docs/threadpool.html
# https://nim-lang.org/docs/streams.html
# https://nim-lang.org/docs/asyncfile.html
# https://nim-lang.org/docs/asyncfutures.html
# https://nim-lang.org/docs/asyncdispatch.html
# https://nim-lang.org/docs/asyncfutures.html

##[
## TLDR
- threads, channels, actors and actions
  - actor: a specific Thread that knows how to work with data of type T
  - action: proc executed by and local to an actor
  - channel: a pipe that relays data of type T between and actions
- threads
  - require --threads:on switch
  - each thread has its own GC heap and mem sharing is restricted
    - improves efficiency and prevents race conditions
  - procs used with threads should have {.thread.} pragma
  - vars local to threads should use {.threadvar.}
  - exceptions
    - a handle exception in one thread cant affect another
    - an unhandle exception in one thread terminates the entire process
- channels
  - require --threads:on switch
  - designed for use with Threads, not Threadpool.spawn
  - cant relay cyclic data structures
  - can be passed by ptr to actions or declared in module scope

links
-----
- other
  - peter
    - [multitasking](https://peterme.net/multitasking-in-nim.html)
    - [async programming](https://peterme.net/asynchronous-programming-in-nim.html)
- system
  - [parallel & spawn intro](https://nim-lang.org/docs/manual_experimental.html#parallel-amp-spawn)
  - [threads intro](https://nim-lang.org/docs/manual.html#threads)
  - [system channels](https://nim-lang.org/docs/channels_builtin.html)
  - [system par loop iterator](https://nim-lang.org/docs/system.html#%7C%7C.i%2CS%2CT%2Cstaticstring)
  - [system threads](https://nim-lang.org/docs/threads.html)
- pkgs
  - [async dispatch](https://nim-lang.org/docs/asyncdispatch.html)
  - [async file](https://nim-lang.org/docs/asyncfile.html)
  - [async futures](https://nim-lang.org/docs/asyncfutures.html)
  - [async streams](https://nim-lang.org/docs/asyncstreams.html)
  - [lock and condition vars](https://nim-lang.org/docs/locks.html)
  - [streams](https://nim-lang.org/docs/streams.html)
  - [thread pool](https://nim-lang.org/docs/threadpool.html)
- niche
  - [co routines](https://nim-lang.org/docs/coro.html)
  - [fusion pools](https://nim-lang.github.io/fusion/src/fusion/pools.html)
  - [fusion smart pointers](https://nim-lang.github.io/fusion/src/fusion/smartptrs.html)


## locks
- locks and conition vars

lock types
----------
- Cond SysCond condition variable
- Lock SysLock whether its re-entrant/not is unspecified

lock procs
----------
- acquire the given lock
- broadcast unblocks threads blocked on the specified condition variable
- deinitCond frees resources associated with condition var
- deinitLock frees resources associated with lock
- initCond initializes a condition var
- initLock intiializes a lock
- release a lock
- signal to a condition var
- tryAcquire a given lock
- wait on the condition var

lock templates
--------------
- withLock: acquires > executes body > releases

## system threads

system thread types
-------------------
- Thread[T] object

system thread procs
-------------------
- createThread of type T/void with thread fn X and data arg Y/nil
- getThreadId() of the currently thread
- handle of Thread[T]
- joinThread back to main process when finished
- joinThreads back to main process when finished
- onThreadDestruction called upon threads destruction (returns/throws)
- pinToCpu sets the affinity for a thread
## threadpool
- abstraction over lower level system thread fnality

]##

import std/[sugar, strutils, strformat, locks]

var
  bf: Thread[void] ## actor for a channel
  chizzle: Channel[string] ## a queue for string data
  gf: Thread[void] ## actor for a channel
  L: Lock
  numThreads: array[4, Thread[int]] ## actors for int data

proc threadEcho[T](x: T): void {.thread.} =
  ## action that accepts data
  ## L.acquire
  ## execute stuff
  ## L.release
  ## withLock to acquire, execute & release automatically
  L.withLock: echo fmt"i am thread {getThreadId()=} with data {x=}"

proc threadMsg: void {.thread.} =
  ## action for sending data
  ## send will deep copy its arguments
  chizzle.send("phone ring ring ring")

proc threadRec: void {.thread.} =
  ## action for consuming data
  echo fmt"ignoring; busy binging mr.robot: {chizzle.recv()=}"

echo "############################ system threads"

L.initLock

for i in numThreads.low .. numThreads.high:
  createThread(numThreads[i], threadEcho, i)
  echo fmt"created thread: {i=} {numThreads[i].running=}"
joinThreads(numThreads)

L.deinitLock

echo "############################ system channels: blocking"

open chizzle # unlimited queue size, defaults to 0
gf.createThread threadMsg ## gf actor executes threadMsg action

bf.createThread threadRec ## bf actor executes ThreadRec action
joinThreads gf, bf

echo "############################ channels: non blocking"

echo "############################ threadpool"
# import std/[threadpool]

# with spawn
# for i in ord(numThreads.low)..ord(numThreads.high):
#   spawn (i + 10).ekothis
# sync()

# with spawn
# only 2 items allowed in queue at any given time
# subsequent send calls will be blocked (use trySend to guard against this)
# open chizzle, 2
# spawn threadMsg()
# spawn threadRec()
# sync()

echo "############################ async"
# import std/[asyncdispatch]
# an async proc
# proc laterGater(s: string): Future[void] {.async.} =
#   for i in 1..10:
#     await sleepAsync(10) # ms
#     echo "iteration ", i, " for string ", s

# let
#   seeya = laterGater("see ya later aligator")
#   afterwhile = laterGater("after while crocodile")
# waitFor seeya and afterwhile
# also runForever

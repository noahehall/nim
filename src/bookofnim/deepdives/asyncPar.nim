##
## concurrency and parallelism
## ===========================
## [bookmark](https://nim-lang.org/docs/asyncstreams.html)

##[
## TLDR
- see servers.nim for async server stuff
- you generally need the following for any thread related logic
  - required: --threads:on switch
  - should use: std/locks
- its useful to think about threads and channels using the actor model
  - actor: a procedure recreated on a thread to execute some logic
    - its simpler for actors to pull/push data via a channel to/from other actors
    - else you can pass data between actors through a thread when its created
    - an actor can create additional actors/threads/channels
  - channel: the bus in which data is sent between actors
    - channels defined on the main/current thread are available to all sibling actors
    - channels not defined on the main thread must be passed to other threads by ptr via an actor
  - thread: where execution occurs on a CPU, 12-core machine has 12 concurrent execution contexts
    - only a single thread can execute at any given time per cpu, timesharing occurs otherwise
    - Thread[void]: no data is passed via thread to its actor; the actor uses a channel only
    - Thread[NotVoid]: on thread creation, instance of NotVoid is expected and provided to its actor
- 1.6.12 vs v2
  - system.threads is now std/typedthreads
  - system.threads still works in v2, but you should prefer import std/typedthreads
    - maybe you dont even need to import typedthreads, not sure of the difference
      - TODO

links
-----
- other
  - peter
    - [multitasking](https://peterme.net/multitasking-in-nim.html)
    - [async programming](https://peterme.net/asynchronous-programming-in-nim.html)
  [status-im chronos: alternative asyncdispatch](https://github.com/status-im/nim-chronos)
- system
  - [parallel & spawn intro](https://nim-lang.org/docs/manual_experimental.html#parallel-amp-spawn)
  - [system channels](https://nim-lang.org/docs/channels_builtin.html)
  - [system par loop iterator](https://nim-lang.org/docs/system.html#%7C%7C.i%2CS%2CT%2Cstaticstring)
  - [system threads](https://nim-lang.org/docs/threads.html)
  - [threads intro](https://nim-lang.org/docs/manual.html#threads)
- pkgs
  - [async dispatch (event loop)](https://nim-lang.org/docs/asyncdispatch.html)
  - [async file](https://nim-lang.org/docs/asyncfile.html)
  - [async futures](https://nim-lang.org/docs/asyncfutures.html)
  - [async streams](https://nim-lang.org/docs/asyncstreams.html)
  - [lock and condition vars](https://nim-lang.org/docs/locks.html)
  - [parallel tasks](https://nim-lang.org/docs/tasks.html)
  - [thread pool](https://nim-lang.org/docs/threadpool.html)
- niche
  - [co routines](https://nim-lang.org/docs/coro.html)
  - [fusion pools](https://nim-lang.github.io/fusion/src/fusion/pools.html)
  - [fusion smart pointers](https://nim-lang.github.io/fusion/src/fusion/smartptrs.html)

todos
-----
- [passing channels safely](https://nim-lang.org/docs/channels_builtin.html#example-passing-channels-safely)
- [multiple async backend support](https://nim-lang.org/docs/asyncdispatch.html#multiple-async-backend-support)
- [add more sophisticated asyncdispatch examples](https://nim-lang.org/docs/asyncdispatch.html)
- add more lock examples


## threads
- thread (system) can be saved to a var / proc and awaited by many callers
- spawn (threadpool): is ephemeral; a flowvar that can be awaited by a single caller
- each thread has its own GC heap and mem sharing is restricted
  - improves efficiency and prevents race conditions
- procs used with threads should have {.thread.} pragma
  - to create a thread from the proc you must use spawn/createThread
  - proc signature cant have var/ref/closure types (enforces no heap sharing restriction)
  - implies `procvar`
  - vars local to threads must use {.threadvar.}
    - implies all the effects of {.global.}
    - can be defined but not initialized: it will be replicated at thread creation
      - `var x* {.threadvar.}: string` is okay, but not `.... = "abc"`
  - exceptions
    - handled exceptions dont propagate across threads
    - unhandled exceptions terminates the entire process

thread pragmas
--------------
- thread: defines this proc as a threads' proc
- threadvar: declares this var as a threads' var

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

threadpool
----------
- implements parallel & spawn
- abstraction over lower level system threads

threadpool types
----------------
- FlowVar data flow
- FlowVarBase untyped base class for FlowVar
- ThreadId

threadpool consts
-----------------
- MaxDistinguishedThread == 32
- MaxThreadPoolSize == 256

threadpool operators
--------------------
- ^ blocks until flowvar is available, then returns its value

threadpool procs
----------------
- awaitAndThen blocks until flowvar is available, then executes action(flowVar)
- blockUntil flowvar is available
- blockUntilAny flowvars are available; if all flowvars are already awaited returns -1
- isReady true if flowvarBase value is ready; awaiting ready flowvars dont block
- parallel block to run in parallel
- pinnedSpawn always call action Y on actor X
- preferSpawn to determine if spawn/direct call is preferred; micro optimization
- setMaxPoolSize changes MaxThreadPoolSize
- setMinPoolSize from the default 4
- spawn action on a new actor; action is never invoked on the calling thread
- sync spanwed actors; i.e. joinThreads
- unsafeRead a flowvar; blocks until flowvar value is available
- spawnX action on new thread if CPU core ready; else on this thread; blocks produce; prefer spawn

typedthreads
------------
- introduced in v2 ? seems to just be the system.threads module (which was deleted?)

## channels
- designed for system.threads, unstable when used with spawn
- deeply copies non cyclic data from thread X to thread Y
- channels declared in the main thread (module scope) is simpler and shared across all threads
  - else you can declare within the body of proc thread and send the ptr to another

system channel types
--------------------
- Channel[T] for relaying messages of type T

system channel procs
--------------------
- close permenantly a channel and frees its resources
- open or update a channel with size int (0 == unlimited)
- peek at total messages in channel, -1 if channel closed, use tryRecv instead to avoid race conds
- ready true if some thread is waiting for new messages
- recv data; blocks its channel scope until delivered
- send deeply copied data; blocks its channel scope until sent
- tryRecv (bool, msg)
- trySend deeply copied data without blocking


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


## asyncdispatch
- asynchronous IO: dispatcher (event loop), future and reactor (sync-style) await
- the primary way to create and consume async programs
- dispatcher: simple event loop that buffers events to be polled (pulled) from the stack
  - linux: uses epoll
  - windows: IO Completion Ports
  - other: select
- poll: doesnt return events, but Future[event]s when they're completed with a value/error
  - always use a [reactor pattern (IMO)](https://en.wikipedia.org/wiki/Reactor_pattern) e.g.  waitFor/runForever
    - procs of type Future[T | void] require {.async.} pragma for enabling `await` in the body
      - awaited procs are suspended until and resumed once their Future arg is completed
      - the dispatcher invokes the next async proc while the current is suspended
      - vars, objects and other procs can be awaited
      - awaited Futures with unhandled exceptions are rethrown
        - yield Future; f.failed instead of try: await Future except: for increased reliability
  - alternatively (IMO not preferred) use the [proactor pattern](https://en.wikipedia.org/wiki/Proactor_pattern)
    - you can check Future.finished for success/failure and .failed specifically
    - or pass a callback
- Futures ignore {raises: []} effects
- addWrite/Read exist for adapting unix-like libraries to be async on windows; avoid if possible


asyncdispatch types
-------------------
- AsyncEvent ptr
- AsyncFD file descriptor
- Callback proc(AsyncFD)
- CompletionData object
  - fd: AsyncFD
  - cb: Callback
  - cell: ForeignCell (system)
- CustomRef
- PDispatcher ref of PDispatcherBase
  - ioPort: Handle (winlean)
  - handles: HashSet[AsyncFD]

asyncdispatch procs
-------------------
- accept new socket connection returning future client socket
- acceptAddr new socket connecting returning future (client , address)
- activeDescriptors for the current event loop (doesnt require syscall)
- addEvent registers cb to invoke upon some AsyncEvent
- addProcess registeres cb to invoke when some PID exits
- addRead starts watching AsyncFD and invokes cb when its read-ready; only useful for windows
- addTimer invokes cb after/every int milliseconds
- addWrite starts watching AsyncFD and invokes cb when its write-ready; only useful for windows
- callSoon invoke cb when control returns to the event loop
- close an AsyncEvent
- closeSocket and unregister it
- connect to socket FD at some remote addr, port and domain
- contains true if AsyncFD is registered on the current threads event loop
- createAsyncNativeSocket
- dial and connect to addr:port via some protocol (e.g. TCP for IPv4/6); tries until successful
- drain and process as many events until timeout X; errors if no events are pending
- getGlobalDispatcher
- getIoHandler for some Dispatcher; supports both win & linux
- hasPendingOperations only checks global dispatcher
- maxDescriptors of the current process (requires syscall); only for Windows, Linux, OSX, BSD
- newAsyncEvent threadsafe; not auto registered with a dispatcher
- newCustom CustomRef
- newDispatcher for this thread
- poll for X then wait to process pending events as they complete; throws ValueError if none exist
- readAll FutureStream[string] that completes when all data is consumed
- recv from socket and complete once up to/before X bytes read/socket disconnects
- recvFromInto buf of size X, datagram from socket; senders addr saved in saddr and saddrlen
- recvInto buf of size X, data from socket; completes once up to/before X bytes read/socket disconnects
- register AsyncFD with some dispatcher
- runForever the global dispatcher poll event loop
- send X bytes from buf to socket; complete once all data sent
- sendTo socket some data
- setGlobalDispatcher
- setInheritable this file descriptor by child processes; not guaranteed check with declared()
- sleepAsync for X milliseconds
- trigger AsyncEvent
- unregister AsyncEvent
- waitFor and block the current thread until Future completes
- withTimeout wait for this Future or return false if timeout expires

asyncdispatch macros
--------------------
- async converts async procedures into iterators and yield statements
- multisync converts async procs into both async & sync procs (removes await calls)

## asyncfutures
- primitives for creating and consuming futures
- all other modules build on asyncfutures and generally isnt imported directly

asyncfutures types
------------------
- Future[T] ref of FutureBase
  - value
- FutureBase ref of RootObject
  - callbacks: CallbackList
  - finished: bool
  - error: Exception
  - errorStackTrace: string
- FutureError object of Defect
  - cause: FutureBase
- FutureVar[T] distinct Future[T]


asyncfutures consts
-------------------
- isFutureLoggingEnabled

asyncFutures procs
------------------
- and returns future X when future Y and Z complete
- or returns future X when future Y or Z complete
- addCallback to execute when future X completes; accepts FutureBase[T]/Future[T]
- all returns when futures 0..X complete
- asyncCheck discards futures
- callsoon somecallback on next tick of asyncdispatcher if running, else immediately
- clean resets finished status of some future
- clearCallbacks
- complete future X with value Y
- fail future X with exception Y
- failed bool
- finished bool
- getCallSoonProc
- mget a mutable value stored in future
- newFuture of type T owned by proc X
- read the value of a finished future
- readError of a failed future
- setCallSoonproc change implementation of callsoon

## asyncfile
- asynchronous reads & writes
- unlike std/os you need to get an FD on a file first via openAsync
  - most procs require an AsyncFD and not a filename[string]

asyncfile types
---------------
- AsyncFile = ref object
  - fd: AsyncFD
  - offset: int64

asyncfile procs
---------------
- close a file
- [get | set]File[Pos | Size]
- newAsyncFile from an AsyncFD
- openAsync file X in mode Y returning AsyncFile; all other procs require an AsyncFile
- read[All | Buffer | Line | ToStream]
- write[Buffer | FromStream]
  - writeFromStream: perfect for saving streamed data to af ile without wasting memory
]##

import std/[sugar, strutils, strformat, locks]
from std/os import sleep

var
  bf: Thread[void] ## actor working as bf
  gf: Thread[void] ## actor working as gf
  L: Lock
  numThreads: array[4, Thread[int]] ## actors working with int data

proc echoAction[T](x: T): void {.thread.} =
  ## action that accepts data
  ## L.acquire
  ## execute stuff
  ## L.release
  ## withLock to acquire, execute & release automatically
  L.withLock: echo fmt"i am thread {getThreadId()=} with data {x=}"

echo "############################ system threads"

L.initLock

for i in numThreads.low .. numThreads.high:
  createThread(numThreads[i], echoAction, i)
  echo fmt"created thread: {i=} {numThreads[i].running=}"
joinThreads(numThreads)

L.deinitLock

echo "############################ system channels"

var
  relay: Channel[string] ## a queue for string data

echo "############################ system channels: blocking"

proc sendAction: void {.thread.} =
  sleep 500
  ## action for sending data
  ## blocks its channel's scope until msg delivered; deep copies its arguments
  relay.send "phone ring ring ring"

proc receiveAction: void {.thread.} =
  ## action for consuming data
  ## recv blocks its channel's scope until msg received
  echo fmt"blocking; busy binging mr.robot: {relay.recv()=}"
  echo "unblocked: until i receive data"

open relay, maxItems = 0 ## 0 = unlimited queue

gf.createThread sendAction ## gf actor plays sendAction action
bf.createThread receiveAction ## bf actor plays receiveAction action
joinThreads gf, bf

echo "############################ channels: non blocking"

proc sendActionA: void {.thread.} =
  ## action for sending data without blocking
  sleep 500
  ## deep copies its arguments
  if not relay.trySend "phone ring ring ring": echo "failed to send message"

proc receiveActionA: void {.thread.} =
  ## action for consuming data without blocking
  while true:
    let comms = relay.tryRecv()
    if comms.dataAvailable: echo fmt"non blocking: {comms.msg=}"; break
    echo "never blocked: no data!"
    sleep 400 ## before next check

gf.createThread sendActionA
bf.createThread receiveActionA
jointhreads gf, bf

echo "############################ threadpool"
import std/threadpool

for i in numThreads.low .. numThreads.high:
  ## create ephemeral actors for some action
  spawn (i + 10).echoAction
sync() ## join created actors to main thread


## adjust channel size capping at 1 message
open relay, 1

spawn sendAction()
spawn sendActionA() ## unsuccessful because total msg > channel size 1
spawn sendActionA()
spawn receiveActionA()
sync()

close relay


echo "############################ asyncdispatch "
import std/[asyncdispatch]


## getFuturesInProgress requires --define:futureLogging

proc f1 (): Future[string] {.async.} =
  ## handling exeptions the correct way
  asyncCheck sleepAsync(1) ## when you DONT care about the value/error
  let slept = sleepAsync(1) ## when you DO care about the value/error
  yield slept ## wont re raise exceptions
  if slept.failed: result = "failed to sleep"
  else: result = "slept like a vampire"

let fv1 = f1()
echo fmt"{waitFor f1()=}"
echo fmt"{waitFor fv1=}"

proc f2 (): Future[string] {.async.} =
  ## handling exceptions the wrong way
  try:
    await sleepAsync(1)
    result = "try/catch wont catch all async errors all the time"
  except:
    result = "exception was thrown"

echo fmt"{waitFor f2()=}"

proc laterGater(s: string): Future[void] {.async.} =
  for i in 1..2:
    await sleepAsync(10)
    echo "iteration ", i, " for string ", s

let
  seeya = laterGater("see ya later aligator")
  afterwhile = laterGater("after while crocodile")
waitFor seeya and afterwhile

echo "############################ asyncfutures "
import std/asyncfutures

let
  fake1 = newFuture[string]("success example") ## Future[T]
  fakeFailed = newFuture[string]("failed example") ## provide a name for debugging
  someErr = newException(ValueError, "oops")
var fake2 = newFutureVar[int]("FutureVar example") ## FutureVar[T]


## TODO: this doesnt echo
## @see https://forum.nim-lang.org/t/9946#65549
addCallback[string](
  fake1,
  cb = proc(x: Future[string]): void = echo fmt"fake1 callback: ${x.read=}")

echo fmt"before complete {fake1.finished=}"
fake1.complete "fake 1 value"
echo fmt"after complete {fake1.finished=}"
echo fmt"{fake1.read=}"

fake2.complete 1
echo fmt"complete 1 {fake2.read=}"
echo fmt"{fake2.mget=}"
fake2.clean
fake2.complete 2
echo fmt"clean -> complete {fake2.read=}"

fakeFailed.fail(someErr)
if fakeFailed.failed: echo fmt"{fakeFailed.readError.msg=}"

echo "############################ asyncfile "
import std/[asyncfile, os] ## asyncdispatch imported above

const
  afilepath = "/tmp/or/rary.txt"

try:
  afilepath.parentDir.createDir
  discard fmt"touch {afilepath}".execShellCmd
except: echo fmt"couldnt create {afilepath.parentDir}"

var
  reader = afilepath.openAsync fmRead
  writer = afilepath.openASync fmWrite


waitFor writer.write "first line in file\n"
let cursize = writer.getFileSize
echo fmt"{waitFor reader.read (int)cursize=}"
waitFor writer.write "second line in file"
echo fmt"{waitFor reader.read (int)writer.getFileSize - cursize=}"

for f in [reader,writer]: f.close

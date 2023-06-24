# blah doesnt work
# ^ @see https://github.com/nim-lang/threading/pull/31

##[
## TLDR
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
    - Thread[NotVoid]: on thread creation, instance of NotVoid is expected and passed to its actor
      - in order to pass multiple params, use something like a tuple/array/etc


## channels
- designed for system.threads, unstable when used with spawn
- deeply copies non cyclic data from thread X to thread Y
- channels declared in the main thread (module scope) is simpler and shared across all threads
  - else you can declare within the body of proc thread and send the ptr to another

channels types
--------------------
- Channel[T] for relaying messages of type T

channels procs
--------------------
- close permenantly a channel and frees its resources
- open or update a channel with size int (0 == unlimited)
- peek at total messages in channel, -1 if channel closed, use tryRecv instead to avoid race conds
- ready true if some thread is waiting for new messages
- recv data; blocks its channel scope until delivered
- send deeply copied data; blocks its channel scope until sent
- tryRecv (bool, msg)
- trySend deeply copied data without blocking


]##
import std/assertions
import threading/channels


echo "############################ channelss"

var
  relay: Channel[string] ## a queue for string data

echo "############################ channelss: blocking"

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

gf.createThread sendAction
bf.createThread receiveAction
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
joinThreads gf, bf

#[
  @see https://nim-lang.org/docs/manual_experimental.html#parallel-amp-spawn
  @see https://nim-lang.org/docs/channels_builtin.html

  thread related stuff requires --threads:on

  modules
  - threadpool: abstraction over lowerlevel system thread fnality

  best practices
  - procs used with threads should (but dont need to) have {.thread.} pragma

]#

import std/threadpool

# a fn meant for a thread
proc ekothis(i: int): void {.thread.} =
  echo "i am thread ", $i

var threads: array[10, Thread[int]]

# without threadpool
for i in threads.low..threads.high:
  createThread(threads[i], ekothis, i)
joinThreads(threads)

# with spawn
for i in ord(threads.low)..ord(threads.high):
  spawn (i + 10).ekothis
sync()

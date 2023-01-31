#[
  @see https://nim-lang.org/docs/manual_experimental.html#parallel-amp-spawn

  everything in this file requires --threads:on

  modules
  - threadpool: abstraction over lowerlevel system thread fnality

  best practices
  - procs used with threads should (but dont need to) have {.thread.} pragma

]#

import std/threadpool
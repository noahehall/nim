#[

todos
-----
.. code-block:: Nim
  # probably need a memory_mgmt.nim file
  # skipped everything in this section
  # but they look intersting
  addAndFetch doesnt have a description
  copyMem copies content from memory at source to memory at dest
  compileOption(x[, y]) check if a switch is active and/or its value at compile time
  create allocates a new memory block with atleast T.sizeof * size bytes
  createShared allocates new memory block on the shared heap with atleast T.sizeof * bytes
  createSharedU allocates new memory block on the shared heap with atleast T.sizeof * bytes
  createU allocates memory block atleast T.sizeof * bytes
  dealloc frees the memory allocated with alloc, alloc0, realloc, create or createU
  deallocHeap frees the thread local heap
  deallocShared frees the mem allocated with allocShared, allocShared0 or reallocShared
  equalMem compares size bytes of mem blocks a and b
  freeShared frees the mem allocated with createShared, createSharedU, or resizeShared
  GC_disable()
  GC_disableMarkAndSweep()
  GC_enable()
  GC_enableMarkAndSweep()
  GC_fullCollect()
  GC_getStatistics():
  getAllocStats():
  getFrame():
  getFrameState():
  isNotForeign returns true if x belongs to the calling thread
  moveMem copies content from memory at source to memory at dest
  prepareMutation string literals in ARC/ORC mode are copy on write, this must be called before mutating them
  rawEnv retrieve the raw env pointer of a closure
  rawProc retrieve the raw proc pointer of closer X
  resize a memory block
  resizeShared
  setControlCHook proc to run when program is ctrlc'ed
  sizeof blah in bytes

- [dll generation](https://nim-lang.org/docs/nimc.html#dll-generation)
- https://nim-by-example.github.io/bitsets/
- https://nim-by-example.github.io/macros/
- https://nim-lang.org/docs/atomics.html
- https://nim-lang.org/docs/bitops.html
- https://nim-lang.org/docs/cgi.html
- https://nim-lang.org/docs/colors.html
- https://nim-lang.org/docs/complex.html
- https://nim-lang.org/docs/dynlib.html
- https://nim-lang.org/docs/editdistance.html
- https://nim-lang.org/docs/encodings.html
- https://nim-lang.org/docs/endians.html
- https://nim-lang.org/docs/highlite.html
- https://nim-lang.org/docs/lexbase.html
- https://nim-lang.org/docs/locks.html
- https://nim-lang.org/docs/macrocache.html
- https://nim-lang.org/docs/macros.html
- https://nim-lang.org/docs/nimc.html#nim-for-embedded-systems
- https://nim-lang.org/docs/punycode.html
- https://nim-lang.org/docs/rlocks.html
- https://nim-lang.org/docs/rst.html
- https://nim-lang.org/docs/rstast.html
- https://nim-lang.org/docs/rstgen.html
- https://nim-lang.org/docs/tut1.html#sets-bit-fields
- https://nim-lang.org/docs/tut2.html#templates-examplecolon-lifting-procs
- https://nim-lang.org/docs/typeinfo.html
- https://nim-lang.org/docs/typetraits.html
- https://nim-lang.org/docs/volatile.html
- https://nim-lang.org/docs/segfaults.html

]#
echo "############################ REEEAAALLLY should list"
# GC_Strategy (enum) the application should use
  # gcThroughput,             ## optimize for throughput
  # gcResponsiveness,         ## optimize for responsiveness (default)
  # gcOptimizeTime,           ## optimize for speed
  # gcOptimizeSpace            ## optimize for memory footprint
# owned[T] mark a ref/ptr/closure as owned
# pointer use addr operator to get a pointer to a variable
# using statement provides syntactic convenience where the same param names & types are used over and over

echo "############################ skipped list"
# @see https://nim-lang.org/docs/system.html#7 are somewhere on this page
# AllocStats
# AtomType
# Endianness
# FileSeekPos
# ForeignCell
# lent[T]
# sink[T]
# StackTraceEntry a single entry in a stack trace
# TFrame something to do with callstacks
# TypeOfMode something to do with proc/iter invocations
# asm assembler statements enabled direct embedding of assemlber code in nim code

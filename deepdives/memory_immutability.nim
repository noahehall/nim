#[
  @see https://nimbus.guide/auditors-book/02.2.3_memory_management_gc.html
  @see https://nim-lang.org/1.6.0/gc.html
  @see https://github.com/Z3Prover/z3
  @see https://nim-lang.org/docs/drnim.html

  Stack allocated (value semantics)
    - plain objects
    - chars
    - numbers
    - pointer types (alloc)

  Heap allocated (usually ref semantics)
    - sequences (value semantics)
    - strings (value semantics)
    - ref types
    - pointer types (malloc)

  Copied on assignment
    - sequences
    - strings

  mutable
    - var (variables & parameters)
    - ref/pointer types can always be mutated through a pointer

  immutable
    - const (compile time)
    - let (runtime, cant be reassigned)
    - ref/pointer variables cant point to a new ref/pointer after

  memory allocation
    - nim GC backed by TLSF allocator for soft real-time guarantees
    - flag `-d:useMalloc` to bypass TLSF allocator and use malloc/free
]#

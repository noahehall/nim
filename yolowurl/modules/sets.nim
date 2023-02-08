#[
  @see
    - https://nim-lang.org/docs/sets.html

  procs
    a - b	Difference
    A - B	difference of two sets (A without B's elements)
    A * B	intersection of two sets
    A + B	union of two sets
    a < b	Check if a is a subset of b
    A < B	strict subset relation (A is a proper subset of B)
    A <= B	subset relation (A is subset of B or equal to B)
    A == B	set equality
    card(A)	the cardinality of A (number of elements in A)
    contains(A, e)	A contains element e
    e in A	set membership (A contains element e)
    e notin A	A does not contain element e
    excl(A, elem)	same as A = A - {elem}
    incl(A, elem)	same as A = A + {elem}
]#

echo "############################ set"
# basetype must be of int8/16, uint8/16/byte, char, enum
# ^ hash sets (import sets) have no restrictions
# implemented as high performance bit vectors
# often used to provide flags for procs

# set[T] generic type for constructing bit sets
type Opts = set[char]
type IsOn = set[int8]
let
  simpleOpts: Opts = {'a','b','c'}
  onn: IsOn = {1'i8}
  offf: IsOn = {0'i8}
  flags: Opts = {'d'..'z'}

echo "my cli opts are: ", simpleOpts, onn , offf, flags
# flag example from tut1
type
  MyFlag* {.size: sizeof(cint).} = enum
    A
    B
    C
    D
  MyFlags = set[MyFlag]

proc toNum(f: MyFlags): int = cast[cint](f)
proc toFlags(v: int): MyFlags = cast[MyFlags](v)

echo "toNum {}: ", toNum({})
echo "toNum {A}: ", toNum({A})
echo "toNum {D}: ", toNum({D})
echo "toNum {A,C}: ", toNum({A, C})
echo "toFlags 0: ", toFlags(0)
echo "toFlags 7: ", toFlags(7)

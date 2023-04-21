##
## structured collections and ordinals
## ===================================

##[
## TLDR
- objects, enums and tuples are in userDefinedTypes.nim
- structured types
  - can hold multiple values and have unlimited levels of nesting
  - two groups
    - containers of fields: e.g. objects, tuples, hashtables
    - collections of items: e.g. sequences, arrays, char, sub/ranges, tables
- ordinal types
  - ordinals are values that can be orderly counted
  - enums, u/integers, bool
  - are countable and ordered, with a smallest & highest value
- FYI about low & high procs
  - should only be used with types not values

links
-----
- [nim by example: arrays](https://nim-by-example.github.io/arrays/)
- [table constructor](https://nim-lang.org/docs/manual.html#statements-and-expressions-table-constructor)

## structured: collections
- cstringArray

## array
- list of a static number of items
- similar to C arrays but more memory safety

array procs
-----------
- array[n, T] fixed-length dimensionally homogeneous
- array, openArray, UncheckedArray, varargs
- the array size is encoded in its type
- to pass an array to a proc its signature must specify the size and type
- array access is always bounds checked (theres a flag to disable)
- the index type can be any ordinal type
- each array dimension must have the same type,
  - nested (multi-dimensional) arrays can have different types than their parent

array like
----------
- openArray[T] a procs parameter that accepts an array/seq of any size but only of 1 dimension
- UncheckedArray[T] array with no bounds checking for implmenting customized flexibly sized arrays
- varargs[T] an openarray paramter that accepts a variable number of args in a procedure

table
-----
- syntactic sugar for an array constructor (not to be confused with std/tables!)
- {"k": "v"} == [("k", "v")]
- {key, val}.newOrderedTable to convert it to a dictionary (requires std/tables)
- benefits of table design
  - the order of (key,val) are preserved to support ordered dicts
  - literals can be a const which requires a minimal amount of memory

## sequence
- seq[T] dynamic-length dimensionally homogeneous
- always heap allocated & gc'ed
- can be passed to any proc accepting a seq/openarray
- the @ is the array to seq operator: init array and convert to seq
  - converting an openArray into a seq is not as efficient as it copies all elements
  - or use the newSeq proc

## range and alice

range
-----
- range[T] generic constructor for range
- range of values from an ordinal/flaoting-point type
- .. Binary slice operator that constructs an inclusive interval
- b[0 .. ^1] ==  b[0 .. b.len-1] == b[0 ..< b.len]
- forward: starts at 0
- backward: start at ^1,
- range of values from an integer or enumeration type
- are checked at runtime whenever the value changes
- valuable for catching / preventing underflows.
- e.g. Nims natural type: type Natural = range[0 .. high(int)]
  - should be used to guard against negative numbers
  - you can use Natural.low to check for 0

slice
-----
- provides a range of values matching the type required by the operator/proc
- same syntax as slice but different type (Slice) & context
- collection types define operators/procs which accept slices in place of ranges
  - the operator/proc determines the type of values they except in a slice


## ordinals
- Ordinal[T] generic ordinal type
- SomeOrdinal: any int, unit, bool, or enum

## generic interface
- should generally work with most types in this file

immutable ops
-------------
- [a .. ^b]	Slice: b is a backwardsIndex (inclusive)
- [a .. b]	Slice: inclusive
- [a ..< b]	Slice: excluded upper bound like b == len - 1
- @	Turn an array type into a sequence
- & concat 2 things
- cstringArrayToSeq cstringArray to seq[int]
- newSeq[T](n) create new seq of T with length n into y
- newSeq[T](s: seq[T]; n) create seq of T with length n, assigned to var s
- newSeqOfCap	Create a new sequence with zero length and a given capacity
- newSeqUninitialized only available for number types
- ord(x)	returns the integer value that is used to represent x's value
- pred(x[, n]) opposite of succ, i.e. previous
- succ(x[, n]) returns the n'th successor of x
- toOpenArray not defined in js targets
- find returns index of thing in item


mutable ops
-----------
- add	y to collection x
- dec(x, n)	decrements x by n; n is an integer
- dec(x)	decrements x by one
- del	O(1) delete item at index, doesn't preserve the order
- delete	Delete an item while preserving the order of elements (O(n) operation)
- grow sets length of X to y
- inc(x, n)	increments x by n; n is an integer
- inc(x)	increments x by one
- insert	Insert an item into container x
- pop	Remove and return last item of a sequence
- setLen increase/truncate the length of something
- shrink truncates X to length Y
- swapRefsInArray swaps x[N] with y[N] if the elements are refs

inspection ops
--------------
- contains true if y is in x, shortcut for find(a, item) => 0
- high (len x) - 1
- high(x) highest possible value/index
- is(x, y) true if value x of type y
- isnot(x,y) opposite of is, equivalent to not(x is type)
- len	Return the length
- low(x) lowest possible value/index s
- varargsLen the number of variadic arguments in x
- in/notin

## set
- set[T] generic set constructor
- collection of distinct ordinal values
- basetype must be of int8/16, uint8/16, byte, char, enum
  - hash sets (import std/sets) dont have this restriction
- implemented as high performance bit vectors
- often used to provide flags for procs

set operators
-------------
- a - b	Difference
- A - B	difference of two sets (A without B's elements)
- A * B	intersection of two sets
- A + B	union of two sets
- a < b	Check if a is a subset of b
- A < B	strict subset relation (A is a proper subset of B)
- A <= B	subset relation (A is subset of B or equal to B)
- A == B	set equality
- e in A	set membership (A contains element e)
- e notin A	A does not contain element e

set procs
---------
- card(A)	the cardinality of A (number of elements in A)
- excl(A, elem)	same as A = A - {elem}
- incl(A, elem)	same as A = A + {elem}

]##
{.push hint[XDeclaredButNotUsed]:off, hint[GlobalVar]:off .}

echo "############################ arrays"
var # vars dont need to be initialized to a value
  nums4: array[0 .. 3, int] # 4 items
  rangeArr: array[0..10, int] # max 11 items
  emptyArr: array[4, int]
let
  nums: array[4, int] = [1,9,8,5] # 4 items
  smun = [5,8,9,1]
  # this allows you to convert an ordinal (e.g. an enum) to an array
  # e.g. declaring an array x: array[MyEnum, string] = [x, y, z]
  arrayWithRange: array[0..5, string] = ["one", "two", "three", "four", "five", "six"]

proc withArrParam[I, T](a: array[I, T]): string =
  result = "first item in array " & $a[0]
discard withArrParam nums
discard withArrParam smun
echo "the range of this array is ", low nums, "..", high nums

# multi dimensional array with different index types
type
  TimeToEat = enum
    breakfast, lunch, dinner, sweettooth
  WhatToEat = enum
    proteinshake, ramen, ramentWithMeet, pnutbutteryjelly
  Eating = array[breakfast .. sweettooth, WhatToEat] # enum indexed
  WeeklyFoodTracker = array[0 .. 6, Eating] # integer indexed
  MonthlyFoodTracker = array[0 .. 3, array[0 .. 6, array[breakfast .. sweettooth, WhatToEat]]]
    # ^ oneliner, if only months were exactly 4 weeks

var onSundayIAte: Eating
onSundayIAte[breakfast] = proteinshake
onSundayIAte[lunch] = ramen
onSundayIAte[dinner] = ramentWithMeet
onSundayIAte[sweettooth] = pnutbutteryjelly

# remember, not assigning a value sets a default value
# ^ in this case 1 .. high will be filled with proteinshakes
# ^ because we only set index 0
var lastWeek: WeeklyFoodTracker
lastWeek[0] = onSundayIAte
echo "last sunday i ate: ", lastWeek[0]
echo "but there are ", lastWeek.len , " days in a week.. are you cheating on your diet?"



echo "############################ tables"

let areJustArrays: array[0, int] = {:}
echo "tables are sugar for arrays: " & $areJustArrays.repr
var myTable = {"fname": "noah", "lname": "hall"}
echo "my name is: ", $myTable
echo "my firstname is: ", myTable[0][1]

echo "############################ sequences"
# seq[T] generic type for constructing sequences
var
  woops: seq[int] = @[1,2,3,4]
  swoop: seq[int] = newSeq[int](4) # empty but has length 4
  emptySeq: seq[int]
  seqEmpty = newSeq[int]()

woops.add(5)
echo woops
swoop.add(woops)
echo swoop.len
echo "first ", woops[0]
echo "first ", woops[0 ..< 1]
echo "first 2", woops[0 .. 1]
echo "last ", woops[^1]

var me = "noAH"
me[0 .. 1] = "NO"
echo "change first 2 els ", me

# @ converts [x..y, type] into seq[type] efficiently
var globalseq = @[1,2,3]

echo "concat 2 seq, copies both returns new", globalseq & @[4,5,6]
echo "copy seq then append a single el and return new seq ", globalSeq & 4
echo "copy seq then prepend a single el and return new seq ", 0 & globalseq


echo "############################ range"
# BackwardsIndex returned by ^ (distinct int) values for reverse array access
const lastFour = ^4
const lastOne = ^1
echo "tell me your name ", "my name is noah"[lastFour .. lastOne]

# range[T] for constructing range types
type
  MySubrange = range[0..5]
echo MySubrange

var thisRange: range[0..5]
echo "thisRange bounds = ", thisRange.low, "..", thisRange.high
# for i in thisRange:  doesnt work, you need to use low & and high
for i in thisRange..thisRange: # dunno, works but says deprecated
  echo "got range to work ", i


echo "############################ slice"
# HSlice[T; U] T inclusive lower bound, U inclusive upper bound
# Slice[T] alias for HSlice[T, T]
# copied from docs
var
  a = "Nim is a programming language"
  bbb = "Slices are useless."
echo a[7 .. 12] # --> 'a prog' > forward slice
bbb[11 .. ^2] = "useful" # backward slice
echo bbb # --> 'Slices are useful.'


echo "############################ set"
# set[T] generic type for constructing sets of chars / ints
# there is no getter for sets (like in js), you have to loop through it or check for existence

let myCharSet: set[char] = {'a', 'b'}
echo myCharSet.contains('a')

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


var globalset1 = {1,2,3}
var globalset2 = {2,4,6}
echo "intersection of {1,2,3} and {2,4,6} = ", globalset1 * globalset2
echo "union of {1,2,3} and {2,4,6} = ", globalset1 + globalset2
echo "difference of {1,2,3} and {2,4,6} = ", globalset1 - globalset2
echo "is {1,2,3} a subset of {1,2,3} ", globalset1 <= {1,2,3}
echo "is {1,2,3} a strict subset of y ", globalset1 < {1,2,3}
echo "the cardinality of {1,2,3} is ", card globalset1

var globalset11 = deepCopy globalset1
globalset11.excl({2})
echo "remove {2} from {1,2,3} ", globalset11


echo "############################ general logic"
echo "seq[int] contains 6 ", @[5,6,7].contains(6)
echo "(1..3) contains 2 ", (1..3).contains(2)
echo "is a in arr[char] ", 'a' in ['a', 'b', 'c']
echo "99 notin {1,2,3} ", 99 notin {1,2,3}
echo "index of b in [a,b,c] ", ['a','b', 'c'].find('b')
echo "index of 4 in @[1..8] ", @[1,2,3,4,5,6,7,8].find 4

var globalarr = [1,0,0,4]
globalarr[1..2] = @[2,3]
echo "inplace mutation [1,0,0,4][1..2]= @[2,3] should be ", globalarr

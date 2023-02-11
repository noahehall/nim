##
## ordinals, array, sequences, range
## ==========================
##
## including arrays and sequences as the interface is similar to Ordinals
##
##
## ordinals: enums, integers, char, bool, subranges
## - only enums and subranges are included in this file
## - see typeSimple.nim for integers, chars and bool
##
## arrays: array, openArray, UncheckedArray
##
#[
  types
    array[n, T] fixed-length dimensionally homogeneous
    openArray[T] ptr to the array data and a length field
    Ordinal[T] generic ordinal type
    seq[T] dynamic-length dimensionally homogeneous
    UncheckedArray[T] array with no bounds checking
    cstringArray

  immutable ops
    [a .. ^b]	Slice: b is a backwardsIndex (inclusive)
    [a .. b]	Slice: inclusive
    [a ..< b]	Slice: excluded upper bound like b == len - 1
    @	Turn an array type into a sequence
    & concat 2 things
    ord(x)	returns the integer value that is used to represent x's value
    succ(x[, n]) returns the n'th successor of x
    pred(x[, n]) opposite of succ, i.e. previous
    cstringArrayToSeq cstringArray to seq[int]

  mutable ops
    add	y to x
    dec(x, n)	decrements x by n; n is an integer
    dec(x)	decrements x by one
    del	O(1) removal, doesn't preserve the order
    delete	Delete an item while preserving the order of elements (O(n) operation)
    inc(x, n)	increments x by n; n is an integer
    inc(x)	increments x by one
    insert	Insert an item at a specific position
    newSeq[T](n)	create seq of T with length n, = values to each index instead of add
    newSeq[T](s: seq[T]; n) create seq of T with length n, assigned to var s
    newSeqOfCap	Create a new sequence with zero length and a given capacity
    newSeqUninitialized only available for number types
    pop	Remove and return last item of a sequence
    swapRefsInArray swaps x[N] with y[N] if the elements are refs
    setLen increase/truncate the length of something
    toOpenArray not defined in js targets

  inspection ops
    contains true if y is in x, shortcut for find(a, item) => 0
    len	Return the length
    low(x) lowest possible value/index
    high (len x) - 1
    high(x) highest possible value/index
    varargsLen the number of variadic arguments in x
]#

echo "############################ arrays"
# the array size is encoded in its type
# to pass an array to a proc its signature must specify the size and type
# array access is always bounds checked (theres a flag to disable)
# the index type can be any ordinal type
# each array dimension must have the same type,
# ^ nested (multi-dimensin) arrays can have different types than their parent
var
  nums: array[4, int] = [1,9,8,5] # 4 items
  nums4: array[0 .. 3, int] # 4 items
  rangeArr: array[0..10, int] # max 11 items
  smun = [5,8,9,1]
  emptyArr: array[4, int]
  # this allows you to convert an ordinal (e.g. an enum) to an array
  # e.g. declaring an array x: array[MyEnum, string] = [x, y, z]
  # @see matrix section: https://nim-by-example.github.io/arrays/
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
  MonthlyFoodTracker = array[0 .. 3, array[0 .. 6, array[breakfast .. sweettooth, WhatToEat]]] # oneliner, if only months were exactly 4 weeks

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


echo "############################ sequences"
# always heap allocated & gc'ed
# can be passed to any proc accepting a seq/openarray
# the @ is the array to seq operator: init array and convert to seq
# ^ or use the newSeq proc

# seq[T] generic type for constructing sequences
var
  poops: seq[int] = @[1,2,3,4]
  spoop: seq[int] = newSeq[int](4) # empty but has length 4
  emptySeq: seq[int]
  seqEmpty = newSeq[int]()

poops.add(5)
echo poops
spoop.add(poops)
echo spoop.len
echo "first ", poops[0]
echo "first ", poops[0 ..< 1]
echo "first 2", poops[0 .. 1]
echo "last ", poops[^1]

var me = "noAH"
me[0 .. 1] = "NO"
echo "change first 2 els ", me

echo "############################ enums"
# A variable of an enum can only be assigned one of the enum's specified values
# enum values are usually a set of ordered symbols, internally mapped to an integer (0-based)
# $ convert enum value to its name
# ord convert enum name to its value

type
  GangsOfAmerica = enum
    democrats, republicans, politicians
# you can assign custom values to enums
type
  PeopleOfAmerica {.pure.} = enum
    coders = "think i am", teachers = "pretend to be", farmers = "prefer to be", scientists = "trying to be"

echo politicians # impure so doesnt need to be qualified
echo PeopleOfAmerica.coders # coders needs to be qualified cuz its labeled pure

# its idiomatic nim to have ordinal enums (1, 2, 3, etc)
# ^ and not assign disjoint values (1, 5, -10)
# enum iteration via ord
for i in ord(low(GangsOfAmerica))..
        ord(high(GangsOfAmerica)):
  echo GangsOfAmerica(i), " index is: ", i
# iteration via enum
# this echos the custom strings
for peeps in PeopleOfAmerica.coders .. PeopleOfAmerica.scientists:
  echo "we need more ", peeps

# example from tut1
type
  Direction = enum
    north, east, south, west # 0,1,2,3
  BlinkLights = enum
    off, on, slowBlink, mediumBlink, fastBlink
  LevelSetting = array[north..west, BlinkLights] # 4 items of BlinkLights
var
  level: LevelSetting
level[north] = on
level[south] = slowBlink
level[east] = fastBlink
echo level        # --> [on, fastBlink, slowBlink, off]
echo low(level)   # --> north
echo len(level)   # --> 4
echo high(level)  # --> west


echo "############################ range"
# .. Binary slice operator that constructs an inclusive interval
# b[0 .. ^1] ==  b[0 .. b.len-1] == b[0 ..< b.len]
# forward: starts at 0
# backward: start at ^1,
# range of values from an integer or enumeration type
# are checked at runtime whenever the value changes
# valuable for catching / preventing underflows.
# e.g. Nims natural type: type Natural = range[0 .. high(int)]
# ^ should be used to guard against negative numbers

# BackwardsIndex returned by ^ (distinct int) values for reverse array access
const lastFour = ^4
const lastOne = ^1
echo "tell me your name ", "my name is noah"[lastFour .. lastOne]

# range[T] for constructing range types
type
  MySubrange = range[0..5]
echo MySubrange

echo "############################ slice"
# same syntax as slice but different type (Slice) & context
# collection types define operators/procs which accept slices in place of ranges
# the operator/proc specify the type of values they work with
# the slice provides a range of values matching the type required by the operator/proc

# HSlice[T; U] T inclusive lower bound, U inclusive upper bound
# Slice[T] alias for HSlice[T, T]
# copied from docs
var
  a = "Nim is a programming language"
  bbb = "Slices are useless."
echo a[7 .. 12] # --> 'a prog' > forward slice
bbb[11 .. ^2] = "useful" # backward slice
echo bbb # --> 'Slices are useful.'

##
## array, sequences, etc
## =====================
##
## basically any collection sharing roughly the same interface (sans strings)
##
#[
  types
    UncheckedArray[T] array with no bounds checking
    openArray[T] ptr to the array data and a length field
    array[n, T] fixed-length dimensionally homogeneous
    seq[T] dynamic-length dimensionally homogeneous

  SomeOrdinal matches any ordinal type (including enums with holes)
  Ordinal[T] generic ordinal type (array, seq, integer, bool, char, enum and their subtypes)
  ordinal procs
    dec(x, n)	decrements x by n; n is an integer (mutates)
    dec(x)	decrements x by one (mutates)
    high(x) highest possible value/index
    inc(x, n)	increments x by n; n is an integer (mutes)
    inc(x)	increments x by one (mutates)
    low(x) lowest possible value/index
    ord(x)	returns the integer value that is used to represent x's value
    pred(x, n)	returns the n'th predecessor of x, pred(5) == 4
    succ(x, n)	returns the n'th successor of x
    succ(x)	returns the successor of x
    len	Return the length
    setLen increase/truncate the length of something

  seq procs
    @	Turn an array into a sequence
    add	Add an item to the sequence
    del	O(1) removal, doesn't preserve the order
    delete	Delete an item while preserving the order of elements (O(n) operation)
    insert	Insert an item at a specific position
    newSeq[T](n)	create seq of T with length n, = values to each index instead of add
    newSeq[T](s: seq[T]; n) create seq of T with length n, assigned to var s
    newSeqOfCap	Create a new sequence with zero length and a given capacity
    newSeqUninitialized only available for number types
    pop	Remove and return last item of a sequence
    setLen	Set the length of a sequence
    x & y	Concatenate two sequences
    x[a .. ^b]	Slice of a sequence but b is a reversed index (both ends included)
    x[a .. b]	Slice of a sequence (both ends included)
    x[a ..< b]	Slice of a sequence (excluded upper bound)
]#

echo "############################ bool"
# only true & false evaluate to bool
# but its an enum, so 0=false, 1=true
# if and while conditions must be of type bool


echo "############################ strings"
# value semantics
# are really just seq[char|byte] except for the terminating nullbyte \0
# ^0 terminated so nim strings can be converted to a cstring without a copy
# can use any seq proc for manipulation
# compared using lexicographical order
# to intrepret unicode, you need to import the unicode module


var msg: string = "yolo"
echo msg & " wurl" # concat and return new string
msg.add(" wurl") # modifies the string in place
echo msg, "has length ", len msg
let
  poop6 = "flush\n\n\n\n\n\nescapes are interpreted"
  flush = r"raw string, escapes arent interpreted"
  multiline = """
    can be split on multiple lines,
    escape sequences arent interpreted
    """
echo poop6, flush, multiline
echo "cmp a, z ", cmp("a", "z")
echo "cmp z, a ", cmp("z", "a")
echo "cmp a, a ", cmp("a", "a")


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

#[
  super long nim syntax file focusing on the basics
  only uses the implicitly imported system module
  see deepdives dir to dive deep

  the road to code
    bookmark: https://nim-lang.org/docs/tut2.html#exceptions-annotating-procs-with-raised-exceptions
    then here: https://nim-lang.org/docs/lib.html # categorize these in deepdive files
    then here: https://nim-lang.org/docs/system.html
    then here: https://nim-lang.org/docs/nimc.html
    then here: https://nim-lang.org/docs/docgen.html
    then here: https://nim-lang.org/docs/manual_experimental.html
    then here: https://nim-lang.org/docs/backends.html
    then here: https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html
    and finally: https://nim-lang.org/docs/nep1.html

  skim and copy:
    nim package directory: get familiar with what exists
      https://nimble.directory/
    the available procs and grab the ones with immediate usefulness
      https://nim-lang.org/docs/manual.html
    nim in action
      - reading: finished this like a year ago, it was super old then away
      - copying pg40 custom array ranges

  review:
    - we have like 1000 different nim files, consolidate

  eventual:
    https://nim-lang.org/docs/tut3.html
    https://nim-lang.org/docs/destructors.html

  other stuff
    https://nim-lang.org/docs/nims.html
    https://peterme.net/asynchronous-programming-in-nim.html
    https://peterme.net/handling-files-in-nim.html
    https://peterme.net/multitasking-in-nim.html
    https://peterme.net/optional-value-handling-in-nim.html
    https://peterme.net/tips-and-tricks-with-implicit-return-in-nim.html
    https://peterme.net/using-nimscript-as-a-configuration-language-embedding-nimscript-pt-1.html
    https://peterme.net/how-to-embed-nimscript-into-a-nim-program-embedding-nimscript-pt-2.html
    https://peterme.net/creating-condensed-shared-libraries-embedding-nimscript-pt-3.html

  skipped/should read again
    https://nim-by-example.github.io/bitsets/
    https://nim-by-example.github.io/macros/
    https://nim-lang.org/docs/tut1.html#sets-bit-fields
]#

#[
  # style guide & best practices

  idiomatic nim (from docs/styleguide), or borrowed from somewhere else (e.g. status auditor docs)
    - camelCase for code (status)
    - MACRO_CASE for external constants (status)
    - PascalCase for all types (status)
    - PascalCase for internal constants (status)
    - shadowing proc params > declaring them as var enables the most efficient parameter passing (docs)
    - declare as var > proc var params when modifying global vars (docs)
    - use result > last statement expression > return statement (docs [result = optimized]) (status prefers last statement)
    - use Natural range to guard against negative numbers (e.g. in loops) (docs)
    - use sets (e.g. as flags) > integers that have to be or'ed (docs)
    - spaces in range operators, e.g. this .. that > this..that (docs)
    - X.y > x[].y for accssing ref/ptr objects (docs: highly discouraged)
    - run initialization logic as toplevel module statements, e.g. init data (docs)
    - module names are generally long to be descriptive (docs)
    - use include to split large modules into distinct files (docs)
    - composition > inheritance is often the better design (docs)
    - type > cast operator cuz type preserves the bit pattern (docs)
    - cast > type conversion to force the compiler to reinterpret the bit pattern (docs)
    - object variants > inheritance for simple types; no type conversion required (docs)
    - MyCustomError should follow the hierarchy defiend in system.Exception (docs)
    - never raise an exception with a msg, and only in exceptional cases (not for control flow)

  my preferences thus far
    - strive for parantheseless code
    - keep it as sugary as possible
    - prefer fn x,y over x.fn y over fn(x, y) unless it conflicts with the context
      - e.g. pref x.fn y,z when working with objects
      - e.g. pref fn x,y when working with procs
      - e.g. pref fn(x, ...) when chaining/closures (calling syntax impacts type compatibility (docs))
    - object vs tuple
      - TODO: figure out which is more performant or if there are existing guidelines
      - tuple: no inheritance / private fields required
      - object: inheritance / private fields required
]#

#[
  # modules
    - generally 1 file == 1 module
    - include can split 1 module == 1..X files
    - top level statements are exected at start of program
    - isMainModule: returns true if current module compiled as the main file (see testing.nim)

  ambiguity
    - when a third imports the same symbol from 2 different modules
    - procs/iterators are overloaded, so no ambiguity
    - everything else must be qualified (modName.poop) if ambiguous

  import: top-level symbols marked * from another module
    import math # imports everything
    import std/math # qualified import everything
    import mySubdir/thirdFile
    import myOtherSubdir / [fourthFile, fifthFile]
    import thisTHing except thiz,thaz,thoz
    from thisThing import this, thaz, thoz # can invoke this,that,thot without qualifying
    from thisThing import nil # must qualify symbols to invoke, e.g. thisThing.blah()
    from thisThing as tt import nil # define an alias

  include: a file as part of this module
    include xA,xB,xC

  # exporting stuff
  export something
]#

#[
  # operators
    - precedence determined by its first character
    - are just overloaded procs, e.g. proc `+`(....) and can be invoked just like procs
    - infix: a + b must receive 2 args
    - prefix: + a must receive 1 arg
    - postfix: dont exist in nim

  + - * \ / < > @ $ ~ & % ! ? ^ . |

  bool
    not, and, or, xor, <, <=, >, >=, !=, ==

  short circuit
    and or

  char
    ==, <, <=, >, >=

  integer bitwise
    and or xor not shl shr

  integer division
    div

  module
    mod

  assignment
    =
      - value semantics: copied on assignment, all types have value semantics
      - ref semantics: referenced on assignment, anything with ref keyword

  ordinal (integers, chars, bool, subranges)
    dec(x, n)	decrements x by n; n is an integer
    dec(x)	decrements x by one
    high(x) highest possible value
    inc(x, n)	increments x by n; n is an integer
    inc(x)	increments x by one
    low(x) lowest possible value
    ord(x)	returns the integer value that is used to represent x's value
    pred(x, n)	returns the n'th predecessor of x
    pred(x)	returns the predecessor of x
    succ(x, n)	returns the n'th successor of x
    succ(x)	returns the successor of x

  set
    A + B	union of two sets
    A * B	intersection of two sets
    A - B	difference of two sets (A without B's elements)
    A == B	set equality
    A <= B	subset relation (A is subset of B or equal to B)
    A < B	strict subset relation (A is a proper subset of B)
    e in A	set membership (A contains element e)
    e notin A	A does not contain element e
    contains(A, e)	A contains element e
    card(A)	the cardinality of A (number of elements in A)
    incl(A, elem)	same as A = A + {elem}
    excl(A, elem)	same as A = A - {elem}

  ref/pter:
    . and [] always def-ref, i.e. return the value and not the ref
    . access tuple/object
    [] arr/seq/string
    new allocate a new instance
]#

#[
  # keywords
    of as in notin is isnot

    return
      - without an expression is shorthand for return result
    result
      - implicit return variable
      - initialized with procs default value, for ref types it will be nil (may require manual init)
      - its idiomatic nim to mutate it
    discard
      - use a proc for its side effects but ignore its return value

]#

#[
  # statements

  simple statements
    - cant contain other statements
    - e.g. assignment, invocations, and using return
  complex statements
    - can contain other statements
    - must always be indented except for single complex statements
    - e.g. if, when, for, while
]#

#[
  # expressions
    - result in a value
    - indentation can occur after operators, open parantheiss and commas
    - paranthesis and semicolins allow you to embed statements where expressions are expected

]#

#[
  # visibility

  var: local or global var
  *: this thing is visible outside the module
  scopes: all blocks (ifs, loops, procs, etc) introduce a closure EXCEPT when statements
]#

echo "############################ pragmas"
# @see https://nim-lang.org/docs/manual.html#pragmas
# @see https://nim-lang.org/docs/nimc.html#additional-features
# {.acyclic.} dunno read the docs
# {.async.} this fn is asynchronous and can use the await keyword
# {.base.} for methods, to associate fns with a base type. see inheritance
# {.bycopy|byref.} label a proc arg
# {.dirty.} dunno, but used with templates
# {.exportc: "or-use-this-specific-name".}
# {.exportc.} disable proc name mangling when compiled
# {.inheritable.} # check the docs: create alternative RootObj
# {.inject.} dunno, something to do with symbol visibility
# {.inline.} # check the docs: inlines a procedure
# {.noSideEffect.} convert a proc to a func, but why not just use func?
# {.pop.} # removes a pragma from the code that follows, check the docs
# {.pure.} requires qualifying ambiguous references; x fails, but y.x doesnt
# {.push ...} # pushes a pragma into the context of the code that follows, check the docs
# {.raises: [permit,these].} # compiler throws error if an unlisted exception can be raised
# {.size: ...} # check the docs
# {.thread.} informs the compiler this fn is meant for execution on a new thread
# {.threadvar.} informs the compiler this var should be local to a thread

echo "############################ variables"
var poop1 = "flush"
let poop2 = "hello"
# compile-time evaluation cannot interface with C
# there is no compile-time foreign function interface at this time.
# consts must be initialized with a value
const poop3 = "flush"

# computes fac(4) at compile time:
# notice the use of paranthesis and semi colins
const fac4 = (var x = 1; for i in 1..4: x *= i; x)

echo poop1, poop2, poop3, fac4
# stropping
let `let` = "stropping"; echo(`let`) # stropping enables keywords as identifiers

echo "############################ nil"
# if a ref/ptr points to nothing, its value is nil
# thus use in comparison to prove not nil

echo "############################ bool"
# only true & false evaluate to bool
# if and while conditions must be of type bool

echo "############################ strings"
# value semantics
# are really just seq[char|byte] except for the terminating nullbyte \0
# ^0 terminated so nim strings can be converted to a cstring without a copy
# can use any seq proc for manipulation
# compared using lexicographical order
# to intrepret unicode, you need to import the unicode module
var msg: string = "yolo"
echo msg & " wurl" # returns a new string
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


echo "############################ char"
# always 1 byte so cant represent most UTF-8 chars
# single ASCII characters
# basically an alias for uint8
# enclosed in single quotes
let
  xxx = 'a'
  y = '\109'
  z = '\x79'


echo "############################ number types"
# a word on integers
# not converted to floats automatically
# use toInt and toFloat
let
  x1: int32 = 1.int32   # same as calling int32(1)
  y1: int8  = int8('a') # 'a' == 97'i8
  z1: float = 2.5       # int(2.5) rounds down to 2
  sum: int = int(x1) + int(y1) + int(z1) # sum == 100

# signed integers, 32bit/64bit depending on system
# Conversion between int and int32 or int64 must be explicit except for string literals.
# int8,16,32,64 # 8 = +-127, 16 = +-~32k, 32 = +-~2.1billion
# default int === same size as pointer (platform word size)
const
  b = 100
  c = 100'i8
  num0 = 0 # int
  num1: int = 2
  num2: int = 4
  amilliamilliamilli = 1_000_000

# uint: unsigned integers, 32/64 bit depending on system,
# uint8,16,32,64 # 8 = 0 -> 2550, 16 = ~65k, 32 = ~4billion
const
  e: uint8 = 100
  f = 100'u8
echo "4 / 2 === ", num2 / num1 # / always returns a float
echo "4 div 2 === ", num2 div num1 # always returns an int

# float: float32 (C Float), 64 (C Double)
# float (alias for float64) === processors fastest type
const
  num3 = 2.0 # float
  num4 = 4.0'f32
  num5: float64 = 4.9'f64
  g = 100.0
  h = 100.0'f32
  i = 4e7 # 4 * 10^7
  l = 1.0e9
  m = 1.0E9
echo "4.0 / 2.0 === ", num4 / num3
echo "4.0 div 2.0 === ", "gotcha: div is only for integers"
echo "conversion acts like javascript floor()"
echo "int(4.9) div int(2.0) === ", int(num5) div int(num3)
echo "remainder of 5 / 2: ", 5 mod 2

echo "############################ hexadecimal"
const
  n = 0x123

echo "############################ binary"
const
  o = 0b1010101

echo "############################ octal"
const
  p = 0o123

echo "############################ byte"
# behaves like uint8
# if dealing with binary blobs, prefer seq[byte] > string,
# if dealing with binary data, prefer seq[char|uint8]


echo "############################ if"
# if
if not false: echo "true": else: echo "false"
if 11 < 2 or (11 == 11 and 'a' >= 'b' and not true):
  echo "or " & "true"
elif "poop" == "boob": echo "boobs arent poops"
else: echo false

echo "############################ when"
# a compile time if statement
# the condition MUST be a constant expression
# does not open a new scope
# only the first truthy value is compiled
when system.hostOS == "windows":
  echo "running on Windows!"
elif system.hostOS == "linux":
  echo "running on Linux!"
elif system.hostOS == "macosx":
  echo "running on Mac OS X!"
else:
  echo "unknown operating system"



when false: # trick for commenting code
  echo "this code is never run"

echo "############################ case expressions"

# can use strings, ordinal types and integers, ints/ordinals can also use ranges
echo case num3
  of 2: "of 2 satisifes float 2.0"
  of 2.0: "is float 2.0"
  of 5.0, 6.0: "float is 5 or 6.0"
  of 7.0..12.9999: "wow your almost a teenager"
  else: "not all cases covered: compile error if we dont discard"

case 'a'
of 'b', 'c': echo "char 'a' isnt of char 'b' or 'c'"
else: discard

#[
  case num2:
  of 2.0: echo "type mispmatch because num2 is int"
]#
proc positiveOrNegative(num: int): string =
  result = case num: # <-- case is an expression
    of low(int).. -1: # <--- check the low proc
      "negative"
    of 0:
      "zero"
    of 1..high(int): # <--- check the high proc
      "positive"
    else: # <--- this is unreachable, but doesnt throw err
      "impossible"

echo positiveOrNegative(-1)

echo "############################ raise "
# throw an exception
# system.Exception provides the interface
# have to be allocated on the heap (var) because their lifetime is unknown

var
  err: ref OSError
new(err)
err.msg = "the request to the OS failed"
# raise e
# alternatively, you can raise without defining a custom err
# raise newException(OSError, "the request to the os Failed")
# raise # raising without an error rethrows the previous exception

echo "############################ try/catch/finally "

if true:
  try:
    let f: File = open "this file doesnt exist"

  except OverflowDefect:
    echo "wrong error type"
  except ValueError:
    echo "cmd dude you know what kind of error this is"
  # except IOError:
  except:
    echo "unknown exception! this is bad code"
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
    # raise <-- would rethrow whatever the previous err was
  finally:
    echo "Glad we survived this horrible day"
    echo "if you didnt catch the err in an except"
    echo "this will be the last line before exiting"

echo "############################ iterators "
# inlined at the callsite when compiled
# ^ do not have the overhead from function calling
# ^ prone to code bloat
# ^ useful for defining custom loops on complex objects
# can be used as operators if you enclose the name in back ticks
# can be wrapped in a proc with the same name to accumulate the result and return it as a seq
# distinction with procs
# ^ can only be called from loops
# ^ cant contain a return statement
# ^ doesnt have an implicit result
# ^ dont support recursion
# ^ cant be forward declared
# @see https://nim-by-example.github.io/for_iterators/
# @see https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#iterators

iterator `...`*[T](a: T, b: T): T =
  var res: T = a
  while res <= b:
    yield res # enables returning a value without exiting
    inc res # we can continue because of yield

for i in 0...5:
  echo "useless iterator ", i


iterator countTo(n: int): int =
  var i = 0
  while i <= n:
    yield i
    inc i
for i in countTo(5):
  echo i

# iterator: closures
# basically javascript yield
# have state and can be resumed
# @see https://nim-by-example.github.io/for_iterators/

# std count iterators
# countup == .. and ..< (zero index countup)
# countdown == ..^ and ..^1 (zero index countdown)

# std collection iterators
# items/mitems : mutable/immutable, just the value
for item in "noah".items:
  echo "item is ", item
# pairs/mpairs: mutable/immutable index & item
for index, item in ["a","b"].pairs:
  echo item, " at index ", index

echo "############################ for"
# loops over iterators
for i in 1..2:
  echo "loop " & $i
for i in 1 ..< 2:
  echo "loop ", i
for i in countup(0,10,2):
  echo "evens only ", i
for i in countdown(11,0, 2):
  echo "odds only ", i
for i in "noah":
  echo "spell my name spell my name when your not around me ", i
for i, n in "noah":
  echo "index ", i, " is ", n

let intArr = [5,4,3,2,1]
for i in low(intArr) .. high(intArr):
  echo "index ", i, " in nums = ", intArr[i]

echo "############################ while"
var num6 = 0
while num6 < 10: # break, continue work as expected
  echo "num6 is ", num6
  inc num6

echo "############################ range"
# b[0 .. ^1] ==  b[0 .. b.len-1] == b[0 ..< b.len]
# forward: starts at 0
# backward: start at ^1,
# range of values from an integer or enumeration type
# are checked at runtime whenever the value changes
# valuable for catching / preventing underflows.
# e.g. Nims natural type: type Natural = range[0 .. high(int)]
# ^ should be used to guard against negative numbers
type
  MySubrange = range[0..5]
echo MySubrange

echo "############################ slice"
# same syntax as slice but different type (Slice) & context
# collection types define operators/procs which accept slices in place of ranges
# the operator/proc specify the type of values they work with
# the slice provides a range of values matching the type required by the operator/proc

# copied from docs
var
  a = "Nim is a programming language"
  bbb = "Slices are useless."
echo a[7 .. 12] # --> 'a prog' > forward slice
bbb[11 .. ^2] = "useful" # backward slice
echo bbb # --> 'Slices are useful.'

echo "############################ block"
# theres a () syntax but we skipped it as its not idiomatic nim
# introducing a new scope
let sniper = "scope parent"
block:
  let sniper = "scope private"
  echo sniper
echo sniper

# break out of nested loops
block poop:
  var count = 0
  while true:
    while true:
      while count < 5:
        echo "I took ", count, " poops"
        count += 1
        if count > 2: # dont want to take too many
          break poop

echo "############################ do"
# you have to read the docs on this one
echo do:
  "this ting"



echo "############################ arrays fixed-length dimensionally homogeneous"
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
  echo "first item in array ", a[0]
discard withArrParam nums
discard withArrParam smun

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


echo "############################ sequences dynamic-length dimensionally homogeneous"
# length can change @ runtime (like strings)
# always heap allocated & gc'ed
# always indexed starting at 0
# can be passed to any proc accepting a seq/openarray
# the @ is the array to seq operator: init array and convert to seq
# ^ or use the newSeq proc
# for loops use the items (seq value) or pairs (index, value) on seqs

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

echo "############################ set"
# basetype must be of int8/16, uint8/16/byte, char, enum
# ^ hash sets (import sets) have no restrictions
# implemented as high performance bit vectors
# often used to provide flags for procs
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

echo "############################ procedures"
# special return types
# ^ auto = type inference
# ^ void = nothing is returned, no need to use discard
# returning things: (cant contain a yield statement)
# ^ use return keyword for early returns
# ^ result = sumExpression: enables return value optimization & copy elision
# ^ if return/result isnt used last expression's value is returned
# overload: redeclare with different signature
proc pubfn*(): void =
  echo "the * makes this fn public"

# params with defaults dont requre a type
proc eko(this = "Default value"): void =
  debugEcho this
eko "wtf1"
eko("wtf2")
"wtf3".eChO

# use of semi to group parameters by type
proc ekoGroups(a, b: int; c: string, d: char): void =
  echo "ints: ", a, b, " strings: ", c, d
ekogroups 1, 2, "c", 'd'
# requires parenths for named args
ekogroups(b = 2, a = 1, c = "c is named, but d param isnt", 'd')

# anything less than 3*sizeof(pointer), i.e. 24 bytes on 64-bit OS
proc passedByValue(x: string): void =
  when false:
    x = 20 # this will throw an error
  echo x, " cant be modified"
let xx = "I"
passedByValue xx

# but you can copy then mutate, duh
proc copyThenMutateValue(x: string): void =
  var ll = x
  ll = ll & " was cloned"
  echo ll, " then mutated"

copyThenMutateValue xx

var zz = "who"
proc passedByReference(yy: var string): void =
  yy = "you" # mutates whatever yy points to
  echo zz, " were modified"
passedByReference zz

proc redurn(this: string): string =
  result &= this
debugEcho redurn "Wtf is result value"

# you can use explicitly return aswell
proc mutate(this: var int): int =
  this += 5
  return this
# error: 5 is not mutable
# debugEcho mutate 5
var num7 = 5
debugEcho mutate num7, num7.mutate, mutate(num7)

# noSideEffect pragma: statically ensures there are no side effects
# see func
proc add5(num: int): int {. noSideEffect .} =
  result = num + 5 # returned implicitly
debugEcho add5 5, 5.add5.add5, add5 add5(5).add5

# forward declaration
# everything must be declared (vars, objects, procs, etc) before being used
# cannot be used with mutually recursive procedures
proc allInts(x,y,z: int): int # dont include = or a body
echo allInts(1, 2, 3) # used before defined
proc allInts(x, y, z: int): int =
  result = x + y + z

# procs as (raw) strings
proc str(s: string): string = s
echo str"proc as a string\n escapes arent interporeted"

# procs as operators
# must use `symbol`
proc `***`(i: int): auto =
  result = i * i * i
echo ***5 + ***(5)

if `==`( `+`(3, 4), 7): echo "invoking operator as proc looks wierd"

# generic procs
proc wtf[T](a: T): auto =
  result = "wtf " & $a
echo wtf "yo"

# calling syntax impacts type compatability
# ^ I cant seem to get this to throw an error
# ^ read the docs (manual) and figure this out
# ^ @see https://nim-lang.org/docs/manual.html#types-procedural-type
proc greet(name: string): string =
  "Hello, " & name & "!"
proc bye(name: string): string =
  "Goodbye, " & name & "."
proc communicate(greeting: proc (x: string): string, name: string) =
  echo greeting(name)
communicate(greet, "John")
communicate(bye, "Mary")
echo "############################ openarray (proc params)"
# proc signature type only enabling accepting an array of any length
# ^ but only 1 dimension, i.e. wont accept a nested arr/seq
# always index with int and starting at 0
# array args must match the param base type, index type is ignored
# arrays and seqs are implicity converted for openArray params

# copied from docs
var
  fruits: seq[string] # reference to a sequence of strings that is initialized with '@[]'
  capitals: array[3, string] # array of strings with a fixed size

capitals = ["New York", "London", "Berlin"] # array 'capitals' allows assignment of only three elements
fruits.add("Banana") # sequence 'fruits' is dynamically expandable during runtime
fruits.add("Mango")

proc openArraySize(oa: openArray[string]): int =
  oa.len

# procedure accepts a sequence as parameter
echo "size of fruits ", openArraySize(fruits)
# but also an array type
echo "number of capitals ", openArraySize(capitals)

echo "############################ varargs (proc spread params)"
# enables passing a variable number of args to a proc param
# the args are converted to an array if the param is the last param

# haha almost forgot the _ doesnt matter
# s  == seq[string]
proc eko_all(s: varargs[string]) =
  for x in s:
    echo "var arg: ", x
e_k_o_a_l_l "this", "that", "thot"

# `$` second param converts each item to string
# s == seq[string] no matter what we pass
proc eko_anything(s: varargs[string, `$`]) =
  for x in s:
    echo x
eKoAnyThInG 1, "threee", @[1,2,3]

echo "############################ funcs (pure procs)"
# alias for {. noSideEffect .}
# compiler throws error if reading/writing to global variables
# ^ i.e. any var not a parameter/local
# allocating a seq/string does not throw an err

func poop(): string =
  result = "yolo"
  result.add(" wurl") # <-- permitted because its a local var

echo poop()


echo "############################ converters (implicit type conversion procs)"
# @see https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#converter

type Option[T] = object
  case hasValue: bool
  of true:
    value: T
  else:
    discard
let aa = Option[int](hasValue: true, value: 1)
let bb = Option[int](hasValue: true, value: 2)

# create an implicit conversion
converter get[T](x: Option[T]): T =
  x.value
# aa and bb are implicitly converted to ints, and can use the + operator
echo "adding two options ", aa + bb

echo "############################ templates (code gen procs)"
# enables raw code substitution
# read the docs on this one
# @see https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#template
# ^ used in ranges/slices is a template
# ^ returns a distinct int of type BackwardsIndex

const lastOne = ^1
const lastFour = ^4
echo "tell me your name ", "my name is noah"[lastFour .. lastOne]

echo "############################ closures"
# read the docs on this one
# something to do with long lived ref objects & unreclaimable memory
# @see https://nimbus.guide/auditors-book/02.1.4_closure_iterators.html

# closures with proc notation
proc runFn(a: string, fn: proc(x: string): string): string =
  fn a
echo runFn("with this string", proc (x: string): string = "received: " & x)

# closures with do notation
# just a shorter proc
# haha fkn notice how the DO is placed after the fn
# lol and not as a param to the fn
# @see https://nim-lang.org/docs/manual_experimental.html#do-notation
echo runFn("with another string") do (x: string) -> string: "another: " & x


# # anonymous proc: doesnt have a name and surrounded by paranthesis
# var someName = ( proc (params): returnType = "poop")
# # alternatively you can import sugar to get the -> symbol
# import sugar
# var someName = (params) -> returnType => "poop"
# # can also be used as a type for a proc param that accepts a fn
# proc someName(someFn: (params) -> returnType) =

echo "############################ type aliases"
# type aliases are identical & auto cast to their base
type
  BigMoney* = int # <- can be used wherever int is expected
echo 4 + BigMoney(2000)

type StrOrInt = string|int
let thizString: StrOrInt = "1"
let thisInt: StrOrInt = 1

echo "could be a string or an int ", thizString, thisInt
echo "############################ type aliases distinct"
# does not create inheritance but are identical with to base type
# ^ you can borrow fields/procs/etc from the base type
# ^ else explicity define everything
# base and distinct can be cast to eachother

type
  BiggerMoney = distinct BigMoney
  BiggestMoney {.borrow: `.`.} = distinct BigMoney # borrows all procs
# echo 10 + FkUMoney(100) # type mismatch

echo "############################ object"
# Enumeration and object types may only be defined within a type statement.
# note the placement of * for visibility outside of the module
# traced by the garbage collector, no need to free them when allocated
# each object type has a construct,
# when instantiated unspecified fields receive the field types default value
type
  PrivatePoop = object
    i*: bool # field is visible
    times: int
  PublicPoop* = object # <-- type is visible
    u: bool
    times: int
let ipoop = PrivatePoop(i: false, times: 0)
let upoop = PublicPoop(u: true, times: 100)
let everyonepoop = upoop # deep copy
echo "did ", ipoop
echo "or did ", upoop
echo "does ", everyonepoop

type
  Someone* = object
    name*, bday: string
    age*: int

var noah: Someone = Someone(name: "Noah",
  bday: "12/12/2023",
  age: 18 )
echo noah

let you = Someone(name:"not noah", bday:"dunno", age: 19)
debugEcho you

echo "############################ object getter/setters"
# public fields can ignore this section
# private fields (without *) are not publically visible
# you can create and export a proc operator for get/set operations

type SomeObj* = object
  pub*: string # can be set outside the mod
  prv: string # requires a getter & setter outside the mod

# make sure to export your getters and setters
proc `prv=`*(x: var SomeObj, v: string) {.inline.} =
    x.prv = v
proc `prv`*(x: SomeObj): string {.inline.} = x.prv

var myobj = SomeObj(pub: "pub field")

echo "myobj before setting: ", myobj
myobj.prv= "another value"
echo "myobjn after setting: ", myobj

# copied from docs
type
  Vector* = object # should use a tuple for vectors
    x, y, z: float

# example overloading [] operator
proc `[]=`* (v: var Vector, i: int, value: float) =
  # setter
  case i
  of 0: v.x = value
  of 1: v.y = value
  of 2: v.z = value
  else: assert(false)
proc `[]`* (v: Vector, i: int): float =
  # getter
  case i
  of 0: result = v.x
  of 1: result = v.y
  of 2: result = v.z
  else: assert(false)
echo "############################ ref"



# see inheritance
# traced references pointing gc'ed heap
# generally you should always use ref objects with inheritance
# non-ref objects truncate subclass fields on = assignment
# since objs are value types, composition is as efficient as inheritance
# ^ unlike in other languages
# dont have to label ref objects as var in proc signatures to mutate them

# Someone isnt Ref, but people instance is
let people: ref Someone = new(Someone)
people.name = "npc"
people.bday = "< now"
people.age = 1

# alternative ref syntax via type signature
type
  SomeoneRef* = ref Someone # causes all instances to be ref types
  OrRefObject = ref object
    fieldX, y, z: string
let people2 = SomeoneRef(name: "npc",
  bday: "before noah",
  age: 1)

echo "############################ ptr"
# see inheritance
# untraced references (are unsafe), pointing to manually managed memory locations
# required when accessing hardware/low-level ops

echo "############################ inheritance: ref / ptr"
# introduce many-to-one relationships: many instances point to the same heap
# reference equality check
# of creates a single layer of inheritance between types
# base types must be of an existing obj that points to RootObj or RootObj
# ^ else they are implictly `final`
# ^ TODO: find {.inheritable.} for introducing new object roots
# objects can be self-referencing
# use the [] operator when logging the object (see strutils)

type WhoPoop = ref object of RootObj
    name: string
type YouPoop = ref object of WhoPoop
type IPoop = ref object of WhoPoop

# overload procs by changing the signature
proc did_i_poop(self: WhoPoop): string  =
  "i dont know"
proc didipoop(self: YouPoop): string =
  self.name & " is a filthy animal"
proc dIdIpOoP(self: IPoop): string =
  self.name & " has evolved passed pooping"

# this has to be `var` to enable adding subtypes
# let throws error because You/IPoop arent WhoPoops
# const doesnt work at all and im not sure why but its a compile time issue
var sherlockpoops: seq[WhoPoop] = @[]
sherlockpoops.add(YouPoop(name: "spiderman"))
sherlockpoops.add(IPoop(name: "noah"))
for criminal in sherlockpoops:
  # echo $criminal doesnt work because $ doesnt exist on RootObj
  echo criminal.dIDIPOOP

# type checking
if sherlockpoops[0] of YouPoop: echo "filthy animal" else: echo "snobby bourgeois"

echo "############################ dynamic dispatch"
# generally only required with ref objects
# use method whenever an object has an inherited subtype only known at runtime

# copied from docs
type
  Expression = ref object of RootObj ## abstract base class for an expression
  Literal = ref object of Expression
    x: int
  PlusExpr = ref object of Expression
    a, b: Expression

# watch out: 'eval' relies on dynamic binding
method eval(e: Expression): int {.base.} = # <-- its for the base type
  # override this base method
  quit "to override!"
## use methods because at runtime we need to know the type
method eval(e: Literal): int = e.x
method eval(e: PlusExpr): int = eval(e.a) + eval(e.b)
# these procs dont need dynamic binding
proc newLit(x: int): Literal = Literal(x: x)
proc newPlus(a, b: Expression): PlusExpr = PlusExpr(a: a, b: b)

echo eval(newPlus(newPlus(newLit(1), newLit(2)), newLit(4)))

echo "############################ multi-methods"
# occurs when multiple overloaded procs exist with different signatures
# however they are still ambiguous because of inheritance
# you have to use --multimethods:on when compiling

type
  Thing = ref object of RootObj
  Unit = ref object of Thing
    x: int
# accepts any Thing
method collide(a, b: Thing) {.inline.} =
  quit "to override!"
# note the order
method collide(a: Thing, b: Unit) {.inline.} =
  echo "1"
# note the order
method collide(a: Unit, b: Thing) {.inline.} =
  echo "2"

var aaaa, bbbb: Unit
new aaaa
new bbbb
# there both Units, but collide doesnt have an over specifically for that
# so which will be used? type preference occurs from left -> right
collide(aaaa, bbbb) # output: 2

echo "############################ variants"

# copied from docs
# This is an example how an abstract syntax tree could be modelled in Nim
type
  NodeKind = enum  # the different node types
    nkInt,          # a leaf with an integer value
    nkFloat,        # a leaf with a float value
    nkString,       # a leaf with a string value
    nkAdd,          # an addition
    nkSub,          # a subtraction
    nkIf            # an if statement
  Node2 = ref object
    case kind: NodeKind  # the `kind` field is the discriminator
    of nkInt: intVal: int
    of nkFloat: floatVal: float
    of nkString: strVal: string
    of nkAdd, nkSub:
      leftOp, rightOp: Node2
    of nkIf:
      condition, thenPart, elsePart: Node2

var myFloat = Node2(kind: nkFloat, floatVal: 1.0)
echo "my float is: ", myFloat.repr
# the following statement raises an `FieldDefect` exception, because
# n.kind's value does not fit:
# n.strVal = ""

echo "############################ tuple fixed length hetergenous"
# similar to objects sans inheritance, + unpacking + more dynamic + fields always public
# structural equality check
# ^ tuples of diff types are == if fields have same type, name and order
# ^ anonymous tuples are compatible with tuples with field names if type matches
# instantiation must match order of fields in signature
# instantiation doesnt require field names
# field access by name/index (const int)

type
  # object syntax
  NirvStack = tuple
    fe: seq[string]
    be: seq[string]
  # tuple syntax
  StackNirv = tuple[fe: seq[string], be: seq[string]]

# no names required
var hardCoreStack: NirvStack = (@["ts"], @["ts, bash"])
# if provided, order must match signature
var newCoreStack: StackNirv = (fe: @["ts", "nim"], be: @["ts", "nim", "bash"])

# anonymous field syntax
let js = ("super", 133, 't')
echo js

var sj = (iz: "super", wha: 133, t: 't')
sj.iz = "duper"
debugEcho "you are ", js[0] & $sj.wha & $sj.t

# tuples dont need their type declared separately
var bizDevOps: tuple[biz: string, dev: string, ops: string] =
  ("intermediate", "senior", "intermediate")
echo "rate yourself on bizDevOps: ", bizDevOps

# tuples can be destructured (unpacked)
let (bizRating, devRating, opsRating) = bizDevOps
echo "rate yourself on bizDevOps: ", bizRating, " ", devRating, " ", opsRating

# copied from docs
# even in loops
let aaa = [(10, 'a'), (20, 'b'), (30, 'c')]
for (x, c) in aaa:
  echo x # This will output: 10; 20; 30
for i, (x, c) in aaa:
  echo i, c # Accessing the index is also possible


echo "############################ recursive types"
# objects, tuples and ref objects that recursively depend on each other
# must be declared within a single type section

# copied from docs
type
  Node = ref object  # a reference to an object with the following field:
    le, ri: Node     # left and right subtrees
    sym: ref Sym     # leaves contain a reference to a Sym

  Sym = object       # a symbol
    name: string     # the symbol's name
    line: int        # the line the symbol was declared in
    code: Node       # the symbol's abstract syntax tree

echo "############################ type conversions"
# cast operator forces the compiler to interpret a bit pattern to be of another type
# type() converions preserve the abstract value, but not the bit-pattern


echo "############################ repr"
# prints anything
# advanced/custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)

echo "repr: ", sherlockpoops.repr

echo "############################ generics"
# parameterized: Thing[T]
# restricted Thing[T: x or y]
# static Thing[MaxLen: static int, T] <-- find this one in the docs

echo "############################ files"
# no clue why we need to add the dir
# not that way in system.nim
# ^ its because vscode pwd is /nim and not /nim/yolowurl
let entireFile = readFile "yolowurl/yolowurl.md"
echo "file has ", len entireFile, " characters"

# you need to open a file to read line by line
# notice the dope bash-like syntax
proc readFile: string =
  let f = open "yolowurl/yolowurl.md"
  defer: close f # <-- make sure to close the file object
  result = readline f
echo "first line of file is ", readFile()

# upsert a file
const tmpfile = "/tmp/yolowurl.txt"
writeFile tmpfile, "a luv letter to nim"
echo readFile tmpfile

# overwrite an existing file
proc writeLines(s: seq[string]): void =
  let f = tmpfile.open(fmWrite) # open for writing
  defer: close f
  for i, l in s: f.writeLine l
writeLines @["first line", "Second line"]
echo readFile tmpfile

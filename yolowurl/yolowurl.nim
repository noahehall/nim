#[
  super long nim syntax file focusing on the basics
  only uses the implicitly imported system module
  see deepdives dir to dive deep

  bookmark: https://nim-lang.org/docs/tut1.html#advanced-types-arrays
  then here: https://nim-lang.org/docs/tut2.html
  then here: https://nim-lang.org/docs/tut3.html
  then here: https://nim-lang.org/docs/lib.html # categorize these in deepdive files
  then here: https://nim-lang.org/docs/nimc.html
  then here: https://nim-lang.org/docs/manual_experimental.html
  then here: https://nim-lang.org/docs/docgen.html
  then here: https://nim-lang.org/docs/destructors.html
  then here: https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html
  then here: https://nim-lang.org/docs/backends.html
  then here: nim in action
    - reading: shiz finished this like 2 years ago, it was super old then away
    - copying pg40 custom array ranges, just skim the remainder in case the above missed something
  and finally: https://nim-lang.org/docs/nep1.html
  and finally: https://nim-lang.org/docs/manual.html
  you should be good when there arent any empty sections in this file
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


  skipped
    https://nim-by-example.github.io/bitsets/
    https://nim-by-example.github.io/macros/
]#

#[
  # style guide

  idiomatic nim (from docs/styleguide), or borrowed from somewhere else (e.g. status auditor docs)
    - camelCase for code (status)
    - MACRO_CASE for external constants (status)
    - PascalCase for all types (status)
    - PascalCase for internal constants (status)
    - shadowing proc params > declaring them as var enables the most efficient parameter passing (docs)
    - declare as var > proc params (docs): modifying global vars
    - use result > last statement expression > return statement (status)
    - use Natural range to guard against negative numbers (e.g. in loops)
    - use sets for flags > integers that have to be or'ed

  my preferences thus far
    - strive for parantheseless code
    - keep it as sugary as possible
    - prefer fn x,y over x.fn y over fn(x, y) unless it conflicts with the context
      - e.g. pref x.fn y when working with objects
      - e.g. pref fn x,y when working with procs
      - e.g. pref fn(x, ...) when chaining
]#

#[
  # importing stuff
  import math is the same as import std/math
  import fileInThisDir
  import mySubdir/thirdFile
  import myOtherSubdir / [fourthFile, fifthFile]
  import thisTHing except thiz,thaz,thoz
  from thisThing import this,thaz,thoz
  from thisThing import nil # now you have to qualify all thisThing.blah() to invoke
  include a,b,c # instead of imports, it includes, i.e. a,b,c are 1 module in 3 files

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
      - value semantics: copied on assignment, most types are value semantics
      - ref semantics: referenced on assignment, anything with ref keyword

  ordinal
    ord(x)	returns the integer value that is used to represent x's value
    inc(x)	increments x by one
    inc(x, n)	increments x by n; n is an integer
    dec(x)	decrements x by one
    dec(x, n)	decrements x by n; n is an integer
    succ(x)	returns the successor of x
    succ(x, n)	returns the n'th successor of x
    pred(x)	returns the predecessor of x
    pred(x, n)	returns the n'th predecessor of x

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
# {.acyclic.} dunno read the docs
# {.async.} this fn is asynchronous and can use the await keyword
# {.base.} for methods, to associate fns with a base type. see inheritance
# {.bycopy|byref.} label a proc arg
# {.dirty.} dunno, but used with templates
# {.exportc: "or-use-this-specific-name".}
# {.exportc.} disable proc name mangling when compiled
# {.inject.} dunno, something to do with symbol visibility
# {.noSideEffect.} convert a proc to a func, but why not just use func?
# {.pop.} # removes a pragma from the code that follows, check the docs
# {.pure.} requires qualifying ambiguous references; x fails, but y.x doesnt
# {.push ...} # pushes a pragma into the context of the code that follows, check the docs
# {.raises: [permit,these].} # compiler throws error if an unlisted exception can be raised
# {.thread.} informs the compiler this fn is meant for execution on a new thread
# {.threadvar.} informs the compiler this var should be local to a thread
# {.size: ...} # check the docs

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
# reference & pointer types to prove parameters are initialized

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
# range of values from an integer or enumeration type
# are checked at runtime whenever the value changes
# valuable for catching / preventing underflows.
# e.g. Nims natural type: type Natural = range[0 .. high(int)]
# ^ should be used to guard against negative numbers
type
  MySubrange = range[0..5]

echo MySubrange
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



echo "############################ arrays fixed-length homogeneous"
# the array size is encoded in its type
# so you to pass an array to a proc the proc must specify the size as well as type
# array access is always bounds checked
var
  nums: array[4, int] = [1,9,8,5]
  rangeArr: array[0..10, int]
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

echo "############################ openarray"
# parameter-only type representing a pointer, length pair
# aka slices, ranges, views, spans
# arrays and seqs are implicity converted to openArray

echo "############################ sequences dynamic-length homogeneous"

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

echo "############################ tuple fixed length hetergenous"
let js = ("super", 133, 't')
echo js

var sj = (iz: "super", wha: 133, t: 't')
sj.iz = "duper"
debugEcho "you are ", sj[0] & $sj.wha & $sj.t

echo "############################ set"
# basetype must be of int8/16, uint8/16/byte, char, enum
# ^ hash sets (import sets) have no restrictions
# implemented as high performance bit vectors
# often used to provide flags for procs
type Opts = set[char]
type IsOn = set[int8]
let
  simpleOpts: Opts = {'a','b','c'}
  on: IsOn = {1'i8}
  off: IsOn = {0'i8}
  flags: Opts = {'d'..'z'}

echo "my cli opts are: ", simpleOpts, on , off, flags
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

# haha almost forgot the _ doesnt matter
proc eko_all(s: varargs[string]) =
  for x in s:
    echo "var arg: ", x
e_k_o_a_l_l "this", "that", "thot"

# use of semi to group parameters by type
proc ekoGroups(a, b: int; c: string, d: char): void =
  echo "ints: ", a, b, " strings: ", c, d
ekogroups 1, 2, "c", 'd'
# requires parenths for named args
ekogroups(b = 2, a = 1, c = "c is named, but d param isnt", 'd')

# `$` second param converts everything to string
proc eko_anything(s: varargs[string, `$`]) =
  for x in s:
    echo x
eKoAnyThInG 1, "threee", @[1,2,3]

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
# are identical to their base but cant be used in their place
# requires explicit casting to their base
# requires base procs & fields to be be borred for use on subtypes
type
  BiggerMoney = distinct BigMoney
  BiggestMoney {.borrow: `.`.} = distinct BigMoney # borrows all procs
# echo 10 + FkUMoney(100) # type mismatch

echo "############################ object values"
# Enumeration and object types may only be defined within a type statement.
# structural equality check
# note the placement of * for visibility
# traced by the garbage collector, no need to free them when allocated
type
  PrivatePoop = object
    i*: bool
    times: int
  PublicPoop* = object # <-- u dirty animal
    u: bool
    times: int
let ipoop = PrivatePoop(i: false, times: 0)
let upoop = PublicPoop(u: true, times: 100)
echo "did ", ipoop
echo "or did ", upoop


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

echo "############################ object refs"
# reference equality check
# dont have to label ref objects as var in proc signatures to mutate them
let people: ref Someone = new(Someone)
people.name = "npc"
people.bday = "< now"
people.age = 1
# alternative ref syntax via declaration
type
  SomeoneRef* = ref Someone
  OrRefObject = ref object
    fieldX, y, z: string
let people2 = SomeoneRef(name: "npc",
  bday: "before noah",
  age: 1)

echo "############################ object pointers"
# manually managed

echo "############################ inheritance"
# of creates a single layer of inheritance between types
# base types must be of RootObj type else they wont have an ancestor
# object types with no ancestors are implictly `final`
# generally you should always use ref objects with inheritance
# use the [] operator when logging the object (see strutils)
# objects can be self-referencing
type WhoPoop = ref object of RootObj
    name: string
type YouPoop = ref object of WhoPoop
type IPoop = ref object of WhoPoop

# overload methods/procs by changing the signature
# use method whenever an object has an inherited subtype only known at runtime
# ^ i.e. invocation depends on the actual object being invoked
# ^ with proc only the {.base.} method is called
method did_i_poop(self: WhoPoop): string {.base.} =
  "i dont know"
method didipoop(self: YouPoop): string =
  self.name & " is a filthy animal"
method dIdIpOoP(self: IPoop): string =
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

echo "############################ repr"
# prints anything
# advanced/custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)

echo "repr: ", sherlockpoops.repr

echo "############################ generics"
# parameterized: Thing[T]
# restricted Thing[T: x or y]
# static Thing[MaxLen: static int, T] <-- find this one in the docs

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
# enum iteration via enum
# this echos the custom strings
for peeps in PeopleOfAmerica.coders .. PeopleOfAmerica.scientists:
  echo "we need more ", peeps

# ordinals doesnt work with disjoint enums
# i.e. those assigned custom integer values (string values okay i think)
## low(x) lowest possible value
## high(x) highest possible value
## inc x ++1
## dec x --1
## ord(x) the ordinal value of x
## X(i) casts the index to an enum

echo "############################ ordinal types"
# Enumerations, integer types, char and bool (and subranges)
# see operators > ordinal

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

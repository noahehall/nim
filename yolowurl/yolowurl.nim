#[
  super long nim syntax file
  ctrl -f it
  bookmark: https://nim-by-example.github.io/procs/
]#

#[
  # import
  import math === import std/math
  import firstFile
  import mySubdir/thirdFile
  import myOtherSubdir / [fourthFile, fifthFile]
]#

#[
  # wtf lol cant get these to compile
  echo "nil === void", $nil.nil
  discard echo "ignore return values"
  echo "true | false ", true | false
]#

############################ variables
var poop1 = "flush" # runtime mutable
let poop2 = "hello" # runtime immutable
# compile-time evaluation cannot interface with C
# there is no compile-time foreign function interface at this time.
# consts must be initialized with a value
const poop3 = "flush" # compile time immutable
let `let` = "stropping"; echo(`let`) # stropping enables keywords as identifiers

############################ strings
# must be enclosed in double quotes
# escape sequences are parsed
# always mutable
var msg: string = "yolo"
echo msg & " wurl" # returns a new string
msg.add(" wurl") # modifies the string in place
echo msg
let
  poop6 = "flush"
  flush = r"raw string, no escape sequences required"
  multiline = """can be split on multiple lines, no escape sequences required"""

############################ char
# single ASCII characters
# enclosed in single quotes
let
  x = 'a'
  y = '\109'
  z = '\x79'


############################ number types
const num1: int = 2
const num2: int = 4
echo "4 / 2 === ", num2 / num1
echo "4 div 2 === ", num2 div num1
const num3 = 2.0
const num4: float = 4.0
const num5: float = 4.9
echo "4.0 / 2.0 === ", num4 / num3
echo "4.0 div 2.0 === ", "gotcha: div is only for integers"
echo "conversion acts like javascript floor()"
echo "int(4.9) div int(2.0) === ", int(num5) div int(num3)
echo "remainder of 5 / 2: ", 5 mod 2

# - signed integers, 32bit/64bit depending on system
# - int8,16,32,64 # 8 = +-127, 16 = +-~32k, 32 = +-~2.1billion
const
  a = 100
  b: int8 = 100
  c = 100'i8
  d: int = 1
# uint: positive integers, 32/64 bit depending on system,
# uint8,16,32,64 # 8 = 0 -> 2550, 16 = ~65k, 32 = ~4billion
const
  e: uint8 = 100
  f = 100'u8
# floats
const
  g = 100.0
  h = 100.0'f32
  i = 4e7 # 4 * 10^7


############################ control flow: branching
# if
if not false: echo "true": else: echo "false"
if 11 < 2 or (11 == 11 and 'a' >= 'b' and not true):
  echo "or " & "true"
elif "poop" == "boob": echo "boobs arent poops"
else: echo false

# when is a compile time if statement
when true:
  echo "evaluated at compile time"
when false: # false = trick for commenting code
  echo "this code is never run"

# case
# are actually expressions
# every possible case must be covered
# can use strings, sets and ranges of ordinal types
case num3
of 2:
  echo "of 2 satisifes float 2.0"
of 2.0: echo "is float 2.0"
else: discard

case 'a'
of 'b', 'c': echo "char 'a' isnt of char 'b' or 'c'"
else: echo "not all cases covered: compile error if we remove else:discard"

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

############################ control flow: loops
# for
# this uses the items iterator, as we are only using i
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
# this iuses the pairs iterator, as we are using i AND n
for i, n in "noah":
  echo "index ", i, " is ", n

var num6 = 0
while num6 < 10: # break, continue work as expected
  echo "num6 is ", num6
  inc num6

# block statements
# wide range of uses cases, but primarily breaking out of nested loops
block poop:
  var count = 0
  while true:
    while true:
      while count < 5:
        echo "I took ", count, " poops"
        count += 1
        if count > 2:
          break poop

# iterators
# can be used as operators if you enclose the name in back ticks
# you can define an interator for looping over anything, e.g. user types
# @see https://nim-by-example.github.io/for_iterators/
iterator `...`*[T](a: T, b: T): T =
  var res: T = a
  while res <= b:
    yield res
    inc res

for i in 0...5:
  echo i

# iterator: inlined for loop
# do not have the overhead from function calling
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
############################ structs

# fixed-length homogeneous arrays
var
  nums: array[4, int] = [1,9,8,5]
  smun = [5,8,9,1]
  emptyArr: array[4, int]

# dynamic-length homogeneous sequences
var
  poops: seq[int] = @[1,2,3,4]
  spoop = @[4,3,2,1]
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

# fixed length hetergenous tuples
let js = ("super", 133, 't')
echo js

var sj = (iz: "super", wha: 133, t: 't')
sj.iz = "duper"
debugEcho "you are ", sj[0] & $sj.wha & $sj.t

# types: user defined struct
type
  IPoop = object
    didi: bool
    times: int


############################ procedures
# special return types
# auto = type inference
# void = nothing is returned
proc pubfn*(): void =
  echo "the * makes this fn importable"

proc eko(this: string): void =
  debugEcho this
eko "wtf"
eko("wtf")

# result serves as an implicit return variable
# initialized as: var result: ReturnType
# its idiomatic nim to mutate it
proc redurn(this: string): auto =
  result = this
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
proc add5(num: int): int {. noSideEffect .} =
  result = num + 5 # returned implicitly
debugEcho add5 5, 5.add5.add5, add5 add5(5).add5

# forward declaration
proc allInts(x,y,z: int): int
echo allInts(1, 2, 3) # used before defined
proc allInts(x, y, z: int): int =
  result = x + y + z

# procs as operators
# must use `symbol`
proc `***`(i: int): auto =
  result = i * i * i

echo ***5 + ***(5)

# generic procs
proc wtf[T](a: T): auto =
  result = "wtf " & $a
echo wtf "yo"

# proc someName(p1: varargs[string]): string =
#   # p1 is an object that takes an arbitrary amount of strings
# proc someName = # returns void, and doesnt accept params
# proc someName: void = echo "defined on one line"
# proc someName: auto = "return type is inferred"

# # anonymous proc: doesnt have a name and surrounded by paranthesis
# var someName = ( proc (params): returnType = "poop")
# # alternatively you can import sugar to get the -> symbol
# import sugar
# var someName = (params) -> returnType => "poop"
# # can also be used as a type for a proc param that accepts a fn
# proc someName(someFn: (params) -> returnType) =

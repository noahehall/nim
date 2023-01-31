#[
  super long nim syntax file focusing on the basics
  only uses the implicitly imported system module
  see deepdives dir to dive deep

  bookmark: https://matthiashager.com/nim-object-oriented-programming
  then here: https://peterme.net/asynchronous-programming-in-nim.html
  then here: https://nimbus.guide/auditors-book/
  then here: https://nim-lang.org/docs/nimc.html
  then here: https://nim-lang.org/docs/docgen.html
  then here: https://nim-lang.org/docs/destructors.html
  then here: https://nim-lang.org/docs/manual_experimental.html
  then here: https://matthiashager.com/gui-options-for-nim
  and finally: https://nim-lang.org/docs/manual.html

  skipped
    https://nim-by-example.github.io/bitsets/
    https://nim-by-example.github.io/macros/

  idiomatic nim
    - todo

  my preferences thus far
    - strive for parantheseless code, fkn hate the shift key
    - keep shiz as sugary as possible
    - prefer fn x,y over x.fn y over fn(x, y) unless the context demands it
]#

#[
  # importing stuff
  import math is the same as import std/math
  import fileInThisDir
  import mySubdir/thirdFile
  import myOtherSubdir / [fourthFile, fifthFile]

  # exporting stuff
  export something
]#

#[
  # compiling stuff
  nim CMD OPTS FILE ARGS
  CMDS
    c compile
    r compile to $nimcache/projectname then run it, prefer this over `c -r`
  OPTS
    -r used with c to compile then run
    --threads:on enable threads for parallism
    --backend c|find-the-other-backends

]#
#[
  # wtf lol cant get these to compile
  echo "nil === void", $nil.nil # <-- think its just suppose to be nil and not nil.nil
  discard echo "ignore return values" <-- you cant discard a void
  echo "true | false ", true | falsev <-- | is xor
]#

#[
  # operators
  =     +     -     *     /     <     >
  @     $     ~     &     %     |
  !     ?     ^     .     :     \
  == => != etc

  # keywords
  and or not xor shl shr div mod in notin is isnot of as
]#
echo "############################ pragmas"
# find them in the docs somewhere
# {.pure.} requires qualifying ambigigious references
# ^ x fails, but y.x doesnt
# {.base.} for methods, to associate fns with a base type
# ^ see inheritance
# {.thread.} informs the compiler this fn is meant for execution on a new thread
# {.threadvar.} informs the compiler this var should be local to a thread
# {.async.} this fn is asynchronous and can use the await keyword
echo "############################ variables"
var poop1 = "flush" # runtime mutable
let poop2 = "hello" # runtime immutable
# compile-time evaluation cannot interface with C
# there is no compile-time foreign function interface at this time.
# consts must be initialized with a value
const poop3 = "flush" # compile time immutable
let `let` = "stropping"; echo(`let`) # stropping enables keywords as identifiers

echo "############################ strings"
# must be enclosed in double quotes
# are really just seq[char] so you can use any seq proc for manipulation
# check # proc section for proc strings
# to intrepret unicode, you need to import the unicode module
var msg: string = "yolo"
echo msg & " wurl" # returns a new string
msg.add(" wurl") # modifies the string in place
echo msg
let
  poop6 = "flush\n\n\n\n\n\nescapes are interpreted"
  flush = r"raw string, escapes arent interpreted"
  multiline = """
    can be split on multiple lines,
    escape sequences arent interpreted
    """
echo poop6, flush, multiline


echo "############################ char"
# single ASCII characters
# basically an alias for uint8
# enclosed in single quotes
let
  x = 'a'
  y = '\109'
  z = '\x79'


echo "############################ number types"
const num1: int = 2
const num2: int = 4
echo "4 / 2 === ", num2 / num1 # / always returns a float
echo "4 div 2 === ", num2 div num1 # div always returns an int
const num3 = 2.0
const num4: float = 4.0
const num5: float = 4.9
echo "4.0 / 2.0 === ", num4 / num3
echo "4.0 div 2.0 === ", "gotcha: div is only for integers"
echo "conversion acts like javascript floor()"
echo "int(4.9) div int(2.0) === ", int(num5) div int(num3)
echo "remainder of 5 / 2: ", 5 mod 2

# signed integers, 32bit/64bit depending on system
# int8,16,32,64 # 8 = +-127, 16 = +-~32k, 32 = +-~2.1billion
# int === same size as pointer
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
# floats:  float32, float64, and float
# float === processors fastest type
const
  g = 100.0
  h = 100.0'f32
  i = 4e7 # 4 * 10^7


echo "############################ control flow: branching"
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

echo "############################ control flow: loops"
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
# theres a () syntax but we skipped it as its not idiomatic nim
# wide range of uses cases, but primarily breaking out of nested loops
block poop:
  var count = 0
  while true:
    while true:
      while count < 5:
        echo "I took ", count, " poops"
        count += 1
        if count > 2: # dont want to take too many
          break poop

# do statements
# you have to read the docs on this one
echo do:
  "this ting"



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



echo "############################ arrays fixed-length homogeneous"
# the array size is encoded in its type
# so you to pass an array to a proc the proc must specify the size as well as type
var
  nums: array[4, int] = [1,9,8,5]
  smun = [5,8,9,1]
  emptyArr: array[4, int]
  # this allows you to convert an ordinal (e.g. an enum) to an array
  # when declaring an array, e,g. x: array[MyEnum, string] = [x, y, z]
  # @see matrix section: https://nim-by-example.github.io/arrays/
  arrayWithRange: array[0..5, string] = ["one", "two", "three", "four", "five", "six"]

proc withArrParam[I, T](a: array[I, T]): string =
  echo "first item in array ", a[0]
discard withArrParam nums
discard withArrParam smun

echo "############################ sequences dynamic-length homogeneous"
# dynamically allocated (on the heap, not the stack)
# but still immutable unless created with var
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


echo "############################ procedures"
# special return types
# auto = type inference
# void = nothing is returned
proc pubfn*(): void =
  echo "the * makes this fn public"

proc eko(this: string): void =
  debugEcho this
eko "wtf"
eko("wtf")
"wtf".echo

# haha almost forgot the _ doesnt matter
proc eko_all(s: varargs[string]) =
  for x in s:
    echo x
# notice the missing _
ekoall "this", "that", "thot"

# `$` second param converts everything to string
proc eko_anything(s: varargs[string, `$`]) =
  for x in s:
    echo x
eKoAnyThInG 1, "threee", @[1,2,3]

# you cant mutate args passed by value
proc passedByValue(x: string): void =
  when false:
    x = 20 # this will throw an error
  echo x, " cant be modified"
let xx = "I"
passedByValue xx

proc copyThenMutateValue(x: string): void =
  var ll = x
  ll = ll & " was cloned"
  echo ll, " then mutated"

copyThenMutateValue xx

# arguments to proc are immutable by default
# you have to prepend var to arg type defs to mutate them
var zz = "who"
proc passedByReference(yy: var string): void =
  yy = "you" # mutates whatever yy points to
  echo zz, " were modified"
passedByReference zz

# result serves as an implicit return variable
# initialized as: var result: ReturnType
# its idiomatic nim to mutate it
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
proc add5(num: int): int {. noSideEffect .} =
  result = num + 5 # returned implicitly
debugEcho add5 5, 5.add5.add5, add5 add5(5).add5

# forward declaration
proc allInts(x,y,z: int): int
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

# generic procs
proc wtf[T](a: T): auto =
  result = "wtf " & $a
echo wtf "yo"

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

# proc someName(p1: varargs[string]): string =
#   # p1 is an object that takes an arbitrary amount of strings

# # anonymous proc: doesnt have a name and surrounded by paranthesis
# var someName = ( proc (params): returnType = "poop")
# # alternatively you can import sugar to get the -> symbol
# import sugar
# var someName = (params) -> returnType => "poop"
# # can also be used as a type for a proc param that accepts a fn
# proc someName(someFn: (params) -> returnType) =


echo "############################ type aliases"
# type aliases are identical to their base
# are automatically cast to their base
# theres a technical term for this, check the scala docs
type
  BigMoney* = int # <- can be used wherever int is expected
echo 4 + BigMoney(2000)

echo "############################ type aliases distinct"
# are identical to their base
# requires explicit casting to their base
# requires base procs to be be borred
type
  BiggerMoney = distinct BigMoney
  BiggestMoney {.borrow: `.`.} = distinct BigMoney # borrows all procs
# echo 10 + FkUMoney(100) # type mismatch

echo "############################ objects"
# just a group of fields
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

# mutable (var) object created on the stack
# can be passed to fns that require a mutable param
var noah: Someone = Someone(name: "Noah",
  bday: "12/12/2023",
  age: 18 )
echo noah
# immutable (let) object created on the stack
let you = Someone(name:"not noah", bday:"dunno", age: 19)
debugEcho you

# ref objects allocated on the heap
# mittens cant be changed (i.e. point to something else)
# but the pointer on the heap can be changed (i.e. mutate its attrs)
# also dont have to label ref objects as var in proc signatures to mutate them
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

echo "############################ inheritance"
# of creates inheritance between types
# base types must be of RootObj type else they wont have an ancestor
# object types with no ancestors are implictly `final`
type WhoPoop = ref object of RootObj
    name: string
type YouPoop = ref object of WhoPoop
type IPoop = ref object of WhoPoop

# overload methods/procs by changing the self arg
# we use method for dynamic dispatch
# ^ i.e. the overloaded method is called based on the type
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

echo "############################ enums"
# type checked (thus cant be anonymous and must have a type)
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

echo "############################ assert"
# check the compiler flags for how to embed unit tests in code
# ^ think its -d:danger or --asertions:off
# ^ so that assertions are optionally removed when compiled
# ^^ theres a technical term for this type of runtime assertions
assert "a" == $'a' # has to be of same type

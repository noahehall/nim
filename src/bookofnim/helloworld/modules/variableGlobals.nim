##
## variables and globals
## =====================

##[
## TLDR
- catchall for global keywords/procs/types/etc not specified in other files
- anything like `BLAH=` can be written `BLAH =`
  - the former enables you to define/overload operators via 'proc `poop=`[bloop](soop): doop = toot'
- converts are listed here because their purpose is implicit type coercion
- additional type features are covered in tupleObjectTable.nim
- you can call clear on pretty much anything

var/global todos
----------------
- [couldnt get eval to work](https://github.com/nim-lang/Nim/blob/version-1-6/lib/system.nim#L2816)
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

var/global links
----------------
- [system vars](https://nim-lang.org/docs/system.html#8)
- [typeinfo](https://nim-lang.org/docs/typeinfo.html)
- [converters](https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#converter)

## var
- runtime mutable global var

## let
- runtime immutable

## const
- compile-time evaluation cannot interface with C
- there is no compile-time foreign function interface at this time.
- consts must be initialized with a value
- declares variables whose values are constant expressions

## static
- static represents a compile time entity, whether variable, block or type restriction
- static[T] meta type representing all values that can be evaluated at compile time
- all static params are treated as generic params, thus may lead to executable bloat (see generics)

## eval
- eval executes a block of code at compile time

## stropping
- enable use of keywords as operators

## auto
- auto only for proc return types and signature parameters
- parameter auto: creates an implicit generic of proc[x](a: [x])
- return auto: causes the compiler to infer the type form the routine body

## type casts
- cast operator forces the compiler to interpret a bit pattern to be of another type
- i.e. interpret the bit pattern as another type, but dont actually convert it to the other type
- only needed for low-level programming and are inherently unsafe

## type coercions
- aka type conversions sometimes in docs, but always means coercion
  - type coercions preserve the abstract value, but not the bit-pattern
- allocCStringArray creates a null terminated cstringArray from
- chr(i): convert 0..255 to a char
- cstringArrayToSeq
- only widening (smaller > larger) conversions are automatic/implicit
- ord(i): convert char to an int
- parseInt/parseFloat from a string
- static(x): force the compile-time evaluation of the given expression
- toFloat(int): convert int to a float
- toInt(float): convert float to an int
- toOpenArray
- toOpenArrayByte

## type inspection
- type(x): retrieve the type of x, discouraged should use typeof
- typeof(x): retrieve the type of x
- typeOfProc: retrieve the result of a proc, i.e. typeof x, typeOfProc

## echo/repr
- roughly equivalent to writeLine(stdout, x); flushFile(stdout)
- available for the JavaScript target too.
- cant be used with funcs/{.noSideEffect.} (use debugEcho)

]##


echo "############################ variables"
var poop1 = "flush"
let poop2 = "hello"
const poop3 = "flush"

# docs
const fac4 = (var x = 1; for i in 1..4: x *= i; x) ## \
  ## notice the use of semi colins to have multiple statements on a single line

echo poop1, poop2, poop3, fac4

let `let` = "stropping"
echo(`let`) ## stropping enables keywords as identifiers

var autoInt: auto = 7 ## type inference, relevant for proc return type
echo "autoInt labeled auto but its type is ", $type(autoInt)

echo "############################ static"
static:
  ## explicitly requires compile-time execution
  echo "at compile time"

# docs copypasta didnt work, @see https://nim-lang.org/docs/manual.html#special-types-static-t
proc meaningOfLife(question: static string): auto =
  var what {.global.} = 42
  result = question
const theAnswer = meaningOfLife("what is it")
# echo theAnswer, "the meaning of life is ", $what lol dunno what should be a global?


echo "############################ variable logic"
# shallow(blah) marks blah as shallow for optimization, subsequent assignments  wont deep copy
# shallowCopy(x, y) copies y into x

when compiles(3 + 4):
  ## checks whether x can be compiled without any semantic error.
  ## useful to verify whether a type supports some operation:
  echo "'+' for integers is available at compile time"

var typeSupportBlah = "halb"
when declared typeSupportBlah:
  ## whether x is declared at compile time
  echo "blah is declared at compile time"

when not declared thisDoesntExist:
  echo "some thing doesnt exist at compile time"

when declaredInScope typeSupportBlah:
  ## checks current scope at compile time
  echo "blah is declared in scope at compile time"

when defined typeSupportBlah:
  ## checks whether something is defined at compile time
  echo "something is defined at compile time"

var d33pcopy: string ## \
  ## if gc:arc|orc you have to enable via --deepcopy:on
d33pcopy.deepCopy typeSupportBlah
echo "deep copy of some other thing ", d33pcopy

# get the default value
echo "the default int value is ", int.default
echo "the default seq[int] value is ", $ seq[int].default


echo "############################ interesting globals"
# appType (const) console|gui|lib
echo "app type is " & appType

# CompileTime (const) HH:MM:SS
echo "i was compiled at " & CompileTime

# isMainModule (const) true if module accessed as main module; used to embed tests
echo "am i the main module? ", $isMainModule

# NaN (const) IEEE value for Not a number; use isNan/classify from math instead
# NimMajor (const)
# NimMinor (const)
# NimPatch (const)
# NimVersion (const)
echo "does NimVersion = NimMajor.NimMinor.NimPatch? ",
  $NimVersion, " = ", $NimMajor, ".", $NimMinor, ".", $NimPatch

# QuitFailure (const) failure value passed to quit
echo "on failure I call quit with ", $QuitFailure

# QuitSuccess (const)
echo "on success i call quit with ", $QuitSuccess

# efficiently retrieve a tuple of all local variables
echo "locally defined vars are those not in a global scope ", locals()
block superPrivateScope:
  var inScope: string = "im in a block"
  echo "locals in a block: ", locals()

# shorthand for echo(msg); quit(code)
echo "quit the program with quit(n) or quit(msg, n)"

echo "############################ global let"
# nimvm: bool true in Nim VM context and false otherwise; valid for when expressions

echo "############################ type casts"
var myInt = 10

proc doubleFloat(x: float): float = x * x
echo "old people double your money in this infomercial: ", doubleFloat(cast[float](myInt))

echo "############################ type coercions"
# assert typeof("a b c".split) is string
# assert typeof("a b c".split, typeOfProc) is seq[string]

echo "coerce to expression to static: ", static[bool](1 == 1)

echo "############################ converters (implicit type conversion procs)"
type Option[T] = object
  case hasValue: bool
  of true:
    value: T
  else:
    discard
let aa = Option[int](hasValue: true, value: 1)
let bb = Option[int](hasValue: true, value: 2)

converter get[T](x: Option[T]): T =
  ## create an implicit conversion for Option[T]
  ## now Option[int] + Option[int] works
  x.value
echo "adding two options ", aa + bb

# copied from docs
# bad style ahead: Nim is not C.
converter toBool(x: int): bool = x != 0
if 4:
  echo "compiles because implicit conversxion converts int to bool"

echo "############################ type inference"
var somevar: seq[char] = @['n', 'o', 'a', 'h']
var othervar: string = ""
echo "somevar is seq? ", somevar is seq
echo "somevar is seq[char]? ", "throws err when adding subtype seq[char]"
echo "somevar isnot string? ", somevar isnot string


type MyType = ref object of RootObj
var instance: MyType = MyType()

echo "is instance of MyType ", instance of MyType


echo "############################ echo and related"
echo "just a regular echo statement"

# same as echo but pretends to be free of sideffects
# for use with funcs/procs marked as {.noSideEffect.}
debugEcho "this time with debugEcho "

# prints anything
# custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)
echo "this time with repr ", @[1,2,3].repr

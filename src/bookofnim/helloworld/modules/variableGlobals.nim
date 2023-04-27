##
## variables and globals
## =====================

##[
## TLDR
- catchall for global keywords/procs/types/etc not specified in other files
- anything like `BLAH=` can be written `BLAH =`
  - the former enables you to define/overload operators via 'proc `woop=`[bloop](soop): doop = toot'
- converts are listed here because their purpose is implicit type coercion
- additional type features are covered in structuredContainers.nim
- you can call clear on pretty much anything

links
-----
- [system vars](https://nim-lang.org/docs/system.html#8)
- [typeinfo](https://nim-lang.org/docs/typeinfo.html)
- [converters](https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#converter)
- [special types](https://nim-lang.org/docs/manual.html#special-types)

TODOs
-----
- blah.reset a thing to its default value

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
- toFloat(int): convert int to a float
- toInt(float): convert float to an int
- toOpenArray
- toOpenArrayByte

## type inspection
- type(x): retrieve the type of x, discouraged should use typeof
- typeof(x, mode = typeofIter): retrieve the type of x
- typeOfProc: retrieve the result of a proc, i.e. typeof x, typeOfProc
- TypeofMode: enum[typeofProc|typeofIter] second param to typeof

## echo/repr
- roughly equivalent to writeLine(stdout, x); flushFile(stdout)
- available for the JavaScript target too.
- cant be used with funcs/{.noSideEffect.} (use debugEcho)

## important globals

- nimvm: true if current execution context is compile time

]##

{.push hint[XDeclaredButNotUsed]:off .}
echo "############################ variables"
var woop1 = "flush" ## mutable vars dont require a value when defined
let woop2 = "hello" ## must be assigned a value
const woop3 = "flush" ## must be assigned a value

# docs
const fac4 = (var x = 1; for i in 1..4: x *= i; x) ## \
  ## use of semi colins to have multiple statements on a single line

echo woop1, woop2, woop3, fac4

let `let` = "stropping" ## stropping enables keywords as identifiers
echo(`let`)

var autoInt: auto = 7 ## type inference; relevant for proc return types
echo "autoInt labeled auto but its type is ", type(autoInt)


echo "############################ variable logic"
# shallow copy isnt defined for arc/orc
# shallow(blah) marks blah as shallow for optimization, subsequent assignments  wont deep copy
# shallowCopy(x, y) copies y into x

let someString = "some string"
var d33pcopy: string ## \
  ## if gc:arc|orc you have to enable via --deepcopy:on
d33pcopy.deepCopy someString
echo "deep copy of some other thing ", d33pcopy

var a = "i was a"
var b = "i was b"
a.swap b
echo "a and b", a, b


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
echo "cast int to a float ", doubleFloat(cast[float](myInt))

echo "############################ type support"
# assert typeof("a b c".split) is string
# assert typeof("a b c".split, typeOfProc) is seq[string]

echo "a static bool ", static[bool](1 == 1)

let myStaticVar = static(1 + 2) ## \
  ## static(x): force the compile-time evaluation of the given expression
echo "my static var", myStaticVar

static:
  # can also be used as a block
  echo "at compile time"
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

# returns the string representation of anything
# custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)
echo "this time with repr ", @[1,2,3].repr

##
## variables and globals
## =====================
## redo this entire file, likely just name it globals or something

##[
## TLDR
- anything like `BLAH=` can be written `BLAH =`
  - the former enables you to define/overload operators via 'proc `woop=`[bloop](soop): doop = toot'
- you can call clear on pretty much anything

links
-----
- [system vars](https://nim-lang.github.io/Nim/system.html#8)

TODOs
-----
- blah.reset a thing to its default value
- [type conversions](https://nim-lang.github.io/Nim/manual.html#statements-and-expressions-type-conversions)
- [type casts](https://nim-lang.github.io/Nim/manual.html#statements-and-expressions-type-casts)

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


echo "############################ echo and related"
echo "just a regular echo statement"

# same as echo but pretends to be free of sideffects
# for use with funcs/procs marked as {.noSideEffect.}
debugEcho "this time with debugEcho "

# returns the string representation of anything
# custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)
echo "this time with repr ", @[1,2,3].repr

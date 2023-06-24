## nims type system
## ================

##[
## TLDR
- the potential for effectively using typedesc deserves multiple readings of the docs
- not understanding bind once vs bind many can produce interesting bugs in your code
- to cast a float to a string, use myFloat.repr, `$` doesnt work

links
-----
- other
  - [converters](https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#converter)
- high impact
  - [generic inference restrictions](https://nim-lang.github.io/Nim/manual.html#generics-generic-inference-restrictions)
  - [generics](https://nim-lang.github.io/Nim/manual.html#generics)
  - [implicit generics](https://nim-lang.github.io/Nim/manual.html#generics-implicit-generics)
  - [special types](https://nim-lang.github.io/Nim/manual.html#special-types)
  - [special types](https://nim-lang.github.io/Nim/manual.html#special-types)
  - [type bound operators](https://nim-lang.github.io/Nim/manual.html#procedures-type-bound-operators)
  - [type classes](https://nim-lang.github.io/Nim/manual.html#generics-type-classes
  - [typedesc](https://nim-lang.github.io/Nim/manual.html#special-types-typedesc-t)
  - [typeinfo](https://nim-lang.github.io/Nim/typeinfo.html)
  - [view types](https://nim-lang.github.io/Nim/manual_experimental.html#view-types)

TODOs
-----
- [out parameters](https://nim-lang.github.io/Nim/manual_experimental.html#strict-definitions-and-nimout-parameters-nimout-parameters)
- read through the scala notes and try to replicate the algebraic data types
- move all the type logic stuff in here
- metatype examples
- type bound operator examples (and should probably reread those docs)
- probably should reread the typedesc docs
- [symbol lookups in generics](https://nim-lang.github.io/Nim/manual.html#generics-symbol-lookup-in-generics)
  - mixin statement
  - bind statement
  - delegating bind statements
- generics and the method call syntax
  - theres a `[:X]` syntax that doesnt conflict with the method call syntax (blah.method)
    - [docs](https://nim-lang.github.io/Nim/manual.html#procedures-method-call-syntax)
    - [forum post](https://forum.nim-lang.org/t/10125)
- [example with is operator for generics](https://nim-lang.github.io/Nim/manual.html#generics-is-operator)

## metatypes
- untyped lookup symbols & perform type resolution after the expression is interpreted & checked
  - i.e. expression is lazily resolved to its value (for templates)
  - use to pass a block of statements
- typed: semantic checker evaluates and transforms args before expression is interprted & checked
  - an expression that is [eagerly] resolved to its value (for templates)
  - i.e. whenever u set a type in a signature its resolved immediately
- typedesc a type description
- void absence of any type, generally used as proc return type

## type bound operators
- a proc or func starting with = but isnt an operator (yet still uses backticks in signature)
  - is always visible to the type, i.e. regardless of visibility of the definition
  - i.e. are bound to the Type and lifted to global scope
- unrelated to propertie setters which end in = despite syntax similarities
  - =copy
  - =destroy Generic destructor implementation
  - =sink Generic sink implementation
  - =trace Generic trace implementation
  - =deepcopy
  - =wasMoved

## type classes
- pseudo type that can be used to match via the is operator
- are compile-time constraints enforced at instantiation, not dynamically at runtime
- in addition, every generic type creates a type class of the same name
  - native: object, tuple, enuim, proc, iterator, ref, ptr, var, distinct, array, set, seq, auto
- can be conbined, e.g. `type RecordType = (object or tuple)` or as `object | tuple`
- will be intantiated (overloaded) once for each unique combination used within the program
  - bind once types: each are bound once per concrete type
  - bind many types: each are bound for every concrete type if `distinct|typedesc` is applied

typedesc
--------
- nim treats the names of types as regular values in certain contexts in the compilation phase
- typedesc is a generic type for all types denoting the type class of all types
  - i.e. all types are really typedesc[blah], e.g. int == typedesc[int]
- procs using typedesc params are implicitly generic
  - i.e. `p(a: typedesc)` == `p[T](a: typedesc[T])`
  - i.e. `p(a: typedesc; b:a)` == `p[T](a: typedesc[T]; b: T)` == `p(int, 4)`

static[T]
---------
- must be constant expressions
- are treated as generic parameters, thus compiled for each unique type T
- proc parameters can also be static,
- expressions (e.g. proc invocations) can be coereced to static(blah()) for compile time evalution

## converters
- routine that (re)defines conversion between two types
- can be explicitly invoked for readability
- converter chaining is not automatic
  - i.e. a > b > c exist, but a > c does not occur automatically

inspection
----------
- type(x): retrieve the type of x, discouraged should use typeof
- typeof(x, mode = typeofIter): retrieve the type of x
- typeOfProc: retrieve the result of a proc, i.e. typeof x, typeOfProc
- TypeofMode: enum[typeofProc|typeofIter] second param to typeof

## generics
- abc

## views
- a symbol (let, var, const,etc) that has a view type
  - views borrow their values from some other location
  - ensures `thisView = thisLocation`
    - thisView doesnt outlive thisLocation
    - thisLocation isnt mutated
- any type that is/contains
  - `lent T` view into T
  - `openArray[T]`
  - e.g.: openArray[byte] | lent string | Table[openArray[char], int]
- except if
  - constructed via ptr / proc
  - e.g. proc (x: openArray[T]) | ptr openArray[char] | ptr array[4, lent int]
- path expressions: the source for thisLocation must be
  - accessor like e[i]
  - pointer dereference like e[]
  - type conversion/cast like T(e) | cast[T](e)
  - procs that return view types
]##

{.push hint[XDeclaredButNotUsed]:off .}
echo "############################ type aliases"
type
  BigMoney* = int # <- can be used wherever int is expected
echo 4 + BigMoney(2000)

type StrOrInt = string|int
let thizString: StrOrInt = "1"
let thisInt: StrOrInt = 1

echo "could be a string or an int ", thizString, thisInt

echo "############################ type aliases distinct"
type
  BiggerMoney = distinct BigMoney
  BiggestMoney {.borrow: `.`.} = distinct BigMoney # borrows all procs
# echo 10 + FkUMoney(100) # type mismatch

echo "############################ metatypes"
# todo


echo "############################ type bound operators"
# todo


echo "############################ generics"
# parameterize procs, iterators or types
# parameterized: Thing[T]
# 3 constrained: Thing[T: x or y] will resolve to x or y staticlly, and remain so at runtime
# ^ i.e. a var Z cant change between x & y after semantic resolution phase
# generic params are compiled separately for each unique value/combination of such
# ^ generic params should not be overused (IMO) as it will lead to code bloat

# generic procs
proc wtf[T](a: T): auto =
  # the is operator is useful for type specialization within generic code
  if T is SomeNumber: result = "wtf is this num " & $a
  elif T is string: result = "wtf is this string " & $a
  else: result = "wtf is this thing " & $typeof a

echo wtf "yo"
echo wtf 2
echo wtf ("tup", "el")

# generic proc method call syntax
proc foo[T](i: T) =
  echo i, " using method call syntax"
var ii: int
# ii.foo[int]() # Error: expression 'foo(i)' has no type (or is ambiguous)
ii.foo[:int]() # Success


echo "############################ type classes"
# even tho myRecord is tuple, it doesnt extend from tuple
# so we have to add typeof myRecord explicitly to RecordType
var myRecord: tuple[wtf: string] = (wtf: "yo")

# this matches against tuple, we dont need to add it to the RecordType
type OtherRecord = tuple
  wtf: string

# from docs
# create a type class that will match all tuple and object types
type RecordType = (typeof myRecord) or object | tuple # or and | are interchangable
# an implicitly generic procedure:
# each param is bound ONCE to a concrete subtype of T (object|tupe|myRecord)
proc printFields[T: RecordType](rec: T) = # same as printFields(rec: RecordType)
  for key, value in fieldPairs(rec):
    echo key, " = ", value

var utherRecord: OtherRecord = (wtf: "yo2")

printFields(myRecord)
printFields(utherRecord)

# bind many types use distinct to enable params to bind to ANY of the concrete subtypes of T
# T can be pulled out like before into a type declaration
# without the distinct both first and second would HAVE to be of the same type, because it binds once
proc fieldsPrint[T: distinct tuple | object](first, second: T) =
  if typeof first is typeof second: echo "got two of the same"
  else: echo "got a tuple and object"

echo "############################ typedesc"
# docs
template declareVariableWithType(T: typedesc, value: T) =
  var x: T = value

declareVariableWithType(int, 42)


echo "############################ converters (implicit type conversion procs)"
type Option[T] = object
  case hasValue: bool
  of true:
    value: T
  else:
    discard
let aa = Option[int](hasValue: true, value: 1)
let bb = Option[int](hasValue: true, value: 2)

# TODO(noah) strict case objects
# converter get[T](x: Option[T]): T =
#   ## create an implicit conversion for Option[T]
#   ## now Option[int] + Option[int] works
#   x.value
# echo "adding two options ", aa + bb

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

echo "############################ static"

static:
  echo "this at compile time"

echo "a static bool ", static[bool](1 == 1)

let myStaticVar = static(1 + 2) ## \
  ## static(x): force the compile-time evaluation of the given expression
echo "my static var", myStaticVar

echo "############################ type casts"
var myInt = 10

proc doubleFloat(x: float): float = x * x
# echo "cast int to a float ", doubleFloat(cast[float](myInt)) # TODO(noah): throws in v2

echo "############################ type inspection"
# assert typeof("a b c".split) is string
# assert typeof("a b c".split, typeOfProc) is seq[string]
let x: string = "ima string"
let y: typeof(x) = "ima also a string"

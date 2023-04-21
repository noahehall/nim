## algebraic data types and traits
## ===============================

##[
## TLDR
- algebraic data types and catchall for nims type system

links
-----
- [type classes](https://nim-lang.org/docs/manual.html#generics-type-classes
- [implicit generics](https://nim-lang.org/docs/manual.html#generics-implicit-generics)
- [type bound operators](https://nim-lang.org/docs/manual.html#procedures-type-bound-operators)
- [object variants](https://nim-lang.org/docs/manual.html#types-object-variants)

todos
-----
- read through the scala notes and try to replicate the algebraic DTs
- move all the type logic stuff in here
- create a test file
- add readme
- add to bookofnim
- metatype examples
- type bound operator examples (and should probably reread those docs)
- probably should reread the typedesc docs
- [symbol lookups in generics](https://nim-lang.org/docs/manual.html#generics-symbol-lookup-in-generics)
  - mixin statement
  - bind statement
  - delegating bind statements

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
- a proc or func whose name starts with = but isnt an operator
- unrelated to propertie setters which end in = despite syntax similarities
  - x =copy y
  - x =destroy y Generic destructor implementation
  - x =sink y Generic sink implementation
  - x =trace y Generic trace implementation

## type classes
- pseudo type that can be used to match via the is operator
- object, tuple, enum, proc, ref, ptr, var, distinct, array, set, seq auto
- in addition, every generic type creates a type class of the same name

## typedesc
- since nim treats the names of types as regular values in certain contexts in the compilation phase
- typedesc is a generic type for all types denoting the type class of all types
- procs using typedesc params are implicitly generic

## object variants
- preferred over an object hierarchy with multiple levels when simple variants suffice
- are tagged unions, which use an enum to discrimate between variant
  - generally a field called `kind` is set to SomeEnum, whose fields determine the branch
- also called `case objects` in the docs

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
# static constrained: Thing[T: x or y] will resolve to x or y staticlly, and remain so at runtime
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


echo "############################ object variants"

type
  LanguageKind = enum # consumers can create these kinds of object variants
    typescript, nimlang, shell
  Language = ref LanguageObj # uses the fields defined in the object
  LanguageObj = object # tagged unions
    # shared fields
    stack: string
    appName: string
    # each variant must have distinct fields
    case kind: LanguageKind # discriminated by this field
    of typescript:
      bun: bool
    of nimlang:
      c: bool
    of shell:
      bash: bool

# create a new case object
var fireTeam = Language(kind: nimlang, stack: "allstack", appName: "nirvai" )
var webTeam = Language(kind: typescript, stack: "fullstack", appName: "nirvaiWeb")
var opsTeam = Language(kind: shell, stack: "network", appName: "nirvConnect")

##
## tuples, objects and tables
## ==========================

##[
## TLDR
- heterogenous containers of named fields of any type
- enums are in ordinalStructured.nim

todo
- [symbol lookups in generics](https://nim-lang.org/docs/manual.html#generics-symbol-lookup-in-generics)
  - mixin statement
  - bind statement
  - delegating bind statements
- in general everything about tables
- metatype examples
- type bound operator examples (and should probably reread those docs)
- find {.inheritable.} for introducing new object roots
- object variants (reread the docs, couldnt get working)
- probably should reread the typedesc docs
- blah.reset an object to its default value

links
- [distinct type aliases](https://nim-lang.org/docs/manual.html#types-distinct-type)
- [type bound operators](https://nim-lang.org/docs/manual.html#procedures-type-bound-operators)
- [inheritance](https://nim-lang.org/docs/manual.html#type-relations)
- [type classes](https://nim-lang.org/docs/manual.html#generics-type-classes
- [implicit generics](https://nim-lang.org/docs/manual.html#generics-implicit-generics)

## tuples
- lexical order of fields with few abstractions
- structurally equivalent if the order & field types match
- similar to objects sans inheritance, + unpacking + more dynamic + fields always public
- structural equality check
  - tuples of diff types are == if fields have same type, name and order
  - anonymous tuples are compatible with tuples with field names if type matches
- instantiation must match order of fields in signature
- instantiation doesnt require field names
- field access by name/index (const int)

## objects
- complex tuples without lexical ordering (lol my definition)
- provide inheritance & hidden fields > tuples
- nominally equivalent
- enum and object types may only be defined within a type statement.
- traced by the garbage collector, no need to free them when allocated
- each object type has a constructor
- when instantiated unspecified fields receive the field types default value
- only private fields require exported get/setters

## type aliases
- are identical & auto cast to their base

## type aliases (distinct)
- a type derived from a base type but incompatible with its base type
- i.e. does not create inheritance with its base type but is expected to match its structure
  - you can {.borrow.} fields/procs/etc from the base type
  - else you must explicity redefine everything
- base and distinct can be cast to eachother

## table
- syntactic sugar for an array constructor
- {"k": "v"} == [("k", "v")]
- {key, val}.newOrderedTable
- empty table is {:} in contrast to a set which is {}
- the order of (key,val) are preserved to support ordered dicts
- can be a const which requires a minimal amount of memory

## ref
- generic traced pointer type mem is gc'ed on heap
- generally you should always use ref objects with inheritance
- non-ref objects truncate subclass fields on = assignment
- since objs are value types, composition is as efficient as inheritance
- dont have to label ref objects as var in proc signatures to mutate them

## ptr
- generic untraced pointer type
- untraced references (are unsafe), pointing to manually managed memory locations
- required when accessing hardware/low-level ops

## ref/pter procs
- . and [] always def-ref, i.e. return the value and not the ref
- . access tuple/object
- new(T) object of type T and return a traced ref, when T is a ref the result type will be T, else ref T
- new[T](a) object of type T and return a trace reference to it in a
- new[T](a; finalizer) same as before, but this time finalizer is called a is gc'ed
- of i.e. instanceof creates a single layer of inheritance between types
- as
- in notin is isnot
- isNil(x) sometimes more efficient than == nil

## inheritance (ref/ptr)
- introduce many-to-one relationships: many instances point to the same heap
- reference equality check
- base types should ref RootObj/a type that does
  - else they are implictly `final`
  - RootRef is a reference to RootObj (root of nims object hierachy, like javascripts object)
- objects can be self-referencing
- use the [] operator when logging the object (see strutils)

## dynamic dispatch
- generally only required with ref/ptr objects
- use method whenever an object has an inherited subtype only known at runtime

## multi-methods
- occurs when multiple overloaded procs exist with different signatures
- however they are still ambiguous because of inheritance
- you have to use --multimethods:on when compiling

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

## variants
- preferred over an object hierarchy with multiple levels
- when simple variants (based on some discriminate field) will suffice

## recursive types
- objects, tuples and ref objects that recursively depend on each other
- must be declared within a single type section

## type classes
- pseudo type that can be used to match via the is operator
- object, tuple, enum, proc, ref, ptr, var, distinct, array, set, seq auto
- in addition, every generic type creates a type class of the same name

## typedesc
- since nim treats the names of types as regular values in certain contexts in the compilation phase
- typedesc is a generic type for all types denoting the type class of all types
- procs using typedesc params are implicitly generic

]##

echo "############################ tables"
var myTable = {"fname": "noah", "lname": "hall"}
echo "my name is: ", $myTable
# TODO: find this in the docs somewhere, this seems a bit rediculouos
# ^ lol you can get the key via blah["key"] with hashtables
# @see https://nim-lang.org/docs/tables.html
echo "my firstname is: ", myTable[0][1]

echo "############################ tuple fixed length"
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
  ("intermediate", "senior", "beginner")
echo "rate yourself on bizDevOps: ", bizDevOps

# tuples can be destructured (unpacked)
let (bizRating, devRating, opsRating) = bizDevOps
echo "rate yourself on bizDevOps: ", bizRating, " ", devRating, " ", opsRating
let (first, _, third) = bizDevOps
echo "skipped the second item ", first & " " & third

# copied from docs
# even in loops
let aaa = [(10, 'a'), (20, 'b'), (30, 'c')]
for (x, c) in aaa:
  echo x # This will output: 10; 20; 30
for i, (x, c) in aaa:
  echo i, c # Accessing the index is also possible


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

echo "############################ object"
type
  PrivatePoop = object
    i*: bool # field i dont think is visible because the type isnt
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

# overload dollars for custom toString
proc `$`(self: Someone): string =
  "my name is, " & self.name & " and i was born on " & self.bday

echo $you


echo "############################ Properties: object getter/setters"
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

echo "############################ type bound operators"
# todo

echo "############################ ref"
# see inheritance

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
# todo

echo "############################ nil"
# if a ref/ptr points to nothing, its value is nil
# thus use in comparison to prove not nil

echo "############################ inheritance: ref / ptr"
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
echo "is sherlockpoops[0] nil? ", isNil(sherlockpoops[0])

echo "############################ dynamic dispatch"
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
# use methods because at runtime we need to know the type
method eval(e: Literal): int = e.x
method eval(e: PlusExpr): int = eval(e.a) + eval(e.b)
# these procs dont need dynamic binding
proc newLit(x: int): Literal = Literal(x: x)
proc newPlus(a, b: Expression): PlusExpr = PlusExpr(a: a, b: b)

echo eval(newPlus(newPlus(newLit(1), newLit(2)), newLit(4)))

# you can force call the base method via procCall someMethod(a,b)

echo "############################ multi-methods"
# copied from docs
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
# there both Units, but collide doesnt have an overload specifically for that
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


echo "############################ recursive types"
# copied from docs
type
  Node = ref object  # a reference to an object with the following field:
    le, ri: Node     # left and right subtrees
    sym: ref Sym     # leaves contain a reference to a Sym

  Sym = object       # a symbol
    name: string     # the symbol's name
    line: int        # the line the symbol was declared in
    code: Node       # the symbol's abstract syntax tree

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

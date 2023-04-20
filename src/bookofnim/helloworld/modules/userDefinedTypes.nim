## user defined types
## ==================

##[
## TLDR
- objects, tuples and enums are used to define custom types
- if a ref/ptr points to nothing, its value is nil
- enum and object types may only be defined within a type statement
- tuples vs objects
  - tuples
    - structurally equivalent: order and type of fields must match
    - all fields are public
    - can be destructured/unpacked
    - lexical ordering of fields are maintained
    - field access by name/index (const int)
    - can be anonymous and dont require a type statement
  - objects
    - provide inheritance & hidden fields
    - nominally equivalent: type name must match
    - provide inheritance
    - field access by name

links
-----
- [distinct type aliases](https://nim-lang.org/docs/manual.html#types-distinct-type)
- [inheritance](https://nim-lang.org/docs/manual.html#type-relations)

todos
-----
- add a testfile
- import in bookofnim.nim
- update readme
- object variants (reread the docs, couldnt get working)

## base types
- used to construct custom types

objects
-------
- ref/ptr objects can use of to distinguish between types
- traced by the garbage collector, no need to free them when allocated
- each object type has a constructor
- when instantiated unspecified fields receive the field types default value
- only private fields require exported get/setters


tuples
------
- fixed-length; maintain lexical order of fields
- similar to objects sans inheritance, + unpacking + more dynamic + fields always public
- instantiation must match order of fields in signature (field name not required)


enum
----
- A variable of an enum can only be assigned one of the enum's specified values
- enum values are usually a set of ordered symbols, internally mapped to an integer (0-based)
- $ convert enum index value to its name
- ord convert enum name to its index value
- its idiomatic nim to have ordinal enums (0, 1, 2, 3, etc)
  - and not assign disjoint values (1, 5, -10)

## inheritance
- introduce many-to-one relationships: many instances point to the same heap
- reference equality check
- base types should ref RootObj/a type that does
  - else they are implictly `final`
  - RootRef is a reference to RootObj (root of nims object hierachy, like javascripts object)
- objects can be self-referencing
- use the [] operator when logging the object (see strutils)
- when both ref & non-ref exist for the same type, end each type name with Obj/Ref

ref
---
- generic traced pointer type mem is gc'ed on heap
- generally you should always use ref objects with inheritance
- non-ref objects truncate subclass fields on = assignment
- since objs are value types, composition is as efficient as inheritance
- dont have to label ref objects as var in proc signatures to mutate them

ptr
---
- generic untraced pointer type
- untraced references (are unsafe), pointing to manually managed memory locations
- required when accessing hardware/low-level ops

ref/pter procs
--------------
- . and [] always def-ref, i.e. return the value and not the ref
- . access tuple/object
- new(T) object of type T and return a traced ref, when T is a ref the result type will be T, else ref T
- new[T](a) object of type T and return a trace reference to it in a
- new[T](a; finalizer) same as before, but this time finalizer is called a is gc'ed
- of i.e. instanceof creates a single layer of inheritance between types
- as
- in notin is isnot
- isNil(x) sometimes more efficient than == nil for pter types


dynamic dispatch
----------------
- generally only required with ref/ptr objects
- use method whenever an object has an inherited subtype only known at runtime

multi-methods
-------------
- occurs when multiple overloaded procs exist with different signatures
- however they are still ambiguous because of inheritance
- you have to use --multimethods:on when compiling

## variants
- preferred over an object hierarchy with multiple levels when simple variants suffice

## recursive types
- objects, tuples and ref objects that recursively depend on each other
- must be declared within a single type section
]##

{.push
  hint[XDeclaredButNotUsed]: off,
  hint[GlobalVar]: off,
  hint[Name]: off
.}
echo "############################ object"
# exporting fields with *
# overload dollars $ for custom types

type
  Computer = object
    os: string
    de: string
    wm: string

type
  DistroObj = object
    computer: Computer
  DistroRef = ref DistroObj

echo "############################ getter/setters"
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


echo "############################ tuple"
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


echo "############################ enums"
type AmericaOfJobs = enum
  nineToFives, fiveToNines, twentyFourSeven # order matters: assigned as 0,1,2

# you can assign custom string values for use with $ operator
type PeopleOfAmerica {.pure.} = enum
  coders = "think i am",
  teachers = "pretend to be",
  farmers = "prefer to be",
  scientists = "trying to be"

# you can assign both the ordinal and string value
type ExplicitEnum = enum
  AA = (0, "letter AA"),
  BB = (1, "letter BB")

echo ExplicitEnum.AA # letter AA
echo twentyFourSeven # impure so doesnt need to be qualified
echo PeopleOfAmerica.coders # coders needs to be qualified cuz its labeled pure

# enum iteration via ord
for i in ord(low(AmericaOfJobs))..
        ord(high(AmericaOfJobs)):
  echo AmericaOfJobs(i), " index is: ", i
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


echo "############################ ref"
type
  Someone = object
    name: string
    bday: string
    age: int

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

method baseMethod(self: SomeoneRef): bool {.base.} =
  # override this base method
  raise newException(CatchableError, "Method without implementation override")

echo "############################ ptr"
# todo


echo "############################ inheritance: ref / ptr"
type WhoWoop = ref object of RootObj
    name: string
type YouWoop = ref object of WhoWoop
type IWoop = ref object of WhoWoop

# overload procs by changing the signature
proc did_i_woop(self: WhoWoop): string  =
  "i dont know"
proc didiwoop(self: YouWoop): string =
  self.name & " is a filthy animal"
proc dIdIwoop(self: IWoop): string =
  self.name & " has evolved passed wooping"


# this has to be `var` to enable adding subtypes
# let throws error because You/IWoop arent WhoWoops
# const doesnt work at all and im not sure why but its a compile time issue
var sherlockwoops: seq[WhoWoop] = @[]
sherlockwoops.add(YouWoop(name: "spiderman"))
sherlockwoops.add(IWoop(name: "noah"))
for criminal in sherlockwoops:
  # echo $criminal doesnt work because $ doesnt exist on RootObj
  echo criminal.dIDIwoop

# type checking
if sherlockwoops[0] of YouWoop: echo "filthy animal" else: echo "snobby bourgeois"
echo "is sherlockwoops[0] nil? ", isNil(sherlockwoops[0])

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
# they're both Units, but collide doesnt have an overload specifically for that
# so which will be used? type preference occurs from left -> right
collide(aaaa, bbbb)

echo "############################ variants"
# better example @see https://nim-lang.org/docs/json.html#JsonNodeObj
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

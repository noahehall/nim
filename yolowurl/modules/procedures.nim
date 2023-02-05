
echo "############################ procedures"
# special return types
# ^ auto = type inference
# ^ void = nothing is returned, no need to use discard
# returning things: (cant contain a yield statement)
# ^ use return keyword for early returns
# ^ result = sumExpression: enables return value optimization & copy elision
# ^ if return/result isnt used last expression's value is returned
# overload: redeclare with different signature
# args passed to procs are eagerly evaluated
# ^ see templates for lazy evaluation
proc pubfn*(): void =
  echo "the * makes this fn public"

# params with defaults dont requre a type
proc eko(this = "Default value"): void =
  debugEcho this
eko "wtf1"
eko("wtf2")
"wtf3".eChO

# use of semi to group parameters by type
proc ekoGroups(a, b: int; c: string, d: char): void =
  echo "ints: ", a, b, " strings: ", c, d
ekogroups 1, 2, "c", 'd'
# requires parenths for named args
ekogroups(b = 2, a = 1, c = "c is named, but d param isnt", 'd')

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

# calling syntax impacts type compatability
# ^ I cant seem to get this to throw an error
# ^ read the docs (manual) and figure this out
# ^ @see https://nim-lang.org/docs/manual.html#types-procedural-type
proc greet(name: string): string =
  "Hello, " & name & "!"
proc bye(name: string): string =
  "Goodbye, " & name & "."
proc communicate(greeting: proc (x: string): string, name: string) =
  echo greeting(name)
communicate(greet, "John")
communicate(bye, "Mary")
echo "############################ openarray (proc params)"
# proc signature type only enabling accepting an array of any length
# ^ but only 1 dimension, i.e. wont accept a nested arr/seq
# always index with int and starting at 0
# array args must match the param base type, index type is ignored
# arrays and seqs are implicity converted for openArray params

# copied from docs
var
  fruits: seq[string] # reference to a sequence of strings that is initialized with '@[]'
  capitals: array[3, string] # array of strings with a fixed size

capitals = ["New York", "London", "Berlin"] # array 'capitals' allows assignment of only three elements
fruits.add("Banana") # sequence 'fruits' is dynamically expandable during runtime
fruits.add("Mango")

proc openArraySize(oa: openArray[string]): int =
  oa.len

# procedure accepts a sequence as parameter
echo "size of fruits ", openArraySize(fruits)
# but also an array type
echo "number of capitals ", openArraySize(capitals)

echo "############################ varargs (proc spread params)"
# enables passing a variable number of args to a proc param
# the args are converted to an array if the param is the last param

# haha almost forgot the _ doesnt matter
# s  == seq[string]
proc eko_all(s: varargs[string]) =
  for x in s:
    echo "var arg: ", x
e_k_o_a_l_l "this", "that", "thot"

# `$` second param converts each item to string
# s == seq[string] no matter what we pass
proc eko_anything(s: varargs[string, `$`]) =
  for x in s:
    echo x
eKoAnyThInG 1, "threee", @[1,2,3]

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


echo "############################ template "
# enables raw code substitution on nim's abstract syntax tree
# are processed in the semantic pass of the compiler
# accepts meta types: @see https://nim-lang.org/docs/tut3.html
# ^ untyped: lookup symbols & perform type resolution after the expression is interpreted & checked
# ^^ use to pass a block of statements
# ^ typed: semantic checker evaluates and transforms args before expression is interprted & checked
# ^^ basically opposite of typed, lol which now makes sense
# ^ type: i.e. you set the type in the signature

# copied from docs
template `!=` (a, b: untyped): untyped =
  # it will replace a & b with the a and b operands to !=
  # then replace a != b in the original with the below template
  not (a == b)
# thats how the compiler rewrites below to: assert(not (5 == 6))
assert(5 != 6)

# lazy evaluation of proc args
const debug = true
var xy = 4
# msg arg is evaluted before the fn is evoked
proc log_eager(msg: string) {.inline.} =
  if debug: stdout.writeLine(msg)
# the template is processed before msg arg
# so if debug is false, msg wont be evaluted
template log_lazy(msg: string) =
  if debug: stdout.writeLine(msg)

logEager("x has the value: " & $xy) # & and $ are expensive! only use with lazy templates
logLazy("x has the value: " & $xy)

# copied from docs
# example of using untyped to get a block of statements
# the block statements are bound to the body param
template blockRunner(please: bool, body: untyped): void =
  let theyAskedNickely = please # reassign please so its only evaluted once
  if theyAskedNickely:
    try:
      body
    finally:
      echo "maze runner was okay, should have been better"
  else:
    echo "you forgot to say please"

blockRunner true:
  echo "number 1"
  echo "number 2"
blockRunner false:
  echo "i dont say please"
  echo "do or you will die a horrible death"

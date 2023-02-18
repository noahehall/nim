##
## sugar deep dive
## ===============
## keeping nim sweet

##[
TLDR
- syntactic sugar based on nims macro system
- -> sugar for type defs
- => sugar for procs

links
- [sugar](https://nim-lang.org/docs/sugar.html)
- [with](https://nim-lang.org/docs/with.html)
- [algorithms](https://nim-lang.org/docs/algorithm.html)

todos
- macro capture(locals: varargs[typed]; body: untyped): untyped
  - capture local variables for use in a closure
- macro dump(x: untyped): untyped
- macro dumpToString(x: untyped): string
- macro dup[T](arg: T; calls: varargs[untyped]): T
  - echo for debugging expressions, prints the expression textual representation
- algorithms link
]##


echo "############################ sugar"
import std/sugar

proc runFn(x: string, fn: (string) -> string): string =
  ## -> type declarations; doesnt support semicolons
  ## blah -> blah | blah {.somePragma.} -> blah
  fn x

let myLambda = (s: string) {.noSideEffect.} => "hello " & s ## \
  ## => macro: anonymous procs, same restraints as ->
proc myProc(s: string): string = s & " it indeed works with procs too"

echo runFn("noah", myLambda)
echo runFn("this string", (x) => "your string was: " & x)
echo runFn("hall", myProc)

# macro collect(body: untyped): untyped
# macro collect(init, body: untyped): untyped
# ^ add values to seqs/sets/tables
# you can pass an init value, e.g. collect(blah): ...
const myRange = 1..10

const mySeq = collect:
  ## collect things into a sequence
  for i in myRange: i
echo "sugary seq: " & $mySeq

import std/[sets]
const myHashSet = collect:
  for i in myRange: {i}
echo "sugary unordered hashSet: " & $myHashSet

import std/[tables]
const myTable = collect:
  for i in myRange: {i: i*2}
echo "sugary table: " & $myTable


echo "############################ sort algorithms"
import std/algorithm
# cmp is useful for writing generic algs without perf loss
# cmpMem is available for pointer types
echo "echo sort seq[int] with cmp[int] ", sorted(@[4, 2, 6, 5, 8, 7], cmp[int])

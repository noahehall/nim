##
## sugar deep dive
## ===============
## [bookmark](https://nim-lang.github.io/Nim/wrapnils.html)

##[
## TLDR
- the sweetest nim syntax
- the fusion pkg provides additional sugar, but its modules are dispersed through other files
- working with data structures (e.g. sorting) generally requires std/algorithm

links
-----
- high impact
  - [sugar](https://nim-lang.org/docs/sugar.html)
  - [with](https://nim-lang.org/docs/with.html)
  - [algorithm](https://nim-lang.org/docs/algorithm.html)
  - [enumarate any collection](https://nim-lang.org/docs/enumerate.html)
  - [wrapnils optional chaining](https://nim-lang.github.io/Nim/wrapnils.html)
  - [system do notation](https://nim-lang.org/docs/manual_experimental.html#do-notation)
- niche
  - [import private symbols](https://github.com/nim-lang/Nim/blob/devel/lib/std/importutils.nim)

TODOs
-----
- std/wrapnils: optional chaining
- macro capture(locals: varargs[typed]; body: untyped): untyped
  - capture local variables for use in a closure
- macro dump(x: untyped): untyped
- macro dumpToString(x: untyped): string
- macro dup[T](arg: T; calls: varargs[untyped]): T
  - echo for debugging expressions, prints the expression textual representation
- std/algorithm
  - then review all the sort procs for each datatype (they all depend on algo)

## do blocks and proc fn signatures
- do blocks can be considered an alias for `block:`
- proc expressions can use do notation when passed as a parameter to a proc
- can also be used to pass multiple blocks to a macro
- i.e.
  - do with paranthesis is an anonymous proc
  - do without paranthesis is just a block of code

## sugar

sugar procs
-----------
- -> for type defs in proc signatures
- => for lambdas
]##


echo "############################ do"

echo do: "this expression"

## expects a proc
proc echoThis(a: proc (x: string): string): void =
  echo a("expression")
# we pass a proc via do
# the () on echoThis isnt required
echoThis do (x:string) -> string:
  "this " & x


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
# recommended over map & filter/etc
const myRange = 1..10

const mySeq = collect:
  ## oneliner from os docs: collect(for k in walkDir("dirA"): k.path).join(" ")
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


echo "############################ algorithm"
import std/algorithm

# cmp is useful for writing generic algs without perf loss
# cmpMem is available for pointer types
echo "sort seq[int] with cmp[int] ", sorted(@[4, 2, 6, 5, 8, 7], cmp[int])

proc cmpCustom[T](x, y: T): int =
  ## return 0, -1 or 1 for custom sorts
  ## requires == and < operators defined for type T
  result = if x == y: 0 elif x < y: -1 else: 1

echo "using custom cmp proc ", sorted(@[4, 2, 6, 5, 8, 7], cmpCustom[int])

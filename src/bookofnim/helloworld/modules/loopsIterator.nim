## loops and iterators
## ===================

##[
## TLDR
- iterators are included, as their only used with loops
  - the parallel iterator is in asyncParMem
- for loops can iterate over any iterator

links
-----
- [iterators](https://nim-lang.org/docs/iterators.html)
- [iterator tut](https://nim-by-example.github.io/for_iterators/)
- [closureScope](https://nim-lang.org/docs/system.html#%7C%7C.i%2CS%2CT%2Cstaticstring)
- [status iterator docs](https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#iterators)

todos
-----
- [nim by example: closure iterators](https://nim-by-example.github.io/for_iterators/)
- iterToProc

## loop/iterator related procs
- finished determine if a first class iterator has finished
- countup  == `..` == `..<` (zero index countup)
- countdown  == `..^` == `..^1` (zero index countdown)
- items for i blah.items:
- pairs for i,z blah.pairs:
- low(blah) .. high(blah)

## iterators
- inlined at the callsite when compiled
  - do not have the overhead from function calling
  - prone to code bloat
  - useful for defining custom loops on complex objects
- can be used as operators if you enclose the name in back ticks
- can be wrapped in a proc with the same name to accumulate the result and return it as a seq
- distinction with procs
  - can only be called from loops
  - uses yield instead of return keyword
  - doesnt have an implicit result
  - dont support recursion
  - cant be forward declared
]##

{.push hint[GlobalVar]:off .}

echo "############################ iterators "
# iterable[T] an expression that yeilds T
iterator `...`*[T](a: T, b: T): T =
  var res: T = a
  while res <= b:
    yield res # enables returning a value without exiting
    inc res # we can continue because of yield

for i in 0...5: echo "useless iterator ", i

iterator countTo(n: int): int =
  var i = 0
  while i <= n: yield i; inc i

for i in countTo(5): echo i

# std collection iterators
# items/mitems : immutable/mutable, just the value
for item in "noah".items: echo "item is ", item

# pairs/mpairs: immutable/mutable index & item
for index, item in ["a","b"].pairs: echo item, " at index ", index

# fields: immutable items of containers
for field in ("first", "second").fields: echo field

# fieldPairs: immutable key, value of containers
for k, v in ("first", "second").fieldPairs: echo k, v

# copied from docs: finished proc
iterator mycount(a, b: int): int {.closure.} =
  var x = a
  while x <= b:
    yield x
    inc x
# case 1: finished is error prone
# ^ it only returns true AFTER the iteration is finished
var finishedIncorrect = mycount # instantiate the iterator
while not finished(finishedIncorrect):
  echo "incorrect finished usage: ", finishedIncorrect(1, 3) # 1,2,3,0

# case 2: correct usage for finished
# ^ here we break out of the loop
var finishedCorrect = mycount # instantiate the iterator
while true:
  let value = finishedCorrect(1, 3)
  if finished(finishedCorrect): break # and discard 'value'!
  echo "correct finished usage: ", value # 1,2,3

echo "############################ for"
# loops over iterators
for i in 1..5: echo "loop .. " & $i
for i in 1 ..< 5: echo "loop ..< ", i
for i in countup(0,10,2): echo "evens only ", i # alias for ..
for i in countdown(11,0, 2): echo "odds only ", i
for i in "noah": echo "spell my name spell my name when your not around me ", i
for i, n in "noah": echo "index ", i, " is ", n

let intArr = [5,4,3,2,1]
for i in low(intArr) .. high(intArr): echo "index ", i, " in nums = ", intArr[i]

echo "############################ while"
var num6 = 0
while num6 < 10: # break, continue work as expected
  echo "inc num6 is ", num6
  inc num6

while num6 > Natural.low:
  echo "dec num 6 is ", num6
  dec num6

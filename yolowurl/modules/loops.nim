
#[
  @see
    - https://nim-lang.org/docs/iterators.html


  iterator procs
    - finished determine if a first class iterator has finished
]#

echo "############################ iterators "
# inlined at the callsite when compiled
# ^ do not have the overhead from function calling
# ^ prone to code bloat
# ^ useful for defining custom loops on complex objects
# can be used as operators if you enclose the name in back ticks
# can be wrapped in a proc with the same name to accumulate the result and return it as a seq
# distinction with procs
# ^ can only be called from loops
# ^ cant contain a return statement
# ^ doesnt have an implicit result
# ^ dont support recursion
# ^ cant be forward declared
# @see https://nim-by-example.github.io/for_iterators/
# @see https://nimbus.guide/auditors-book/02.1_nim_routines_proc_func_templates_macros.html#iterators

# iterable[T] an expression that yeilds T
iterator `...`*[T](a: T, b: T): T =
  var res: T = a
  while res <= b:
    yield res # enables returning a value without exiting
    inc res # we can continue because of yield

for i in 0...5:
  echo "useless iterator ", i


iterator countTo(n: int): int =
  var i = 0
  while i <= n:
    yield i
    inc i
for i in countTo(5):
  echo i

# iterator: closures
# basically javascript yield
# have state and can be resumed
# @see https://nim-by-example.github.io/for_iterators/

# std count iterators
# countup == .. == ..< (zero index countup)
# countdown == ..^ == ..^1 (zero index countdown)

# std collection iterators
# items/mitems : mutable/immutable, just the value
for item in "noah".items:
  echo "item is ", item
# pairs/mpairs: mutable/immutable index & item
for index, item in ["a","b"].pairs:
  echo item, " at index ", index

echo "############################ for"
# loops over iterators
for i in 1..2:
  echo "loop " & $i
for i in 1 ..< 2:
  echo "loop ", i
for i in countup(0,10,2):
  echo "evens only ", i
for i in countdown(11,0, 2):
  echo "odds only ", i
for i in "noah":
  echo "spell my name spell my name when your not around me ", i
for i, n in "noah":
  echo "index ", i, " is ", n

let intArr = [5,4,3,2,1]
for i in low(intArr) .. high(intArr):
  echo "index ", i, " in nums = ", intArr[i]

echo "############################ while"
var num6 = 0
while num6 < 10: # break, continue work as expected
  echo "num6 is ", num6
  inc num6

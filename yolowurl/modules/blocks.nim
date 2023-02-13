## blocks
## ======

##[
TLDR
----
- blocks have a () syntax but we skipped it as its not idiomatic nim in this context
- scope starts after the : symbol, and ends when the indentention returns to previous level
- named blocks have similar usescases to javascript
- like most other things, blocks can be expressions and assigned to a var
- see loopIterator.nim for closureScope blocks

do blocks
---------
- you should probably read the docs on do blocks

once blocks
-----------
- are executed once, the first time their seen by the compiler
]##

echo "############################ block"

let sniper = "scope parent" ## \
  ## is in the global scope
block: ## \
  ## creates new scope
  let sniper = "scope private" ## local
  echo sniper
echo sniper ## global scoped

block poop:
  var count = 0
  while true:
    while true:
      while count < 5:
        echo "I took ", count, " poops"
        count += 1
        if count > 2: ## dont want to take too many
          break poop

var stupidChar = block:
  var dumbChar = 'a'
  if dumbChar in {'a', 'b', 'c'}:
    echo "dumbChar is in alphabeta ", dumbChar
  ord(dumbChar)
echo "im running out of silly examples ", ord(stupidChar) == ord(true)

echo "############################ do"

echo do:
  "this ting"

echo "############################ once"

once:
  echo "this the first time this block is reached"

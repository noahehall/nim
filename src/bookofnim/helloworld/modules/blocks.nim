## blocks
## ======

##[
## TLDR
- blocks have a () syntax but we skipped it as its not idiomatic nim in this context
- scope starts after the : symbol, and ends when the indentention returns to previous level
- named blocks have similar usescases to javascript
- like most other things, blocks can be expressions and assigned to a var
- see loopIterator.nim for closureScope blocks

links
-----
- [block statements](https://nim-lang.org/docs/manual.html#statements-and-expressions-block-statement)
- [block expressions](https://nim-lang.org/docs/manual.html#statements-and-expressions-block-expression)
- [once template](https://nim-lang.org/docs/system.html#once.t%2Cuntyped)

todos
-----
- have no clue where `do:` is within the documentation
  - but from the context looks like its just an alias for `block:`

## do blocks
- see todos

## once blocks
- are executed once, the first time their seen by the compiler
]##

echo "############################ block"

let sniper = "scope module" ## is in the module scope, global to this module
block:
  let sniper = "scope private" ## block scope, not visible to module
  echo sniper
echo sniper

block myblock:
  var count = 0
  while true:
    while true:
      while count < 5:
        echo "everyone say", count, " woop woop"
        count += 1
        if count > 2:
          break myblock

let myChar = block:
  var yourChar = 'a'
  if yourChar in {'a', 'b', 'c'}:
    echo "yourChar was found ", yourChar
  yourChar # last expression is returned
echo "can I sit in your char, i mean chair " & $myChar

echo "############################ do"

echo do: "this expression"

echo "############################ once"

once:
  echo "this the first time this block is reached"

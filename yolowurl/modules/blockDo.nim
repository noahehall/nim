
echo "############################ block"
# theres a () syntax but we skipped it as its not idiomatic nim in this context
# introducing a new scope
let sniper = "scope parent"
block:
  let sniper = "scope private"
  echo sniper
echo sniper

# break out of nested loops
block poop:
  var count = 0
  while true:
    while true:
      while count < 5:
        echo "I took ", count, " poops"
        count += 1
        if count > 2: # dont want to take too many
          break poop

# like ifs and whens, blocks can also be expressions
var stupidChar = block:
  var dumbChar = 'a'
  if dumbChar in {'a', 'b', 'c'}:
    echo "dumbChar is in alphabeta ", dumbChar
  ord(dumbChar)
echo "im running out of silly examples ", ord(stupidChar) == ord(true)

echo "############################ do"
# you have to read the docs on this one
echo do:
  "this ting"

echo "############################ once"

once:
  echo "this the first time this block is reached"

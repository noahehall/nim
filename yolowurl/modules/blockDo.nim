
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

echo "############################ do"
# you have to read the docs on this one
echo do:
  "this ting"

## branching: if when case
## =======================

##[
## TLDR
- new scopes are introduced immediately aftered the keywords (e.g. if, elif, etc)
  - except for when statements/expressions
- use whens for completely removing sections of code at compile time
- all can be used as expressions and the result assigned to a var
- case statement branches should be listed in order of most expected

branching todos
---------------
- [likely](https://nim-lang.org/docs/system.html#likely.t%2Cbool)
- [unlikely](https://nim-lang.org/docs/system.html#unlikely.t%2Cbool)

## when
- a compile time if statement
- the condition MUST be a constant expression
- does not open a new scope
- only the first truthy value is compiled

## case
- similar to if, but represents a multi-branch selection
- supports strings, ordinal types and integers
  - ints/ordinals can also use ranges
  - the `of` part must match the value type
- can also use elif, else branches
]##

echo "############################ if"
if not false: echo "true": else: echo "false"

# difficult to read, but note the placement of :
echo if 1 > 2: "its true" elif 2 < 1: "also true" else: "must be the multiverse"

# another funny one
if 11 < 2 or (11 == 11 and 'a' >= 'b' and not true or false ):
  echo "no clue"
elif "woop" == "poow": echo "poows arent woops"
else: echo "you are the holy one"

echo "############################ when"
# think this is as copypasta from docs
when system.hostOS == "windows":
  echo "running on Windows!"
elif system.hostOS == "linux":
  echo "running on Linux!"
elif system.hostOS == "macosx":
  echo "running on Mac OS X!"
else:
  echo "unknown operating system"

when isMainModule:
  # true if the module is compiled as the main file
  # useful for embedding tests within the module
  assert true == true

var whichVerse:string = when 1 > 2: "real world" else: "twitter verse"
echo "i live in the " & whichVerse

when false: # trick for commenting code
  echo "this code is never run and not required to be commented out"

# check if execution is compiletime or runtime (executable)
# likely got this from the docs too
when nimvm:
  echo "in nim's vm, so its compile time"
else:
  echo "I must be running after compilation via an executable"

echo "############################ case expressions"
var numCase = 50.345
echo case numCase
  of 2: "of 2 satisifes float 2.0" # ofs must a constant expression
  of 2.0: "is float 2.0" # if we switch to devel branch this throws duplicate
  of 5.0, 6.0:
    {.linearScanEnd.} # signify the end of likely scenarios
    "float is 5 or 6.0"
  of 7.0..12.9999: "wow your almost a teenager"
  elif numCase in 13.00 .. 51.00: "just made it!" # must come after of statements
  else: "not all cases covered: compile error if we dont discard" # required for non-ordinal types

case 'a'
of 'b', 'c': echo "char 'a' isnt of char 'b' or 'c'"
else: discard

#[
  case num2:
  of 2.0: echo "type mispmatch because num2 is int"
]#
proc positiveOrNegative(num: int): string =
  result = case num: # <-- case is an expression
    of low(int).. -1: # <--- check the low proc
      "negative"
    of 0:
      "zero"
    of 1..high(int): # <--- check the high proc
      "positive"
    else: # <--- this is unreachable, but doesnt throw err
      "impossible"

echo positiveOrNegative(-1)

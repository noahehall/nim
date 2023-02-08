#[
  todos
    likely @see https://nim-lang.org/docs/system.html#likely.t%2Cbool
    unlikely @see https://nim-lang.org/docs/system.html#unlikely.t%2Cbool
]#
echo "############################ if"
# if
if not false: echo "true": else: echo "false"
if 11 < 2 or (11 == 11 and 'a' >= 'b' and not true):
  echo "or " & "true"
elif "poop" == "boob": echo "boobs arent poops"
else: echo false

echo "############################ when"
# a compile time if statement
# the condition MUST be a constant expression
# does not open a new scope
# only the first truthy value is compiled
when system.hostOS == "windows":
  echo "running on Windows!"
elif system.hostOS == "linux":
  echo "running on Linux!"
elif system.hostOS == "macosx":
  echo "running on Mac OS X!"
else:
  echo "unknown operating system"



when false: # trick for commenting code
  echo "this code is never run"

echo "############################ case expressions"

# can use strings, ordinal types and integers, ints/ordinals can also use ranges
echo case num3
  of 2: "of 2 satisifes float 2.0"
  of 2.0: "is float 2.0"
  of 5.0, 6.0: "float is 5 or 6.0"
  of 7.0..12.9999: "wow your almost a teenager"
  else: "not all cases covered: compile error if we dont discard"

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

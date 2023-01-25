#[
  getting back up to speed on nim
]#

# strings
var msg: string = "yolo"
echo msg & " wurl" # returns a new string
msg.add(" wurl") # modifies the string in place
echo msg


# number types
const num1: int = 2
const num2: int = 4
echo "4 / 2 === ", num2 / num1
echo "4 div 2 === ", num2 div num1

const num3 = 2.0
const num4: float = 4.0
const num5: float = 4.9
echo "4.0 / 2.0 === ", num4 / num3
echo "4.0 div 2.0 === ", "gotcha: div is only for integers"
echo "conversion acts like javascript floor()"
echo "int(4.9) div int(2.0) === ", int(num5) div int(num3)

# control flow: branching
if not false: echo "true": else: echo "false"
if 11 < 2 or (11 == 11 and 'a' >= 'b' and not true):
  echo "or " & "true"
elif "poop" == "boob": echo "boobs arent poops"
else: echo false

when true:
  echo "evaluated at compile time"

case num3
of 2:
  echo "of 2 satisifes float 2.0"
of 2.0: echo "is float 2.0"
else: discard

case 'a'
of 'b', 'c': echo "char 'a' isnt of char 'b' or 'c'"
else: echo "not all cases covered: compile error if we remove else:discard"

#[
  case num2:
  of 2.0: echo "type mispmatch because num2 is int"
]#

# control flow: loops
for i in 1..2:
  echo "loop " & $i # & concat nor $ conversion required
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

var num6 = 0
while num6 < 10: # break, continue work as expected
  echo "num6 is ", num6
  inc num6

###### structs

# fixed-length homogeneous arrays
var
  nums: array[4, int] = [1,9,8,5]
  smun = [5,8,9,1]
  emptyArr: array[4, int]

# dynamic-length homogeneous sequences
var
  poops: seq[int] = @[1,2,3,4]
  spoop = @[4,3,2,1]
  emptySeq: seq[int]
  seqEmpty = newSeq[int]()

poops.add(5)
echo poops
spoop.add(poops)
echo spoop.len
echo "first ", poops[0]
echo "first ", poops[0 ..< 1]
echo "first 2", poops[0 .. 1]
echo "last ", poops[^1]

var me = "noAH"
me[0 .. 1] = "NO"
echo "change first 2 els ", me

# fixed length hetergenous tuples
let js = ("super", 133, 't')
echo js

var sj = (iz: "super", wha: 133, t: 't')
sj.iz = "duper"
debugEcho "you are ", sj[0] & $sj.wha & $sj.t


#### procedures
proc eko(this: string): void =
  debugEcho this
eko "wtf"
eko("wtf")

proc redurn(this: string): string =
  return this
debugEcho redurn "Wtf"

proc mutate(this: var int): int =
  this += 5
  return this
# error: 5 is not mutable
# debugEcho mutate 5
var num7 = 5
debugEcho mutate num7, num7.mutate, mutate(num7)

proc add5(num: int): int =
  result = num + 5 # returned implicitly
debugEcho add5 5, 5.add5.add5, add5 add5(5).add5

# forward declaration
proc allInts(x,y,z: int): int
echo allInts(1, 2, 3) # used before defined
proc allInts(x, y, z: int): int =
  result = x + y + z


echo "############################ tuple fixed length hetergenous"
# similar to objects sans inheritance, + unpacking + more dynamic + fields always public
# structural equality check
# ^ tuples of diff types are == if fields have same type, name and order
# ^ anonymous tuples are compatible with tuples with field names if type matches
# instantiation must match order of fields in signature
# instantiation doesnt require field names
# field access by name/index (const int)

type
  # object syntax
  NirvStack = tuple
    fe: seq[string]
    be: seq[string]
  # tuple syntax
  StackNirv = tuple[fe: seq[string], be: seq[string]]

# no names required
var hardCoreStack: NirvStack = (@["ts"], @["ts, bash"])
# if provided, order must match signature
var newCoreStack: StackNirv = (fe: @["ts", "nim"], be: @["ts", "nim", "bash"])

# anonymous field syntax
let js = ("super", 133, 't')
echo js

var sj = (iz: "super", wha: 133, t: 't')
sj.iz = "duper"
debugEcho "you are ", js[0] & $sj.wha & $sj.t

# tuples dont need their type declared separately
var bizDevOps: tuple[biz: string, dev: string, ops: string] =
  ("intermediate", "senior", "intermediate")
echo "rate yourself on bizDevOps: ", bizDevOps

# tuples can be destructured (unpacked)
let (bizRating, devRating, opsRating) = bizDevOps
echo "rate yourself on bizDevOps: ", bizRating, " ", devRating, " ", opsRating

# copied from docs
# even in loops
let aaa = [(10, 'a'), (20, 'b'), (30, 'c')]
for (x, c) in aaa:
  echo x # This will output: 10; 20; 30
for i, (x, c) in aaa:
  echo i, c # Accessing the index is also possible

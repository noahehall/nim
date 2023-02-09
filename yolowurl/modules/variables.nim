
echo "############################ variables"
var poop1 = "flush"
let poop2 = "hello"
# compile-time evaluation cannot interface with C
# there is no compile-time foreign function interface at this time.
# consts must be initialized with a value
const poop3 = "flush"


# computes fac(4) at compile time:
# notice the use of paranthesis and semi colins
const fac4 = (var x = 1; for i in 1..4: x *= i; x)

echo poop1, poop2, poop3, fac4

# stropping
let `let` = "stropping"
echo(`let`) # stropping enables keywords as identifiers

var autoInt: auto = 7 # auto generally used with procs as it provides type inference
echo "autoInt labeled auto but its type is ", $type(autoInt)

echo "############################ variable support"
# shallow(blah) marks blah as shallow for optimization, subsequent assignments  wont deep copy
# shallowCopy(blah) use this instead of = for a shallow copy
# checks whether x can be compiled without any semantic error.
# useful to verify whether a type supports some operation:
when compiles(3 + 4):
  echo "'+' for integers is available at compile time"

# whether x is declared at compile time
var typeSupportBlah = "halb"
when declared typeSupportBlah:
  echo "blah is declared at compile time"

when not declared thisDoesntExist:
  echo "some thing doesnt exist at compile time"

# checks currenty scope at compile time
when declaredInScope typeSupportBlah:
  echo "blah is declared in scope at compile time"

# checks whether something is defined at compile time
when defined typeSupportBlah:
  echo "something is defined at compile time"

# if gc:arc|orc you have to enable via --deepcopy:on
var d33pcopy: string
d33pcopy.deepCopy typeSupportBlah
echo "deep copy of some other thing ", d33pcopy

# get the default value
echo "the default int value is ", int.default
echo "the default seq[int] value is ", $ seq[int].default

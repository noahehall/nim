
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

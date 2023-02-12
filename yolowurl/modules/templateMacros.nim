## templates and macros
## ====================
##
## pretty much skipped the entire section on templates
## - [start here](https://nim-lang.org/docs/manual.html#templates)
## - ^ continue until you get to macros
##
## pretty much skipped the entire section on macros
## - [start here](https://nim-lang.org/docs/manual.html#macros)
## - ^ continue until you get to SpecialTypes
##
echo "############################ template"
# simple form of a macro
# @see https://nim-lang.org/docs/manual.html#overload-resolution-lazy-type-resolution-for-untyped
# enables raw code substitution on nim's abstract syntax tree
# are processed in the semantic pass of the compiler
# accepts meta types


# copied from docs
template `!=` (a, b: untyped): untyped =
  # it will replace a & b with the a and b operands to !=
  # then replace a != b in the original with the below template
  not (a == b)
# thats how the compiler rewrites below to: assert(not (5 == 6))
assert(5 != 6)

# lazy evaluation of proc args
const debug = true
var xy = 4
# msg arg is evaluted before the fn is evoked
proc log_eager(msg: string) {.inline.} =
  if debug: stdout.writeLine(msg)
# the template is processed before msg arg
# so if debug is false, msg wont be evaluted
template log_lazy(msg: string) =
  if debug: stdout.writeLine(msg)

logEager("x has the value: " & $xy) # & and $ are expensive! only use with lazy templates
logLazy("x has the value: " & $xy)

# copied from docs
# example of using untyped to get a block of statements
# the block statements are bound to the body param
template blockRunner(please: bool, body: untyped): void =
  let theyAskedNickely = please # reassign please so its only evaluted once
  if theyAskedNickely:
    try:
      body
    finally:
      echo "maze runner was okay, should have been better"
  else:
    echo "you forgot to say please"

blockRunner true:
  echo "number 1"
  echo "number 2"
blockRunner false:
  echo "i dont say please"
  echo "do or you will die a horrible death"


echo "############################ skipped: macros"
#[
  I basically skipped everything related to macros
  I should have captured everything in this file (which is what im doing now)
]#

#[
  # stuff
    ForLoopStmt
    NimNode
    instantiationInfo
]#

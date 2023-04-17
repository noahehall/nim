## templates and macros
## ====================
## [bookmark](https://nim-lang.org/docs/manual.html#templates)

##[
## TLDR
- pretty much skipped the entire section on templates, and definitely on macros
- FYI: you dont know nim if you dont know templates & macros

todos
-----
- [macros](https://nim-lang.org/docs/manual.html#macros)
  - ^ continue until you get to SpecialTypes
- [macro tut](https://nim-lang.org/docs/tut3.html)
- [fusion astdsl](https://nim-lang.github.io/fusion/src/fusion/astdsl.html)
- [templates vs generics](https://forum.nim-lang.org/t/9985)
- [system.nimNode is discussed here](https://nim-lang.org/docs/manual.html#pragmas-compiletime-pragma)
- [typed vs untyped for templates](https://nim-lang.org/docs/manual.html#templates-typed-vs-untyped-parameters)
- [custom annotations with template pragmas](https://nim-lang.org/docs/manual.html#userminusdefined-pragmas-custom-annotations)
- [macro pragmas](https://nim-lang.org/docs/manual.html#userminusdefined-pragmas-macro-pragmas)
- [asyncmacro](https://github.com/nim-lang/Nim/blob/devel/lib/pure/asyncmacro.nim)
- put the asyncdispatch templates in this file

## templates
- simple form of a macro
- [supports lazy evaluation](https://nim-lang.org/docs/manual.html#overload-resolution-lazy-type-resolution-for-untyped)
- enables raw code substitution on nim's abstract syntax tree
- are processed in the semantic pass of the compiler
- accepts meta types

template types
--------------
- untyped an expression thats not resolved for lazy evaluation
- typed an expression that is resolved for greedy evaluation
]##

echo "############################ template"
# copied from docs
template `!=` (a, b: untyped): untyped =
  ## it will replace a & b with the a and b operands to !=
  ## then replace a != b in the original with the below template
  ## i.e. assert(5 != 6) -> assert(not (5 == 6))
  not (a == b)
assert(5 != 6)

# lazy evaluation of proc args
const debug = true
var xy = 4
proc log_eager(msg: string) {.inline.} =
  ## msg arg is evaluted before the fn is evoked
  if debug: stdout.writeLine(msg)
template log_lazy(msg: string) =
  ## the template is processed before msg arg
  ## so if debug is false, msg wont be evaluted
  if debug: stdout.writeLine(msg)

logEager("x has the value: " & $xy) ## & and $ are expensive! only use with lazy templates
logLazy("x has the value: " & $xy)

# copied from docs
template blockRunner(please: bool, body: untyped): void =
  ## example of using untyped to get a block of statements
  ## the block statements are bound to the body param
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
# ForLoopStmt
# NimNode
# instantiationInfo

## templates and macros
## ====================
## [bookmark](https://nim-lang.github.io/Nim/manual.html#templates)

##[
## TLDR
- pretty much skipped the entire section on templates, and definitely on macros
- FYI: you dont know nim if you dont know templates & macros

links
-----
- [templates](https://nim-lang.github.io/Nim/manual.html#templates)
- [macros](https://nim-lang.github.io/Nim/manual.html#macros)

TODOs
-----
- [dynamic arguments for bindSym](https://nim-lang.github.io/Nim/manual_experimental.html#dynamic-arguments-for-bindsym)
- [term rewriting macros](https://nim-lang.github.io/Nim/manual_experimental.html#term-rewriting-macros)
- niminaction: chapter 9
- [macros](https://nim-lang.github.io/Nim/manual.html#macros)
  - ^ continue until you get to SpecialTypes
- [macro tut](https://nim-lang.github.io/Nim/tut3.html)
- [fusion astdsl](https://nim-lang.github.io/fusion/src/fusion/astdsl.html)
- [templates vs generics](https://forum.nim-lang.org/t/9985)
- [system.nimNode is discussed here](https://nim-lang.github.io/Nim/manual.html#pragmas-compiletime-pragma)
- [entire templates section](https://nim-lang.github.io/Nim/manual.html#templates-typed-vs-untyped-parameters)
- [custom annotations with template pragmas](https://nim-lang.github.io/Nim/manual.html#userminusdefined-pragmas-custom-annotations)
- [macro pragmas](https://nim-lang.github.io/Nim/manual.html#userminusdefined-pragmas-macro-pragmas)
- [asyncmacro](https://github.com/nim-lang/Nim/blob/devel/lib/pure/asyncmacro.nim)
- put the asyncdispatch templates in this file



## templates
- simple form of a macro
- [supports lazy evaluation](https://nim-lang.github.io/Nim/manual.html#overload-resolution-lazy-type-resolution-for-untyped)
- enables raw code substitution on nim's abstract syntax tree
- are processed in the semantic pass of the compiler
- accepts meta types

template types
--------------
- untyped an expression thats not resolved, i.e. lazy evaluation that prevents type checking
- typed an expression that is resolved for greedy evaluation

## macros
- an API for metaprogramming

]##

{.push hint[XDeclaredButNotUsed]: off.}

echo "############################ template"
# copied from docs
template `!=` (a, b: untyped): untyped =
  ## it will replace a & b with the a and b operands to !=
  ## then replace a != b in the original with the below template
  ## i.e. assert(5 != 6) -> assert(not (5 == 6))
  not (a == b)
# assert(5 != 6) # TODO(noah): throws in v2

# lazy evaluation of proc args
const debug = true
var xy = 4
# TODO(noah): stdout not system in v2
# proc logEager(msg: string) {.inline.} =
#   ## msg arg is evaluted before the fn is evoked
#   if debug: stdout.writeLine(msg)
# template logLazy(msg: string) =
#   ## the template is processed before msg arg
#   ## so if debug is false, msg wont be evaluted
#   if debug: stdout.writeLine(msg)

# TODO(noah): requires updating both procs to v2
# logEager("x has the value: " & $xy) ## & and $ are expensive! only use with lazy templates
# logLazy("x has the value: " & $xy)

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

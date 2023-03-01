##
## exception handling, debugging (todo), documentation
## ===================================================

##[
## TLDR
- all custom exceptions should ref a specific error/CatchableERror/Defect/and lastly Exception
- Exception is the base type for CatachableError (exceptions), Defect (non catchable)
- raise keyword the only way to raise (throw) an exception
  - system.Exception provides the interface
  - have to be allocated on the heap (var) because their lifetime is unknown
- docgen
  - having `*` after - (like on this line) will break htmldocs rst parser
    - you must escape it with backticks (see above) or backslash \*
    - the line number reported may not be correct, but the filename will be
      - error reported as `Error: '*' expected`
  - pretty prints code in the html
  - `back ticks` and back slashes e.g. \*.nims can escape special chars

todos
-----
- reread the assertion docs and capture the info
.. code-block:: Nim
  # bunch of todos
  errorMessageWriter (var) called instead of stdmsg.write when printing stacktrace
  onUnhandledException (var) override default behavior: write stacktrace to stderr then quit(1)
  outOfMemHook (var) override default behavior: write err msg then terminate (see docs for example)
  unhandledExceptionHook (var) override default behavior: write err msg then terminate
  localRaiseHook: same as globalRaiseHook but on a thread local level
    globalRaiseHook (var) influence exception handling on a global level
    ^ if not nil, every raise statement calls this hook
    ^ if returns false, exception is caught and does not propagate

links
-----
- [assertions](https://nim-lang.org/docs/assertions.html)
- [defect doc](https://nim-lang.org/docs/system.html#Defect)
- [docgen](https://nim-lang.org/docs/docgen.html)
- [drnim](https://nim-lang.org/docs/drnim.html)
- [embedding runnable examples](https://nim-lang.org/docs/system.html#runnableExamples%2Cstring%2Cuntyped)
- [exception doc](https://nim-lang.org/docs/system.html#Exception)
- [exception hierarchy doc](https://nim-lang.org/docs/manual.html#exception-handling-exception-hierarchy)
- [nim reStructuredText & markdown](https://nim-lang.org/docs/rst.html)
- [nimscript compatibility tests](https://github.com/nim-lang/Nim/blob/devel/tests/test_nimscript.nims)
- [segfaults module](https://nim-lang.org/docs/segfaults.html)
- [status exception handling docs](https://nimbus.guide/auditors-book/02.3_correctness_distinct_mutability_effects_exceptions.html#enforcing-exception-handling)
- [system exceptions you can extend from](https://github.com/nim-lang/Nim/blob/version-1-6/lib/system/exceptions.nim)
- [use this restructuredText wiki](https://docutils.sourceforge.io/docs/user/rst/quickref.html)

## Exception Handling
- interesting stuff
  - getStackTrace() only works for debug builds
  - getStackTrace(e) of a specific exception
  - getStackTraceEntries() doesnt work for the js backend
  - getStackTraceEntries(e) of a specific exception

Defect types
------------
- AccessViolationDefect invalid memory access
- ArithmeticDefect any kin dof arithmetic error
- AssertionDefect assertion returns false
- DeadThreadDefect sending a msg to a dead thread
- Defect abstract type representing all uncatchable errors (anything mappable to a quit/trap/exit operation)
- DivByZeroDefect int div by 0
- FieldDefect field is not accessible because its discriminants value does not fit
- FloatDivByZeroDefect  float div by 0
- FloatInexactDefect operation cant be represented with infinite precision, e.g. 2.0/3.0, log(1.1)
- FloatingPointDefect base type for floating point defects
- FloatInvalidOpDefect invalid ops according to IEEE, e.g. 0.0/0.0
- FloatOverflowDefect  stackoverflow.com
- FloatUnderflowDefect stackunderflow.com
- IndexDefect  array index out of bounds
- NilAccessDefect dereferences of nil pointers (only raised when segfaults is imported)
- ObjectAssignmentDefect object being assigned to its parent object
- ObjectConversionDefect converting to an incompatible type
- OutOfMemDefect failed to allocate memory
- OverflowDefect runtime integer stackoverflows.com, results too big for the provided bits
- RangeDefect range check error
- ReraiseDefect if there is no exception to reraise
- StackOverflowDefect when the hardware used for a subroutine stackoverflows.com

Error (exception) types
-----------------------
- CatchableError abstract type for all catchable exceptions
- EOFError occurred
- IOError occcurred
- KeyError key cannot be found in a table/set/strtabs
- LibraryError dynamic library doesnt load
- OSError operating system service failure
- ResourceExhaustedError when resource request cant be fulfilled
- ValueError string/object conversion

## documentation
- starting a line with ## creates a title that appears in the left sidebar
- both --- and === need to be the same length of whatever they're underlining
  - === creates an underline
  - --- creates a subtitle and appears undearneath the previous title in the sidebar
- `low(openArray) <#low,openArray[T]>`_  creates an html #fragment
- starting a line with .. code-block:: Nim creates a codeblock for stuff indented beneath it
- starting a line with .. image:: poop.com/image.gif creates an image
- include another doc file .. include:: ./system_overview.rst
- [^ check how it looks](https://raw.githubusercontent.com/nim-lang/Nim/version-1-6/lib/system_overview.rst)

]##

echo "############################ documentation: src code"
let goodcode* = "isdocumented"  ## `goodcode` should be self documenting, but sometimes naming
                                ## conventions arent enuff
let badcode = "ishardtomaintain"  ## this is not included in docs because its not exported


type GoodApplications* = object
  ## especially things like custom types
  ## may need additional abbreviations to describe their purpose
  pubfield*: string ## is included in docs
  prvfield: string  ## also included since goodapplications is exported

echo "############################ documentation: runnableExamples"

runnableExamples:
  ## ignored in release/debug, but not during docgen:
  ## - will aggregate all into a separate module, compile, test
  ## - also ensures only exported symbols exist
  var iam = GoodApplications(pubfield: "yes u are", prvfield: "I know I am") ## \
    ## example of creating a good application
  repr iam


echo "############################ Exceptions "
type LearningError = object of CatchableError

block howlong:
  try:
    if 24 div 12 == 2:
      raise newException(LearningError, "its been a long time")
  except LearningError as e:
    echo e.msg & " but i finally found the time"

echo "############################ raise "
proc neverThrows(): string {.raises: [].} =
  result = "dont compile if I can raise any error"
echo neverThrows()

proc maybeThrows(x: int): int {.raises: [ValueError].} =
  result = x
echo maybeThrows(23)

var
  err: ref OSError
new(err)
err.msg = "the request to the OS failed"
# raise e
# alternatively, you can raise without defining a custom err
# raise newException(OSError, "the request to the os Failed")
# raise # raising without an error rethrows the previous exception

echo "############################ try/catch/finally "
if true:
  try:
    let f: File = open "this file doesnt exist"
  except OverflowDefect, ArithmeticDefect: # catch multiple types
    echo "wrong error type"
  except ValueError as e:
    echo "you can access the current exception if assigned: ", e.msg
  # except IOError:
  except KeyError:
    # explicitly convert the currentException to a type
    let e = (ref IOError)(getCurrentException())
    echo "wrong error type: ", e.msg
  except:
    echo "unknown exception! this is bad code"
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
    # raise <-- would rethrow whatever the previous err was
  finally:
    echo "Glad we survived this horrible day"
    echo "if you didnt catch the err in an except"
    echo "this will be the last line before exiting"

# can be an expression
# the try + except must all be of the same type
# if theres a finally, it must return void
let divBy0: float = try: 4 / 0 except: -1.0
echo "oops! ", divBy0

echo "############################ defer "
# @see https://nim-lang.org/docs/manual.html#exception-handling-defer-statement
# alternative try finally statement that avoids lexical nesting + scoping flexibility
# all statements after defer will be within an implicit try block
# top level defers arent supported (must be within a block/proc/etc)

proc somethingStupid: auto =
  result =  "something"
  defer: echo "this is the finally block"
  result &= " stupid in an implicit try block"

echo somethingStupid()

echo "############################ assert"
# useful for guard, pre & post conditions if using design by contract
# ^ i think drnim even extends this further
# ^ haha remember trying to use thiz: https://github.com/codemix/contractual
# -d:danger or --asertions:off to remove from compilation
# --assertions:on to keep them in compiled output
assert "a" == $'a' # has to be of same type

# is always turned on regardless of --assertions flag
doAssert 1 < 2, "failure msg"
# doAssertRaises(IndexDefect): # declare exceptions the codeblock raises
# doAssertRaises(KeyError):
#   discard {'a', 'b'}['z']

# true if the module is compiled as the main file
# useful for embedding tests within the module
when isMainModule:
  assert true == true

echo "############################ debugger"
# Todo, find the debugger apiin the docs somewhere
# PFrame runtime frame of the callstack, part of the debugger api

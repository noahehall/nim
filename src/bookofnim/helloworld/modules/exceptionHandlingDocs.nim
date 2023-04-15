##
## exception handling, debugging, documentation
## ============================================

##[
## TLDR
- docgen:
  - having `*` after - (like on this line) will break htmldocs rst parser
    - you must escape it with backticks `*` or backslash \*
    - error reported as `Error: '*' expected`
  - pretty prints code in the html
  - `back ticks` and back slashes e.g. \*.nims can escape special chars
  - if reusing rsts (e.g. for github readmes)
    - make sure to add an empty line before the first indented list item
    - IMO always externalize readme.rst files so their viewable in github & in html docs
- exceptions
  - all custom exceptions should ref a specific error/CatchableERror/Defect/and lastly Exception
    - Exception is the base type for CatachableError (exceptions) and Defect (non catchable)
    - has to be allocated on the heap (requires ref) because their lifetime is unknown
  - raise keyword for throwing an exception/defect
    - e.g. `raise errInstance`
    - e.g. `raise newException(OSError, "Oops! did i do that?")`
    - raising without an error rethrows the previous exception
  - compile with `--panics:on` to make defects unrecoverable
- assert
  - -d:danger or --asertions:off to remove from compilation
  - --assertions:on to keep them in compiled output
- doAssert
  - always on regardless of flags
  - can be used to check for specific errors with `doAssertRaises(woop):` block
  - useful for hard checks & design by contract
- drnim
  - requires koch to be setup

links
-----
- other
  - [restructuredText wiki](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
  - [status exception handling docs](https://nimbus.guide/auditors-book/02.3_correctness_distinct_mutability_effects_exceptions.html#enforcing-exception-handling)
- devel source
  - [assertions](https://github.com/nim-lang/Nim/blob/devel/lib/std/assertions.nim)
  - [exception and effect types](https://github.com/nim-lang/Nim/blob/devel/lib/system/exceptions.nim)
- high impact
  - [assertions](https://nim-lang.org/docs/assertions.html)
  - [defect](https://nim-lang.org/docs/system.html#Defect)
  - [docgen](https://nim-lang.org/docs/docgen.html)
  - [documenting, profiling and debugging nim code](https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html)
  - [exception handling with defer](https://nim-lang.org/docs/manual.html#exception-handling-defer-statement)
  - [exception hierarchy](https://nim-lang.org/docs/manual.html#exception-handling-exception-hierarchy)
  - [exception](https://nim-lang.org/docs/system.html#Exception)
  - [reStructuredText & markdown](https://nim-lang.org/docs/rst.html)
  - [restructured text intro](https://docutils.sourceforge.io/docs/user/rst/quickstart.html)
  - [runnable examples](https://nim-lang.org/docs/system.html#runnableExamples%2Cstring%2Cuntyped)
- niche
  - [drnim](https://nim-lang.org/docs/drnim.html)
  - [segfaults module](https://nim-lang.org/docs/segfaults.html)

todos
-----
- drnim tool
- debugger
- [try-except discussion](https://forum.nim-lang.org/t/9765)
.. code-block:: Nim
  errorMessageWriter (var) called instead of stdmsg.write when printing stacktrace
  onUnhandledException (var) override default behavior: write stacktrace to stderr then quit(1)
  outOfMemHook (var) override default behavior: write err msg then terminate (see docs for example)
  unhandledExceptionHook (var) override default behavior: write err msg then terminate
  localRaiseHook: same as globalRaiseHook but on a thread local level
    globalRaiseHook (var) influence exception handling on a global level
    ^ if not nil, every raise statement calls this hook
    ^ if returns false, exception is caught and does not propagate

## Exception Handling

- interesting stuff
  - getStackTrace() only works for debug builds
  - getStackTrace(e) of a specific exception
  - getStackTraceEntries() doesnt work for the js backend

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
- IndexDefect array index out of bounds
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

try/except/finally
------------------
- like most things can be an expression and assigned to a var
- the try + except must all be of the same type
- if theres a finally, it must return void

defer
-----
- alternative try finally statement that avoids lexical nesting + scoping flexibility
- all statements after defer will be within an implicit try block
- top level defers arent supported (must be within a block/proc/etc)

assert
------
- useful for guard, pre & post conditions if using design by contract
- i think drnim even extends this further

## documentation
- starting a line with ## creates a title that appears in the left sidebar
- both --- and === need to be the same length of whatever they're underlining
  - === creates an underline
  - --- creates a subtitle and appears undearneath the previous title in the sidebar
- `low(openArray) <#low,openArray[T]>`_  creates an html #fragment ?
- starting a line with .. code-block:: Nim creates a codeblock for stuff indented beneath it
- starting a line with .. image:: woopwoop.com/image.gif creates an image
- include another doc file .. include:: ./system_overview.rst
  - [example nim file including rst](https://github.com/nim-lang/Nim/blob/devel/lib/system.nim)
  - [^ e.g. system_overview](https://raw.githubusercontent.com/nim-lang/Nim/devel/lib/system_overview.rst)
- `.. _LinkName: some.url.com` can be referenced as `LinkName_`

runnableExamples
----------------
- example code to be formatted and displayed in html docs
- ignored in release/debug, but parsed during docgen:
  - will aggregate all into a separate module, compile, test
  - ensures only exported symbols exist
    - errors if private symbols are included

]##

echo "############################ documentation: src code"
let goodcode* = "isdocumented"  ## `goodcode` should be self documenting, but sometimes naming
                                ## conventions arent enuff
let badcode = "ishardtomaintain"  ## this is not included in docs because its not exported


type GoodApplications* = object
  ## especially things like custom types
  ## may need additional abbreviations to describe their purpose
  pubfield*: string ## public: included in docs
  # FYI: this throws on nim_docs src/bookofnim.nim
  # ^ but not on nim doc src/bookofnim.nim
  # ^ Error: the field 'prvfield' is not accessible.
  prvfield*: string # TODO: errors on doc creation

echo "############################ documentation: runnableExamples"

runnableExamples:
  var iam = GoodApplications(pubfield: "yes u are", prvfield: "I know I am") ## \
    ## example of creating a good application
  discard repr iam


echo "############################ Exceptions "
var err: ref OSError ## requires ref! only ref objects can be raised
new(err) # a new OSError instance without a msg
err.msg = "Oops! this is a bad error msg"

type LearningError = object of CatchableError ## \
  ## The first pass is figuring things out.
  ## the second pass is ironing things out

block howlong:
  try:
    if 24 div 12 == 2:
      raise newException(LearningError, "its been a long time")
  except LearningError as e:
    echo e.msg & " I shouldnt have left you"

echo "############################ raise "

proc neverThrows(): string {.raises: [].} =
  ## we set raises to empty list
  result = "dont compile if I can raise any error"
echo neverThrows()

proc maybeThrows(x: int): int {.raises: [ValueError].} =
  ## only value errors are allowed
  try:
    raise newException(ValueError, "will be raised")
  except CatchableError:
    echo "caught a value error!"
  result = x
echo maybeThrows(23)


echo "############################ try/except/finally "
if true:
  try:
    let f: File = open "a file that doesnt exist"
  except OverflowDefect, ArithmeticDefect:
    echo "wrong error type"
  except ValueError as e:
    echo "you can access the current exception if assigned: ", e.msg
  except KeyError:
    # explicitly convert the currentException to a type
    let e = (ref IOError)(getCurrentException())
    echo "wrong error type: ", e.msg
  except:
    echo "unknown exception"
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
  finally:
    echo "Glad we survived this horrible day",
      "\nif you didnt catch the err in an except",
      "\nthis will be the last line before exiting"

when false:
  # div by 0 is a defect in nim2 and cannot be caught
  let divBy0: float = try: 4 / 0 except FloatOverflowDefect: -1.0


echo "############################ defer "
proc deferExample: auto =
  echo "before defer"
  defer:
    echo "inside defer",
      "\nan implicit finally block",
      "\nunlike try/finally there is no except clause"
  echo "\tafter defer" &
    "\n\tall statements in the same scope as defer" &
    "\n\tare in an implicit try block" &
    "\n\tnote this is NOT within the defer block"
  result = "defer return this"


echo deferExample()


echo "############################ assert"
# can be turned off
assert "a" == $'a'

# is always turned on regardless of --assertions flag
doAssert 1 < 2, "failure msg"

doAssertRaises KeyError:
  raise newException(KeyError, "key error")

when false:
  doAssertRaises AssertionDefect:
    raiseAssert "this msg"

try:
  # handles assertions in the current block
  onFailedAssert msg:
    # assert handler logic
    let m = "assert handled: " & msg
    raise newException(CatchableError, m)
  # all assertions will be managed
  doAssert 1 == 2, "1 !== 2"
except CatchableError as e:
  echo e.msg

# echo "############################ debugger"
# # Todo, find the debugger api in the docs somewhere
# # PFrame runtime frame of the callstack, part of the debugger api

#[
  exception stuff, debugging, documentation and testing

  @see
    - https://github.com/status-im/nim-testutils/tree/master/testutils/fuzzing
    - https://nim-lang.org/docs/assertions.html
    - https://nim-lang.org/docs/assertions.html
    - https://nim-lang.org/docs/docgen.html
    - https://nim-lang.org/docs/drnim.html
    - https://nim-lang.org/docs/segfaults.html
    - https://nim-lang.org/docs/testament.html (preferred std testing tool)
    - https://nim-lang.org/docs/unittest.html (use testament instead)
    - https://nimbus.guide/auditors-book/02.3_correctness_distinct_mutability_effects_exceptions.html#enforcing-exception-handling

]#

echo "############################ documentation"
## double bang starts a documentation comment
## are part of the syntax tree
## only permitted in specific places
# @see https://github.com/nim-lang/Nim/blob/version-1-6/lib/system/exceptions.nim
# ^ for examples of writing excellent documentation and how to document your src c0d3

echo "############################ Defects "
# AccessViolationDefect invalid memory access
# ArithmeticDefect any kin dof arithmetic error
# AssertionDefect assertion returns false
# DeadThreadDefect sending a msg to a dead thread
# Defect abstract type representing all uncatchable errors (anything mappable to a quit/trap/exit operation)
# DivByZeroDefect int div by 0
# FieldDefect field is not accessible because its discriminants value does not fit
# FloatDivByZeroDefect  float div by 0
# FloatInexactDefect operation cant be represented with infinite precision, e.g. 2.0/3.0, log(1.1)
# FloatingPointDefect base type for floating point defects
# FloatInvalidOpDefect invalid ops according to IEEE, e.g. 0.0/0.0
# FloatOverflowDefect  stackoverflow.com
# FloatUnderflowDefect stackunderflow.com
# IndexDefect  array index out of bounds
# NilAccessDefect dereferences of nil pointers (only raised when segfaults is imported)
# ObjectAssignmentDefect object being assigned to its parent object
# ObjectConversionDefect converting to an incompatible type
# OutOfMemDefect failed to allocate memory
# OverflowDefect runtime integer stackoverflows.com, results too big for the provided bits
# RangeDefect range check error
# ReraiseDefect if there is no exception to reraise
# StackOverflowDefect when the hardware used for a subroutine stackoverflows.com

echo "############################ error (exception) types "
# CatchableError abstract type for all catchable exceptions
# EOFError end of file
# IOError occcurred
# KeyError key cannot be found in a table/set/strtabs
# LibraryError dynamic library doesnt load
# OSError operating system service failure
# ResourceExhaustedError when resource request cant be fulfilled
# ValueError string/object conversion

echo "############################ Exceptions "
# all custom exceptions should ref Exception
# @see https://nim-lang.org/docs/system.html#Exception
# @see https://nim-lang.org/docs/manual.html#exception-handling-exception-hierarchy

echo "############################ raise "
# throw an exception
# system.Exception provides the interface
# have to be allocated on the heap (var) because their lifetime is unknown

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


echo "############################ push/pop pragma"
# this (im-status) trick prohibits procs from throwing defects, but allows errors
# compiler will throw if its analysis determines a proc can throw a defect, helps u debug

# all procs after this line will have this pragma
# first line of your file
{.push raises:[Defect]}

# your
# code
# here

# all procs after this line will have the previous push removed
# last line of your file
{.pop.}


echo "############################ try/catch/finally "

if true:
  try:
    let f: File = open "this file doesnt exist"

  except OverflowDefect:
    echo "wrong error type"
  except ValueError:
    echo "cmd dude you know what kind of error this is"
  # except IOError:
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


echo "############################ assert"
# useful for guard, pre & post conditions if using design by contract
# ^ i think drnim even extends this further
# ^ haha remember trying to use thiz: https://github.com/codemix/contractual
# -d:danger or --asertions:off to remove from compilation
# --assertions:on to keep them in compiled output
assert "a" == $'a' # has to be of same type

# is always turned on regardless of --assertions flag
doAssert 1 < 2, "failure msg"

# true if the module is compiled as the main file
# useful for embedding tests within the module
when isMainModule:
  assert true == true

echo "############################ debugger"
# Todo, find the debugger[ api] in the docs somewhere
# PFrame runtime frame of the callstack, part of the debugger api
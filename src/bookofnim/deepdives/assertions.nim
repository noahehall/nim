##
## assertions
## ==========

##[
## TLDR
- assert vs doAssert
  - assert: designed for tests
    - -d:danger or --asertions:off to remove from compilation
    - --assertions:on to keep them in compiled output
  - doAssert: designed for design by contract (IMO)
    - are never removed from compiled output
    - i think drnim even extends this further

links
-----
- high impact
  - [assertions](https://nim-lang.github.io/Nim/assertions.html)


## assertion

assertion procs
---------------
- assert(cond, msg) throws if cond evaluates to false; designed for unit tests
- doAssert(cond, msg) see assert, always on
- doAssertRaises(ThisException): code that raises ThisException
- failedAssertImpl(msg) called when an assertion fails
- raiseAssert(msg) raises an AssertionDefect

]##

echo "############################ assertions"

import std/assertions

# can be turned off
assert "a" == $'a'

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

# is always turned on regardless of --assertions flag
doAssert 1 < 2, "failure msg"

doAssertRaises KeyError:
  raise newException(KeyError, "key error")

when false:
  doAssertRaises ValueError:
    echo "I dont raise a value error"
    echo "try, except wont catch me"

#[
  @see
    - https://github.com/status-im/nim-testutils/tree/master/testutils/fuzzing
    - https://nim-lang.org/docs/assertions.html
    - https://nim-lang.org/docs/drnim.html
    - https://nim-lang.org/docs/segfaults.html
    - https://nim-lang.org/docs/testament.html (preferred std testing tool)
    - https://nim-lang.org/docs/unittest.html (use testament instead)
    - https://nimbus.guide/auditors-book/02.3_correctness_distinct_mutability_effects_exceptions.html#enforcing-exception-handling

  defects: non-recoverable errors
    - Defect, OverflowDefect
  exceptions: recoverable errors
    - ValueError, IOError

]#

echo "############################ raises"

proc neverThrows(): string {.raises: [].} =
  result = "dont compile if I can raise an error"

echo neverThrows()

proc maybeThrows(x: int): int {.raises: [ValueError].} =
  result = x

echo maybeThrows(23)

echo "############################ push/pop pragma"
# this (im-status) trick prohibits procs from throwing defects, but allows errors
# compiler will throw if its analysis determines a proc can throw a defect, helps u debug


# all procs after this line will have this pragma
# first line of your file
{.push raises:[Defect]}

# your module code here

# all procs after this line will have the previous push removed
# last line of your file
{.pop.}

echo "############################ try"
# try: ... except PoopEx as e: echo e.message


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

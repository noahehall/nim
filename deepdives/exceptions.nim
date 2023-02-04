#[
  @see https://nimbus.guide/auditors-book/02.3_correctness_distinct_mutability_effects_exceptions.html#enforcing-exception-handling

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
# this trick prohibits procs to throw any error except defects

# all procs after this line will have this pagma
{.push raises:[Defect]}

# all procs after this line will have the previous push removed
{.pop.}

echo "############################ try"
# try: ... except PoopEx as e: echo e.message

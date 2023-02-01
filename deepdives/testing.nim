#[
  @see https://github.com/status-im/nim-testutils/tree/master/testutils/fuzzing
  @see https://nim-lang.org/docs/assertions.html
]#

echo "############################ assert"
# useful for pre & post conditions if using design by contract
# haha remember trying to use thiz: https://github.com/codemix/contractual
# -d:danger or --asertions:off to remove from compilation
# --assertions:on to keep them in compiled output
assert "a" == $'a' # has to be of same type

# is always turned on regardless of --assertions flag
doAssert 1 < 2, "failure msg"

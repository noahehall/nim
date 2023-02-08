#[
  subset of nim that can be evaluated by nims builtin VM
  @see
    - https://nim-lang.org/docs/nims.html
    - https://nim-lang.org/docs/nimscript.html

  usecase: configs (see compiler for --skip flags)
  nim will automatically process .nims configs in the following order (later overrides previous)
    - $XDG_CONFIG_HOME/nim/config.nims || ~/config/nim/config.nims
    - $parentDir/config.nims
    - $projectDir/config.nims
    - $project.nims

  usecase: build tool

  usecase: cross platform scripting (good bye complex bash scripts?)
    -

  limitations
    - any stdlib module relying on `importc` pragma cant be used
    - ptr operations are tested, but may have bugs
    - var T args (rely on ptr operations) thus may have bugs too
    - multimethods not available
    - random.randomize() you must pass an int64 as a seed
]#

echo "############################ config"
# you can set switches via 2 syntax
# switch("opt", "size") # --opt:size
# --define:release # --define:Release #  prefer this cleaner syntax

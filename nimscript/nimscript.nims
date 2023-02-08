#[
  subset of nim that can be evaluated by nims builtin VM
  @see
    - https://nim-lang.org/docs/nims.html
    - https://nim-lang.org/docs/nimscript.html
    - https://nim-lang.org/docs/tasks.html

  usecase: configs (see compiler for --skip flags)
  nim will automatically process .nims configs in the following order (later overrides previous)
    - $XDG_CONFIG_HOME/nim/config.nims || ~/config/nim/config.nims
    - $parentDir/config.nims
    - $projectDir/config.nims
    - $project.nims

  usecase: build tool
    - you have to read through docs/task as well as system/tasks
    - default provides: help, build, tests, and bench cmds

  usecase: cross platform scripting (good bye complex bash scripts?)
    - The syntax, style, etc is identical to compiled nim
    - supports templates, macros, types, oncepts, effect tracking system, etc
    - modules can work in both .nim and .nims (see limitations)

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

echo "############################ build"
# TODO

echo "############################ scripts"
#!/usr/bin/env nim

import std/distros

# Architectures.
if defined(amd64):
  echo "Architecture is x86 64Bits"
elif defined(i386):
  echo "Architecture is x86 32Bits"
elif defined(arm):
  echo "Architecture is ARM"

# Operating Systems.
if defined(linux):
  echo "Operating System is GNU Linux"
elif defined(windows):
  echo "Operating System is Microsoft Windows"
elif defined(macosx):
  echo "Operating System is Apple OS X"

# Distros.
if detectOs(Ubuntu):
  echo "Distro is Ubuntu"
elif detectOs(ArchLinux):
  echo "Distro is ArchLinux"
elif detectOs(Debian):
  echo "Distro is Debian"

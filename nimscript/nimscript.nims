#[
  subset of nim that can be evaluated by nims builtin VM
  @see
    - https://nim-lang.org/docs/nims.html
    - https://nim-lang.org/docs/nimscript.html
    - https://nim-lang.org/docs/tasks.html
    - https://github.com/kaushalmodi/nim_config/blob/master/config.nims (example script)
    - https://github.com/nim-lang/Nim/blob/devel/tests/test_nimscript.nims (compatibility tests)
    - https://github.com/nim-lang/nimble#creating-packages (with nimscript for nimble integration)
    - https://nim-lang.org/docs/os.html

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
    - supports templates, macros, types, concepts, effect tracking system, etc
    - modules can work in both .nim and .nims (see limitations)
    - FYI: a *.nims file doesnt have a separate $projectDir/$project config file,
      - it is its own config file, but can rely on the other types, or manually import

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

# example Architectures (docs)
if defined(amd64):
  echo "Architecture is x86 64Bits"
elif defined(i386):
  echo "Architecture is x86 32Bits"
elif defined(arm):
  echo "Architecture is ARM"

# example Operating Systems (docs)
if defined(linux):
  echo "Operating System is GNU Linux"
elif defined(windows):
  echo "Operating System is Microsoft Windows"
elif defined(macosx):
  echo "Operating System is Apple OS X"

# example Distros (docs)
if detectOs(Ubuntu):
  echo "Distro is Ubuntu"
elif detectOs(ArchLinux):
  echo "Distro is ArchLinux"
elif detectOs(Debian):
  echo "Distro is Debian"

# nimble integration/metadata
# bin, binDir, installDirs, installExt, installFiles
# skipDirs, skipExt, skipFiles, srcDir
# packageName = the default is the nimscript filename
author = "noah edward hall"
backend = "c"
description = "my first nimscript!"
license = "Free"
version = "0.0.1"

mode = ScriptMode.Verbose ## \
  ## Silent, Whatif echos instead of executes
  ## set the mode when the script starts
  ## influece how mkDir, rmDir, etc behave

# requiresData: seq[string] = ## \
  # list of requirments for r/w access

const buildCPU = system.hostCPU ## \
  ## useful for cross compilation

const buildOS = system.hostOS ## \
  ## useful for cross copmilation

when true:
  echo "this package was built on: ", buildOs, "/", buildCPU

# nimscript specific procs
# cppDefine,
# cpDir(from, to)
# cpFile(from, to)

cd ".." ## \
  ## permanently change directories
  ## use withDir

exec "ls" ## \
  ## if cmd errs an OSError is raised
  ## use gorgeEx to instead receive the exit code & output

echo "is a == A ? ", cmpic("a", "A")

delEnv("MY_LEAKED_BANKACCOUNT_PASSWORD") ## \
  ## from the environment

echo "yolo world? ", dirExists("../yolowurl") ## \
  ## reporting false, dunno, likely due to cwd

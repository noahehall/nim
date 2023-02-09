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
# --define:release # prefer this cleaner syntax
--opt:size

echo "############################ build"
# TODO: you need to read through the task docs

echo "############################ scripts"
#!/usr/bin/env nim
# to set switches in shebang: #!/usr/bin/env -S nim --hints:off

# nimble integration/metadata
# bin, binDir, installDirs, installExt, installFiles
# skipDirs, skipExt, skipFiles, srcDir
# packageName = the default is the nimscript filename
author = "noah edward hall"
backend = "c"
description = "my first nimscript!"
license = "Free"
version = "0.0.1"

# generally any std nim/third party package may work
# see the limitations section
import std/distros

echo "############################ scripts: vars/flags"
# hint(name, bool) enable/disable a specific hint

mode = ScriptMode.Verbose ## \
  ## Silent, Whatif echos instead of executes
  ## set the mode when the script starts
  ## influece how mkDir, rmDir, etc behave

# requiresData: seq[string] = ## \
  # list of requirments for r/w access

const buildCPU = system.hostCPU ## \
  ## useful for cross compilation if set to a nondefault value

const buildOS = system.hostOS ## \
  ## useful for cross cmmpilation if set to a nondefault value

when true:
  echo "this package was built on: ", buildOs, "/", buildCPU


echo "############################ scripts: env"
delEnv("MY_LEAKED_BANKACCOUNT_PASSWORD") ## \
  ## from the environment
echo "are we gonna get pwned? ", existsEnv("MY_LEAKED_BANKACCOUNT_PASSWORD")
echo "do you know my name? ", getEnv("USER")

echo "does this configuration key exist? ", exists("opt.size") ## \
  ## we set --opt:size previously, still reports false, dunno
echo "whats the value of conf key: ", get("gcc")
echo "what invocation cmd was used ", getCommand() ## \
  ## e.g. e, c, js, build, help

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


echo "############################ scripts: files/dirs/etc"
# files/dirs
# cpDir(from, to)
# cpFile(from, to)

echo "yolo world? ", dirExists("../yolowurl") ## \
  ## reporting false, dunno, likely due to cwd
echo "every repo should have a root readme: ", fileExists("../README.md") ## \
  ## probably cwd again, ahh yup cwd is ..

echo "whats the absolute path: ", getCurrentDir()

echo "subdirs in cwd: ", listDirs(".") ## \
  ## non-recursive, seq[string]
echo "files in cwd: ", listFiles(".") ## \
  ## non-recursive, seq[string]

mkDir("tmp/mkdir/p") ## \
  ## mkdir -p blah

try: mvDir("tmp/mkdir/p", getCurrentDir() & "/nimscript/")
except: echo "cant move TO a non-empty dir, ", getCurrentDir() & "/nimscript/"

echo "############################ scripts: exec"
echo "will u return the symlink or resolve it? ", findExe("runpostman") ## \
  ## first in cwd, then each $PATH dir

exec "ls" ## \
  ## if cmd errs an OSError is raised
  ## use gorgeEx to instead receive the exit code & output
# exec("ls", "..") ## \
## exec cmd, input; cache = ""
## doesnt seem to work as expected when passing input

cd ".." ## \
  ## permanently change directories
  ## use withDir



echo "############################ scripts: catchall procs"
# cppDefine(blah) is a C preprocessor #define and needs to be mangled
echo "is a == A ? ", cmpic("a", "A")

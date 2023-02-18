##
## nimscript
## =========

##[
## TLDR
- subset of nim that can be evaluated by nims builtin VM

links
- [nims intro](https://nim-lang.org/docs/nims.html)
- [nimscript spec](https://nim-lang.org/docs/nimscript.html)
- [example nims config](https://github.com/kaushalmodi/nim_config/blob/master/config.nims)

todos
- [tasks](https://nim-lang.org/docs/tasks.html)
- [creating pkgs with nimscript & nimble](https://github.com/nim-lang/nimble#creating-packages)
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
]##

echo "############################ config"
# you can set switches via 2 syntax
# switch("opt", "size") # --opt:size
# --define:release # prefer this cleaner syntax
--opt:size

echo "############################ scripts"
#!/usr/bin/env nim
# to set switches in shebang: #!/usr/bin/env -S nim --hints:off

# nimble integration/metadata
# bin, binDir, installDirs, installExt, installFiles
# skipDirs, skipExt, skipFiles, srcDir
# packageName = the default is the nimscript filename
# requires(varargs[string])  set the list of reqs of this nimble pkg

author = "noah edward hall"
backend = "c"
description = "my first nimscript!"
license = "Free"
version = "0.0.1"

# generally any std nim/third party package may work
# see the limitations section & tests link
import std/distros

echo "############################ scripts: vars/flags"
# hint(name, bool) enable/disable specific hints
# warning(name, bool) enable/disable specific warnings

mode = ScriptMode.Verbose ## \
  ## Silent, Whatif echos instead of executes
  ## set the mode when the script starts
  ## influece how mkDir, rmDir, etc behave

# requiresData = seq[string] ## \
  # list of requirments for r/w access

const buildCPU = system.hostCPU ## \
  ## useful for cross compilation if set to a nondefault value

const buildOS = system.hostOS ## \
  ## useful for cross cmmpilation if set to a nondefault value

when true:
  echo "this package was built on: ", buildOs, "/", buildCPU


echo "############################ scripts: env"
# env
putEnv("MY_LEAKED_BANKACOUNT_PASSWORD", "p0oP1nurm0u7h")
echo "are we gonna get pwned? ", existsEnv("MY_LEAKED_BANKACOUNT_PASSWORD")
delEnv("MY_LEAKED_BANKACOUNT_PASSWORD") ## \
  ## from the environment
echo "do you know my name? ", getEnv("USER")

# nim conf
echo "does this key exist in conf? ", exists("opt.size") ## \
  ## we set --opt:size previously, still reports false, dunno
put("poop", "first check the tp") ## \
  ## upserts conf
echo "read conf key poop: ", get("poop") ## \
  ## returns empty string if not found

# nim
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
# mvFile(from, to)
# rmFile

echo "wheres nimcache ", nimcacheDir() ## \
  ## remember blah_d is debug and blah_r is release

echo "yolo world? ", dirExists("../yolowurl") ## \
  ## reporting false, dunno, likely due to cwd (in vscode)
  ## like in bash, always have a reference point
withDir "nimscript":
  ## after this block exists we return to prev dir
  ## the below should now return true if running this file in vscode
  echo "yolo world? ", dirExists("../yolowurl")

echo "every repo should have a root readme: ", fileExists("../README.md") ## \
  ## probably cwd again, ahh yup cwd is .. in vscode
  ## like in bash, always have a reference point
withDir "nimscript":
  echo "README.md is in parentDir now? ", fileExists("../README.md")

echo "cwd: ", getCurrentDir()
echo "project dir: ", projectDir()
echo "what dir is this file in? ", thisDir()

echo "subdirs in cwd: ", listDirs(".") ## \
  ## non-recursive, seq[string]
echo "files in cwd: ", listFiles(".") ## \
  ## non-recursive, seq[string]

const tmpDir = "tmp/mkdir/p"
mkDir(tmpDir) ## \
  ## mkdir -p blah
echo tmpDir, " created? ", dirExists(tmpDir)
try: mvDir("tmp", getCurrentDir() & "/nimscript/")
except: echo "cant move TO a non-empty dir, ", getCurrentDir() & "/nimscript/"

rmDir("tmp")
echo tmpDir, " deleted? ", not dirExists(tmpDir)

echo "############################ scripts: exec"
# setCommand(cmd; project) ## \
# pretty sure project is the path to a project
# sets the nim cmd that should be used after  this script is finished
# not sure the usecase for this one
# why would you need to set a cmd after a script has finished?
# ^ probably because `.nims` dual purpose is for configuration which executes before a `.nim` file
# ^ thus you can control (e.g. cross compilation) execution of the mainfile

echo "how many args did we receive? ", paramCount()
for i in 0..<paramCount(): echo "param ", i, " is ", paramStr i ## \
  ## 0 absolute path to nim
  ## 1 is cmd

echo "will u return the symlink or resolve it? ", findExe("runpostman") ## \
  ## searches first in cwd, then each $PATH dir until it finds the executable

echo "which executable is running? ", selfExe() ## \
  ## absolute path to nim/nimble
selfExec("-v") ## \
  ## command must not contain the nim part

exec "pwd" ## \
  ## if cmd errs an OSError is raised
  ## use gorgeEx to instead receive the exit code & output
exec "groups", "blah" ## \
  ## exec cmd, input; cache = ""
  ## doesnt seem to work as expected when passing input
  ## expected groups: ‘blah’: no such user
  ## exec groups blah does return expected

cd ".." ## \
  ## permanently change directories
  ## use withDir for a temporary change



echo "############################ scripts: catchall procs"
# cppDefine(string) is a C preprocessor #define and needs to be mangled
# patchFile(pkg, thisFile, withThisFile) overrides location of a file belonging to pkg
# readAllFromStdin() read all data from stdin; blocks until EOF event (stdin closed)
# readLineFromStdin() read a line from stdin; blocks until EOF event (stdin closed)
# toDll(fname) posix adds lib$fname.so, windows appends .dll to fname
# toExe(fname) posix returns fname unmodified, windows appends .exe
echo "is a == A ? ", cmpic("a", "A") == 0

echo "############################ scripts: tasks"
# used in buildscripts, but also for defining tasks in general
# now whats a task? lol for that we'll have to search the docs
# technically its a template which creates a proc named blahTask
# but why do you need a task, and not just a proc? no fkn clue
# ahh you should also read the nimble docs on this one

task poop, "with this description":
  ## a task with a description is public
  echo "completed!"

task soup, "":
  ## a task without a description is hidden
  ## you can call one task from another
  poopTask()

poopTask() ## \
  ## tasks can also be called directly

echo "############################ build"
# TODO: you need to read through the task docs

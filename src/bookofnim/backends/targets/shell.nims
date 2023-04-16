#!/usr/bin/env nim
# ^ or /usr/bin/env -S nim --hints:off e.g.


# TODO: spike moving to nimcr
# ^ @see https://github.com/PMunch/nimcr

import std/[sugar, sequtils, strformat, strutils, distros, os]

const
  configFile = "bookofnim.nim.ini"
  dirtmp = "/tmp/dir"
  dotdir = "."
  mydir = "targets"
  mydirdir = "backends"
  readme = "README.md"
  SOME_KEY = "KEY_SOME"
  somecmd = "pwd"
  somecmdarg = "--help"
  someval = "valsome"
  symlinkedcmd = "runpostman"
  tmpdir = "/tmp/dir/with/multiple/sub/dirs"

echo "############################ nimble integration"
# check nimdocs for more
author = "noah edward hall"
backend = "c"
description = "nimscript api example"
license = "TO KILL!"
version = "0.0.1"

echo "############################ config internal via .cfg / .nims"
## .cfg and .nims can be autoloaded based on cfg path algorithm (see packaging docs)
## can also use the logic in the external section that follows

--opt:size ## set compiler switches
mode = ScriptMode.Verbose ## Silent | Whatif
requiresData = @[] ## exposes requirments for r/w access
const buildCPU = system.hostCPU ## build target
const buildOS = system.hostOS ## build target

echo fmt"this package will build for {buildOS=}/{buildCPU=}"
echo fmt"{projectName()=}"
put(SOME_KEY, someval) ## upsert conf
echo fmt"{exists(SOME_KEY)=}"
echo fmt"empty string if not found {get(SOME_KEY)=}"

echo "############################ config external via .ini"
import std/[parsecfg]

echo fmt"{thisDir()=}"
const cfg = normalizedPath fmt"""{thisDir() / ".." / ".." / ".." / configFile}""".readFile
var dict = newconfig()
proc parseCfg(): void =
  ## unfortunately parseconfig not available in nimscript
  ## so we have to manually read and parse
  ## this quick algo doesnt support multiline values
  ## @see [extract and parse spec procs](https://github.com/nim-lang/Nim/blob/devel/testament/specs.nim) for parsing a file into a config
  var curSection = ""
  for ll in cfg.splitLines:
    let l = ll.strip
    if l.startsWith(";") or l.startsWith("#") or l.len == 0: continue
    elif l.startsWith("["): curSection = l.split({'[', ']'})[1].strip
    else:
      let kv = l.split({':', '='}, maxsplit = 1)
      dict.setSectionKey(curSection, kv[0].strip, (if kv.len == 2: kv[1].strip else: ""))

parseCfg()
for s in sections dict: echo fmt"{s=}"
echo fmt"""{dict.getSectionValue "section b", "k1"=}"""
echo fmt"""{dict.getSectionValue "section b", "--k4"=}"""
echo fmt"""{dict.getSectionValue "section b", "k9"=}"""
echo fmt"""{dict.getSectionValue "", "--threads"=}"""

echo "############################ env"
putEnv(SOME_KEY, someval)
echo fmt"{existsEnv(SOME_KEY)=}"
echo fmt"{getEnv(SOME_KEY)=}"
delEnv(SOME_KEY)

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


echo "############################ files/dirs/etc"

echo fmt"*_d = debug, *_r = release {nimcacheDir()=}"
echo fmt"{getCurrentDir()=}"
echo fmt"{projectDir()=}"
echo fmt"{thisDir()=}"
echo fmt"{projectPath()=}"
echo fmt"before cd {dirExists mydir=}"
cd (thisDir() / "..")  ## change is permanent
echo fmt"after cd {dirExists mydir=}"
cd ".."

withDir mydirdir:
  ## change is temporary
  ## after this block finishes we return to prev dir
  echo fmt"{dirExists mydir=}"
  echo fmt"{fileExists readme=}"
  echo fmt"non recursive {listDirs dotdir=}"
  echo fmt"non recursive {listFiles dotdir=}"

mkDir(tmpdir) ## mkdir -p tmpdir
cpDir(tmpdir, dirtmp)
for dir in [tmpdir, dirtmp]: rmDir(dir)



echo "############################ exec"
echo fmt"current Nim cmd {getCommand()=}"
echo fmt"{paramCount()=}"
for i in 0..<paramCount(): echo fmt"{paramStr i=}" ## \
  ## 0 absolute path to nim
  ## 1 is cmd

echo fmt"in cwd, then in $PATH {findExe somecmd=}"
echo fmt"resolves symlinks {findExe symlinkedcmd=}"
echo fmt"{selfExe()=}"
selfExec "-v"
exec somecmd ## throws OSError on non 0
echo fmt"returns output & exit code {gorgeEx somecmd=}"


echo "############################ catchall procs"
echo fmt"case insensitive {cmpic(tmpdir, dotdir)=}"

echo "############################ tasks"

# can also run via nimble woopwoop
task wOOpwOOp, "nimlang entering stage right":
  echo "w00p w00p... WOOP WOOP"

task djvoice, "":
  ## hidden tasks descriptions are not logged to console
  echo "ARE YOU READDDDY"
  woopwoopTask() ## tasks can run other tasks for creating pipelines

djvoiceTask()

## the following are available inside *.nimble files
# task lifecycle hooks
# before wOOpwOOp:
#   echo "djvoice: EVERYONE SAY!"
# after wOOpwOOp:
#   echo "djvoice: CMON LOUDERRR"
#   return false # stop execution
#   echo "djvoice: IS THAT ALL YOU GOT"
# local task requirements
# taskRequires "wOOpwOOp", "somedeb =~ x.y.z"

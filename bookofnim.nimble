from strutils import unindent
import os

const nimv = "1.9.3" ## sync on nim version

# Package

version       = nimv
author        = "noahehall"
description   = """
  book of nim: bow to the crown
  tested on ubuntu with nim >= 1.6.12; including v2
""".unindent

license       = "TO KILL!"
srcDir        = "src"

# Dependencies

requires "nim >= " & nimv

# Tasks

task test, "executes ./github/scripts/tests.nims":
  exec "nim e .github/scripts/test.nims"

task copyGitHooks, "copies .github/hooks to .git/hooks":
  let toDir = currentSourcePath() / ".." / ".git/hooks"
  let fromDir = currentSourcePath() / ".." / ".github/hooks"
  for kind, path in fromDir.walkDir:
    if kind == pcFile and path[(path.len - 3) .. ^1] == ".sh":
      # git hooks dont have file extensions
      let githook = path.lastPathPart[0 .. ^4]
      echo "installing git hook: ", githook
      path.cpFile toDir / githook


task postclone, "executes post-repo-clone tasks":
  copyGitHooksTask()
  testTask()

from strutils import unindent
import os

# Package

version       = "0.1.1"
author        = "noahehall"
description   = """
  book of nim: bow to the crown
  tested on ubuntu with nim >= 1.6.12; including v2
""".unindent

license       = "TO KILL!"
srcDir        = "src"

# Dependencies

requires "nim >= 1.6.12"

# Tasks

task test, "executes ./github/scripts/tests.nims":
  exec "nim e .github/scripts/test.nims"

task copyGitHooks, "copies .github/hooks to .git/hooks":
  let toDir = currentSourcePath() / ".." / ".git/hooks"
  let fromDir = currentSourcePath() / ".." / ".github/hooks"
  for kind, path in fromDir.walkDir:
    # git hooks dont have file extensions
    if kind == pcFile and path.searchExtPos == -1:
      echo "installing git hook: ", path.lastPathPart
      path.cpFile toDir / path.lastPathPart


task postclone, "executes post-repo-clone tasks":
  copyGitHooksTask()
  testTask()

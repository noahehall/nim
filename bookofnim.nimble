from strutils import unindent
import os

# Package

version       = "1.9.3" # syncd to nim version
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
    if kind == pcFile and path[(path.len - 3) .. ^1] == ".sh":
      echo "installing git hook: ", path.lastPathPart
      # git hooks dont have file extensions
      path.cpFile toDir / path.lastPathPart[0 .. ^4]


task postclone, "executes post-repo-clone tasks":
  copyGitHooksTask()
  testTask()

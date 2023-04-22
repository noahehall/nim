from strutils import unindent

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

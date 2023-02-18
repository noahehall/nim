#!/usr/bin/env nim

author = "noah edward hall"
backend = "c"
description = """
bOaT: bunch of arbitrary things
"""
license = "Free"
version = "0.0.1"

import std/distros

mode = ScriptMode.Verbose ## \
  ## TODO: the default should not be verbose

if not defined(linux):
  quit "Unfortunately, boat is only available for linux", 1
if not detectOs(Ubuntu) and not detectOs(Debian):
  echo "Be careful! we've only tested on debian like systems"

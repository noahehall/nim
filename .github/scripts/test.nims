#!/usr/bin/env nim

import std/[os, strformat]

mode = ScriptMode.Verbose

let
  # proxy for github || local machine
  rootDir = absolutePath normalizedPath "GITHUB_WORKSPACE".getEnv "."

proc installDeps: void =
  debugEcho """
    sudo apt-fast -y install \
      valgrind
  """.gorge

proc runTests: void =
  withDir rootDir:
    debugEcho fmt"testament --directory:{rootDir} all".gorge

when isMainModule:
  installDeps()
  runTests()

#!/usr/bin/env nim

import std / [os, strformat]

mode = ScriptMode.Verbose

let
  # proxy for github || local machine
  rootDir = absolutePath normalizedPath "GITHUB_WORKSPACE".getEnv "."

proc installDeps: void =
  # debatable if we should fail if unable to install deps
  # the concern are the tests running, not the deps installing
  debugEcho """
    sudo apt-fast -y install \
      valgrind
  """.gorge

proc runTests: int =
  result = withDir rootDir:
    let (result, code) = fmt"testament --directory:{rootDir} all".gorgeEx
    debugEcho result
    code

when isMainModule:
  installDeps()
  quit runTests()

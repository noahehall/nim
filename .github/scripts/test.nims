#!/usr/bin/env nim

import std / [os, strformat]

import ./run.nims

mode = ScriptMode.Verbose

let
  # proxy for github || local machine
  rootDir = absolutePath normalizedPath "GITHUB_WORKSPACE".getEnv "."

proc installDeps: (string, int) =
  result = """
    sudo apt-fast -y install \
      valgrind
  """.gorgeEx

proc runTests: (string, int) =
  result = withDir rootDir:
    fmt"testament --directory:{rootDir} all".gorgeEx

when isMainModule:
  for action in @[
    installDeps,
    runTests
  ]: run action

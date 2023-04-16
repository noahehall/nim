#!/usr/bin/env nim

import std / [os, strformat]

import ./run.nims

mode = ScriptMode.Verbose

let
  # proxy for repo root
  rootDir = absolutePath normalizedPath "GITHUB_WORKSPACE".getEnv getCurrentDir()

cd rootDir

proc installDeps: (string, int) =
  result = """
    sudo apt-fast -y install \
      valgrind
  """.gorgeEx

proc runTests: (string, int) =
  result = fmt"testament --directory:{rootDir} all".gorgeEx

proc createTestResultsHtml*: (string, int) =
  result = fmt"testament --directory:{rootDir} html".gorgeEx

when isMainModule:
  for action in @[
    installDeps,
    runTests,
    createTestResultsHtml
  ]: run action

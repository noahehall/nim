#!/usr/bin/env nim

import std / [os, strformat]

import ./run.nims

mode = ScriptMode.Verbose

let
  # proxy for github || local machine
  rootDir = absolutePath normalizedPath "GITHUB_WORKSPACE".getEnv "."
  docOpts = """
    --docInternal
    --git.commit:develop
    --git.url:https://github.com/noahehall/nim
    --hints:off
    --index:on
    --multimethods:on
    --project
    --threads:on
    --verbosity:0
    """
  mainFile = "src/bookofnim.nim"

proc deletePrevdocs(): (string, int) =
  result = with rootDir:
    "rm -rf ./htmldocs".gorgeEx

proc createDependencyGraphs(): (string, int) =
  result = with rootDir:
    fmt"nim genDepend {mainFile}".gorgeEx

proc createTestResultsHtml(): (string, int) =
  result = with rootDir:
    "testament html".gorgeEx

proc createSourceDocs(): (string, int) =
  result = with rootDir:
    fmt"nim doc -b:c {docOpts} {mainFile}".gorgeEx

when isMainModule:
  for action in @[
    deletePrevdocs,
    createDependencyGraphs,
    createTestResultsHtml,
    createDocs
  ]: run action

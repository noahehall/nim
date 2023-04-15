#!/usr/bin/env nim

import std / [os, strformat]

import ./run.nims

mode = ScriptMode.Verbose

let
  # proxy for github || local machine
  rootDir = absolutePath normalizedPath "GITHUB_WORKSPACE".getEnv getCurrentDir()
  docsDir =  "htmldocs"
  mainFile = "src/bookofnim.nim"
  docOpts = fmt"""
    --docInternal \
    --git.commit:develop \
    --git.url:https://github.com/noahehall/nim \
    --hints:off \
    --index:on \
    --multimethods:on \
    --project \
    --threads:on \
    --verbosity:0 \
    --outdir:{docsDir} \
    """

cd rootDir

proc installDeps: (string, int) =
  result = """
    sudo apt-fast -y install \
      graphviz
  """.gorgeEx

proc deletePrevdocs(): (string, int) =
  echo "deleting previous docs"
  try:
    rmDir rootDir / docsDir
    ("dir removed", 0)
  except OSError:
    ("failed to rm dir", 1)


proc createSourceDocs(): (string, int) =
  echo "create source code documentation"
  try:
    fmt"doc -b:c {docOpts} {rootDir / mainFile}".selfExec
    ("source documentation created", 0)
  except OSError:
    ("failed to create documentation", 1)

proc createDependencyGraphs(): (string, int) =
  echo "creating source code dependency graphs"
  try:
    fmt"genDepend {rootDir / mainFile}".selfExec
    for output in @[
      rootDir / "src/bookofnim.dot",
      rootDir / "src/bookofnim.png"
    ]: output.mvFile absolutePath(docsDir / output.extractFilename)
    ("dependency graph generated", 0)
  except OSError:
    ("failed to generate deps graph", 1)

when isMainModule:
  for action in @[
    installDeps,
    deletePrevdocs,
    createSourceDocs,
    createDependencyGraphs, # needs to execute after source docs are created
  ]: run action

#!/usr/bin/env nim

import std / [os, strformat]

import
  ./run.nims,
  ./test.nims

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

proc deletePrevdocs: (string, int) =
  echo "deleting previous docs"
  try:
    rmDir rootDir / docsDir
    ("dir removed", 0)
  except OSError:
    ("failed to rm dir", 1)


proc createSourceDocs: (string, int) =
  echo "create source code documentation"
  try:
    fmt"doc -b:c {docOpts} {rootDir / mainFile}".selfExec
    ("source documentation created", 0)
  except OSError:
    ("failed to create documentation", 1)

proc createTestResults: (string, int) = createTestResultsHtml()

proc createDependencyGraphs: (string, int) =
  echo "creating source code dependency graphs"
  try:
    fmt"genDepend {rootDir / mainFile}".selfExec
    ("dependency graph generated", 0)
  except OSError:
    ("failed to generate deps graph", 1)

proc mvFilesToHtmlDocsDir: (string, int) =
  echo "moving docs to htmldocs dir"
  try:
    for output in @[
      rootDir / "src/bookofnim.dot",
      rootDir / "src/bookofnim.png",
      rootDir / "testresults.html" # TODO think this broke viewing testresults in github pages
    ]: output.mvFile rootDir / docsDir / output.extractFilename
    ("documentation moved to htmldocs dir", 0)
  except CatchableError:
    ("failed to move documentation", 1)

when isMainModule:
  for action in @[
    installDeps,
    deletePrevdocs,
    createSourceDocs,
    createDependencyGraphs,
    createTestResults,
    mvFilesToHtmlDocsDir # must occur last
  ]: run action

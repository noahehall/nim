# --colors:on # breaks vscode run code extension
# --experimental:codeReordering dont use or fear the amount of logs it produces
# FYI: hint/warningAsError requires switch() syntax

--assertions:off
--checks:on
--debugger:native
--deepcopy:on # required for mm:orc/arc
--define:nimStrictDelete
--define:release
--define:ssl
--define:threadsafe
--errorMax:1
--experimental:strictEffects
--forceBuild:on
--hints:on
--mm:orc
--multimethods:on
--panics:on
--parallelBuild:0
--stackTraceMsgs:off
--styleCheck:hint
--threads:on
--tlsEmulation:on
--unitsep:on # ASCII unit separator between error msgs
--verbosity:0
--warnings:on
switch("hint","GlobalVar:off") # spams u to death
switch("hintAsError", "DuplicateModuleImport:on")
switch("hintAsError", "Performance:on")
switch("hintAsError", "XDeclaredButNotUsed:on")
switch("warningAsError", "ConfigDeprecated:on")
switch("warningAsError", "Deprecated:on")
switch("warningAsError", "GcUnsafe:on")
switch("warningAsError", "HoleEnumConv:on")
switch("warningAsError", "ResultUsed:on")
switch("warningAsError", "UnusedImport:on")
case getCommand():
  of "c", "cc", "cpp", "objc":
    --lineDir:on
    --lineTrace:on
    --stackTrace:on
  else: discard

case getEnv "ENV":
  of "DEV":
    --assertions:on
    --debuginfo:on
    --declaredLocs:on
    --define:debug
    --errorMax:0
    --excessiveStackTrace:on
    --forceBuild:off
    --opt:size
    --showAllMismatches:on
    --stackTraceMsgs:on
    --styleCheck:error
    --verbosity:2
    switch("hintAsError", "XDeclaredButNotUsed:off")
    switch("warningAsError", "Deprecated:off")
    switch("warningAsError", "HoleEnumConv:off")
  of "PERF":
    --danger
  of "SIZE":
    # @see https://github.com/ee7/binary-size
    --checks:off
    --opt:size
    --passC:"-flto"
    --passL:"-flto"
  of "SPEED":
    --checks:off
    --opt:speed
    --passC:"-flto"
    --passL:"-s"
  else: discard

case existsEnv "CI":
  of true:
    --parallelBuild:1
    --verbosity:2
  else: discard

when (NimMajor, NimMinor, NimPatch) <= (1,6,12):
  # throws in v2, maybe its no longer experimental?
  --experimental:implicitDeref
  # fails in ci, no clue but my stupid guess is
  # we need to delete test cache files before running tests after changing config switches
  switch("warningAsError", "HoleEnumConv:off")
  switch("hintAsError", "Performance:off")
  # throws on nim source code
  # @see https://github.com/nim-lang/Nim/issues/21713
  switch("hintAsError", "DuplicateModuleImport:off")
  switch("hintAsError", "XDeclaredButNotUsed:off")
  switch("warningAsError", "Deprecated:off")
  switch("warningAsError", "UnusedImport:off")
else:
  --define:futureLogging
  switch("warningAsError", "CastSizes:on")

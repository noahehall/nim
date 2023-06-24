discard """
- This config aims to provide sensible defaults for web applications
- push & pop specific pragmas in source when required, e.g. hint[Name]:off

the available environments include:
- ENV=DEV: relaxes strict mode to allow for active development of features
- ENV=PERF: danger mode
- ENV=SIZE: reduced application size
- ENV=SPEED: increased application speed
- else uses --define:release

the following envvars, if set to any value, will enable additional settings
- CI: no parallel + force builds with verbosity set to 2
- TEST: stacktraces turned on with verbosity set to 2
  - see tests/config.nims for more (we borrowed heavily from nim's test config.nims)

the following compiler switches are set for all environments focusing on
developing applications with nim in a ghetto `strict` mode; in particular
- all deprecations are errors
- hints promoting good coding hygine are turned into errors
- warnings that could materialize into bugs are turned into errors
- nimPreviewSlimSystem is set to remove deprecated symbols and other things

The aforementioned settings will disrupt your development velocity as you transition.
depending on the size of your code base and deviation from `strict` standards
will likely require major refactoring

FYI:
- --colors:on > breaks vscode run code extension
- --experimental:codeReordering > will be replaced with a better solution in the future
- --experimental:notnil > prefer strictNotNil unless your consuming unreliable packages
  - however strictNotNil currently throws on nim source, so we use notnil
- [hint|warning][AsError] > requires switch() syntax in configs
- the following are removed until https://github.com/noahehall/nim/issues/40
  --experimental:views
  --experimental:strictCaseObjects
  switch("warningAsError", "BareExcept:on")
  switch("warningAsError", "ProveInit:on")
  switch("warningAsError", "ResultUsed:on")
  switch("warningAsError", "Uninit:on")
- the following require more time to understand impact and usecase
  - --define:useRealtimeGC # @see https://nim-lang.github.io/Nim/refc.html
"""

--assertions:off # should only be enabled in dev, use doAssert for hard checks
--checks:on
--debugger:native
--deepcopy:on # required for mm:orc/arc
--define:futureLogging
--define:nimPreviewCstringConversion
--define:nimPreviewSlimSystem
--define:nimStrictDelete
--define:release
--define:ssl
--define:threadsafe
--errorMax:1
--experimental:callOperator
--experimental:dotOperators
--experimental:flexibleOptionalParams
--experimental:notnil
--experimental:parallel
--experimental:strictDefs
--experimental:strictFuncs
--hints:on
--mm:orc # required for async apps, else use arc
--multimethods:on
--panics:on
--parallelBuild:0
--spellSuggest
--stackTraceMsgs:off
--styleCheck:error
--tlsEmulation:on
--unitsep:on # ASCII unit separator between error msgs
--verbosity:0
--warnings:on
switch("hint", "CC:off")
switch("hint", "CodeBegin:off")
switch("hint", "CodeEnd:off")
switch("hint", "CondTrue:off")
switch("hint", "GCStats:off")
switch("hint", "GlobalVar:off") # spams u to death
switch("hint", "Link:off")
switch("hint", "Path:off")
switch("hint", "Processing:off")
switch("hint", "Success:off")
switch("hintAsError", "ConvFromXtoItselfNotNeeded:on")
switch("hintAsError", "ConvToBaseNotNeeded:on")
switch("hintAsError", "DuplicateModuleImport:on")
switch("hintAsError", "LineTooLong:on")
switch("hintAsError", "Performance:on")
switch("hintAsError", "XDeclaredButNotUsed:on")
switch("warningAsError", "CannotOpenFile:on")
switch("warningAsError", "CastSizes:on")
switch("warningAsError", "ConfigDeprecated:on")
switch("warningAsError", "CStringConv:on")
switch("warningAsError", "Deprecated:on")
switch("warningAsError", "EachIdentIsTuple:on")
switch("warningAsError", "EnumConv:on")
switch("warningAsError", "GcUnsafe:on")
switch("warningAsError", "HoleEnumConv:on")
switch("warningAsError", "OctalEscape:on")
switch("warningAsError", "SmallLshouldNotBeUsed:on")
switch("warningAsError", "UnreachableElse:on")
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
    --verbosity:2
    switch("hintAsError", "XDeclaredButNotUsed:off")
    switch("warningAsError", "Deprecated:off")
    switch("warningAsError", "HoleEnumConv:off")
  of "PERF":
    --danger
  of "SIZE":
    # @see https://github.com/ee7/binary-size
    --define:useMalloc
    --opt:size
    --passC:"-flto"
    --passL:"-flto"
  of "SPEED":
    --opt:speed
    --passC:"-flto"
    --passL:"-s"
  else: discard

case getEnv "ENV":
  of "SIZE", "SPEED", "PERF":
    --checks:off
    --hints:off
    --lineDir:off
    --lineTrace:off
    --stackTrace:off
    --warnings:off
  else: discard

case existsEnv "CI":
  of true:
    --forceBuild:on
    --parallelBuild:1
    --verbosity:2
  else: discard

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
--stackTraceMsgs:on
--styleCheck:error
--threads:on
--tlsEmulation:on
--unitsep:on # ASCII unit separator between error msgs
--verbosity:0
--warnings:on
# --hintAsError:Performance:on
# --hintAsError:XDeclaredButNotUsed:on
# --warningAsError:GcUnsafe:on

case getCommand():
  of "c", "cc", "cpp", "objc":
    --lineDir:on
    --lineTrace:on
    --stackTrace:on
  else: discard

case existsEnv "CI":
  of true:
    --parallelBuild:0
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
    --styleCheck:hint
    --verbosity:2
    # --colors:on # breaks vscode run code extension
    # --hintAsError:Performance:off
    # --warningAsError:GcUnsafe:off
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

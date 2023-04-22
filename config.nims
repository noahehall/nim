# --hint:Conf:off # wtf? bookofnim/config.nims(1, 2) Error: 'on' or 'off' expected, but 'Conf:
# ^ fails on any hint

--debugger:native
--deepcopy:on # required for mm:orc/arc
--define:nimStrictDelete
--define:ssl
--define:threadsafe
--experimental:strictEffects
--hints:on
--mm:orc
--multimethods:on
--panics:on
--parallelBuild:0 # 1 is always a good idea in CI
--stackTraceMsgs:on
--styleCheck:hint # in real apps set this to error
--threads:on
--tlsEmulation:on
--unitsep:on # ASCII unit separator between error msgs
--warnings:on
# you probably want the following in real apps
# --warningAsError:GcUnsafe:on
# --hintAsError:Performance:on

case getCommand():
  of "c", "cc", "cpp", "objc":
    --lineDir:on
    --lineTrace:on
    --stackTrace:on
  else: discard

case getEnv "ENV":
  of "DEV":
    --assertions:on
    --checks:on
    --debuginfo:on
    --declaredLocs:on
    --errorMax:0
    --excessiveStackTrace:on
    --opt:size
    --showAllMismatches:on
    --verbosity:2
    # --colors:on # breaks vscode run code extension
  else:
    --assertions:off
    --define:release
    --errorMax:1
    --forceBuild:on
    --opt:speed
    --verbosity:0

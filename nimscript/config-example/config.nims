# lets setup nimscript.nim for prod using the preferred syntax
# $projectDir/config.nims is useful for setting defaults
# ^ that override $parent & base nims and can be overridden by $projectfile.nims
--assertions:on
--debugger:native
--define:nimStrictDelete
--define:release
--define:ssl
--errorMax:1
--forceBuild:on
--hints:on
--mm:orc
--multimethods:on
--opt:size
--parallelBuild:0
--stackTraceMsgs:on
--styleCheck:hint
--threads:on
--tlsEmulation:on
--verbosity:0
--warnings:on

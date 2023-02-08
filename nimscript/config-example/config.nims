# lets setup nimscript.nim for prod using the preferred syntax
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

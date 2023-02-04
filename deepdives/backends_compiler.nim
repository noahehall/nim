#[
  @see
    - https://nim-lang.org/docs/asyncjs.html (js)
    - https://nim-lang.org/docs/backends.html
    - https://nim-lang.org/docs/dom.html (js)
    - https://nim-lang.org/docs/jsbigints.html (js)
    - https://nim-lang.org/docs/jsconsole.html (js)
    - https://nim-lang.org/docs/jscore.html (js)
    - https://nim-lang.org/docs/jsffi.html (js)
    - https://nim-lang.org/docs/nimc.html
    - https://nim-lang.org/docs/packaging.html



  nim CMD OPTS FILE ARGS
    nim --fullhelp see all cmd line opts
    nim --listCmd

  CMDS
    buildIndex
    check
    compile/c
    compileToC/cc
    compileToCpp/cpp
    compileToOC/objc
    ctags
    doc generate documentation for a specific backend
    dump
    e
    genDepend
    js
    jsondoc
    r compile to $nimcache/projectname then run it, prefer this over `c -r`

  OPTS
  single OPTS that take an arg req a colon
    --app:console/gui/lib/staticlib
    --assertions/-a:on/off
    --backend c|find-the-other-backends
    --checks/-x:on/off
    --colors:on|off
    --debugger:native
    --declaredLocs:on|off
    --forceBuild/-f:on/off
    --import:PATH
    --include:PATH
    --lib:PATH
    --lineTrace:on/off
    --nimcache=<targetdir> change the location of nims cache dir
    --opt:none/speed/size
    --out/-o:FILE
    --outdir:DIR
    --path-p:PATH
    --run/-r used with c to compile then run
    --stackTrace:on/off
    --stdout:on|off
    --threads:on enable threads for parallism
    -d:danger super duper production: optimization optimizes away all runtime checks and debugging help like stackframes
    -d:release production: includes some runtime checks and optimizations are turned on

    compiler
      --backend/-b:c|cpp|js|objc
      --cc:SYMBOL
      --cpu:SYMBOL
      --errorMax:N
      --exceptions:setjmp|cpp|goto|quirky
      --experimental:$1
      --hotCodeReloading:on|off
      --implicitStatic:on|off
      --incremental:on|off
      --mm:orc|arc|refc|markAndSweep|boehm|go|none|regions
      --multimethods:on|off
      --panics:on|off
      --parallelBuild:0|1|...
      --sinkInference:on|off
      --skipCfg:on|off
      --skipParentCfg:on|off
      --skipProjCfg:on|off
      --skipUserCfg:on|off
      --tlsEmulation:on|off
      --trmacros:on|off
      --verbosity:0|1|2|3

    output
      --asm
      --compileOnly/-c:on|off
      --docCmd:cmd
      --docInternal
      --docSeeSrcUrl:url
      --embedsrc:on|off
      --genScript:on|off
      --index:on|off
      --lineDir:on|off
      --nimcache:PATH
      --nimMainPrefix:prefix
      --noLinking:on|off
      --noMain:on|off
      --os:SYMBOL
      --project

    input
      --docRoot:path

    debugging
      --debuginfo:on|off
      --excessiveStackTrace:on|off
      --showAllMismatches:on|off
      --stackTraceMsgs:on|off

    developer
      --NimblePath:PATH
      --noNimblePath
      --clearNimblePath
      --benchmarkVM:on|off--profileVM:on|off

    runtime enduser
      --putenv:key=value


    all runtime checks can can be turned on/off as -x:on/off
    all require poop:on/off
      --boundChecks
      --fieldChecks
      --floatChecks
      --infChecks
      --nanChecks
      --objChecks
      --overflowChecks
      --rangeChecks

    all hints can be turned on/off as --hints:on|off|list.
    all require :on/off
      --hint:POOP
      --hintAsError:POOP

    all warnings can be turned on/off as -w/--warnings:on|off|list
    all require :on/off
      --warning:POOP
      --warningAsError:POOP

    style checks
      --styleCheck:off|hint|error
      --styleCheck:usages


  skipped
    --cincludes:DIR
    --clib:LIBNAME
    --clibdir:DIR
    --cppCompileToNamespace:namespace
    --define/-d
    --defusages
    --dynlibOverride:SYMBOL
    --dynlibOverrideAll
    --eval:cmd
    --excludePath:PATH
    --expandArc:PROCNAME
    --expandMacro:MACRO
    --filenames:abs|canonical|legacyRelProj
    --legacy:$2
    --maxLoopIterationsVM:N
    --passC/-t:OPTION
    --passL/-l:OPTION
    --processing:dots|filenames|off
    --spellSuggest|:num
    --undefine/-u
    --unitsep:on|off
    --usenimcache
    --useVersion:1.0|1.2
    doc2text
    rst2html
    rst2tex

]#

#[
  # C - the default backend
]#

#[
  # javascript backend

  gotchas / best practices
    - addr and ptr have different semantic meaning in JavaScript; newbs should avoid
    - cast[T](x) translated to (x), except between signed/unsigned ints
    - cstring in JavaScript means JavaScript string, and shouldnt be used as binary data buffer
]#


echo "############################ something"

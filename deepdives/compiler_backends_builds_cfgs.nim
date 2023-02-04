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
    buildIndex build index for all docs
    check for syntax/semantics
    compile/c
    compileToC/cc c backend
    compileToCpp/cpp c++ backend
    compileToOC/objc objective c backend
    ctags create tags file
    doc generate documentation for a specific backend
    dump list conditions & search paths
    e run a nimscript file (file.nims not file.nim)
    genDepend output dependency graph to a dot file
    js javascript backend
    jsondoc output docs to a json file
    r compile to $nimcache/projectname then run it, prefer this over `c -r`

    compiler OPTS
      --app:console/gui/lib/staticlib generate a console app|GUI app|DLL|static library
      --backend/-b:c|cpp|js|objc backend to use with commands like nim doc or nim r
      --cc:SYMBOL specify the C compiler
      --checks/-x:on/off turn all runtime checks on|off
      --colors:on|off for compiler msgs
      --compileOnly/-c:on|off generate a compile script and .deps file
      --cpu:SYMBOL set the target processor (cross-compilation)
      --errorMax:N stop compilation after N errors; 0 means unlimited
      --exceptions:setjmp|cpp|goto|quirky exception handling implementation
      --experimental:$1 enable experimental language feature X
      --hotCodeReloading:on|off support for hot code reloading on|off
      --implicitStatic:on|off implicit compile time evaluation on|off
      --incremental:on|off only recompile the changed modules
      --mm:orc|arc|refc|markAndSweep|boehm|go|none|regions memory mgmt strategy, orc for new/async
      --multimethods:on|off
      --panics:on|off turn panics into process terminations
      --parallelBuild:N num of cpus for parallel build (0 for auto-detect)
      --sinkInference:on|off turn sink parameter inference on|off
      --threads:on enable mult-threading
      --tlsEmulation:on|off thread local storage emulation
      --trmacros:on|off term rewriting macros
      --verbosity:0|1|2|3

    compile time symbol OPTS
      -d:danger remove all runtime checks and debugging, e.g. benchmarks against C
      -d:release optimize for performance
      -d:ssl activate ssl sockets
      -d:useMalloc optimize for low memory systems

    output OPTS
      --asm produce assembler code
      --assertions/-a:on/off
      --embedsrc:on|off embeds the original source code as comments in the generated output
      --forceBuild/-f:on/off rebuild all modules
      --genScript:on|off think its just an alias for --compileOnly (does the same thing)
      --index:on|off index file generation
      --lineDir:on|off runtime stacktraces include #line directives C only with --native:debugger
      --lineTrace:on/off runtime stacktraces include line numbers C only
      --nimMainPrefix:prefix use {prefix}NimMain instead of NimMain in the produced C/C++ code
      --noLinking:on|off compile Nim and generated files but do not link
      --noMain:on|off do not generate a main procedure (required for some cross-compilation targets)
      --opt:none/speed/size e.g. small output size (IoT), or fast runtime
      --os:SYMBOL the target operating system (cross-compilation)
      --out/-o:FILE change the output filename
      --outdir:DIR change the output dir
      --stackTrace:on/off runtime stacktrackes C only

    configuration OPTS
      --clearNimblePath empty the list of Nimble package search paths
      --import:PATH a module before compiling/running
      --include:PATH a module before compiling/running
      --lib:PATH set system library path
      --NimblePath:PATH add a path for Nimble support
      --nimcache:PATH path used for generated files
      --noNimblePath deactivate the Nimble path
      --path/-p:PATH add path to search paths
      --skipCfg:on|off do not read the nim installation's configuration file
      --skipParentCfg:on|off do not read the parent dirs' configuration files
      --skipProjCfg:on|off do not read the project's configuration file
      --skipUserCfg:on|off do not read the user's configuration

    documention OPTS
      --docCmd:skip|cmds for runnableExamples
      --docInternal generate documentation for non-exported symbols
      --docRoot:@pkg|@path|@default|path TODO: not quite sure if these symbols are correct
      --docSeeSrcUrl:url activate 'see source'
      --project document the whole project

    debugging OPTS
      --benchmarkVM:on|off with cpuTime() on|off
      --profileVM:on|off VM profiler
      --stdout:on|off output to stdout
      --debugger:native use native gdb debugger
      --debuginfo:on|off  debug information
      --declaredLocs:on|off declaration locations in messages
      --dump.format:json dump conditions & search paths as json
      --excessiveStackTrace:on|off stack traces use full file paths
      --run/-r run after compiling
      --showAllMismatches:on|off in overloading resolution
      --stackTraceMsgs:on|off enable user defined stack frame msgs via setFrameMsg

    runtime OPTS
      --putenv:key=value


    specific runtime check OPTS
    require :on/off, set all --checks/-x:on/off
      --boundChecks
      --fieldChecks
      --floatChecks
      --infChecks
      --nanChecks
      --objChecks
      --overflowChecks
      --rangeChecks

    specific compiler hint OPTS
    require :on/off, set all --hints:on/off/list
      --hint:POOP:
      --hintAsError:POOP:

    specific compiler warning OPTS
    require :on/off, set all --warnings/-w:on|off|list
      --warning:POOP
      --warningAsError:POOP

    compiler style check OPTS
      --styleCheck:off|hint|error hints or errors for identifiers conflicting with official style guide
      --styleCheck:usages enforce consistent spellings of identifiers, but not style declarations


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

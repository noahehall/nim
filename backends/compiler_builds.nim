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


  todos
    useStdoutAsStdmsg @see https://nim-lang.org/docs/io.html#stdmsg.t

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
      --checks/-x:on/off turn all runtime checks on|off
      --colors:on|off for compiler msgs
      --errorMax:N stop compilation after N errors; 0 means unlimited
      --exceptions:setjmp|cpp|goto|quirky exception handling implementation
      --experimental:$1 enable experimental language feature X
      --hotCodeReloading:on|off support for hot code reloading on|off
      --implicitStatic:on|off implicit compile time evaluation on|off
      --incremental:on|off only recompile the changed modules
      --deepcopy:on|off 'system.deepCopy', required to set via cli if using with --mm:arc|orc
      --mm:orc|arc|refc|markAndSweep|boehm|go|none|regions memory mgmt strategy, orc for new/async, arc|orc for realtime systems
      --multimethods:on|off
      --panics:on|off turn panics into process terminations
      --parallelBuild:N num of cpus for parallel build (0 for auto-detect)
      --sinkInference:on|off turn sink parameter inference on|off
      --threads:on enable mult-threading
      --tlsEmulation:on|off thread local storage emulation
      --trmacros:on|off term rewriting macros
      --verbosity:0|1|2|3 0 minimal, 1 default, 2 stats/libs/filters, 3 debug for compiler developers

    compile time symbol/switches OPTS
    values can be checked in when, defined(), and define pragmas
    case and _ insensitive
    keys starting with nim are reserved
    @see https://nim-lang.org/docs/nimc.html#compiler-usage-compileminustime-symbols
    either --define/-d:poop[=soop]
      --define:danger remove all runtime checks and debugging, e.g. benchmarks against C
      --define:release optimize for performance (default is debug)
      --define:ssl activate OpenSSL ssl sockets module
      --define:useMalloc optimize for low memory systems using C's malloc instead of Nim's memory manager, requires --mm:none/arc/orc, also see nimPage256/516/1k & nimMemAlignTiny
      --define:useRealtimeGC support for soft realtime systems
      --define:logGC gc logging to stdout
      --define:nodejs target nodejs (not web) when target is js
      --define:memProfiler memory profile for the native GC
      --define:uClibc use uClibc instead of libc
      --define:nimStrictDelete throws if indexed passed to a delete operator is out of bounds


    output OPTS
      --asm produce assembler code
      --assertions/-a:on/off
      --embedsrc:on|off embeds the original source code as comments in the generated output
      --forceBuild/-f:on/off rebuild all modules
      --index:on|off index file generation
      --lineDir:on|off runtime stacktraces include #line directives C only with --native:debugger
      --lineTrace:on/off runtime stacktraces include line numbers C only
      --nimcache:PATH generated files, ($XDG_CACHE_HOME|~/.cache)/nim/$projectname(_r|_d) useful for isolating/immutable/deleting built files
      --nimMainPrefix:prefix use {prefix}NimMain instead of NimMain in the produced C/C++ code
      --noLinking:on|off compile Nim and generated files but do not link
      --opt:none/speed/size e.g. small output size (IoT), or fast runtime
      --out/-o:FILE change the output filename
      --outdir:DIR change the output dir
      --stackTrace:on/off runtime stacktrackes C only

    cross compilation OPTS
    @see https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows (then scroll down for other targets)
      --cc:llvm_gcc|etc specify the C compiler, use --forceBuild to switch between compilers
      --compileOnly/-c:on|off compile nim and generate .dep files, but do not link
      --cpu:arm|i386|etc set the target processor, grep hostCPU for values
      --genScript:on|off generates a compile script, forces --compileOnly
      --noMain:on|off do not generate a main procedure (required for some targets)
      --os:any|linux|android|ios|nintendoswitch the target operating system, grep hostOS for values

    path OPTS
      --clearNimblePath empty the list of Nimble package search paths
      --import:PATH a module before compiling/running
      --include:PATH a module before compiling/running
      --lib:PATH set system library path
      --NimblePath:PATH add a path for Nimble support
      --noNimblePath deactivate the Nimble path
      --path/-p:PATH add path to search paths

    configuration file hierarchy & precedence
    file.nim passed to compile/run becomes the $project file name
    later files overwrite previous settings
    any OPT in this file can be specified in a cfg file; same format as cmd line args
    cmd line opts > cfg file opts
      - install dirs: $nim/config/nim.cfg > etc/nim/nim.cfg [nix] | <nim dir>/config/nim.cfg [win]
      - user dirs: $XDG_CONFIG_HOME/nim/nim.cfg | ~/.config/nim/nim.cfg [nix] | %APPDATA%/nim/nim.cfg [win]
      - recursive parent dirs: $parentDir/nim.cfg all the way to root
      - project dir: $projectDir/nim.cfg lives next to the $project file
      - project cfg file: $projectDir/$project.nim.cfg

    configuration OPTS
    cli opts > file opts
      --skipCfg:on|off do not read the nim installation's configuration file
      --skipParentCfg:on|off do not read the parent dirs' configuration files
      --skipProjCfg:on|off do not read the project dir/file configuration file
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
    @see https://nim-lang.org/docs/nimc.html#compiler-usage-list-of-hints
    can also be set via {.hint[POOP]:on/off.}
    require :on/off, set all --hints:on/off/list
      --hint:POOP:
      --hintAsError:POOP:

    specific compiler warning OPTS
    @see https://nim-lang.org/docs/nimc.html#compiler-usage-list-of-warnings
    can also be set via {.warning[POOP]:on/off.}
    require :on/off, set all --warnings/-w:on|off|list
      --warning:POOP
      --warningAsError:POOP

    compiler style check OPTS
      --styleCheck:off|hint|error hints or errors for identifiers conflicting with official style guide
      --styleCheck:usages enforce consistent spellings of identifiers, but not style declarations

  environment variables
    CC sets compiler when --cc:env is used

  skipped
    --cincludes:DIR
    --clib:LIBNAME
    --clibdir:DIR
    --cppCompileToNamespace:namespace
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
    --passC/-t:OPTION e.g. option for the C compiler, e.g. optimization/cross compilation support
    --passL/-l:OPTION e.g.option for the linker, e.g. cross compilation support
    --processing:dots|filenames|off
    --spellSuggest|:num
    --undefine/-u
    --unitsep:on|off
    --usenimcache
    --useVersion:1.0|1.2
    -d:androidNDK (cross compile for android supporting android studio projects)
    -d:checkAbi
    -d:globalSymbols
    -d:mingw (cross compile for windows from linux)
    -d:nimBultinSetjmp
    -d:nimRawSetjmp
    -d:nimSigSetjmp
    -d:nimStdSetjmp
    -d:nimThreadStackGuard
    -d:nimThreadStackSize
    -d:noSignalHandler @see https://nim-lang.org/docs/nimc.html#signal-handling-in-nim
    -d:tempDir
    -d:useFork
    -d:useNimRtl
    -d:useShPath
    doc2text
    rst2html
    rst2tex

]#

#[
  # C backend - the default
]#

#[
  # CPP backend
]#

#[
  # OBJC backend
]#

#[
  # javascript backend

  gotchas / best practices
    - addr and ptr have different semantic meaning in JavaScript; newbs should avoid
    - cast[T](x) translated to (x), except between signed/unsigned ints
    - cstring in JavaScript means JavaScript string, and shouldnt be used as binary data buffer
]#


echo "############################ compile time checking"
# @see https://nim-lang.org/docs/system.html#compileOption%2Cstring%2Cstring
when compileOption("opt", "size") and compileOption("gc", "boehm"):
  echo "compiled with optimization for size and uses Boehm's GC"
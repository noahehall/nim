##
## memory mgmt and compiler
## ========================
## [bmark: everything starting here](https://nim-lang.github.io/Nim/nimc.html#crossminuscompilation)

##[
## TLDR
- newruntime in docs refer to orc/arc, and is deprecated in favor of picking one of orc/arc
- ORC: the default memory management strategy
  - abc
- ARC
  - abc
- REFC: reference counting
  - nim < 2 default stratetgy

links
-----
- other
  - [nimbus memory mgmt intro](https://nimbus.guide/auditors-book/02.2.3_memory_management_gc.html)
  - [advanced compilers self guided online course](https://www.cs.cornell.edu/courses/cs6120/2020fa/self-guided/)
  - [a cost model for nim](https://nim-lang.org/blog/2022/11/11/a-cost-model-for-nim.html)\
  - [introduct to arc/orc](https://nim-lang.org/blog/2020/10/15/introduction-to-arc-orc-in-nim.html)
- high impact docs
  - [backend introduction](https://nim-lang.github.io/Nim/backends.html)
  - [cross compile applications](https://nim-lang.github.io/Nim/nimc.html#crossminuscompilation)
  - [destructors and move symantics](https://nim-lang.github.io/Nim/destructors.html)
  - [memory management](https://nim-lang.github.io/Nim/mm.html)
  - [nim compiler](https://nim-lang.github.io/Nim/nimc.html)


TODOs
-----
- niminaction: appendix b 282-290
- [checkout glmf example repo for targeting android/ios](https://github.com/treeform/glfm)
- review this entire file again, shiz alot clearer now
- useStdoutAsStdmsg @see https://nim-lang.github.io/Nim/io.html#stdmsg.t
- Mixed mode projects are not officially supported anymore, it's too hard
  - [forum conversation](https://forum.nim-lang.org/t/9948)
- [embedded stack trace profiler guide](https://nim-lang.org/1.6.10/estp.html)
- [additional features](https://nim-lang.github.io/Nim/nimc.html#additional-features)
- [compiling nim with PGO post](https://forum.nim-lang.org/t/10128)

## nimc
- nim CMD OPTS FILE ARGS
  - nim --fullhelp see all cmd line opts
  - nim --listCmd

path substitution
-----------------
- $nim: the global nim prefix path
- $lib: the stdlib path
- $home and ~: users home path
- $config: the main file being compiled
- $projectname: the main file without the ext
- $project[path/dir]: the main files path
- $nimcache: think this is always nimble's cache dir

configuration file hierarchy & precedence
-----------------------------------------
- file.nim passed to compile/run becomes the $project file name
- later files overwrite previous settings
- any OPT in this file can be specified in a cfg file; same format as cmd line args
- cmd line opts > cfg file opts
  - install dirs: $nim/config/nim.cfg > etc/nim/nim.cfg [nix] | <nim dir>/config/nim.cfg [win]
  - user dirs: $XDG_CONFIG_HOME/nim/nim.cfg | ~/.config/nim/nim.cfg [nix] | %APPDATA%/nim/nim.cfg [win]
  - recursive parent dirs: $parentDir/nim.cfg all the way to root
  - project dir: $projectDir/nim.cfg lives next to the $project file
  - project cfg file: $projectDir/$project.nim.cfg

## nimc CMDS

high impact cmds
----------------
- check for syntax/semantics
- compile to --backend:thisThing by default uses -c
- compileToC/cc specifically to C
- compileToCpp/cpp specifically c++ backend
- compileToOC/objc specifically objective c backend
- doc generate documentation for a specific backend
- e run a nimscript file (file.nims not file.nim)
- js specifically javascript backend
- md2html convert a markdown file to html
- r compile to $nimcache/projectname then run it, prefer this over `c -r`
- rst2html convert an rst file to html

useful cmds
-----------
- dump list conditions & search paths

niche cmds
----------
- buildIndex build index for all docs
- ctags create tags file
- genDepend output dependency graph to a dot file
- jsondoc output docs to a json file

## compiler OPTS
- these options are set by either `--blah` or `define:blah`
  - 99% of these should be set in a config.nims
- specifically for those using --define syntax
  - case and _ insensitive
  - values can be checked in when, defined(), and {.define.} pragmas
  - keys starting with nim are reserved
- opts provided on the CMD line >>> opts in config files
- @see https://nim-lang.github.io/Nim/nimc.html#compiler-usage-compileminustime-symbols
- @see https://nim-lang.github.io/Nim/manual.html#implementation-specific-pragmas-compileminustime-define-pragmas
- @see https://nim-lang.github.io/Nim/nimc.html#crossminuscompilation

high impact OPTS lvl 1
----------------------
- --debugger:native use native gdb debugger
- --define:danger remove all runtime checks and debugging, e.g. benchmarks against C
- --define:release optimize for performance (default is debug)
- --define:ssl activate OpenSSL ssl sockets module
- --forceBuild/-f:on/off rebuild all modules
- --multimethods:on|off
- --opt:none/speed/size e.g. small output size (IoT), or fast runtime
- --out/-o:FILE change the output filename
- --outdir:DIR change the output dir
- --panics:on|off turn panics into process terminations
- --putenv:key=value
- --styleCheck:off|hint|error hints or errors for identifiers conflicting with official style guide
- --styleCheck:usages enforce consistent spellings of identifiers, but not style declarations
- --undefine a symbol set by --define
- --useRealtimeGC enable nims GC for solf realtime systems

high impact OPTS lvl 2
-------------------------------------
- --assertions/-a:on/off TODO(noah): done think this is relevant for v2
- --checks/-x:on/off turn all runtime checks on|off
- --deepcopy:on|off 'system.deepCopy', required to set via cli if using with --mm:arc|orc
- --define:nimMaxDescriptorsFallback=N for httpasyncserver
- --define:nimStrictDelete throws if indexed passed to a delete operator is out of bounds
- --errorMax:N stop compilation after N errors; 0 means unlimited
- --excessiveStackTrace:on|off stack traces use full file paths
- --experimental:$1 enable experimental language feature X
- --implicitStatic:on|off implicit compile time evaluation on|off
- --parallelBuild:N num of cpus for parallel build (0 for auto-detect)
- --showAllMismatches:on|off in overloading resolution
- --spellSuggest|:num|auto just set to `--spellSugest` and move on with life
- --threads:on enable mult-threading (defaults to on)
- --tlsEmulation:on|off thread local storage emulation
- --verbosity:0|1|2|3 0 minimal, 1 default, 2 stats/libs/filters, 3 debug for compiler developers

useful OPTS
-----------
- --clearNimblePath empty the list of Nimble package search paths
- --define:tempDir=woop override path returned in os.getTempDir()
- --hotCodeReloading:on|off support for hot code reloading on|off
- --import:PATH a module before compiling/running
- --include:PATH a module before compiling/running
- --incremental:on|off only recompile the changed modules
- --lib:PATH set system library path
- --lineDir:on|off runtime stacktraces include #line directives C only with --native:debugger
- --lineTrace:on/off runtime stacktraces include line numbers C only
- --NimblePath:PATH add a path for Nimble support
- --nimcache:PATH generated files, ($XDG_CACHE_HOME|~/.cache)/nim/$projectname(_r|_d) useful for isolating/immutable/deleting built files
- --nimMainPrefix:prefix use {prefix}NimMain instead of NimMain in the produced C/C++ code
- --noNimblePath deactivate the Nimble path
- --path/-p:PATH add path to search paths


backend/targeting/cross-compiling OPTS
--------------------------------------
- --app:console/gui/lib/staticlib generate a console app|GUI app|DLL|static library
- --asm produce assembler code
- --backend/-b:c|cpp|js|objc backend to use with commands like nim doc or nim r
- --cc:llvm_gcc|etc specify the C compiler, use --forceBuild to switch between compilers
- --compileOnly/-c:on|off compile nim and generate .dep files, but do not link
- --cpu:arm|i386|etc set the target processor, grep hostCPU for values
- --define:nodejs target nodejs (not web) when target is js
- --define:uClibc use uClibc instead of libc
- --embedsrc:on|off embeds the original source code as comments in the generated output
- --genScript:on|off generates a compile script, forces --compileOnly
- --jsbigint64:on|off enable BigInt 64bit integers for js (defaults on)
- --noLinking:on|off compile Nim and generated files but do not link
- --noMain:on|off do not generate a main procedure (required for some targets)
- --os:any|linux|android|ios|nintendoswitch the target operating system, grep hostOS for values
- --stackTrace:on/off runtime stacktrackes C only

memory related define OPTS
--------------------------
- --define:logGC gc logging to stdout
- --define:memProfiler memory profile for the native GC
- --define:useMalloc optimize for low memory systems using C's malloc instead of Nim's memory manager, requires --mm:none/arc/orc, also see nimPage256/516/1k & nimMemAlignTiny
- --define:useRealtimeGC support for soft realtime systems
- --mm:orc|arc|refc|markAndSweep|boehm|go|none|regions memory mgmt strategy, orc for new/async, arc|orc for realtime systems
- --sinkInference:on|off turn sink parameter inference on|off

configuration OPTS
------------------
- --skipCfg:on|off do not read the nim installation's configuration file
- --skipParentCfg:on|off do not read the parent dirs' configuration files
- --skipProjCfg:on|off do not read the project dir/file configuration file
- --skipUserCfg:on|off do not read the user's configuration

documention OPTS
----------------
- --docCmd:skip|cmds for runnableExamples
- --docInternal generate documentation for non-exported symbols
- --docRoot:@pkg|@path|@default|path TODO: not quite sure if these symbols are correct
- --docSeeSrcUrl:url activate 'see source'
- --project document the whole project

debugging OPTS
--------------
- --defusages find the definition and usages of a symbol
- --benchmarkVM:on|off with cpuTime() on|off
- --profileVM:on|off VM profiler
- --stdout:on|off output to stdout
- --debuginfo:on|off  debug information
- --declaredLocs:on|off declaration locations in messages
- --dump.format:json dump conditions & search paths as json
- --stackTraceMsgs:on|off enable user defined stack frame msgs via setFrameMsg
- --processing:dots|filenames|off show files as their being compiled

niche OPTS
----------
- --colors:on|off for compiler msgs
- --exceptions:setjmp|cpp|goto|quirky exception handling implementation
- --trmacros:on|off term rewriting macros
- --index:on|off index file generation


runtime check OPTS
------------------
- require :on/off, set all --checks/-x:on/off
  - --boundChecks
  - --fieldChecks
  - --floatChecks
  - --infChecks
  - --nanChecks
  - --objChecks
  - --overflowChecks
  - --rangeChecks

compiler hint OPTS
------------------
- @see https://nim-lang.github.io/Nim/nimc.html#compiler-usage-list-of-hints
- can also be set via {.hint[woop]:on/off.}
- require :on/off, set all --hints:on/off/list
  - --hint:woop:
  - --hintAsError:woop:
  - sometimes its just woop:off, instead of hint:woop:off

compiler warning OPTS
---------------------
- @see https://nim-lang.github.io/Nim/nimc.html#compiler-usage-list-of-warnings
- can also be set via {.warning[woop]:on/off.}
- require :on/off, set all --warnings/-w:on|off|list
- @see https://nim-lang.github.io/Nim/nimc.html#compiler-usage-list-of-warnings
  - --warning:woop
  - --warningAsError:woop


environment variables
---------------------
- CC sets compiler when --cc:env is used
- `-d:nimPreviewHashRef` enable hashing refs

skipped
-------
- --app:lib something to do with generating dynamic libraries (grep os docs)
- --cincludes:DIR
- --clib:LIBNAME
- --clibdir:DIR
- --cppCompileToNamespace:namespace
- --dynlibOverride:SYMBOL
- --dynlibOverrideAll
- --eval:cmd
- --excludePath:PATH
- --expandArc:PROCNAME
- --expandMacro:MACRO
- --filenames:abs|canonical|legacyRelProj
- --legacy:$2
- --maxLoopIterationsVM:N
- --passC/-t:OPTION e.g. option for the C compiler, e.g. optimization/cross compilation support
- --passL/-l:OPTION e.g.option for the linker, e.g. cross compilation support
- --unitsep:on|off
- --usenimcache
- --useVersion:1.0|1.2
- -d:androidNDK (cross compile for android supporting android studio projects)
- -d:checkAbi
- -d:globalSymbols
- -d:mingw (cross compile for windows from linux)
- -d:nimBultinSetjmp
- -d:nimRawSetjmp
- -d:nimSigSetjmp
- -d:nimStdSetjmp
- -d:nimThreadStackGuard
- -d:nimThreadStackSize
- -d:noSignalHandler @see https://nim-lang.github.io/Nim/nimc.html#signal-handling-in-nim
- -d:useFork
- -d:useNimRtl
- -d:useShPath
- doc2text
- rst2html
- rst2tex

## memory management
- memory allocation
  - nim GC backed by TLSF allocator for soft real-time guarantees
  - flag `-d:useMalloc` to bypass TLSF allocator and use malloc/free
]##


echo "############################ compile time checking"
# @see https://nim-lang.github.io/Nim/system.html#compileOption%2Cstring%2Cstring
when compileOption("opt", "size") and compileOption("gc", "boehm"):
  echo "compiled with optimization for size and uses Boehm's GC"

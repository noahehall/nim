##
## compiling and custome memory mgmt
## =================================
## bookmark: rework this entire file

##[
## TLDR
- Stack allocated (value semantics)
  - plain objects
  - chars
  - numbers
  - pointer types (alloc)
- Heap allocated (usually ref semantics)
  - sequences (value semantics)
  - strings (value semantics)
  - ref types
  - pointer types (malloc)
- Copied on assignment
    - sequences
    - strings
- mutable
  - var (variables & parameters)
  - ref/pointer types can always be mutated through a pointer
- immutable
  - const (compile time)
  - let (runtime, cant be reassigned)
  - ref/pointer variables cant point to a new ref/pointer after


links
-----
- other
  - [chris: understanding mmap (video)](https://www.youtube.com/watch?v=8hVLcyBkSXY)
  - [memory mgmt intro](https://nimbus.guide/auditors-book/02.2.3_memory_management_gc.html)
  - [advanced compilers self guided online course](https://www.cs.cornell.edu/courses/cs6120/2020fa/self-guided/)
- high impact
  - [backend introduction](https://nim-lang.org/docs/backends.html)
  - [cross compile applications](https://nim-lang.org/docs/nimc.html#crossminuscompilation)
  - [destructors and move symantics](https://nim-lang.org/docs/destructors.html)
  - [gc docs](https://nim-lang.org/1.6.0/gc.html)
  - [memory management](https://nim-lang.org/docs/mm.html)
  - [nim compiler](https://nim-lang.org/docs/nimc.html)


todos
-----
- [checkout glmf example repo for targeting android/ios](https://github.com/treeform/glfm)
- review this entire file again, shiz alot clearer now
- useStdoutAsStdmsg @see https://nim-lang.org/docs/io.html#stdmsg.t
- Mixed mode projects are not officially supported anymore, it's too hard
  - [forum conversation](https://forum.nim-lang.org/t/9948)
- [embedded stack trace profiler guide](https://nim-lang.org/1.6.10/estp.html)
- [additional features](https://nim-lang.org/docs/nimc.html#additional-features)

## nimc
- nim CMD OPTS FILE ARGS
  - nim --fullhelp see all cmd line opts
  - nim --listCmd

CMDS
----
- buildIndex build index for all docs
- check for syntax/semantics
- compile/c
- compileToC/cc c backend
- compileToCpp/cpp c++ backend
- compileToOC/objc objective c backend
- ctags create tags file
- doc generate documentation for a specific backend
- dump list conditions & search paths
- e run a nimscript file (file.nims not file.nim)
- genDepend output dependency graph to a dot file
- js javascript backend
- jsondoc output docs to a json file
- r compile to $nimcache/projectname then run it, prefer this over `c -r`

compiler OPTS
-------------
- --app:console/gui/lib/staticlib generate a console app|GUI app|DLL|static library
- --backend/-b:c|cpp|js|objc backend to use with commands like nim doc or nim r
- --checks/-x:on/off turn all runtime checks on|off
- --colors:on|off for compiler msgs
- --errorMax:N stop compilation after N errors; 0 means unlimited
- --exceptions:setjmp|cpp|goto|quirky exception handling implementation
- --experimental:$1 enable experimental language feature X
- --hotCodeReloading:on|off support for hot code reloading on|off
- --implicitStatic:on|off implicit compile time evaluation on|off
- --incremental:on|off only recompile the changed modules
- --deepcopy:on|off 'system.deepCopy', required to set via cli if using with --mm:arc|orc
- --mm:orc|arc|refc|markAndSweep|boehm|go|none|regions memory mgmt strategy, orc for new/async, arc|orc for realtime systems
- --multimethods:on|off
- --panics:on|off turn panics into process terminations
- --parallelBuild:N num of cpus for parallel build (0 for auto-detect)
- --sinkInference:on|off turn sink parameter inference on|off
- --threads:on enable mult-threading
- --tlsEmulation:on|off thread local storage emulation
- --trmacros:on|off term rewriting macros
- --verbosity:0|1|2|3 0 minimal, 1 default, 2 stats/libs/filters, 3 debug for compiler developers

compile time symbol/switches OPTS
---------------------------------
- values can be checked in when, defined(), and define pragmas
- case and _ insensitive
- keys starting with nim are reserved
- @see https://nim-lang.org/docs/nimc.html#compiler-usage-compileminustime-symbols
- either --define/-d:woop[=soop]
  - --define:danger remove all runtime checks and debugging, e.g. benchmarks against C
  - --define:release optimize for performance (default is debug)
  - --define:ssl activate OpenSSL ssl sockets module
  - --define:useMalloc optimize for low memory systems using C's malloc instead of Nim's memory manager, requires --mm:none/arc/orc, also see nimPage256/516/1k & nimMemAlignTiny
  - --define:useRealtimeGC support for soft realtime systems
  - --define:logGC gc logging to stdout
  - --define:nodejs target nodejs (not web) when target is js
  - --define:memProfiler memory profile for the native GC
  - --define:uClibc use uClibc instead of libc
  - --define:nimStrictDelete throws if indexed passed to a delete operator is out of bounds
  - --define:tempDir=woop override path returned in os.getTempDir()

output OPTS
-----------
- --asm produce assembler code
- --assertions/-a:on/off
- --embedsrc:on|off embeds the original source code as comments in the generated output
- --forceBuild/-f:on/off rebuild all modules
- --index:on|off index file generation
- --lineDir:on|off runtime stacktraces include #line directives C only with --native:debugger
- --lineTrace:on/off runtime stacktraces include line numbers C only
- --nimcache:PATH generated files, ($XDG_CACHE_HOME|~/.cache)/nim/$projectname(_r|_d) useful for isolating/immutable/deleting built files
- --nimMainPrefix:prefix use {prefix}NimMain instead of NimMain in the produced C/C++ code
- --noLinking:on|off compile Nim and generated files but do not link
- --opt:none/speed/size e.g. small output size (IoT), or fast runtime
- --out/-o:FILE change the output filename
- --outdir:DIR change the output dir
- --stackTrace:on/off runtime stacktrackes C only

cross compilation OPTS
----------------------
- @see https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows (then scroll down for other targets)
- --cc:llvm_gcc|etc specify the C compiler, use --forceBuild to switch between compilers
- --compileOnly/-c:on|off compile nim and generate .dep files, but do not link
- --cpu:arm|i386|etc set the target processor, grep hostCPU for values
- --genScript:on|off generates a compile script, forces --compileOnly
- --noMain:on|off do not generate a main procedure (required for some targets)
- --os:any|linux|android|ios|nintendoswitch the target operating system, grep hostOS for values

path OPTS
---------
- --clearNimblePath empty the list of Nimble package search paths
- --import:PATH a module before compiling/running
- --include:PATH a module before compiling/running
- --lib:PATH set system library path
- --NimblePath:PATH add a path for Nimble support
- --noNimblePath deactivate the Nimble path
- --path/-p:PATH add path to search paths


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

configuration OPTS
------------------
- cli opts > file opts
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
- --benchmarkVM:on|off with cpuTime() on|off
- --profileVM:on|off VM profiler
- --stdout:on|off output to stdout
- --debugger:native use native gdb debugger
- --debuginfo:on|off  debug information
- --declaredLocs:on|off declaration locations in messages
- --dump.format:json dump conditions & search paths as json
- --excessiveStackTrace:on|off stack traces use full file paths
- --run/-r run after compiling
- --showAllMismatches:on|off in overloading resolution
- --stackTraceMsgs:on|off enable user defined stack frame msgs via setFrameMsg

runtime OPTS
------------
- --putenv:key=value
- -d:nimMaxDescriptorsFallback=N for httpasyncserver

specific runtime check OPTS
---------------------------
- require :on/off, set all --checks/-x:on/off
  - --boundChecks
  - --fieldChecks
  - --floatChecks
  - --infChecks
  - --nanChecks
  - --objChecks
  - --overflowChecks
  - --rangeChecks

specific compiler hint OPTS
---------------------------
- @see https://nim-lang.org/docs/nimc.html#compiler-usage-list-of-hints
- can also be set via {.hint[woop]:on/off.}
- require :on/off, set all --hints:on/off/list
  - --hint:woop:
  - --hintAsError:woop:
  - sometimes its just woop:off, instead of hint:woop:off

specific compiler warning OPTS
------------------------------
- @see https://nim-lang.org/docs/nimc.html#compiler-usage-list-of-warnings
- can also be set via {.warning[woop]:on/off.}
- require :on/off, set all --warnings/-w:on|off|list
  - --warning:woop
  - --warningAsError:woop

compiler style check OPTS
-------------------------
- --styleCheck:off|hint|error hints or errors for identifiers conflicting with official style guide
- --styleCheck:usages enforce consistent spellings of identifiers, but not style declarations

environment variables
---------------------
- CC sets compiler when --cc:env is used
- `-d:nimPreviewHashRef` enable hashing refs

type opts
---------

skipped
-------
- --app:lib something to do with generating dynamic libraries (grep os docs)
- --cincludes:DIR
- --clib:LIBNAME
- --clibdir:DIR
- --cppCompileToNamespace:namespace
- --defusages
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
- --processing:dots|filenames|off
- --spellSuggest|:num
- --undefine/-u
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
- -d:noSignalHandler @see https://nim-lang.org/docs/nimc.html#signal-handling-in-nim
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
# @see https://nim-lang.org/docs/system.html#compileOption%2Cstring%2Cstring
when compileOption("opt", "size") and compileOption("gc", "boehm"):
  echo "compiled with optimization for size and uses Boehm's GC"

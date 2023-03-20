##
## pragmas, effects and experimental features
## ==========================================
## - [bookmark](https://nim-lang.org/docs/manual.html#effect-system)

##[
## TLDR
- pragmas
  - syntax: `{.pragma1, pragma2:val, etc.}`
  - many pragmas require familiarity of C/C++/objc
  - FYI:
    - a futile attempt was taken at categorizing pragmas
    - pragma annotation & macro pragmas are in templateMacros.nim
    - thread/async like templates are in asyncPar.nim

links
-----
- [pragmas section in manual](https://nim-lang.org/docs/manual.html#pragmas)
- [effect system in manual](https://nim-lang.org/docs/manual.html#effect-system)

todos
-----
- [effect system](https://nim-lang.org/docs/manual.html#effect-system)
- [experimental](https://nim-lang.org/docs/manual_experimental.html)
- move all the C pragmas into the backends dir

## pragmas
- enable new functionality without adding new keywords to the language
- are processed on the fly durings emantic checking
- push & prop pragmas should spark your imagination
- user defined pragmas are in a module wide scope distinct from all other symbol types
  - cannot be improted from a module
- union & packed pragma should not use inheritance/GCed memory

.. code-block:: Nim
  var x {.pragmaX.} = thingsome
  var y {.intdefine.} = 20 # see intdefine, 20 will be replaced if --define:y=blah
  proc y(): auto {.pragmaX:value.} =

  {.experimental: "pragmaZ".} # can be module scoped too

  {.pragma:myPragma, pragmaX, pragmaY.} # create new pragma named myPragma
  proc Z(): auto {.myPragma.} # <- now receives pragmaX and pragmaY


custom pragmas
--------------
- compile tiem pragmas: pass to the compiler via `--define:X=Y`
  - intdefine replaces all assignments to X with value extracted from `--define:X=42`
  - strdefine same as intdefine but for strings
  - booldefine same as intdefine but for bools
- user defined pragmas: WOOP is a new pragma,
  - pragma:WOOP, pragmaX, pragmaY
- see templateMacros.nim for template pragmas

universal pragmas
-----------------
- compileTime marks proc as compile time only; vars init during compile and const at runtime
- deprecated: "optional msg" flag, prints warning in compiler logs if symbol is used
- error: "msg" annotate a symbol with an error msg; when the symbol is used a static error is thrown
- fatal: "msg" same as error but compilation is guaranteed to be aborted when symbol is used
- used: inform the compiler this symbol/module is used, and not to print warning about it
- warning: "msg" same as error but for warnings

var pragmas
-----------
- global converts a proc scoped var into a global
- raises: [x,y,z] list permitted exceptions; non listed force compiler errs
- threadvar informs the compiler this var should be local to a thread

proc pragmas
------------
- varags this proc can take a variable number of params after the last one
- async requires import asyncdispatch; proc can now use await keyword
- base method used on a base type for inheritable objects
- closure
- noReturn proc that never returns
- noSideEffect proc is interpreted as a func (see routines.nim)
- thread informs the compiler this proc is meant for execution on a new thread

type pragmas
------------
- acyclic mark object as non recursive incase GC infers otherwise; for GC optimization
- bycopy pass this obj/tuple by value into procs
- byref pass this obj/tuple by ref into procs
- final mark an object as non inheritable
- inheritable create alternative RootObj
- shallow objects can be shallow copied; use w/ caution; speeds up assignments considerably
- union sets an objects fields overlaid in memory producing a union instead of struct in C/++
- packed sets an objects field back to back in memory; e.g. for network/hardware drivers

effect pragmas
--------------
- linearScanEnd signify the end of expected case branches for optimization
- pop: [x,y,z] remove pragma/all previously pushed pragmas from the code that follows
- push: [x,y,z] add pragma into the context of the code that follows

JS pragmas
----------
- importJs fns/symbols that can be called via `obj.fn(args)`

experimental pragmas
--------------------
- enable experimental features
  - parallel

compilation pragmas
-------------------
- assertions:on/off
- boundChecks:on/off
- callconv:on/off
- checks:on/off
- hint[woop]:on/off
- hints:on/off
- nilChecks:on/off
- optimization:none/speed/size
- overflowChecks: on/off
- patterns:on/off
- warning[woop]:on/off
- warnings:on/off

niche pragmas
-------------
- asmNoStackFrame should only be used by procs consisting only of assembler statements
- effects will output all inferred effects (e.g. exceptions) up to this point
- pure requires enums to be fully qualified; x fails, but y.x doesnt
- line modify line information as seen in stacktraces
- regiser a var for placement in hardware registry for faster access

unknown/skipped/C pragmas
-------------------------
- align
- bitsize
- codegenDecl
- compile
- computedGoTo dunno; something to do with case statements in a while loop and interpreters
- cpopNonPod
- dirty something to do with templates
- discardable
- dynlib: "exactName" import a proc/var from a dynamic .{dll,so} library
- dynlib export this symbol to a dynamic library, must be used with exportc
- emit
- exportc: "optionalName" use the symbols/provided name when exporting this to c
- extern: "x$1" affects symbol name mangling when exported
- header
- importc import a proc/var from C
- importCpp
- importObjC
- incompleteStruct
- inject something to do with symbol visibility
- inline a proc; dunno what that means
- link
- localPassc
- nodecl
- passc
- passl
- registerProc dunno; included in the compileTime example
- size dunno
- volatile


## effects

effect types
------------
IOEffect
- ExecIOEffect executing IO operation
- ReadIOEffect describes a read IO operation
- RootEffect custom effects should inherit from this
- TimeEffect
- WriteIOEffect
]##


echo "############################ push/pop pragma"
# @see https://nim-lang.org/docs/manual.html#pragmas-push-and-pop-pragmas
# this (im-status) trick prohibits procs from throwing defects, but allows errors
# compiler will throw if its analysis determines a proc can throw a defect, helps u debug

# all procs after this line will have this pragma
# first line of your file
{.push raises:[Defect]}

# your
# code
# here

# all procs after this line will have the previous push removed
# last line of your file
{.pop.}

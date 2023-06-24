##
## pragmas, effects and experimental features
## ==========================================
## - [bookmark](https://nim-lang.github.io/Nim/manual.html#effect-system-tag-tracking)

##[
## TLDR
- pragmas
  - syntax: `{.pragma1, pragma2:val, type[pragma]:val, etc.}`
  - many pragmas require familiarity of C/C++/objc
  - FYI: a futile attempt was taken at categorizing pragmas
- effect system consists of
  - and empty [] in raises/tags declares none are permitted
  - compile time routine CatchableError tracking {.raises: [commaSeparated] .}
    - compile time tracking of exception types a routine can/t throw
  - user defined effect tag (type) tracking {.tags:[commaSeparated}.}
    - create a type that denotes some user defined thing you want to track
    - apply tag(s) to routine A to permit
    - apply empty [] or {.forbids: [commaSeparated] .} to routine B to restrict calls to routine A
  - functional side effect tracking (implies gc safety below)
    - {.noSideEffect.} throws if this routine has sideEffects
    - {.cast(noSideEffect).}: disables side effect tracking
    - a routine has no sideEffects if:
      - it doesnt access a threadlocal/global var
      - does not invoke a routine that does
  - memory/gc safety tracking
    - a routine is GC safe if:
      - doesnt (in)directly access global vars of type string, seq, ref or closures
    - {.gcsafe.} throws if a routine is unsafe
    - {.cast(gcsafe).} disables safety tracking
  - effect logging
    - a single line with {.effects.} causes the compiler to output all effects up to that point

links
-----
- other
  - [wikipedia side effects](https://en.wikipedia.org/wiki/Effect_system)
- [effect system intro](https://nim-lang.github.io/Nim/manual.html#effect-system)
- [list of effects](https://github.com/nim-lang/Nim/blob/devel/lib/system/exceptions.nim)
- [pragmas intro](https://nim-lang.github.io/Nim/manual.html#pragmas)

TODOs
-----
- [experimental features](https://nim-lang.github.io/Nim/manual_experimental.html)
- [dot operator template](https://nim-lang.github.io/Nim/manual_experimental.html#special-operators-dot-operators)
- move all the C pragmas into the backends dir
- [document the effect types from devel branch](https://github.com/nim-lang/Nim/blob/devel/lib/system/exceptions.nim)
- distribute the pragmas in this file into other files, but keep this comprehensive list up to date

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

universal pragmas
-----------------
- compileTime marks symbol as compile time only; vars init during compile and const at runtime
- deprecated: "optional msg" flag, prints warning in compiler logs if symbol is used
- effects will output all inferred effects (e.g. exceptions) up to this point
- error: "msg" annotate a symbol with an error msg; when the symbol is used a static error is thrown
- fatal: "msg" same as error but compilation is guaranteed to be aborted when symbol is used
- linearScanEnd signify the end of expected case branches for optimization
- pop: x,y,z remove pragma/all pushed pragmas, e.g. {.pop.} removes all
- push: x,y,z add pragmas until popped, e.g. {.push hints:off, warning[blah]: on.}
- used: inform the compiler this symbol/module is used, and not to print warning about it
- warning: "msg" same as error but for warnings
- hint: "msg" output a a hint when symbol is used

var pragmas
-----------
- global stores a proc scoped var in a global location so its initialized only once at startup
- register this variable for placement in a hardware register for faster access

thread pragmas
--------------
- thread this proc can be passed to createThread/spawn
- threadvar this var is local to a thread, implies global pragma

routine pragmas
---------------
- async requires import asyncdispatch; proc can now use await keyword
- base method used on a base type for inheritable objects
- closure
- effectsOf: paramX inform the compiler this proc has the effects of paramX
- inline this proc at the callsite instead of calling it
- noReturn proc that never returns
- noSideEffect proc is interpreted as a func (see routines.nim)
- raises: [x,y,z] list permitted exceptions; non listed force compiler errs
- tags: [x,y,z] list of user defined effects to enforce
- varags this proc can take a variable number of params after the last one

type pragmas
------------
- acyclic mark object as non recursive incase GC infers otherwise; for GC optimization
- bycopy pass this obj/tuple by value into procs
- byref pass this obj/tuple by ref into procs
- final mark an object as non inheritable
- inheritable create alternative RootObj
- overloadableEnums allows two Enums to have same fieldnames, to be resolved at runtime
- packed sets an objects field back to back in memory; e.g. for network/hardware drivers
- pure requires enums to be fully qualified; or omit an objects type field at runtime
- shallow copy on assignment; breaks GC safety; speeds up assignments considerably
- union sets an objects fields overlaid in memory producing a union instead of struct in C/++
- forbids from invoking/consuming type T
- noinit do not initialize this symbol with a default value (optimization)
- requiresInit throw error if this symbol is later used without first being initialized

JS pragmas
----------
- importJs fns/symbols that can be called via `obj.fn(args)`

experimental: "woop"
------------------------
- FYI:
  - can be applied to a symbol / module / config switch
- callOperator enabless overload `(a[,b...])` so it calls a template like `blah(a,...)`
- dotOperators enable overloading `a.b | a.b = c` so it calls a template like `blah(a,b,c)`
- flexibleOptionalParams allows optional parameters in combination with `: body`
- notnil enables annotating nillable types to be initialized with non nill values at compile time
- parallel mechanism for safer parallel logic via compiler checks during semantic analysis
- strictCaseObjects requires every field access to be valid at compile time
- strictDefs every local variable must be initialized explicitly before use (except with let)
- strictFuncs implements a stricter definition of `side effect` when impacts ref/ptr types
- strictNotNil also checks builtin and imported modules
- views a variable that is/contains a non ptr/proc lent/openArray; best used with strictFuncs

template pragmas
----------------
- redefine a template symbols as long as the signature doesnt change

macro pragmas
-------------
- command

compilation pragmas
-------------------
- assertions:on/off
- boundChecks:on/off
- callconv:on/off
- checks:on/off
- hints:on/off or hint[woop]:on/off
- nilChecks:on/off
- optimization:none/speed/size
- overflowChecks: on/off
- patterns:on/off
- warnings:on/off or warning[woop]:on/off

niche pragmas
-------------
- asmNoStackFrame should only be used by procs consisting only of assembler statements
- line modify line information as seen in stacktraces
- regiser a var for placement in hardware registry for faster access

unknown/skipped/C pragmas
-------------------------
- align for variables and object field members
- bitsize
- codegenDecl
- compile
- computedGoTo dunno; something to do with case statements in a while loop and interpreters
- cpopNonPod
- cppNonPod
- dirty something to do with templates
- discardable
- dynlib export this symbol to a dynamic library, must be used with exportc
- dynlib: "exactName" import a proc/var from a dynamic .{dll,so} library
- emit
- exportc: "optionalName" use the symbols/provided name when exporting this to c
- extern: "x$1" affects symbol name mangling when exported
- header dont declare this symbol in C, instead create an include statement
- importc import a proc/var from C
- importCpp
- importObjC
- incompleteStruct
- inject something to do with symbol visibility
- link
- localPassc
- noalias mapped to Cs restrict keyword
- nodecl dont generate a declaration for the symbol in C, use header pragma instead
- passc
- passl
- registerProc included in the compileTime example
- size
- volatile


## effects
- informing the compiler about a routine's side effects
- impacts type compatibility and compilation

exception tracking effects
--------------------------
- implemented through the raises pragma and indirectly through try statements
  - only tracks Exceptions, not Defects
- can be attach to any type of routine (except func?)
  - in a type def, e.g. `type x = proc {.raises [...].}` are part of type checks on assignment
- general rules for determining which exceptions a routine throws
  - all routines potentially raise System.Exception
    - if routine X is invoked and its body cant be inferred
    - unless
      - routine contains a try/except statement, then those are included
      - routine X indirectly invoked via `Y(...)`, then X has `effectsOf: Y`
      - routine X imported via `importc`, then no exceptions expected
      - raise and tryh
      - an explicit `raises` is defined, then can raise only those declared
        - this trumps all others except:
          - expression Y can raise A,B,C and is invoked within Xs scope, then X raises + Y raises


user defined effects
--------------------
- tag routines with custom effects via named types
- routines tagged must be invoked with the named type in scope


functional side effect tracking
-------------------------------

gc safety memory effects
------------------------

effect types
------------

- IOEffect
  - ExecIOEffect executing IO operation
  - ReadIOEffect describes a read IO operation
  - RootEffect custom effects should inherit from this
  - TimeEffect
  - WriteIOEffect

]##


echo "############################ push/pop pragma"
# @see https://nim-lang.github.io/Nim/manual.html#pragmas-push-and-pop-pragmas
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

echo "############################ effects: exception tracking"

type Oops = object of CatchableError

proc neverRaises*(a: string): bool {.raises: [].} = true
  ## any inferred exceptions/defects cause compilation errors

proc canOnlyRaiseOops*(): bool {.raises: [Oops].} =
  if true == false: raise newException(Oops, "sorry")
  else: true

proc couldRaise*(thisParam: proc(): bool): bool {.raises: [], effectsOf: thisParam.} =
  thisParam()

proc passCallback*(): bool = couldRaise(canOnlyRaiseOops)


echo "############################ effects: user defined"

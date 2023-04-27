##
## Hello world: my name is nim #version-2-0
## ========================================
## [bookmark](https://nim-lang.org/docs/manual.html#special-types)

##[
## TLDR
- only uses the implicitly imported system
  - dont import (system, threads, channel) directly, theres some compiler magic to makem work
  - threads, channels, templates, macros, effects, pragmas, os and io are in deepdives
- newer nim versions seems to be getting more strict/better at catching programmer errors
- you should expect everything in nim is heavily overloaded
  - hence only base syntax is shown and shouldnt be considered comprehensive in any form


links
-----
- [system module](https://nim-lang.org/docs/system.html)
- [api design](https://nim-lang.org/docs/apis.html)
- [manual](https://nim-lang.org/docs/manual.html)
- [tools dir](https://github.com/nim-lang/Nim/tree/devel/tools)
- [status auditor docs](https://status-im.github.io/nim-style-guide/00_introduction.html)

todos
-----
- nim in action: copy all your notes starting from pg 40

## std library
- pure libraries: do not depend on external *.dll/lib*.so binary
- impure libraries: not pure libraries
- wrapper libraries: impure low level interfaces to a C library

## style guide & best practices

idiomatic nim
-------------
- always add an Error|Defect suffix to exceptions/defects types (styleguide)
- always add Obj/REf/Prt suffice to secondary flavors of type identifiers (styleguide)
- always align signature parameters longer than 1 line with the one above it (styleguide)
- always continue multi-line invocations on the same column as the open paranthesis (styleguide)
- always extend custom errors from the system.Exception/etc hierarchy (docs)
- always keep lines <= 80  with 2 spaces for indentation (styleguide)
- always prefix impure enum members (e.g. with abbr of the enum name) (styleguide)
- always qualify the imports from std, e.g. std/os and std/[os, posix] (styleguide?)
- always run initialization logic as toplevel module statements, e.g. init data (docs)
- always use subjectVerb not verbSubject in identifiers (styleguide)
- never align the `=` in assignments across subsequent lines (styleguide)
- never prefix getters/setters with `get/setBlah` unless the it has side effects, or cost > O(1) (styleguide)
- never raise an exception without a msg, and never for control flow (docs maybe?)
- prefer composition > inheritance (docs)
- prefer declaring vars as vars > proc var params when modifying global vars (docs)
- prefer descriptive > terse module names (docs)
- prefer nims api conventions (theres bunches), the idea is to make it easy to `guess the procedure` (naming scheme?)
- prefer object variants > inheritance for simple types; no type conversion required (docs)
- prefer shadowing proc params > passing vars; enables the most efficient parameter passing (docs)
- prefer type > cast operator cuz type preserves the bit pattern (docs)
- procs that mutate data should be prefixed with 'm' (styleguide)
- procs that return a transformed copy of soemthing should be in past particle (e.g. wooped) (styleguide)
- refrain from MACRO_CASE naming conventions, no matter what it is (styleguide)
- use a..b unless a .. ^b has an operator (docs, styleguide)
- use cast > type conversion to force the compiler to reinterpret the bit pattern (docs)
- use channel.tryRecv > channel.peek to reduce potential of race conditions (docs)
- use collect macro > map and filter (docs)
- use getMonoTime | cpuTime > now for benchmarking (docs)
- use getTime > epochTime for epoch (docs)
- use include to split large modules into distinct files (docs)
- use options > nil for dealing with optional values (docs)
- use parseopt module > os.parseCmdLine unless specifically required (docs)
- use procs > (macros/templates/iterators/convertors) unless necessary (styleguide)
- use result(its optimized) > return (only for control flow) > last statement expression (stylguide) (FYI status prefers last statement)
- use sets (e.g. as flags) > integers that have to be or'ed (docs)
- use status push > raises convention to help track unfound errs (docs + status)
- use testament > unittests with dir structur like root/tests/somecategory/t\*.nim (testament source)
- use typeof x and not type x (docs)
- use X.y > x[].y for accessing ref/ptr objects (docs: x[].y highly discouraged)
- use yield Future; future.failed > try: await Future: except: blah for reliable error handling (docs)

borrowed from somewhere else (e.g. status auditor docs)
- MACRO_CASE for external constants (status) (permitted in styleguide but not preferred)
- use nimble's recommended [package structure](https://github.com/nim-lang/nimble#project-structure)
- use somename.nim.cfg for non autoloaded config files (nimble source)
- use somename.nim.ini for cfgs requiring parsecfg (IMO to match nimble)

my preferences
--------------
- prefer set/sets over sequences/arrays when possible
- use fmt"{expr}" > &"{expr}" unless you need escapes (me)
- use Natural/Positive for checks/type desc i.e. Positive.low == 1 Natural.low == 0
- never discard Futures; use waitFor (eventually) / asyncCheck (immediately) to throwaway value/error
- never add an Obj/RefP/Ptr suffix to the main type idenfier (styleguide)
- use -d:futureLogging + getFuturesInProgress() to guard against stuck Futures leaking memory
- use """string literals""" that start with new line, i.e. the """ first should be on its own line
- strive for parantheseless code, remember echo f 1, f 2 == echo(f(1), f(2)) and not echo(f(1, f(2)))
- keep it as sugary as possible
- prefer fn x,y over x.fn y over fn(x, y) unless it conflicts with the context
  - e.g. pref x.fn y,z when working with objects
  - e.g. pref fn x,y when working with procs
  - e.g. pref fn(x, ...) when chaining/closures (calling syntax impacts type compatibility (docs))
- prefer `--` over `-` cmd line switches so you can sort nim compiler options
- object vs tuple
  - tuple: inheritance / private fields / reference equality NOT required
  - object: inheritance / private fields / reference equality IS required
- refrain from using blah% operators they tend to be legacy, see https://github.com/nirv-ai/docs/issues/50
- always compile with --panics:on (manual: smaller binaries + optimizations)
- dont use any unsafe language features or disable runtime checks (manual: removes possibility of unchecked runtime errs)
- follow nimlangs API naming scheme for naming things needing nice names like nims nomenclature
- use blahIt variants for an even more terse syntax (which stdlib has the it variants?)

## modules
- generally 1 file == 1 module
- include can split 1 module == 1..X files
- top level statements are executed at start of program (useful for initialization tasks)
- enable information hiding and separate compilation
- all symbols are private (module scoped) unless exported with `*`
- isMainModule: returns true if current module compiled as the main file (see testing.nim)
- ambiguity
  - when module A imports symbol B that exists in C and D
  - procs/iterators are overloaded, so no ambiguity
  - everything else must be qualified (c.b | d.b) if signatures are ambiguous

pure modules
------------
- [pure module devel dir](https://github.com/nim-lang/Nim/tree/devel/lib/pure)]
- a module with no dependencies on foreign functions (modules of other languages, e.g. C)

impure modules
--------------
- [impure module devel dir](https://github.com/nim-lang/Nim/tree/devel/lib/impure)
- a module with a foreign function dependency
- the foreign function must be installed on the host computer for the module to work
- preferred over wrapper modules as they dont require manual memory management

wrapper modules
---------------
- nim modules that provide a 1-to-1 interface with a foreign function (e.g. C libraries)
- can be used directly in Nim, albeit with unsafe features like pointers and bit casts
  - see runtimeMemory.nim

import
------
- top-level symbols marked * from another module
- are only allowed at the top level
- looks in the current dir relative to the imported file and uses the first match
- else traverses up the nim PATH for the first match
  - [search path docs](https://nim-lang.org/docs/nimc.html#compiler-usage-search-path-handling)
  .. code-block:: Nim
    import math # everything except private symbols
    import foo {.all.}  # import everything
    import std/math # import math specifically from the std library
    import mySubdir/thirdFile
    import myOtherSubdir / [fourthFile, fifthFile]
    import thisThing except thiz,thaz,thoz
    import thisThing as thingThis
    import this/thing/here, "that/is/in/this/sub/dir" # identifier is stil here.woop
    import "this/valid dir name/but invalid for nim/someMod" # someMod.woop
    import pkg/someNimblePkg # use pkg to import a nimble pkg
    rom system {.all.} as system2 import nil
    from thisThing import this, thaz, thoz # can invoke this,that,thot without qualifying
    from thisThing import nil # imports thisThing but none of its symbols, use thisThng.woop()
    from thisThing as thingThis import nil # same as above, but with a custom namespace

include
-------
- a file as part of this module
- positives to including files
  - can be used in any scope, e.g. scoped to a block/proc
  - symbols dont require exporting to be consumed in the parent file
  - easier to share code between files
- negatives to including files
  - including files hampers debugging as the composite module is shown instead of the source
    - line numbers dont point to distinct files, but to the composite file
    - IMO stay away from includes and use imports, except if the benefits are useful
- example include before we needed to debug memory leaks (and moved to imports)
.. code-block:: Nim
  include modules/[
    variableGlobals,
    typeSimple,
    ifWhenCase,
    exceptionHandlingDocs,
    loopsIterator,
    blocks,
    routines,
    osIo
  ]

export
------
- enables forwarding this modules dependencies onto downstream modules
  - useful if module X will always be used with module Y
- example exports
.. code-block:: Nim
  export woop # export everything from woop
  export soup.doop # named export
  export boop except soup, doup, loop # export all except specific symbols from boop

## packages
- a file named identifier.nimble creates a package
- all sibling/descendent identifier.nim files become modules of that package

## syntax

operators
---------
- precedence determined by its first character
- are just overloaded procs, e.g. proc `+`(....) and can be invoked just like procs
- infix: a + b must receive 2 args
- prefix: + a must receive 1 arg
- postfix: dont exist in nim
- not is always a unary operator: a not b == a(not b) AND NOT (a) not (b)
.. code-block:: Nim
  # think this is all of the std ops
  =     +     -     *     /     <     >
  @     $     ~     &     %     |
  !     ?     ^     .     :     \
  and or not xor shl shr div mod in notin is isnot of as from

  # bool
    not, and, or, xor, <, <=, >, >=, !=, ==
  # bool (shortcircuit)
    and or
  # char
    ==, <, <=, >, >=
  # integer bitwise
    and or xor not shl shr
  # integer division
    div
  # modulo
    mod
  # assignment
  # - value semantics: copied on assignment, all types have value semantics
  # - ref semantics: referenced on assignment, anything with ref keyword

keywords
--------
- return
  - without an expression is shorthand for return result
- result
  - implicit return variable
  - initialized with procs default value, for ref types it will be nil (may require manual init)
  - its idiomatic nim to mutate it
- discard
  - use a proc for its side effects but ignore its return value

statements
----------
- simple statements
  - cant contain other statements unless separated with a semicolon (statement lists)
  - e.g. assignment, invocations, and using return
- complex statements
  - can contain other statements
  - must always be indented except for single complex statements
  - e.g. if, when, for, while


expressions
-----------
- result in a value, pretty much everything in nim is an expression
- indentation can occur after operators, open parantheiss and commas
- paranthesis and semicolins allow you to embed statements where expressions are expected

visibility
----------
- nim is module and block scoped
- module scope: each nimfile creates an isolated context
  - use the `*` to export symbols into the scope of consumers
- block scope: within a module, every block (ifs, loops, procs, etc) introduces a new scope
  - EXCEPT when statements
- force block scoped vars to global via {.global.} pragma
]##

{.push warning[UnusedImport]:off, hint[GlobalVar]:off .}

import modules / [
  blocks, ## block statements,
  exceptionHandlingDocs, ## exceptions, assertions, doc comments, try/catch, defer
  ifWhenCase, ## if when and case statements
  loopsIterator, ## loops and iterators
  routines, ## main types of procs
  structuredCollectionsOrdinals, ## ordered and collections of items
  structuredContainers, ## objects with named fields
  traitsAdt, ## type traints and algebraic data types
  typeSimple, ## basic types
  userDefinedTypes, ## custom types with objects, tuples and enums
  variableGlobals, ## creating variables and globals
]

##
## Hello world: my name is nim
## ===========================
## [bookmark](https://nim-lang.org/docs/manual.html#special-types)

##[
## TLDR
- only uses the implicitly imported system
  - dont import (system, threads, channel) directly, theres some compiler magic to makem work
  - threads, channels, templates, macros, effects, pragmas, os and io are in deepdives
- newer nim versions seems to be getting more strict/better at catching programmer errors
  - this repo uses nim 1.6.10 and breaks on later versions
- you should expect everything in nim is heavily overloaded
  - hence only simple syntax is shown and shouldnt be considered comprehensive in any form
- generaly guidance
  - everything in javascript is an object, almost everything in nim is an expression

links
-----
- [nim system module](https://nim-lang.org/docs/system.html)
- [nimlang api design](https://nim-lang.org/docs/apis.html)
- [nimlang manual](https://nim-lang.org/docs/manual.html)
- [nimlang tools dir](https://github.com/nim-lang/Nim/tree/devel/tools)
- [status auditor docs](https://status-im.github.io/nim-style-guide/00_introduction.html)

todos
-----
- nim in action: copy all your notes starting from pg 40

## std library
- pure libraries: do not depend on external *.dll/lib*.so binary
- impure libraries: !pure libraries
- wrapper libraries: impure low level interfaces to a C library

## style guide & best practices

idiomatic nim
-------------
- always qualify the imports from std, e.g. std/os and std/[os, posix] (styleguide?)
- any tuple/proc/type signature longer than 1 line should have their parameters aligned with the one above it (styleguide)
- dont align the = across subsequent lines like you see java apps (styleguide)
- dont prefix getters/setters with `get/setBlah` unless the it has side effects, or cost > O(1) (styleguide)
- exceptions/defects types should always have an Error|Defect suffix (styleguide)
- follow nims api conventions (theres bunches), the idea is to make it easy to `guess the procedure` (naming scheme?)
- identifiers should use subjectVerb not verbSubject (lol this ones gonna hurt) (styleguide)
- impure enum members should always have a prefix (e.g. abbr of the enum name) (styleguide)
- keep lines <= 80  with 2 spaces for indentation (styleguide)
- module names are generally long to be descriptive (docs)
- multi-line invocations should continue on the same column as the open paranthesis (styleguide)
- MyCustomError should follow the hierarchy defiend in system.Exception (docs)
- never discard Futures; use waitFor (eventually) / asyncCheck (immediately) to throwaway value/error
- never raise an exception without a msg, and never for control flow (docs maybe?)
- prefer composition > inheritance is often the better design (docs)
- prefer declare as var > proc var params when modifying global vars (docs)
- prefer object variants > inheritance for simple types; no type conversion required (docs)
- prefer type > cast operator cuz type preserves the bit pattern (docs)
- procs that mutate data should be prefixed with 'm' (styleguide)
- procs that return a transformed copy of soemthing should be in past particle (e.g. wooped) (styleguide)
- refrain from MACRO_CASE naming conventions, no matter what it is (styleguide)
- run initialization logic as toplevel module statements, e.g. init data (docs)
- secondary flavors of type identifiers should have suffix Obj|Ref|Ptr (styleguide)
- shadowing proc params > declaring them as var enables the most efficient parameter passing (docs)
- the main type idenfier shouldn not have a Obj|Ref|Ptr suffix (styleguide)
- type identifiers/consts/pure enums use PascalCase, all other (including pure enums) use camelCase
- use -d:futureLogging + getFuturesInProgress() to guard against stuck Futures leaking memory
- use """string literals""" that start with new line, i.e. the """ first should be on its own line
- use a..b unless a .. ^b has an operator (docs, styleguide)
- use cast > type conversion to force the compiler to reinterpret the bit pattern (docs)
- use channel.tryRecv > channel.peek to reduce potential of race conditions (docs)
- use collect macro > map and filter (docs)
- use fmt"{expr}" > &"{expr} (docs) unless you need escapes (me)
- use getMonoTime | cpuTime > now for benchmarking (docs)
- use getTime > epochTime for epoch (docs)
- use include to split large modules into distinct files (docs)
- use Natural/Positive for checks/type desc (docs) i.e. Positive.low == 1 Natural.low == 0
- use parseopt module > os.parseCmdLine unless specifically required (docs)
- use procs > (macros/templates/iterators/convertors) unless necessary (styleguide)
- use result(its optimized) > return (only for control flow) > last statement expression (stylguide) (FYI status prefers last statement)
- use sets (e.g. as flags) > integers that have to be or'ed (docs)
- use status push > raises convention to help track unfound errs (docs + status)
- use options > nil for dealing with optional values (docs)
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
- strive for parantheseless code, remember echo f 1, f 2 == echo(f(1), f(2)) and not echo(f(1, f(2)))
- keep it as sugary as possible
- prefer fn x,y over x.fn y over fn(x, y) unless it conflicts with the context
  - e.g. pref x.fn y,z when working with objects
  - e.g. pref fn x,y when working with procs
  - e.g. pref fn(x, ...) when chaining/closures (calling syntax impacts type compatibility (docs))
- -- > - cmd line switches so you can sort nim compiler options
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
- only top-level symbols marked with * are exported
- isMainModule: returns true if current module compiled as the main file (see testing.nim)
- ambiguity
  - when module A imports symbol B that exists in C and D
  - procs/iterators are overloaded, so no ambiguity
  - everything else must be qualified (c.b | d.b) if signatures are ambiguous

import
------
- top-level symbols marked * from another module
- are only allowed at the top level
- looks in the current dir relative to the imported file and uses the first match
- else traverses up the nim PATH for the first match
  - [checkout the search path docs](https://nim-lang.org/docs/nimc.html#compiler-usage-search-path-handling)
  .. code-block:: Nim
    import math # everything
    import std/math # import math specifically from the std library
    import mySubdir/thirdFile
    import myOtherSubdir / [fourthFile, fifthFile]
    import thisThing except thiz,thaz,thoz
    import thisThing as thingThis
    import this/thing/here, "that/is/in/this/sub/dir" # identifier is stil here.woop
    import "this/valid dir name/but invalid for nim/someMod" # someMod.woop
    import pkg/someNimblePkg # use pkg to import a nimble pkg
    from thisThing import this, thaz, thoz # can invoke this,that,thot without qualifying
    from thisThing import nil # force symbol qualification, e.g. thisThing.blah()
    from thisThing as thingThis import nil # even with an alias

include
-------
- a file as part of this module
- can be used in any scope, e.g. scoped to a block/proc
- including files hampers debugging as the composite module is shown
  - line numbers dont point to distinct files, but to the composite file
  - IMO stay away from includes and use imports, except for simple cases
- example include before we needed to debug memory leaks (and moved to imports)
.. code-block:: Nim
  include modules/[
    variableGlobals,
    typeSimple,
    ifWhenCase,
    exceptionHandlingDocs,
    loopsIterator,
    blocks,
    ordinalStructured,
    routines,
    tupleObjectTable,
    osIo
  ]

export
------
- enables forwarding this modules dependencies onto downstream modules
  - thus importers dont need to import their dependencies' depencencies
  - remember you are exporting the MODULE identifier,
    - e.g. a module X with a type X,
      - export X is exporting the module, not the type X
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
    =

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
  - cant contain other statements unless separated with a semicolon
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
- var: local or global depending on scope,
- force local scope vars to global via {.global.} pragma
- export via symbols via woop* and it will be visible to client modules
- scopes: all blocks (ifs, loops, procs, etc) introduce a closure EXCEPT when statements
]##


import modules / [
  blocks, ## block statements,
  exceptionHandlingDocs, ## exceptions, assertions, doc comments, try/catch, defer
  ifWhenCase, ## if when and case statements
  loopsIterator, ## loops and iterators
  ordinalStructured, ## ordinals and collections
  routines, ## main types of procs
  tupleObjectTable, ## tuples, objects + inheritance, tables
  typeSimple, ## nim primitive
  variableGlobals, ## const, let, var; catchall for globals
]

#[
  yolo wurl: basic nim syntax
  only uses the implicitly imported system, threads and channel built_int module (and their imports)
  dont import any of them directly, theres some compiler magic to makem work

  @see
    - https://nim-lang.org/docs/system.html
    - ../deepdives dir to dive deep

  the road to code
    bookmark: https://nim-lang.org/docs/system.html#gorge%2Cstring%2Cstring%2Cstring
    then here: https://nim-lang.org/docs/nims.html (usecase: configs, scripts, build tool, bash replacement)
    then here: https://nim-lang.org/docs/nimscript.html
    then here: https://nim-lang.org/docs/nep1.html
    then here: https://nim-lang.org/docs/manual_experimental.html
    then here: https://nim-lang.org/docs/mm.html
    then here: https://nim-lang.org/docs/docgen.html
    then here: https://nim-lang.org/blog/2017/10/02/documenting-profiling-and-debugging-nim-code.html
    then here: https://nim-lang.org/docs/backends.html
    and finally: https://nim-lang.org/docs/manual.html
    really finally this time: go through modules @see links and ensure you have captured relevant info in each file
    no really this is the final one: ensure deepdives dir does not contain any system/basic info, and truly dives deep

  review:
    - we have like 1000 different nim files, consolidate

  skim:
    nim package directory: get familiar with what exists
      https://nimble.directory/
    theck each deepdive file and add some comments to each @see link
      - you should probably copypasta some examples as well
    nim in action
      - reading: finished this like a year ago, it was super old then away
      - copying pg40 custom array ranges

  eventually:
    https://nim-lang.org/docs/tut3.html
    https://nim-lang.org/docs/destructors.html

  other stuff
    https://peterme.net/asynchronous-programming-in-nim.html
    https://peterme.net/handling-files-in-nim.html
    https://peterme.net/multitasking-in-nim.html
    https://peterme.net/optional-value-handling-in-nim.html
    https://peterme.net/tips-and-tricks-with-implicit-return-in-nim.html
    https://peterme.net/using-nimscript-as-a-configuration-language-embedding-nimscript-pt-1.html
    https://peterme.net/how-to-embed-nimscript-into-a-nim-program-embedding-nimscript-pt-2.html
    https://peterme.net/creating-condensed-shared-libraries-embedding-nimscript-pt-3.html

]#

#[
  # std library

  - pure libraries: do not depend on external *.dll/lib*.so binary
  - impure libraries: !pure libraries
  - wrapper libraries: impure low level interfaces to a C library
]#

#[
  # style guide & best practices

  idiomatic nim (from docs/styleguide), or borrowed from somewhere else (e.g. status auditor docs)
    - camelCase for code (status)
    - MACRO_CASE for external constants (status)
    - PascalCase for all types (status)
    - PascalCase for internal constants (status)
    - shadowing proc params > declaring them as var enables the most efficient parameter passing (docs)
    - declare as var > proc var params when modifying global vars (docs)
    - use result > last statement expression > return statement (docs [result = optimized]) (status prefers last statement)
    - use Natural range to guard against negative numbers (e.g. in loops) (docs)
    - use sets (e.g. as flags) > integers that have to be or'ed (docs)
    - spaces in range operators, e.g. this .. that > this..that (docs)
    - X.y > x[].y for accssing ref/ptr objects (docs: highly discouraged)
    - run initialization logic as toplevel module statements, e.g. init data (docs)
    - module names are generally long to be descriptive (docs)
    - use include to split large modules into distinct files (docs)
    - composition > inheritance is often the better design (docs)
    - type > cast operator cuz type preserves the bit pattern (docs)
    - cast > type conversion to force the compiler to reinterpret the bit pattern (docs)
    - object variants > inheritance for simple types; no type conversion required (docs)
    - MyCustomError should follow the hierarchy defiend in system.Exception (docs)
    - never raise an exception with a msg, and only in exceptional cases (not for control flow)
    - use status push > raises convention to help track unfound errs (docs + status)

  my preferences thus far
    - strive for parantheseless code
    - keep it as sugary as possible
    - prefer fn x,y over x.fn y over fn(x, y) unless it conflicts with the context
      - e.g. pref x.fn y,z when working with objects
      - e.g. pref fn x,y when working with procs
      - e.g. pref fn(x, ...) when chaining/closures (calling syntax impacts type compatibility (docs))
    - -- > - cmd line switches so you can sort nim compiler options
    - object vs tuple
      - TODO: figure out which is more performant or if there are existing guidelines
      - tuple: inheritance / private fields / reference equality arent required
      - object: inheritance / private fields / reference equality are required
]#

#[
  # modules
    - generally 1 file == 1 module
    - include can split 1 module == 1..X files
    - top level statements are exected at start of program
    - isMainModule: returns true if current module compiled as the main file (see testing.nim)

  ambiguity
    - when module A imports symbol B that exists in C and D
    - procs/iterators are overloaded, so no ambiguity
    - everything else must be qualified (c.b | d.b) if signatures are ambiguous

  import: top-level symbols marked * from another module
  looks in the current dir relative to the imported file and uses the first match
  else traverses up the nim PATH for the first match
  @see https://nim-lang.org/docs/nimc.html#compiler-usage-search-path-handling
    import math # imports everything
    import std/math # qualified import everything
    import mySubdir/thirdFile
    import myOtherSubdir / [fourthFile, fifthFile]
    import thisTHing except thiz,thaz,thoz
    from thisThing import this, thaz, thoz # can invoke this,that,thot without qualifying
    from thisThing import nil # must qualify symbols to invoke, e.g. thisThing.blah()
    from thisThing as tt import nil # define an alias

  include: a file as part of this module
  becareful with too many includes, its difficult to debug
  line numbers dont point to specific included files, but to the composite file
    include xA,xB,xC

  # exporting stuff
  export something
]#

#[
  # operators
    - precedence determined by its first character
    - are just overloaded procs, e.g. proc `+`(....) and can be invoked just like procs
    - infix: a + b must receive 2 args
    - prefix: + a must receive 1 arg
    - postfix: dont exist in nim

  + - * \ / < > @ $ ~ & % ! ? ^ . |

  in place mutations
    add (appends y to x for any seq like container)
    op= (left operand mutates in place)

  bool
    not, and, or, xor, <, <=, >, >=, !=, ==

  short circuit
    and or

  char
    ==, <, <=, >, >=

  integer bitwise
    and or xor not shl shr

  integer division
    div

  module
    mod

  assignment
    =
      - value semantics: copied on assignment, all types have value semantics
      - ref semantics: referenced on assignment, anything with ref keyword

  ordinal (integers, chars, bool, subranges)
    dec(x, n)	decrements x by n; n is an integer (mutates)
    dec(x)	decrements x by one (mutates)
    high(x) highest possible value
    inc(x, n)	increments x by n; n is an integer (mutes)
    inc(x)	increments x by one (mutates)
    low(x) lowest possible value
    ord(x)	returns the integer value that is used to represent x's value
    pred(x, n)	returns the n'th predecessor of x
    pred(x)	returns the predecessor of x
    succ(x, n)	returns the n'th successor of x
    succ(x)	returns the successor of x

  set
    A + B	union of two sets
    A * B	intersection of two sets
    A - B	difference of two sets (A without B's elements)
    A == B	set equality
    A <= B	subset relation (A is subset of B or equal to B)
    A < B	strict subset relation (A is a proper subset of B)
    e in A	set membership (A contains element e)
    e notin A	A does not contain element e
    contains(A, e)	A contains element e
    card(A)	the cardinality of A (number of elements in A)
    incl(A, elem)	same as A = A + {elem}
    excl(A, elem)	same as A = A - {elem}

  ref/pter:
    . and [] always def-ref, i.e. return the value and not the ref
    . access tuple/object
    [] arr/seq/string
    new allocate a new instance
]#

#[
  # keywords
    of as in notin is isnot

    return
      - without an expression is shorthand for return result
    result
      - implicit return variable
      - initialized with procs default value, for ref types it will be nil (may require manual init)
      - its idiomatic nim to mutate it
    discard
      - use a proc for its side effects but ignore its return value

]#

#[
  # statements

  simple statements
    - cant contain other statements
    - e.g. assignment, invocations, and using return
  complex statements
    - can contain other statements
    - must always be indented except for single complex statements
    - e.g. if, when, for, while
]#

#[
  # expressions
    - result in a value
    - indentation can occur after operators, open parantheiss and commas
    - paranthesis and semicolins allow you to embed statements where expressions are expected

]#

#[
  # visibility

  var: local or global var
  *: this thing is visible outside the module
  scopes: all blocks (ifs, loops, procs, etc) introduce a closure EXCEPT when statements
]#


#[
  # pragmas
  enable new fntionality without adding new keywords to the language

  @see
    - https://nim-lang.org/docs/manual.html#pragmas
    - https://nim-lang.org/docs/nimc.html#additional-features

  syntax:
    {.pragma1, pragma2, etc.}


  {.acyclic.} dunno read the docs
  {.async.} this fn is asynchronous and can use the await keyword
  {.base.} for methods, to associate fns with a base type. see inheritance
  {.bycopy|byref.} label a proc arg
  {.compiletime.} check the docs, maybe runs a proc @ compile time
  {.dirty.} dunno, but used with templates
  {.effects.} check the docs: will output all inferred effects (e.g. exceptions) up to this point
  {.exportc: "or-use-this-specific-name".}
  {.exportc.} disable proc name mangling when compiled
  {.hint[POOP]:on/off.} can also be set via cli flags
  {.inheritable.} # check the docs: create alternative RootObj
  {.inject.} dunno, something to do with symbol visibility
  {.inline.} # check the docs: inlines a procedure
  {.noSideEffect.} convert a proc to a func, but why not just use func?
  {.pop.} # removes a pragma from the code that follows, check the docs
  {.pure.} requires qualifying ambiguous references; x fails, but y.x doesnt
  {.push ...} # pushes a pragma into the context of the code that follows, check the docs
  {.raises: [permit,these].} # list permitted/none exceptions; unlisted force compiler errs
  {.size: ...} # check the docs
  {.thread.} informs the compiler this fn is meant for execution on a new thread
  {.threadvar.} informs the compiler this var should be local to a thread
  {.warning[POOP]:on/off.} can also be set via cli flags
]#

include modules/[
  variables,
  typeSimple,
  ifWhenCase,
  exceptionHandlingTesting,
  loops,
  rangeSlice,
  blockDo,
  arrays,
  sequences,
  sets,
  procedures,
  typeComplex,
  typeGenerics,
  tuples,
  typeSupport,
  messages,
  osIoFiles,
  typeGlobals
]

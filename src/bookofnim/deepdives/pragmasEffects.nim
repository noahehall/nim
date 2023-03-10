##
## pragmas
## =======

##[
## TLDR
- this entire section is unfinished, come back later
- enable new functionality without adding new keywords to the language
- syntax: {.pragma1, pragma2:val, etc.}

todos
-----
- [skipped everything starting here](https://nim-lang.org/docs/manual.html#pragmas)
- [additional features](https://nim-lang.org/docs/nimc.html#additional-features)
- [effect system](https://nim-lang.org/docs/manual.html#effect-system)
- [experimental](https://nim-lang.org/docs/manual_experimental.html)

## pragmas
.. code-block:: Nim
  {.acyclic.}
  {.async.} # this fn is asynchronous and can use the await keyword
  {.base.} # for methods, to associate fns with a base type. see inheritance
  {.bycopy|byref.} # label a proc arg
  {.closure.} # introduces a closure?
  {.compiletime.} #  check the docs, maybe runs a proc @ compile time
  {.dirty. }#  dunno, but used with templates
  {.effects.} # check the docs: will output all inferred effects (e.g. exceptions) up to this point
  {.exportc: "or-use-this-specific-name".} # read the docs
  {.exportc.} # disable proc name mangling when compiled
  {.global.} # turns a locally scoped var into a global, e.g. var x: string {.global.} = "global"
  {.hint[woop]:on/off.} # can also be set via cli flags
  {.inheritable.} # check the docs: create alternative RootObj
  {.inject.} # dunno, something to do with symbol visibility
  {.inline.} # check the docs: inlines a procedure
  {.noSideEffect.} # convert a proc to a func, but why not just use func?
  {.pop.} # removes a pragma from the code that follows, check the docs
  {.pure.} # requires qualifying ambiguous references; x fails, but y.x doesnt
  {.push ...} # pushes a pragma into the context of the code that follows, check the docs
  {.raises: [permit,these].} # list permitted/none exceptions; unlisted force compiler errs
  {.size: ...} # check the docs
  {.thread.} # informs the compiler this fn is meant for execution on a new thread
  {.threadvar.} # informs the compiler this var should be local to a thread
  {.warning[woop]:on/off.} #  can also be set via cli flags

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

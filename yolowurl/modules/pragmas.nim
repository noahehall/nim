##
## enable new functionality without adding new keywords to the language
## ====================================================================
##
## - syntax: {.pragma1, pragma2:val, etc.}
##

#[
  # pragmas

  @see
    - https://nim-lang.org/docs/manual.html#pragmas
    - https://nim-lang.org/docs/nimc.html#additional-features

  syntax:
  {.acyclic.} dunno read the docs
  {.async.} this fn is asynchronous and can use the await keyword
  {.base.} for methods, to associate fns with a base type. see inheritance
  {.bycopy|byref.} label a proc arg
  {.closure.} introduces a closure?
  {.compiletime.} check the docs, maybe runs a proc @ compile time
  {.dirty.} dunno, but used with templates
  {.effects.} check the docs: will output all inferred effects (e.g. exceptions) up to this point
  {.exportc: "or-use-this-specific-name".}
  {.exportc.} disable proc name mangling when compiled
  {.global.} turns a locally scoped var into a global, e.g. var x: string {.global.} = "global"
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

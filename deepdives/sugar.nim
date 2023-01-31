#[
  @see https://nim-lang.org/docs/sugar.html
  syntactic sugar based on nims macro system
  pretty sure youre going to want this especially as a js dev
]#

import std/sugar

# -> macro: simple proc type declarations
proc runFn(x: string, fn: (string) -> string): string =
  fn x

# => macro: lambdas
echo runFn("this string", (x) => "your string was: " & x)

# macro capture(locals: varargs[typed]; body: untyped): untyped
# macro collect(body: untyped): untyped
# macro collect(init, body: untyped): untyped
# macro dump(x: untyped): untyped
# macro dumpToString(x: untyped): string
# macro dup[T](arg: T; calls: varargs[untyped]): T
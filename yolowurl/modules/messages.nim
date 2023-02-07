#[
  @see
    - https://nim-lang.org/docs/io.html

  # echo, debugEcho
]#

type MessageWhatev = ref object of RootObj
  iam: string

var someMsg: MessageWhatev = MessageWhatev(iam: "lost in learning nim, but slowing starting to understand")

echo "############################ echo and related"
# roughly equivalent to writeLine(stdout, x); flushFile(stdout)
# available for the JavaScript target too.
# cant be used with funcs/{.noSideEffect.}
echo "just a regular echo statement"

# same as echo but pretends to be free of sideffects
# for use with funcs/procs marked as {.noSideEffect.}
debugEcho "this time with debugEcho "

# prints anything
# custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)
echo "this time with repr ", someMsg.repr

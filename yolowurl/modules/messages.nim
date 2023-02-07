#[
  @see
    - https://nim-lang.org/docs/io.html

  # echo, debugEcho
]#

type MessageWhatev = ref object of RootObj
  iam: string

var someMsg: MessageWhatev = MessageWhatev(iam: "lost in nim")

echo "############################ echo and related"
echo "just a regular echo statement"

# same as echo but pretends to be free of sideffects
# for use with funcs/procs marked as {.noSideEffect.}
debugEcho "this time with debugEcho "

# prints anything
# advanced/custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)
echo "this time with repr ", someMsg.repr

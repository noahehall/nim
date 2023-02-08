
#[
  @see
    - https://nim-lang.org/docs/io.html

  procs/ops/etc
    currentSourcePath() @see https://nim-lang.org/docs/system.html#currentSourcePath.t
    os.parentDir()
    macros.getProjectPath()
    getCurrentDir proc

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


echo "############################ io"
# no clue why we need to add the dir
# not that way in system.nim
# ^ its because vscode pwd is /nim and not /nim/yolowurl
let entireFile = readFile "yolowurl/yolowurl.md"
echo "file has ", len entireFile, " characters"

echo "whats your name: "
# echo "hello: ", readLine(stdin) disabled cuz it stops code runner

# you need to open a file to read line by line
# notice the dope bash-like syntax
proc readFile: string =
  let f = open "yolowurl/yolowurl.md"
  defer: close f # <-- make sure to close the file object
  result = readline f
echo "first line of file is ", readFile()

# upsert a file
const tmpfile = "/tmp/yolowurl.txt"
writeFile tmpfile, "a luv letter to nim"
echo readFile tmpfile

# overwrite an existing file
proc writeLines(s: seq[string]): void =
  let f = tmpfile.open(fmWrite) # open for writing
  defer: close f
  for i, l in s: f.writeLine l
writeLines @["first line", "Second line"]
echo readFile tmpfile

echo "############################ exec related"

# gorge alias for staticExec
# gorgeEx similar to gorge but returns tuple(result, exitCode)
# staticExec external process at compiletime and return its output (stdout + stderr)
# slurp alias for staticRead
# staticRead compile-time readFile for easy resource embedding, e.g. const myResource = staticRead"mydatafile.bin"

# docs
const buildInfo = "Revision " & staticExec("git rev-parse HEAD") &
                  "\nCompiled on " & staticExec("uname -v")
echo "build info: ", buildInfo

#[
  @see https://nim-lang.org/docs/system.html
    - _ assertions: see testing.nim
    - https://nim-lang.org/docs/io.html
    - https://nim-lang.org/docs/iterators.html
    - https://nim-lang.org/docs/widestrs.html

  every module implictly imports the system, threads and channel built_int module
    - threads & channels: see parallelism_concurrency.nim
  system also imports all the modules listed in this file

]#

echo "############################ system"
# echo, debugEcho
# chr(i): convert 0..255 to a char
# ord(i): convert char to an int
# a & b : string concat
# s.add(c): append char/string to an existing char/string
# in: i.e. contains
# notin: i.e. doesnt contain
# parseInt/parseFloat
# len(seq|char)


echo "############################ io"
echo "length of readme.md ", len (readFile "README.md")

echo "whats your name: "
echo "hello: ", readLine(stdin)

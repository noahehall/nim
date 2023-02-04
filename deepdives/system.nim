#[

  @see
    - https://nim-lang.org/docs/io.html
    - https://nim-lang.org/docs/iterators.html
    - https://nim-lang.org/docs/system.html
    - https://nim-lang.org/docs/widestrs.html


  every module implictly imports the system, threads and channel built_int module
    - dont import any of them directly, theres some compiler magic to makem work
    - everything in this file is an automatic import
    - some other system stuff is put in other files (and should be notated as system)

]#

echo "############################ system"
# basic procs/operators every program needs

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

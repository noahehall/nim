#[
  https://nim-lang.org/docs/system.html
  every module implictly imports the system module
  system also imports other modules (listed below)
  system cannot be imported explicitly
]#


const myString = "im not your string, we broke up"
echo myString
debugEcho "my string length: ", len myString

# chr(i): convert 0..255 to a char
# ord(i): convert char to an int
# a & b : string concat
# s.add(c): append char/string to an existing char/string
# in: i.e. contains
# notin: i.e. doesnt contain
# parseInt/parseFloat

#[
  https://nim-lang.org/docs/dollars.html
  $s: toString
]#


#[
  https://nim-lang.org/docs/iterators.html
]#

#[
  https://nim-lang.org/docs/assertions.html
]#

#[
  https://nim-lang.org/docs/io.html
]#

echo "length of readme.md ", len (readFile "README.md")

echo "whats your name: "
echo "hello: ", readLine(stdin)

#[
  https://nim-lang.org/docs/widestrs.html
]#

#[
  https://nim-lang.org/docs/system.html
  every module implictlys the system module
  system also imports other modules (listed below)
  system cannot be imported explicitly
]#


var myString = "im not your string, we broke up"
echo myString
debugEcho "my string length: " & $(len myString)

# chr(i): convert 0..255 to a char
# ord(i): convert char to an int
# a & b : string concat
# s.add(c): append char/string to an existing char/string
# in: i.e. contains
# notin: i.e. doesnt contain

#[
  https://nim-lang.org/docs/iterators.html
]#

#[
  https://nim-lang.org/docs/assertions.html
]#

#[
  https://nim-lang.org/docs/io.html
]#

#[
  https://nim-lang.org/docs/widestrs.html
]#

#[
  https://nim-lang.org/docs/dollars.html
  $s: toString
]#

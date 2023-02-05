#[
  @see
    - https://nim-lang.org/docs/widestrs.html

  string/char procs
    len(s)	Return the length of a string
    chr(i)	Convert an int in the range 0..255 to a character
    ord(c)	Return int value of a character
    a & b	Concatenate two strings
    s.add(c)	Add character to the string
    $	Convert various types to string

  number procs
    div	Integer division	//
    mod	Integer modulo (remainder)	%
    shl	Shift left	<<
    shr	Shift right	>>
    ashr	Arithmetic shift right
    and	Bitwise and	&
    or	Bitwise or	|
    xor	Bitwise xor	^
    not	Bitwise not (complement)	~
    toInt	Convert floating-point number into an int
    toFloat	Convert an integer into a float

  ordinal procs (integer, bool, char, enum)
    succ	Successor of the value
    pred	Predecessor of the value
    inc	Increment the ordinal
    dec	Decrement the ordinal
    high	Return the highest possible value
    low	Return the lowest possible value
    ord	Return int value of an ordinal value

  misc procs
    is	Check if two arguments are of the same type
    isnot	Negated version of is
    !=	Not equals
    addr	Take the address of a memory location
    T and F	Boolean and
    T or F	Boolean or
    T xor F	Boolean xor (exclusive or)
    not T	Boolean not
    a[^x]	Take the element at the reversed index x
    a .. b	Binary slice that constructs an interval [a, b]
    a ..^ b	Interval [a, b] but b as reversed index
    a ..< b	Interval [a, b) (excluded upper bound)
    runnableExamples	Create testable documentation
]#

echo "############################ nil"
# if a ref/ptr points to nothing, its value is nil
# thus use in comparison to prove not nil

echo "############################ bool"
# only true & false evaluate to bool
# if and while conditions must be of type bool

echo "############################ strings"
# value semantics
# are really just seq[char|byte] except for the terminating nullbyte \0
# ^0 terminated so nim strings can be converted to a cstring without a copy
# can use any seq proc for manipulation
# compared using lexicographical order
# to intrepret unicode, you need to import the unicode module
var msg: string = "yolo"
echo msg & " wurl" # concat and return new string
msg.add(" wurl") # modifies the string in place
echo msg, "has length ", len msg
let
  poop6 = "flush\n\n\n\n\n\nescapes are interpreted"
  flush = r"raw string, escapes arent interpreted"
  multiline = """
    can be split on multiple lines,
    escape sequences arent interpreted
    """
echo poop6, flush, multiline


echo "############################ char"
# always 1 byte so cant represent most UTF-8 chars
# single ASCII characters
# basically an alias for uint8
# enclosed in single quotes
let
  xxx = 'a'
  y = '\109'
  z = '\x79'


echo "############################ number types"
# a word on integers
# not converted to floats automatically
# use toInt and toFloat
let
  x1: int32 = 1.int32   # same as calling int32(1)
  y1: int8  = int8('a') # 'a' == 97'i8
  z1: float = 2.5       # int(2.5) rounds down to 2
  sum: int = int(x1) + int(y1) + int(z1) # sum == 100

# signed integers, 32bit/64bit depending on system
# Conversion between int and int32 or int64 must be explicit except for string literals.
# int8,16,32,64 # 8 = +-127, 16 = +-~32k, 32 = +-~2.1billion
# default int === same size as pointer (platform word size)
const
  b = 100
  c = 100'i8
  num0 = 0 # int
  num1: int = 2
  num2: int = 4
  amilliamilliamilli = 1_000_000

# uint: unsigned integers, 32/64 bit depending on system,
# uint8,16,32,64 # 8 = 0 -> 2550, 16 = ~65k, 32 = ~4billion
const
  e: uint8 = 100
  f = 100'u8
echo "4 / 2 === ", num2 / num1 # / always returns a float
echo "4 div 2 === ", num2 div num1 # always returns an int

# float: float32 (C Float), 64 (C Double)
# float (alias for float64) === processors fastest type
const
  num3 = 2.0 # float
  num4 = 4.0'f32
  num5: float64 = 4.9'f64
  g = 100.0
  h = 100.0'f32
  i = 4e7 # 4 * 10^7
  l = 1.0e9
  m = 1.0E9
echo "4.0 / 2.0 === ", num4 / num3
echo "4.0 div 2.0 === ", "gotcha: div is only for integers"
echo "conversion acts like javascript floor()"
echo "int(4.9) div int(2.0) === ", int(num5) div int(num3)
echo "remainder of 5 / 2: ", 5 mod 2

echo "############################ hexadecimal"
const
  n = 0x123

echo "############################ binary"
const
  o = 0b1010101

echo "############################ octal"
const
  p = 0o123

echo "############################ byte"
# behaves like uint8
# if dealing with binary blobs, prefer seq[byte] > string,
# if dealing with binary data, prefer seq[char|uint8]

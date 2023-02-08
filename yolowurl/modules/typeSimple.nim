#[
  @see
    - https://nim-lang.org/docs/widestrs.html
    - https://nim-lang.org/docs/digitsutils.html
    - https://nim-lang.org/docs/dollars.html

  string/char procs
    len(s)	Return the length of a string
    chr(i)	Convert an int in the range 0..255 to a character
    ord(c)	Return int value of a character
    a & b	Concatenate two strings
    s.add(c)	Add character to the string
    $	Convert various types to string
    substr

  number procs
    and	Bitwise and	&
    ashr	Arithmetic shift right
    div	Integer division
    max(x,y)
    min(x,y)
    mod	Integer modulo (remainder)	%
    not	Bitwise not (complement)	~
    or	Bitwise or	|
    shl	Shift left	<<
    shr	Shift right	>>
    toBiggestFloat
    toBiggestInt
    toFloat	Convert an integer into a float
    toInt	Convert floating-point number into an int
    xor	Bitwise xor	^



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
# but its an enum, so 0=false, 1=true
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
echo "cmp a, z ", cmp("a", "z")
echo "cmp z, a ", cmp("z", "a")
echo "cmp a, a ", cmp("a", "a")

echo "############################ char"
# 8 bit char (unsigned, basically an alias for uint8)
# always 1 byte so cant represent most UTF-8 chars
# single ASCII characters
# enclosed in single quotes
let
  xxx = 'a'
  y = '\109'
  z = '\x79'


echo "############################ number types"
# SomeNumber matches Some[Integer|Float]
# SomeFloat matches all float types
# SomeInteger matches Some[Signed|Unsigned]Int
# SomeSignedInt matches all signed integer types
# SomeUnsignedInt matches all unsigned integer types
let
  x1: int32 = 1.int32   # same as calling int32(1)
  y1: int8  = int8('a') # 'a' == 97'i8
  z1: float = 2.5       # int(2.5) rounds down to 2
  sum: int = int(x1) + int(y1) + int(z1) # sum == 100

# int (signed), 32bit/64bit depending on system
# int8,16,32,64 # 8 = +-127, 16 = +-~32k, 32 = +-~2.1billion, BiggestInt alias for int64
# Natural alias for range[0, ..high(int): useful for documentation/debugging/guards
# Positive alias for range[1, ..high(int): useful for documentation/debugging/guards
# PInt32 alias for ptr int32
# Pint64 alias for ptrint64
# BackwardsIndex alias for distinct int, see range docs
# default int === same size as pointer (platform word size), bitwidth depends on architecture
# Conversion between int and int32 or int64 must be explicit except for string literals.
const
  b = 100
  c = 100'i8
  negint = -1
  num0 = 0 # int
  num1: int = 2
  num2: int = 4
  amilliamilliamilli = 1_000_000

echo "abs -1 is ", abs -1

# uint: unsigned integers, 32/64 bit depending on system,
# uint8,16,32,64 # 8 = 0 -> 2550, 16 = ~65k, 32 = ~4billion, BiggestUInt alias uinty64
const
  e: uint8 = 100
  f = 100'u8
echo "4 / 2 === ", num2 / num1 # / always returns a float
echo "4 div 2 === ", num2 div num1 # always returns an int

# float: float32 (C Float), 64 (C Double)
# float (alias for float64|BiggestFloat) === processors fastest type
# PFloat32 alias for ptr float32
# PFloat64 alias for ptr float64

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
echo "(x).clamp(y, z) is faster than max(y, min(z, x)) ", 2.clamp(1, 3)

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
# alias for uint8 that is 8 bits wide
# if dealing with binary blobs, prefer seq[byte] > string,
# if dealing with binary data, prefer seq[char|uint8]
# ByteAddress alias for int, used for converting pointers to itneger addresses

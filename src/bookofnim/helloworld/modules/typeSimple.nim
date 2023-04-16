##
## simple types
## ============

##[
## TLDR
- Conversion between int and int32 or int64 must be explicit except for string literals.
- stay away from [blah% operators in practice](https://nim-lang.org/docs/manual.html#types-preminusdefined-integer-types)
  - % are mainly for backwards compatibility with previous nim versions
- generally procs that work for strings work for chars
- generally strings can use any seq proc for manipulation
- similar to js isNull, use blah.isNil, or blah != nil
  - however you cannot `if blah not nil: ...`

links
-----
- [wide strings](https://nim-lang.org/docs/widestrs.html)
- [dollars](https://nim-lang.org/docs/dollars.html)

## string
- value semantics
- are really just seq[char|byte] except for the terminating nullbyte \0
- ^0 terminated so nim strings can be converted to a cstring without a copy
- compared using lexicographical order
- to intrepret unicode, you need to import the unicode module
- addQuoted escapes and quotes y then appends to x in place
- addEscapedChar escapes y (backslashes everything) then appends to x

## char
- 8 bit char (unsigned, basically an alias for uint8)
- always 1 byte so cant represent most UTF-8 chars
- single ASCII characters
- enclosed in single quotes

## byte
- alias for uint8 that is 8 bits wide
- if dealing with binary blobs, prefer seq[byte] > string,
- if dealing with binary data, prefer seq[char|uint8]
- ByteAddress alias for int, used for converting pointers to itneger addresses

## bool
- only true & false (i.e. not 1/0) evaluate to bool
  - but its an enum, so 0=false, 1=true
  - off/on are aliases for true/false
- if and while conditions must be of type bool

boolean procs
-------------
- != == etc
- is
- isnot
- not
- notin
- and
- or
- in
- xor
- of


## comparisons
- cmp two numbers/strings

## string/char procs
- len(s)	Return the length of a string
- chr(i)	Convert an int in the range 0..255 to a character
- ord(c)	Return int value of a character
- a & b	Concatenate two strings
- s.add(c)	Add character to the string
- $	Convert various types to string
- substr
- find returns index of char in string
- contains true/false

## numbers

number procs
------------
- and	Bitwise and	&
- ashr	Arithmetic shift right
- abs value of some number
- div	Integer division
- high(NumberType)
- Inf == high(int)
- low(NumberType)
- max(x,y)
- min(x,y)
- mod	Integer modulo (remainder)	%
- not	Bitwise not (complement)	~
- or	Bitwise or	|
- Positive range[1..high(int)]
- shl	Shift left	<<
- shr	Shift right	>>
- toBiggestFloat
- toBiggestInt
- toFloat	Convert an integer into a float
- toInt	Convert floating-point number into an int
- xor	Bitwise xor	^

number types
------------
- BackwardsIndex alias for distinct int, see range docs
- float (alias for float64|BiggestFloat) === processors fastest type
- float: float32 (C Float), 64 (C Double)
- Inf float64 infinity
- int (signed), 32bit/64bit depending on system
- int === same size as pointer (platform word size), bitwidth depends on architecture
- int8,16,32,64 - 8 = +-127, 16 = +-~32k, 32 = +-~2.1billion, BiggestInt alias for int64
- NaN not a number
- Natural alias for range[0, ..high(int): useful for documentation/debugging/guards
- NegInf !inf
- PFloat32 alias for ptr float32
- PFloat64 alias for ptr float64
- PInt32 alias for ptr int32
- Pint64 alias for ptrint64
- Positive alias for range[1, ..high(int): useful for documentation/debugging/guards
- SomeFloat matches all float types
- SomeInteger matches Some[Signed|Unsigned]Int
- SomeNumber matches Some[Integer|Float]
- SomeSignedInt matches all signed integer types
- SomeUnsignedInt matches all unsigned integer types
- uint: unsigned integers, 32/64 bit depending on system,
- uint8,16,32,64 # 8 = 0 -> 2550, 16 = ~65k, 32 = ~4billion, BiggestUInt alias uinty64

## mem procs
- addr Take the address of a memory location
- owned
- unown
- disarm
]##

echo "############################ char"
let
  xxx = 'a'
  y = '\109'
  z = '\x79'


echo "############################ number types"
let
  x1: int32 = 1.int32   # same as calling int32(1)
  y1: int8  = int8('a') # 'a' == 97'i8
  z1: float = 2.5       # int(2.5) rounds down to 2
  sum: int = int(x1) + int(y1) + int(z1) # sum == 100


const
  b = 100
  c = 100'i8
  negint = -1
  num0 = 0 # int
  num1: int = 2
  num2: int = 4
  amilliamilliamilli = 1_000_000

echo "abs -1 is ", abs -1

const
  e: uint8 = 100
  f = 100'u8
echo "4 / 2 === ", num2 / num1 # / always returns a float
echo "4 div 2 === ", num2 div num1 # always returns an int



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

var globalint = 2
var globalfloat = 2.5

echo "can use blah% w/ generally any operator. ints are suppose to cast to uint before operation but doesnt seem to work"
echo "10 %% 3 = ", 10 %% 3
echo "3 *% -3 = ", 3 *% -3
echo "3 +% -3 = ", 3 +% -3
echo "3 <=% -3 = ", 3 <=% -3
echo "can use blah= w/ generally any operator to mutate in place "
echo "*= will multiply in place and return void for ints/floats, lol remember those errors we kept getting in the beginning?"


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

echo "############################ bool"
# off (const) alias for false
echo "off is an alias for ", $off
# on (const)
echo "on is an alias for ", $on

echo "############################ strings"
let
  str1 = "wooper scooper"
  str2 = """
    long
    string
    literal
    nothing\i\s
    \s\es\ca\pe\d
    """
  str3 = r"raw string\tliteral"
  str4 = "\r\rstring\t\n\rstring"
  str5 = "hex \x02"
  char1 = 'a'

var msg: string = "yolo"
echo msg & " wurl" # concat and return new string
msg.add(" wurl") # modifies the string in place
echo msg, "has length ", len msg
echo if 'y' in msg: "y in yolo" else: "must be a different universe"
let
  woop6 = "flush\n\n\n\n\n\nescapes are interpreted"
  flush = r"raw string, escapes arent interpreted"
  multiline = """
    can be split on multiple lines,
    escape sequences arent interpreted
    """
echo woop6, flush, multiline
echo "cmp a, z ", cmp("a", "z")
echo "cmp z, a ", cmp("z", "a")
echo "cmp a, a ", cmp("a", "a")

var globalstring = "before"
globalstring &= "appends in place, returns void"
echo "before ", globalstring

echo globalstring & "appends char or string and returns new string"

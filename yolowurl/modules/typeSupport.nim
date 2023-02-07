echo "############################ type casts"
# cast operator forces the compiler to interpret a bit pattern to be of another type

echo "############################ type coercions"
# type coercions preserve the abstract value, but not the bit-pattern
# chr(i): convert 0..255 to a char
# ord(i): convert char to an int
# parseInt/parseFloat from a string
# static(x): force the compile-time evaluation of the given expression
# toFloat(int): convert int to a float
# toInt(float): convert float to an int
# type(x): retrieve the type of x

echo "############################ type checking"

var somevar: seq[char] = @['n', 'o', 'a', 'h']
echo "somevar is seq? ", somevar is seq
echo "somevar is seq[char]? ", "throws err if testing seq[char]"
echo "somevar isnot set? ", somevar isnot set

type MyType = ref object of RootObj
var instance: MyType = MyType()

echo "instance of MyType ", instance of MyType

# checks whether x can be compiled without any semantic error.
# useful to verify whether a type supports some operation:
when compiles(3 + 4):
  echo "'+' for integers is available"

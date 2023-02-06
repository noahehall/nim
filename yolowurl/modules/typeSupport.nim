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

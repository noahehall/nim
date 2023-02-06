echo "############################ type casts"
# cast operator forces the compiler to interpret a bit pattern to be of another type

echo "############################ type coercions"
# type coercions preserve the abstract value, but not the bit-pattern
# chr(i): convert 0..255 to a char
# ord(i): convert char to an int
# static(x): force the compile-time evaluation of the given expression
# type(x): retrieve the type of x

# parseInt/parseFloat

echo "############################ generics"
# parameterize procs, iterators or types
# parameterized: Thing[T]
# restricted Thing[T: x or y]
# static Thing[MaxLen: static int, T] <-- find this one in the docs
# generic procs
proc wtf[T](a: T): auto =
  result = "wtf " & $a
echo wtf "yo"

# generic proc method call syntax
proc foo[T](i: T) =
  echo i, " using method call syntax"
var ii: int
# ii.foo[int]() # Error: expression 'foo(i)' has no type (or is ambiguous)
ii.foo[:int]() # Success

# copied from docs
# generic types
type
  BinaryTree*[T] = ref object # BinaryTree is a generic type with
                              # generic param `T`
    le, ri: BinaryTree[T]     # left and right subtrees; may be nil
    data: T                   # the data stored in a node
proc newNode*[T](data: T): BinaryTree[T] =
  # constructor for a node
  new(result)
  result.data = data

# generic iterator
iterator preorder*[T](root: BinaryTree[T]): T =
  # Preorder traversal of a binary tree.
  # This uses an explicit stack (which is more efficient than
  # a recursive iterator factory).
  var stack: seq[BinaryTree[T]] = @[root]
  while stack.len > Natural: # <-- haha docs didnt follow style guide!
    var n = stack.pop()
    while n != nil:
      yield n.data
      add(stack, n.ri)  # push right subtree onto the stack
      n = n.le          # and follow the left pointer

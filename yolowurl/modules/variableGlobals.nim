#[
  additional global operators, procs, etc
  only captured the unusual/interesting globals
  everything else is likely in another file


  @see
    - https://nim-lang.org/docs/system.html#8 are all on this page somewhere
    - https://nim-lang.org/docs/typeinfo.html
]#


echo "############################ variables"
var poop1 = "flush"
let poop2 = "hello"
# compile-time evaluation cannot interface with C
# there is no compile-time foreign function interface at this time.
# consts must be initialized with a value
# declares variables whose values are constant expressions
const poop3 = "flush"


# computes fac(4) at compile time:
# notice the use of paranthesis and semi colins
const fac4 = (var x = 1; for i in 1..4: x *= i; x)

echo poop1, poop2, poop3, fac4

# stropping
let `let` = "stropping"
echo(`let`) # stropping enables keywords as identifiers

# auto only for proc return types and signature parameters
# parameter auto: creates an implicit generic of proc[x](a: [x])
# return auto: causes the compiler to infer the type form the routine body
var autoInt: auto = 7
echo "autoInt labeled auto but its type is ", $type(autoInt)

static:
  echo "explicitly requires compile-time execution, not just simple expressions"

echo "############################ variable support"
# checks whether x can be compiled without any semantic error.
# useful to verify whether a type supports some operation:
when compiles(3 + 4):
  echo "'+' for integers is available at compile time"

# whether x is declared at compile time
var typeSupportBlah = "halb"
when declared typeSupportBlah:
  echo "blah is declared at compile time"

when not declared thisDoesntExist:
  echo "some thing doesnt exist at compile time"

# checks currenty scope at compile time
when declaredInScope typeSupportBlah:
  echo "blah is declared in scope at compile time"

# checks whether something is defined at compile time
when defined typeSupportBlah:
  echo "something is defined at compile time"

# if gc:arc|orc you have to enable via --deepcopy:on
var d33pcopy: string
d33pcopy.deepCopy typeSupportBlah
echo "deep copy of some other thing ", d33pcopy

# get the default value
echo "the default int value is ", int.default
echo "the default seq[int] value is ", $ seq[int].default


echo "############################ interesting globals"
# globalRaiseHook (var) influence exception handling on a global level
# ^ if not nil, every raise statement calls this hook
# ^ if returns false, exception is caught and does not propagate
# addAndFetch doesnt have a description
# copyMem copies content from memory at source to memory at dest
# cpuRelax
# create allocates a new memory block with atleast T.sizeof * size bytes
# createShared allocates new memory block on the shared heap with atleast T.sizeof * bytes
# createSharedU allocates new memory block on the shared heap with atleast T.sizeof * bytes
# createU allocates memory block atleast T.sizeof * bytes
# dealloc frees the memory allocated with alloc, alloc0, realloc, create or createU
# deallocHeap frees the thread local heap
# deallocShared frees the mem allocated with allocShared, allocShared0 or reallocShared
# equalMem compares size bytes of mem blocks a and b
# errorMessageWriter (var) called instead of stdmsg.write when printing stacktrace
# freeShared frees the mem allocated with createShared, createSharedU, or resizeShared
# GC_disable()
# GC_disableMarkAndSweep()
# GC_enable()
# GC_enableMarkAndSweep()
# GC_fullCollect()
# GC_getStatistics():
# getAllocStats():
# getFrame():
# getFrameState():
# isNotForeign returns true if x belongs to the calling thread
# iterToProc
# moveMem copies content from memory at source to memory at dest
# onUnhandledException (var) override default behavior: write stacktrace to stderr then quit(1)
# outOfMemHook (var) override default behavior: write err msg then terminate (see docs for example)
# prepareMutation string literals in ARC/ORC mode are copy on write, this must be called before mutating them
# rawEnv retrieve the raw env pointer of a closure
# rawProc retrieve the raw proc pointer of closer X
# reset an object to its default value
# resize a memory block
# resizeShared
# setControlCHook proc to run when program is ctrlc'ed
# sizeof blah in bytes
# unhandledExceptionHook (var) override default behavior: write err msg then terminate
# compileOption(x[, y]) check if a switch is active and/or its value at compile time
# hostCPU (const) "i386", "alpha", "powerpc", "powerpc64", "powerpc64el", "sparc", "amd64", "mips", "mipsel", "arm", "arm64", "mips64", "mips64el", "riscv32", "riscv64"
echo "my hostCPU is " & hostCPU

# hostOS (const) "windows", "macosx", "linux", "netbsd", "freebsd", "openbsd", "solaris", "aix", "haiku", "standalone"
echo "my hostOS is " & hostOS

# appType (const) console|gui|lib
echo "app type is " & appType

# CompileTime (const) HH:MM:SS
echo "i was compiled at " & CompileTime

# isMainModule (const) true if module accessed as main module; used to embed tests
echo "am i the main module? ", $isMainModule

# NaN (const) IEEE value for Not a number; use isNan/classify from math instead
# NimMajor (const)
# NimMinor (const)
# NimPatch (const)
# NimVersion (const)
echo "does NimVersion = NimMajor.NimMinor.NimPatch? ",
  $NimVersion, " = ", $NimMajor, ".", $NimMinor, ".", $NimPatch

# off (const) alias for false
echo "off is an alias for ", $off

# on (const)
echo "on is an alias for ", $on

# QuitFailure (const) failure value passed to quit
echo "on failure I call quit with ", $QuitFailure

# QuitSuccess (const)
echo "on success i call quit with ", $QuitSuccess

# number of bytes owned by the process, but do not hold any meaningful data
echo "my process has X bytes of free memory ", getFreeMem()

# amount of memory i suppose, doesnt have description
echo "my process has X bytes of max memory ", getMaxMem()
echo "my process has X bytes of total memory ", getTotalMem()

# number of bytes owned by the process and hold data
echo "my process is using X bytes of memory ", getOccupiedMem()

# efficiently retrieve a tuple of all local variables
echo "locally defined vars are those not in a global scope ", locals()
block superPrivateScope:
  var inScope: string = "im in a block"
  echo "locals in a block: ", locals()

# shorthand for echo(msg); quit(code)
echo "quit the program with quit(n) or quit(msg, n)"

echo "############################ global vars"
# labeled var because they are anonymous procs
# localRaiseHook: same as globalRaiseHook but on a thread local level

echo "############################ global let"
# nimvm: bool true in Nim VM context and false otherwise; valid for when expressions

echo "############################ global const"
# cpuEndian
# Inf
# NegInf

block myBlock:
  var mysTring = "just a block"
  echo myString

# eval executes a block of code at compile time
# eval(myBlock) # dunno @see https://github.com/nim-lang/Nim/blob/version-1-6/lib/system.nim#L2816
echo "############################ global collections/sequences"
# overload contains proc for custom in logic
# shallow(blah) marks blah as shallow for optimization, subsequent assignments  wont deep copy
# shallowCopy(x, y) copies y into x

echo "seq[int] contains 6 ", @[5,6,7].contains(6)
echo "(1..3) contains 2 ", (1..3).contains(2)
echo "is a in arr[char] ", 'a' in ['a', 'b', 'c']
echo "99 notin {1,2,3} ", 99 notin {1,2,3}
echo "index of b in [a,b,c] ", ['a','b', 'c'].find('b')
echo "index of 4 in @[1..8] ", @[1,2,3,4,5,6,7,8].find 4
echo ""

echo "############################ a word on operators"
echo "anything like `xBLAH=` can be written `xBLAH =`"
echo "the former enables you to define/overload operators via 'proc `poop=`[bloop](soop): doop = toot'"

echo "############################ global operators dunno"
# x =copy y
# x =destroy y Generic destructor implementation
# x =sink y Generic sink implementation
# x =trace y Generic trace implementation

echo "############################ global operators numbers"
# stay away from blah% operators in practice @see https://nim-lang.org/docs/manual.html#types-preminusdefined-integer-types
# % are mainly for backwards compatibility with previous nim versions

var globalint = 2
var globalfloat = 2.5

echo "can use blah% w/ generally any operator. ints are suppose to cast to uint before operation but doesnt seem to work"
echo "10 %% 3 = ", 10 %% 3
echo "3 *% -3 = ", 3 *% -3
echo "3 +% -3 = ", 3 +% -3
echo "3 <=% -3 = ", 3 <=% -3
echo "can use blah= w/ generally any operator to mutate in place "
echo "*= will multiply in place and return void for ints/floats, lol remember those errors we kept getting in the beginning?"


echo "############################ global operators string/char"

var globalstring = "before"
globalstring &= "appends in place, returns void"
echo "before ", globalstring

echo globalstring & "appends char or string and returns new string"

echo "############################ global operators seqs"
# @ converts [x..y, type] into seq[type] efficiently
# converting an openArray into a seq is not as efficient as it copies all elements
var globalseq = @[1,2,3]

echo "concat 2 seq, copies both returns new", globalseq & @[4,5,6]
echo "copy seq then append a single el and return new seq ", globalSeq & 4
echo "copy seq then prepend a single el and return new seq ", 0 & globalseq

echo "############################ global operators sets"

var globalset1 = {1,2,3}
var globalset2 = {2,4,6}
echo "intersection of {1,2,3} and {2,4,6} = ", globalset1 * globalset2
echo "union of {1,2,3} and {2,4,6} = ", globalset1 + globalset2
echo "difference of {1,2,3} and {2,4,6} = ", globalset1 - globalset2
echo "is {1,2,3} a subset of {1,2,3} ", globalset1 <= {1,2,3}
echo "is {1,2,3} a strict subset of y ", globalset1 < {1,2,3}
echo "the cardinality of {1,2,3} is ", card globalset1

var globalset11 = deepCopy globalset1
globalset11.excl({2})
echo "remove {2} from {1,2,3} ", globalset11

echo "############################ global operators ordinal"
var globalarr = [1,0,0,4]
globalarr[1..2] = @[2,3]
echo "inplace mutation [1,0,0,4][1..2]= @[2,3] should be ", globalarr


echo "############################ type casts"
# cast operator forces the compiler to interpret a bit pattern to be of another type
# i.e. interpret the bit pattern as another type, but dont actually convert it to the other type
# only needed for low-level programming and are inherently unsafe

var myInt = 10

proc doubleFloat(x: float): float = x * x
echo "old people double your money in this infomercial: ", doubleFloat(cast[float](myInt))

echo "############################ type coercions"
# aka type conversions sometimes in docs, but always means to coercions
# type coercions preserve the abstract value, but not the bit-pattern
# only widening (smaller > larger) conversions are automatic/implicit
# chr(i): convert 0..255 to a char
# cstringArrayToSeq
# ord(i): convert char to an int
# parseInt/parseFloat from a string
# static(x): force the compile-time evaluation of the given expression
# toFloat(int): convert int to a float
# toInt(float): convert float to an int
# toOpenArray
# toOpenArrayByte
# type(x): retrieve the type of x
# typeof(x): same as type
# allocCStringArray creates a null terminated cstringArray from x

echo "############################ type inference"
var somevar: seq[char] = @['n', 'o', 'a', 'h']
var othervar: string = ""
echo "somevar is seq? ", somevar is seq
echo "somevar is seq[char]? ", "throws err when adding subtype seq[char]"
echo "somevar isnot string? ", somevar isnot string


type MyType = ref object of RootObj
var instance: MyType = MyType()

echo "is instance of MyType ", instance of MyType


echo "############################ echo and related"
# roughly equivalent to writeLine(stdout, x); flushFile(stdout)
# available for the JavaScript target too.
# cant be used with funcs/{.noSideEffect.}
echo "just a regular echo statement"

# same as echo but pretends to be free of sideffects
# for use with funcs/procs marked as {.noSideEffect.}
debugEcho "this time with debugEcho "

# prints anything
# custom types cant use $ unless its defined for them (see elseware)
# but you can use the repr proc on anything (its not the prettiest)
echo "this time with repr ", @[1,2,3].repr

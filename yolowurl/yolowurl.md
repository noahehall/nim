- TODO
  - move all of this into bookofnoah so there arent 1000 places to look

### links

- [quick intro](https://narimiran.github.io/nim-basics/)
- [not as quick intro](https://nim-by-example.github.io/)
- [by the creator](https://nim-lang.org/docs/tut1.html)
- [nim style guide](https://nim-lang.org/docs/nep1.html)
- [compiler user guide](https://nim-lang.org/docs/nimc.html)
- [docgen tools guide](https://nim-lang.org/docs/docgen.html)
- [docs](https://nim-lang.org/docs/lib.html)
- specs
  - [manual](https://nim-lang.org/docs/manual.html)
  - [experimental features](https://nim-lang.org/docs/manual_experimental.html)
  - [nim destructors and move semantics](https://nim-lang.org/docs/destructors.html)
  - [standard library](https://nim-lang.org/docs/lib.html)
  - [nim for flow programmers](https://github.com/nim-lang/Nim/wiki/Nim-for-TypeScript-Programmers)
  - [cmdline](https://nim-lang.org/docs/nimc.html)
    - switches
    - symbols
- native modules
  - [io](https://nim-lang.org/docs/io.html)
  - [strutils](https://nim-lang.org/docs/strutils.html)
  - [system module](https://nim-lang.org/docs/system.html)
    - imports
    - types
      - Natural
    - vars
    - lets
    - consts
    - procs
      - `echo` exactly what you think
      - `debugEcho`
      - `readLine` exactly what you think
      - `write`
      - `toInt`
      - `toFloat`
      - `repr` convert any type to string
    - iterators
      - `countup`
    - macros
    - templates
      - `^` roof operator: array access e.g. `a[^x] == a[a.len-x]`
    - exports
  - [iterators](https://nim-lang.org/docs/iterators.html)
  - [assertions](https://nim-lang.org/docs/assertions.html)
  - [dollars](https://nim-lang.org/docs/dollars.html) stringify operator for integers
  - [widestrs](https://nim-lang.org/docs/widestrs.html)

## rules

- indentation must be 2 space chars
- generally `:` ends keyword statement, e.g. an `if` statement
- optionally `;` ends a statement, required if putting 2 statements on the same line
- you can only split a statement after a punctuation symbol, and the next line must be indented
- every identifier must be associated with a type, and types are checked at compile time
  - some types can be automatically inferred, e.g. primtives assigned a value when defined
- the type of a variable cant change
- reserved words: is, func
- TABS are not allowed, ensure your editor is setup for spaces

## conventions

- builtin types & variables are lowercase
- user-defined types are PascalCase

## compiling and running

```sh

# nim CMD -OPTS --FLAGS somefile ARGS
nim c poop.nim # compile poop to binary
nim c -r poop.nim # compile then run poop

# cmd/opts/flags
c # compile
-r # run
--verbosity:X # 0 essential, 1 errs, 2 err + line numbers
--gc:GC_NAME # chose the type of garbage collector to use
--boundsChecks # perform runtime checks, less perf > greater safety
-d:release # turns off a variety of things, like boundsChecks
```

## variables

- case insensitive: except the first letter
  - distinct: Poop poop
  - identical: pOOp pOoP
- under-score insensitive: p_oop and poo_p are the same thing

## types

- value types: allocated on the stack
- reference types: are stored on the heap
- dividing 2 ints produces a float unless you use `div` operator
- statically typed: however variable declarations have their types inferred
- you can explicitly convert types to another via the `cast` keyword

## procedures

- procs with return values, the return value must be used OR discarded
  - the defualt return value is the default value of the return type
  - e.g. ints == 0, stings = "", seqs = @[]
  - if the last expression has a non void value, that value is implicitly returned
    - no need to use return keyword, nor is it idiomatic nim
  - every proc with a return value has an implicit `result` variable declared within its body
    - is mutable, and of the same type as the procedures returnType
      - its idiomatic nim to mutate the `result` var when needed
- procs without return values return void (adding void returnType is optional)
- procs cant be used before their definition without a forward declaration
  - forward declaration: the function signature without a body
- procs without parameters can omit the paranthesis in the difinition
- you can overload procedures by assigning the same name to procedures with different parameter signatures

## loops and iterators

- iterating over an object with one item
  - nim uses the `items` iterator
- iterating over an object with two items
  - nim uses the `pairs` iterator

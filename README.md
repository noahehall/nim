# book of nim

> [bow to the crown](https://www.youtube.com/watch?v=AEtxGOjKx5c) - Heather Dale

- my adventures in nim >= 1.6.12 on ubuntu
- hopefully a useful cheatsheet for my fellow nOobs
- contributions welcomed
- [v2 install steps until v2 is actually released](https://nim-lang.org/blog/2023/03/31/version-20-rc2.html)
  - [v2 press release](https://nim-lang.org/blog/2022/12/21/version-20-rc.html)

[![bookofnim-ci](https://github.com/noahehall/nim/actions/workflows/ci.yaml/badge.svg?branch=develop)](https://github.com/noahehall/nim/actions/workflows/ci.yaml)

## for fullstack appdevs & bizdevops+sec teams

> a language should scale like math: the same notation describing the lowest and highest layers - Andreas

- fullstack is a first principle for us; nim redefines what that means
- many application developers are moving to/incorporating rust/go in their stack; suspend judgment and consider nim for (many, but definitely) these reasons
  - [cross compile applications](https://nim-lang.org/docs/nimc.html#crossminuscompilation)
  - [cross platform scripts](https://nim-lang.org/docs/nims.html#benefits)
  - [robust application & script configuration](https://nim-lang.org/docs/parsecfg.html)
  - [documentation is a first class citizen](https://nim-lang.org/docs/docgen.html)
    - [with first class support for reStructured text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
  - [testing is a first class citizen](https://nim-lang.github.io/Nim/testament.html)
    - [with html reports](https://noahehall.github.io/nim/htmldocs/testresults.html)
    - [and valgrind integration for memory leaks](https://valgrind.org/)
  - [first class support for postgres, mysql](https://nim-lang.org/docs/lib.html#impure-libraries-database-support)
    - [including a generic ODBC wrapper for other dbs](https://nim-lang.org/docs/db_odbc.html)
  - [future proof design philisophy](https://www.youtube.com/watch?v=aDi50K_Id_k)
    - [with ergonomic APIs](https://nim-lang.org/docs/apis.html)
  - [various pragmas to customize, restrict and enhance the compiler and runtime](https://nim-lang.github.io/Nim/manual.html#pragmas)
  - [community forum](https://forum.nim-lang.org/)
  - [spiderman's uncle](https://nim-lang.org/docs/tut3.html)

## recommended ramp up

> You've walked through the tutorials, whats next?

- if you havent, review these first
  - [adambard: learn x in y minutes](https://learnxinyminutes.com/docs/nim/)
  - [flaviut: nim by example](https://nim-by-example.github.io/)
  - [miran: nim basics](https://narimiran.github.io/nim-basics/)
  - [status: auditor docs](https://status-im.github.io/nim-style-guide/00_introduction.html)
  - [official nim tutorial](https://nim-lang.org/docs/tut1.html)
  - [official nim wiki](https://github.com/nim-lang/Nim/wiki)
  - [cheatsheet: reStructured Text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)

> You've finally finished the tutorials, whats next?

- this repo serves two purposes for programmers considering nim as their Nth language:
  - [primary: source code](/src/bookofnim.nim) you can execute while reading
    - examples covering ~ 90%% of nim
  - [secondary: documentation](https://noahehall.github.io/nim/htmldocs/bookofnim.html) you can read while coding
    - contextual info for the API examples with links to documentation and related references
- thus each _chapter_ consists of docs to read and code to run:
  - basic to expressive nim
    - round 1:
      - [hello world](/src/bookofnim/helloworld/helloworld.nim)
    - round 2:
      - [sugar and spices](/src/bookofnim/deepdives/sugar.nim)
  - 1: data types and data wrangling
    - round 1
      - [collections](/src/bookofnim/deepdives/collections.nim), [strings](/src/bookofnim/deepdives/strings.nim)
      - [containers](/src/bookofnim/deepdives/containers.nim), [lists](/src/bookofnim/deepdives/lists.nim),
      - [time and calendar](/src/bookofnim/deepdives/datetime.nim), [maths](/src/bookofnim/deepdives/maths.nim)
    - round 2
      - [data protocols](/src/bookofnim/deepdives/data.nim), [data wrangling](/src/bookofnim/deepdives/dataWrangling.nim),
      - [cryptography](/src/bookofnim/deepdives/crypto.nim)
  - 2: operating system and tests
    - round 1
      - [operating systems and i/o](/src/bookofnim/deepdives/osIo.nim)
    - round 2
      - [testing with testament](/src/bookofnim/deepdives/tests.nim)
  - 3: concurrency, parallelism, servers and databases
    - round 1
      - [async and threads](/src/bookofnim/deepdives/asyncPar.nim)
    - round 2
      - [web and application servers](/src/bookofnim/deepdives/servers.nim)
      - [databases](/src/bookofnim/deepdives/dbs.nim)
  - 4: compiling, packaging, and memory management
    - round 1
      - [pragmas and effects](/src/bookofnim/deepdives/pragmasEffects.nim),
      - [managing memory at runtime](src/bookofnim/deepdives/runtimeMemory.nim)
    - round 2
      - [packaging apps and app configuration](/src/bookofnim/backends/packaging.nim)
      - [compiling and garbage collectors](/src/bookofnim/backends/nimcMemory.nim)
      - [targeting runtime environments](/src/bookofnim/backends/targeting.nim)
      - [specific runtime targets](/src/bookofnim/backends/targets/)
  - 5: filters, metaprogramming and interfacing with other languages
    - round 1
      - [filters](/src/bookofnim/deepdives/filters.nim)
      - [templates and macros](/src/bookofnim/deepdives/templateMacros.nim)
    - round 2
      - [foreign function interface](/src/bookofnim/deepdives/ffi.nim)
  - 6: [community packages](./community/README.md)

> You can read and write nim, whats next?

- diving into the source code, books, and additional exercises
  - [source: nim](https://github.com/nim-lang/Nim/tree/devel/lib)
    - [impure](https://github.com/nim-lang/Nim/tree/devel/lib/impure)
    - [nimscript](https://github.com/nim-lang/Nim/blob/devel/lib/system/nimscript.nim)
    - [pure](https://github.com/nim-lang/Nim/tree/devel/lib/pure)
    - [standard](https://github.com/nim-lang/Nim/tree/devel/lib/std)
    - [system](https://github.com/nim-lang/Nim/blob/devel/lib/system.nim#L1)
    - [test examples](https://github.com/nim-lang/Nim/tree/devel/tests)
    - [testament](https://github.com/nim-lang/Nim/tree/devel/testament)
  - [source: nimforum SPA](https://github.com/nim-lang/nimforum/tree/master/src)
  - [source: nimble api](https://github.com/nim-lang/nimble/blob/master/src/nimblepkg/nimscriptapi.nim)
  - [source: nimtemplate repo template](https://github.com/treeform/nimtemplate/tree/master/src)
  - [book: nim in action](https://www.manning.com/books/nim-in-action)
  - [book: computer programming with Nim](https://ssalewski.de/nimprogramming.html)
  - [book: mastering nim](https://nim-lang.org/blog/2022/06/29/mastering-nim.html)
    - [excerpt of code examples are available](https://github.com/Araq/mastering_nim/tree/master)
  - [exercises: nim on exercism](https://exercism.org/tracks/nim)

## links

internal

- [vscode code-runner cmd for both nimscript and nim files](https://github.com/noahehall/theBookOfNoah/blob/master/vscode.settings.jsonc)
- [shell fns for nim, nimble and choosenim](https://github.com/noahehall/theBookOfNoah/blob/master/linux/bash_cli_fns/nimlang.sh)
- [community packages](./community/README.md)

nimlang

- [std library](https://nim-lang.org/docs/lib.html)
- [nim manual](https://nim-lang.org/docs/manual.html)
- [api design](https://nim-lang.org/docs/apis.html)
- [system module](https://nim-lang.org/docs/system.html)
- [fusion docs](https://github.com/nim-lang/fusion)
  - [ctrl f it](https://nim-lang.github.io/fusion/theindex.html)
- [finding somethign easy to contribute to](https://forum.nim-lang.org/t/9956)
- [nimlang RFCs](https://github.com/nim-lang/RFCs)
- [nimlang on matrix](https://matrix.to/#/!ZmWXggMgfkKpcLbQkB:matrix.org?via=matrix.org)

blogs

- [peter: nim blog](https://peterme.net/tags/nim.html)
- [official nim blog](https://nim-lang.org/blog.html)

benchmarks

- [web frameworks](https://web-frameworks-benchmark.netlify.app/result)
- [techempower](https://www.techempower.com/benchmarks/#section=data-r21&hw=ph&test=json)

nimskull

- [statically typed structured nim fork](https://github.com/nim-works/nimskull)

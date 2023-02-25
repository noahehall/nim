# nim

> [bow to the crown](https://www.youtube.com/watch?v=AEtxGOjKx5c) - Heather Dale

- my adventures in nim
- hopefully a useful cheatsheet for my fellow nOobs

## for fullstack appdevs & bizdevops teams

> a language should scale like math: the same notation describing the lowest and highest layers - Andreas

- fullstack is a first principle for us; nim redefines what that means
- many application developers are moving to/incorporating rust/go in their stack; you should prefer nim for (many, but definitely) these reasons
  - [cross compile applications](https://nim-lang.org/docs/nimc.html#crossminuscompilation)
  - [cross platform scripts](https://nim-lang.org/docs/nims.html#benefits)
  - [robust application & script configuration](https://nim-lang.org/docs/parsecfg.html)
  - [documentation is a first class citizen](https://nim-lang.org/docs/docgen.html)
    - [with first class support for reStructured text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
  - [testing is a first class citizen](https://nim-lang.github.io/Nim/testament.html)
  - [first class support for postgres, mysql](https://nim-lang.org/docs/lib.html#impure-libraries-database-support)
    - [including a generic ODBC wrapper for other dbs](https://nim-lang.org/docs/db_odbc.html)
  - [future proof design philisophy](https://www.youtube.com/watch?v=aDi50K_Id_k)
  - [various pragmas to customize, restrict and enhance the compiler and runtime](https://nim-lang.github.io/Nim/manual.html#pragmas)
  - [spidermans uncle](https://nim-lang.org/docs/tut3.html)

## recommended ramp up

- this repo serves two purposes
  - 1. [online documentation](https://noahehall.github.io/nim/htmldocs/main.html) you can read while coding
    - generally concise abbreviations extracted from one of the nim docs/blogs/etc, always check the nimdocs
  - 2. [source code](./main.nim) you can execute while reading
    - generally concise API invocations of the subject at hand, definitely not comprehensive
- thus each _chapter_ has docs to read and code to run:
  - 0: tutorials (indented below) > [helloworld](/helloworld/helloworld.nim) > [sugar](/deepdives/sugar.nim)
    - [adambard: learn x in y minutes](https://learnxinyminutes.com/docs/nim/)
    - [flaviut: nim by example](https://nim-by-example.github.io/)
    - [miran: nim basics](https://narimiran.github.io/nim-basics/)
    - [status: auditor docs](https://status-im.github.io/nim-style-guide/00_introduction.html)
    - [official nim tutorial](https://nim-lang.org/docs/tut1.html)
    - [official nim wiki](https://github.com/nim-lang/Nim/wiki)
  - 1: [collections](/deepdives/collections.nim) > [strings](/deepdives/strings.nim), [containers](/deepdives/containers.nim), [lists](/deepdives/lists.nim), [datetime](/deepdives/datetime.nim), [maths](/deepdives/maths.nim), [crypto](/deepdives/crypto.nim), [regex](/deepdives/regex.nim),
  - 2: [osIo](/deepdives/osIo.nim), [data](/deepdives/data.nim) > [tests](/deepdives/tests.nim)
  - 3: [asyncParMem](/deepdives/asyncParMem.nim) > [servers](/deepdives/servers.nim), [dbs](/deepdives/dbs.nim)
  - 4: [backends dir](/backends/) > [pragmasEffects](/deepdives/pragmasEffects.nim), [templateMacros](/deepdives/templateMacros.nim)
  - 5: source code & books
    - [source: nim system](https://github.com/nim-lang/Nim/blob/version-1-6/lib/system.nim#L1)
    - [source: nim std modules](https://github.com/nim-lang/Nim/tree/version-1-6/lib/system)
    - [source: nimscript](https://github.com/nim-lang/Nim/blob/devel/lib/system/nimscript.nim)
    - [source: nimble api source](https://github.com/nim-lang/nimble/blob/master/src/nimblepkg/nimscriptapi.nim)
    - [cheatsheet: reStructured Text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
    - [book: nim in action](https://www.manning.com/books/nim-in-action)
      - released in 2017, still highly relevant and recommended
    - [book: mastering nim](https://nim-lang.org/blog/2022/06/29/mastering-nim.html)
      - havent read this one yet, but its new; i like new

## links

internal

- [vscode code-runner cmd for both nimscript and nim files](https://github.com/noahehall/theBookOfNoah/blob/master/vscode.settings.jsonc#L185)
- [shell fns for nim, nimble and choosenim](https://github.com/noahehall/theBookOfNoah/blob/master/linux/bash_cli_fns/nimlang.sh)
- [community packages](./community/README.md)

nimlang

- [std library](https://nim-lang.org/docs/lib.html)
- [nim manual](https://nim-lang.org/docs/manual.html)
- [api design](https://nim-lang.org/docs/apis.html)
- [system module](https://nim-lang.org/docs/system.html)
- [fusion docs](https://github.com/nim-lang/fusion)
  - [ctrl f it](https://nim-lang.github.io/fusion/theindex.html)

blogs

- [peter: nim blog](https://peterme.net/tags/nim.html)
- [official nim blog](https://nim-lang.org/blog.html)

## Todos

---

### quickies

- [check how getTime handles os checks](https://github.com/nim-lang/Nim/blob/version-1-6/lib/pure/times.nim#L897)
- [skipped most of the section on cross compilation](https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows)
- [checkout status opensource theyve already built bunch of things you'll need for nirv](https://github.com/status-im)
- you should review compile_backends.nim again stuff should be alot clearer now
- [optmizing nim](https://nim-lang.org/docs/nimc.html#optimizing-for-nim)
- [pacman devkitpro for nix](https://github.com/devkitPro/pacman/releases)
  - forgot why this is here but its mentioned in the docs for something

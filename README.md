# nim

- my adventures in nim
- hopefully a useful cheatsheet for my fellow nOobs

## for javascript appdevs & bizdevops teams

> a language should scale like math: the same notation describes the lowest and highest layers - Andreas

- fullstack is a first principle for us, nim redefines what that means
- many nodejs devs are moving to/incorporating rust/go in their stack; you should prefer nim for (many, but definitely) these reasons
  - [cross compile applications](https://nim-lang.org/docs/nimc.html#crossminuscompilation)
  - [cross platform scripts](https://nim-lang.org/docs/nims.html#benefits)
  - [documentation is a first class citizen](https://nim-lang.org/docs/docgen.html)
    - [with first class support for reStructured text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
  - [testing is a first class citizen](https://nim-lang.github.io/Nim/testament.html)
  - [first class support for postgres, mysql](https://nim-lang.org/docs/lib.html#impure-libraries-database-support)
    - [including a generic ODBC wrapper for other dbs](https://nim-lang.org/docs/db_odbc.html)
  - [future proof design philisophy](https://www.youtube.com/watch?v=aDi50K_Id_k)
  - [various pragmas to customize, restrict and enhance the compiler and runtime](https://nim-lang.github.io/Nim/manual.html#pragmas)
  - [spidermans uncle](https://nim-lang.org/docs/tut3.html)

## recommended ramp up

> runnableExamples is rarely used, as this repo is meant to be [executable](./main.nim)

- 0: tuts links > helloworld > sugar > collections
  - [flaviut: nim by example](https://nim-by-example.github.io/)
  - [miran: nim basics](https://narimiran.github.io/nim-basics/)
  - [adambard: learn x in y minutes](https://learnxinyminutes.com/docs/nim/)
  - [peter: nim blog](https://peterme.net/tags/nim.html)
  - [official nim blog](https://nim-lang.org/blog.html)
  - [official nim wiki](https://github.com/nim-lang/Nim/wiki)
  - [official nim tutorial](https://nim-lang.org/docs/tut1.html)
  - [official nim manual](https://nim-lang.org/docs/manual.html)
- 1: strings, containers, lists, datetime, maths, crypto, regex,
- 2: osIo, data, tests
- 3: asyncParMem > servers, dbs
- 4: backends dir, nimscript dir
- 5: pragmasEffects, templateMacros
- 6: books/code
  - [nim in action](https://www.manning.com/books/nim-in-action)
    - despite being released in 2017, its still highly relevant
  - [mastering nim](https://nim-lang.org/blog/2022/06/29/mastering-nim.html)
    - havent read this one, but its new; i like new
  - [community packages](./community/README.md)
  - [fusion package](https://github.com/nim-lang/fusion)
  - [system source code](https://github.com/nim-lang/Nim/blob/version-1-6/lib/system.nim#L1)
  - [system modules source code](https://github.com/nim-lang/Nim/tree/version-1-6/lib/system)
  - [reStructured Text cheatsheet](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
  - [my projects](./projects/README.md)

## links

internal

- [vscode code-runner cmd for both nimscript and nim files](https://github.com/noahehall/theBookOfNoah/blob/master/vscode.settings.jsonc#L185)
- [shell fns for nim, nimble and choosenim](https://github.com/noahehall/theBookOfNoah/blob/master/linux/bash_cli_fns/nimlang.sh)

nimlang

- [std library](https://nim-lang.org/docs/lib.html)
- [api design](https://nim-lang.org/docs/apis.html)
- [system module](https://nim-lang.org/docs/system.html)
- [fusion docs](https://github.com/nim-lang/fusion)
  - [ctrl f it](https://nim-lang.github.io/fusion/theindex.html)

## Todos

---

### quickies

- [check how getTime handles os checks](https://github.com/nim-lang/Nim/blob/version-1-6/lib/pure/times.nim#L897)
- [skipped most of the section on cross compilation](https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows)
- [checkout status opensource theyve already built bunch of things you'll need for nirv](https://github.com/status-im)
- you should review compile_backends.nim again stuff should be alot clearer now
- [optmizing string handling](https://nim-lang.org/docs/nimc.html#optimizing-for-nim-optimizing-string-handling)
- [pacman devkitpro for nix](https://github.com/devkitPro/pacman/releases)
  - forgot why this is here but its mentioned in the docs for something

# nim

- my adventures in nim

## for javascript appdevs

- alot of nodejs devs are moving to/incorporating rust/go in their stack; you should prefer nim for (many, but definitely) these reasons
  - [cross compile applications](https://nim-lang.org/docs/nimc.html#crossminuscompilation)
  - [cross platform scripts](https://nim-lang.org/docs/nims.html#benefits)
  - [documentation is a first class citizen](https://nim-lang.org/docs/docgen.html)
    - [with first class support for reStructured text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
  - [testing is a first class citizen](https://nim-lang.github.io/Nim/testament.html)
  - [first class support for postgres, mysql](https://nim-lang.org/docs/lib.html#impure-libraries-database-support)
    - [including a generic ODBC wrapper for other dbs](https://nim-lang.org/docs/db_odbc.html)
  - [spidermans uncle](https://nim-lang.org/docs/tut3.html)

## recommended ramp up

- 0: tuts links > yolowurl > sugar > collections
  - TODO: find where all the links are and bring them into this file
- 1: strings, containers, lists, datetime, maths, algorithms, crypto, regex,
- 2: osIo, tasks, tests, data
- 3: backends dir, nimscript dir
- 4: parallelism_concurrency, memory_immutability > servers, html, dbs
- 5: pragmas

## links

internal

- [vscode code-runner cmd for both nimscript and nim files](https://github.com/noahehall/theBookOfNoah/blob/master/vscode.settings.jsonc#L185)
- [shell fns for nim, nimble and choosenim](https://github.com/noahehall/theBookOfNoah/blob/master/linux/bash_cli_fns/nimlang.sh)
- [hello world](./yolowurl/)
- [deep dives](./deepdives/)
- [nimscript](./nimscript/nimscript.nims)
- [community repos](./community/README.md)
- [backends](./backends/)

nimlang

- [std library](https://nim-lang.org/docs/lib.html)
- [api design](https://nim-lang.org/docs/apis.html)
- [system module](https://nim-lang.org/docs/system.html)

interwebs

- [PEGs vs CFGs](https://stackoverflow.com/questions/5501074/what-are-the-differences-between-pegs-and-cfgs)

## Todos

- there are some basic stuff in deepdives that should actually be in yolowurl
  - ensure deepdives goes beyond the basics
- [you can grep for specifics here](https://nim-lang.github.io/fusion/theindex.html)

---

### quickies

- [check how getTime handles os checks](https://github.com/nim-lang/Nim/blob/version-1-6/lib/pure/times.nim#L897)
- rethink using runnableExamples as docgen doesnt surface proc invocations with doc comments
  - runnableExamples are doconly and dont execute when compiled thus conflict with the goal of this repo, but having useful generated docs is just as important
    - need to resolve this before we rework the examples
- [skipped most of the section on cross compilation](https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows)
- [checkout status opensource theyve already built bunch of things you'll need for nirv](https://github.com/status-im)

### move these to a source file

- [optmizing string handling](https://nim-lang.org/docs/nimc.html#optimizing-for-nim-optimizing-string-handling)
- [pacman devkitpro for nix](https://github.com/devkitPro/pacman/releases)
  - forgot why this is here but its mentioned in the docs for something
- [dll generation](https://nim-lang.org/docs/nimc.html#dll-generation)
- https://nim-by-example.github.io/bitsets/
- https://nim-by-example.github.io/macros/
- https://nim-lang.org/docs/atomics.html
- https://nim-lang.org/docs/bitops.html
- https://nim-lang.org/docs/cgi.html
- https://nim-lang.org/docs/colors.html
- https://nim-lang.org/docs/complex.html
- https://nim-lang.org/docs/dynlib.html
- https://nim-lang.org/docs/editdistance.html
- https://nim-lang.org/docs/encodings.html
- https://nim-lang.org/docs/endians.html
- https://nim-lang.org/docs/highlite.html
- https://nim-lang.org/docs/lexbase.html
- https://nim-lang.org/docs/locks.html
- https://nim-lang.org/docs/macrocache.html
- https://nim-lang.org/docs/macros.html
- https://nim-lang.org/docs/nimc.html#nim-for-embedded-systems
- https://nim-lang.org/docs/punycode.html
- https://nim-lang.org/docs/rlocks.html
- https://nim-lang.org/docs/rst.html
- https://nim-lang.org/docs/rstast.html
- https://nim-lang.org/docs/rstgen.html
- https://nim-lang.org/docs/tut1.html#sets-bit-fields
- https://nim-lang.org/docs/tut2.html#templates-examplecolon-lifting-procs
- https://nim-lang.org/docs/typeinfo.html
- https://nim-lang.org/docs/typetraits.html
- https://nim-lang.org/docs/volatile.html
- https://nim-lang.org/docs/segfaults.html

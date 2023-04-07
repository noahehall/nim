# V2! BABY

- delete this section once this repo runs on V2
- [install steps](https://nim-lang.org/blog/2023/03/31/version-20-rc2.html)

# book of nim

> [bow to the crown](https://www.youtube.com/watch?v=AEtxGOjKx5c) - Heather Dale

- my adventures in nim (1.6.12, will update to 2.0 when stable)
- hopefully a useful cheatsheet for my fellow nOobs
- contributions welcomed

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
    - [with html reports](https://noahehall.github.io/nim/testresults.html)
    - [and valgrind integration for memory leaks](https://valgrind.org/)
  - [first class support for postgres, mysql](https://nim-lang.org/docs/lib.html#impure-libraries-database-support)
    - [including a generic ODBC wrapper for other dbs](https://nim-lang.org/docs/db_odbc.html)
  - [future proof design philisophy](https://www.youtube.com/watch?v=aDi50K_Id_k)
    - [with ergonomic APIs](https://nim-lang.org/docs/apis.html)
  - [various pragmas to customize, restrict and enhance the compiler and runtime](https://nim-lang.github.io/Nim/manual.html#pragmas)
  - [community forum](https://forum.nim-lang.org/)
  - [spiderman's uncle](https://nim-lang.org/docs/tut3.html)

## recommended ramp up

- this repo serves two purposes for programmers considering nim as their Nth language:
  - [primary: source code](/src/bookofnim.nim) you can execute while reading
    - generally concise examples of the subject at hand; providing enough nim to create production-ready applications
  - [secondary: documentation](https://noahehall.github.io/nim/src/htmldocs/bookofnim.html) you can read while coding
    - generally concise abbreviations extracted from nim docs/blogs/etc & categorized with links to technical specs
- thus each _chapter_ consists of docs to read and code to run:
  - 0: tutorials (indented below) > [helloworld](/src/bookofnim/helloworld/helloworld.nim) > [sugar](/src/bookofnim/deepdives/sugar.nim)
    - [adambard: learn x in y minutes](https://learnxinyminutes.com/docs/nim/)
    - [flaviut: nim by example](https://nim-by-example.github.io/)
    - [miran: nim basics](https://narimiran.github.io/nim-basics/)
    - [status: auditor docs](https://status-im.github.io/nim-style-guide/00_introduction.html)
    - [official nim tutorial](https://nim-lang.org/docs/tut1.html)
    - [official nim wiki](https://github.com/nim-lang/Nim/wiki)
  - 1: [collections](/src/bookofnim/deepdives/collections.nim) > [strings](/src/bookofnim/deepdives/strings.nim), [containers](/src/bookofnim/deepdives/containers.nim), [lists](/src/bookofnim/deepdives/lists.nim), [datetime](/src/bookofnim/deepdives/datetime.nim), [maths](/src/bookofnim/deepdives/maths.nim), [crypto](/src/bookofnim/deepdives/crypto.nim), [regex](/src/bookofnim/deepdives/regex.nim),
  - 2: [osIo](/src/bookofnim/deepdives/osIo.nim), [data](/src/bookofnim/deepdives/data.nim) > [ttests](/tests/ttests.nim)
  - 3: [asyncPar](/src/bookofnim/deepdives/asyncPar.nim) > [servers](/src/bookofnim/deepdives/servers.nim), [dbs](/src/bookofnim/deepdives/dbs.nim)
  - 4: [backends dir](/backends/) > [pragmasEffects](/src/bookofnim/deepdives/pragmasEffects.nim), [templateMacros](/src/bookofnim/deepdives/templateMacros.nim)
  - 5: source code & books
    - [source: nim](https://github.com/nim-lang/Nim/tree/version-1-6/lib)
      - [impure](https://github.com/nim-lang/Nim/tree/version-1-6/lib/impure)
      - [nimscript](https://github.com/nim-lang/Nim/blob/devel/lib/system/nimscript.nim)
      - [pure](https://github.com/nim-lang/Nim/tree/version-1-6/lib/pure)
      - [standard](https://github.com/nim-lang/Nim/tree/version-1-6/lib/std)
      - [system](https://github.com/nim-lang/Nim/blob/version-1-6/lib/system.nim#L1)
      - [test examples](https://github.com/nim-lang/Nim/tree/devel/tests)
      - [testament](https://github.com/nim-lang/Nim/tree/devel/testament)
    - [source: nimforum SPA](https://github.com/nim-lang/nimforum/tree/master/src)
    - [source: nimble api](https://github.com/nim-lang/nimble/blob/master/src/nimblepkg/nimscriptapi.nim)
    - [source: nimtemplate repo template](https://github.com/treeform/nimtemplate/tree/master/src)
    - [cheatsheet: reStructured Text](https://docutils.sourceforge.io/docs/user/rst/quickref.html)
    - [book: nim in action](https://www.manning.com/books/nim-in-action)
      - released in 2017, still highly relevant and recommended
    - [book: mastering nim](https://nim-lang.org/blog/2022/06/29/mastering-nim.html)
      - havent read this one yet, but its new; i like new
      - [excerpt of code examples are available](https://github.com/Araq/mastering_nim/tree/master)

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
- [finding somethign easy to contribute to](https://forum.nim-lang.org/t/9956)
- [nimlang RFCs](https://github.com/nim-lang/RFCs)
- [nimlang on matrix](https://matrix.to/#/!ZmWXggMgfkKpcLbQkB:matrix.org?via=matrix.org)

blogs

- [peter: nim blog](https://peterme.net/tags/nim.html)
- [official nim blog](https://nim-lang.org/blog.html)

## Todos

---

### quickies

- [js issues](https://github.com/nim-lang/Nim/labels/Javascript)

---

- [read through concepts](https://nim-lang.org/docs/compiler/concepts.html)
  - [and this forum post](https://forum.nim-lang.org/t/9992)
  - [probably should review each module here](https://nim-lang.org/docs/compiler/theindex.html)
  - [haha we skipped experimental features](https://nim-lang.org/docs/manual_experimental.html)
    - this is a must do
- move the creation of htmldocs to a github action
- [chaining anonymouse procs using with](https://forum.nim-lang.org/t/9500)
  - add example
- [check how qrgen overrides docgen with nimdoc.cfg](https://github.com/aruZeta/QRgen/blob/main/nimdoc.cfg)
  - not sure how we missed this in the beginning
- dont forget about the nimlang/tools dir
- find the rst syntax for creating links between pages and remove all the markdown links
- fix tests/src/skip and add it to a new `good examples of bad code` section
- [check how getTime handles os checks](https://github.com/nim-lang/Nim/blob/version-1-6/lib/pure/times.nim#L897)
- [skipped most of the section on cross compilation](https://nim-lang.org/docs/nimc.html#crossminuscompilation-for-windows)
- [checkout status opensource theyve already built bunch of things you'll need for nirv](https://github.com/status-im)
- you should review compile_backends.nim again stuff should be alot clearer now
- [optmizing nim](https://nim-lang.org/docs/nimc.html#optimizing-for-nim)
- [pacman devkitpro for nix](https://github.com/devkitPro/pacman/releases)
  - forgot why this is here but its mentioned in the docs for something

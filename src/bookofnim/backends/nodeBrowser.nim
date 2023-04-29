##
## js backend: targeting node & browser
## ====================================
## come back later


##[
## TLDR
- filters are discussed filtersTemplateMacros.nim
- gotchas / best practices
  - addr and ptr have different semantic meaning in JavaScript; newbs should avoid
  - cast[T](x) translated to (x), except between signed/unsigned ints
  - cstring in JavaScript means JavaScript string, and shouldnt be used as binary data buffer
TODOs
-----
- the JS codegen only translates to JS what is used at runtime, not at compile-time.
  - In practice though some modules like marshal.nim might not yet be ready for it.
  - [forum conversation](https://forum.nim-lang.org/t/9964)
- [forum discussion on js](https://forum.nim-lang.org/t/9148#62619)
  - std/jsconsole
  - theres bunches of gold nuggets in that thread
links
-----

- https://nim-lang.github.io/Nim/dom.html (js)
- https://nim-lang.github.io/Nim/asyncjs.html (js)
- https://nim-lang.github.io/Nim/jsbigints.html (js)
- https://nim-lang.github.io/Nim/jsconsole.html (js)
- https://nim-lang.github.io/Nim/jscore.html (js)
- https://nim-lang.github.io/Nim/jsffi.html (js)
- [fusion js sets](https://nim-lang.github.io/fusion/src/fusion/js/jssets.html)
- [fusion js xmlhttprequest](https://nim-lang.github.io/fusion/src/fusion/js/jsxmlhttprequest.html)
- [fusion js xmlserializer](https://nim-lang.github.io/fusion/src/fusion/js/jsxmlserializer.html)

types
-----
- JsRoot root type of the js object hierarchy

]##

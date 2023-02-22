#[
links
- https://nim-lang.org/docs/dom.html (js)
- https://nim-lang.org/docs/asyncjs.html (js)
- https://nim-lang.org/docs/jsbigints.html (js)
- https://nim-lang.org/docs/jsconsole.html (js)
- https://nim-lang.org/docs/jscore.html (js)
- https://nim-lang.org/docs/jsffi.html (js)

types
  JsRoot root type of the js object hierarchy

# javascript backend
gotchas / best practices
  - addr and ptr have different semantic meaning in JavaScript; newbs should avoid
  - cast[T](x) translated to (x), except between signed/unsigned ints
  - cstring in JavaScript means JavaScript string, and shouldnt be used as binary data buffer
]#

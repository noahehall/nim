#[
  types
    JsRoot root type of the js object hierarchy

# javascript backend
  gotchas / best practices
    - addr and ptr have different semantic meaning in JavaScript; newbs should avoid
    - cast[T](x) translated to (x), except between signed/unsigned ints
    - cstring in JavaScript means JavaScript string, and shouldnt be used as binary data buffer
]#

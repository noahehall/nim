#[
  @see https://nim-lang.org/docs/backends.html

  nim CMD OPTS FILE ARGS
  CMDS
    c compile
    r compile to $nimcache/projectname then run it, prefer this over `c -r`
  OPTS
    -r used with c to compile then run
    --threads:on enable threads for parallism
    --backend c|find-the-other-backends
    -d:danger super duper production: optimization optimizes away all runtime checks and debugging help like stackframes
    -d:release production: includes some runtime checks and optimizations are turned on
    --nimcache=<targetdir> change the location of nims cache dir

]#

#[
  # C - the default backend
]#

#[
  # javascript backend

  gotchas / best practices
    - addr and ptr have different semantic meaning in JavaScript; newbs should avoid
    - cast[T](x) translated to (x), except between signed/unsigned ints
    - cstring in JavaScript means JavaScript string, and shouldnt be used as binary data buffer
]#

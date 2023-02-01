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

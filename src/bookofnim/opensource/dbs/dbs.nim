##
## database clients
## ================

##[
## TLDR
- sqlite, mysql and postgres driver interopability
  - db_sqlite is designed to be fully compatible and explains why some params arent used
  - you can replace the import and the driver API will be identical
    - useful for testing queries without launching a postgres db
- db.exec & sql proc
  - db.exec(sql"some sql")
  - db.exec(sql"some ?", "sql") - escape by index

links
-----
- other
  - [avoiding sql injections](https://nim-lang.github.io/Nim/manual.html#distinct-type-avoiding-sql-injection-attacks)
  - [limbdb forum post](https://forum.nim-lang.org/t/9210)
    - [cloudflare lmbd post](https://blog.cloudflare.com/introducing-quicksilver-configuration-distribution-at-internet-scale/)
- high impact
  - [mysql client](https://nim-lang.github.io/Nim/db_mysql.html)
  - [postgres client](https://nim-lang.github.io/Nim/db_postgres.html)
  - [sqlite client](https://nim-lang.github.io/Nim/db_sqlite.html)
  - [generic odbc wrapper](https://nim-lang.github.io/Nim/db_odbc.html)
  - [sql parser](https://nim-lang.github.io/Nim/parsesql.html)
  - [mime types db for files & http servers](https://nim-lang.github.io/Nim/mimetypes.html)
- niche
  - [postgres interface](https://nim-lang.github.io/Nim/postgres.html)
  - [sqlite interface](https://nim-lang.github.io/Nim/sqlite3.html)
  - [mysql interface](https://nim-lang.github.io/Nim/mysql.html)
  - [odbc interface](https://nim-lang.github.io/Nim/odbcsql.html)
  - [variable length ints](https://nim-lang.github.io/Nim/varints.html)

## sqlite, postgres & mysql
- the interface should be the same between all 3

module procs
------------
- open or create/renew a db and return a connection to it
- sql converts a string literal into a SqlQuery for db.exec

module types
------------
- DbConn returned by open

db procs
--------
- close connection to db
- exec a query
- getRow returns a list
- getAllRows returns a list

]##

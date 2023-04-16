##
## cryptography
## ============
## [bookmark](https://nim-lang.org/docs/sha1.html)

##[
## TLDR
- random shouldnt be used for cryptographic purposes
- mersenne is deprecated; use random instead
- hashes
  - overload hash proc using `!$` and `!&` to enable hashing of custom datatypes

todos
-----
- [shared hash fns](https://github.com/nim-lang/Nim/blob/devel/lib/pure/collections/hashcommon.nim)

links
-----
- other
  - before using any nim hashing fn: [read this](https://github.com/nim-lang/Nim/issues/19863)
- high impact
  - [base64 en/decoder](https://nim-lang.org/docs/base64.html)
  - [efficient 1way hashing](https://nim-lang.org/docs/hashes.html)
  - [globally distributed unique IDs](https://nim-lang.org/docs/oids.html)
  - [md5 checksums](https://nim-lang.org/docs/md5.html)
  - [openssl](https://nim-lang.org/docs/openssl.html)
  - [random number generator](https://nim-lang.org/docs/random.html)
  - [random sys number generator](https://nim-lang.org/docs/sysrand.html)
  - [sha-1](https://nim-lang.org/docs/sha1.html)
  - [ssl cert finder](https://nim-lang.org/docs/ssl_certs.html)
- nitche
  - [mersenne](https://nim-lang.org/docs/mersenne.html)


## ssl_certs
- scans for SSL certs in SSL_CERT_FILE and SSL_CERT_DIR
- come back later

env vars
--------
- SSL_CERT_FILE
- SSL_CERT_DIR

## hashes
- efficient 1-way hashing of nim types

hashes procs
------------
- !& start/mix a hash value of a new datatype
- !$ finish the hash value of a new datatype
- hash of x
- hashIgnoreStyle of X
- hashIgnoreCase of x
- hashData X an array of bytes of size int
- hashIdentity of X
- hashWangYi1 of 64-bit ints


## base64
- base64 en/decoder for strings and lists of ints/chars

base64 procs
------------
- encode to base64; pass true for URL & filesystem safe encoding
- decode from bas64; leading whitespace is ignored
- encodeMime into base64 as lines; something to do with email MIME format
- initDecodeTable dunno

]##

import std/[strformat, sugar]

const
  myString = "my string"

type SomeObject = object
  first: string
  second: string

let objectSome = SomeObject(first: "1st", second: "2nd")

echo "############################ hashes"

import std/hashes

iterator items(self: SomeObject): Hash =
  ## each field of SomeObject that should be used to compute the hash value
  yield self.first.hash
  yield self.second.hash

proc hash(self: SomeObject): Hash =
  ## overload hash for custom types
  ## note the use of xAtom
  var h: Hash = 0
  for xAtom in self: h = h !& xAtom
  result = !$h

echo fmt"{myString.hash=}"
echo fmt"{objectSome.hash=}"


echo "############################ base64"

import std/base64

echo fmt"{myString.encode=}"
echo fmt"{myString.encode.decode=}"
echo fmt"{encode $objectSome=}"
echo fmt"{decode encode $objectSome=}"

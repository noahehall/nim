##
## servers
## =======
## [bookmark](https://nim-lang.org/docs/asynchttpserver.html#acceptRequest%2CAsyncHttpServer%2Cproc%28Request%29)

##[
## TLDR
- httpclient
  - generally always instantiate a newMimTypes before streaming files from disk
  - by default all procs set useStream == true
    - can be set to false; but then even small files are highly inefficient
  - TLS support requires openssl to be in path and nim compiled with `-d:ssl`
    - used automagically if any URL is prefixed with `https`
    - certs are retrieved via std/ssl_certs
  - only sync functions support timeouts (milliseconds)
    - sets max time to wait to receive data before throwing - NOT the total request time
    - must be specified when instantiating a client
    - affects all internal blocking socket invocations
  - Proxy
    - only basic auth is supported
  - creating clients
    - both a/sync http clients accept
      - userAgent default "Nim httpclient/x.y.z"
      - maxRedirects default 5
      - sslContext for HTTPS requests
      - proxy to use for connections
      - headers for requests
    - newHttpClient accepts an additional arg
      - timeout max ms to wait without receipt of data before throwing
    - newAsyncHttpClient: has additional restrictions
      - all client instance fns must be called with await in scope
  - request procs return one of Async/Response/Future[String]/String depending on httpclient type
    - append Content to procname to return string, e.g. get -> getContent
      - delete
      - get
      - patch
      - post
      - put
    - downloadFile and optionally save to filename
    - head and return response
    - request using an arbitrary http method and keep the connection alive until close()
- net and asyncnet
  - you generally still need some of the procs in net when working with asyncnet

links
-----
- high impact
  - [cookies](https://nim-lang.org/docs/cookies.html)
  - [ftp client (async)](https://nim-lang.org/docs/asyncftpclient.html)
  - [http a/sync client](https://nim-lang.org/docs/httpclient.html)
  - [http server (async)](https://nim-lang.org/docs/asynchttpserver.html)
  - [socket server (async)](https://nim-lang.org/docs/asyncnet.html)
  - [socket server](https://nim-lang.org/docs/net.html)
  - [uri interface](https://nim-lang.org/docs/uri.html)
- niche
  - [email cilent](https://nim-lang.org/docs/smtp.html)
  - [shared a/sync http primitives](https://nim-lang.org/docs/httpcore.html)
  - [low level native socket interface](https://nim-lang.org/docs/nativesockets.html)


TODOs
-----
- niminaction: copy notes from 80 to 100

## httpclient
- nim fetch

httpclient errors
-----------------
- TimeoutError when X milliseconds elapsed without receipt of data
- HttpRequestError when server returns error during get/postContent
- ProtocolError when server doesnt conform to protocol rfc
- IOError when a file cant be opened/reading fails
- ValueError when
  - reading response.code that doesnt have an HttpCode
  - reading response.contentLength thats not an int
  - reading response.lastModified thats not a valid time
- AssertionDefect when making request to url containing `\n`

httpclient types
----------------
- AsyncHttpClient HttpClientBase[Asyncsocket]
- AsyncResponse object
  - version
  - status
  - headers HttpHeaders
  - body
  - bodyStream FutureStream[string]
- HttpClient HttpClientBase[Socket]
- HttpClientBase[SocketType] ref object
  - socket SocketType
  - connected
  - currentUrl Uri we are connected to
  - headers set for the next request
  - maxRedirects allowed; 0 to never follow redirects
  - userAgent
  - timeout ms to wait without receiving data on blocking calls before throwing
  - onProgressChanged nil/proc to invoke when request progress changes
  - getBody
- MultipartData ref object
  - content seq[MultipartEntry]
- MultipartEntries openArray[tuple[name, content]]
- ProgressChangedProc[T] (total, progress, speed): T
- Proxy ref object
  - url Uri
  - auth
- Response ref object
  - version
  - status
  - headers HttpHeaders
  - body
  - bodyStream

httpclient consts
-----------------
- defUserAgent "Nim httpclient/x.y.z"

httpclient operators
--------------------
- []= add file (fname, contentType, content)/entry "some content" to multipart data p

httpclient procs
----------------
- add multipart entries to multipart data
- addFiles
- addFiles to a multipart data objects; should always be used with streams
- body of a response
- close connects held by an http client
- code corronspding to a response status
- contentLength from response header, throws if not an int
- contentType from response header
- getSocket for details about current connection
- lastModified from response header
- newHttpHeaders
- newMultipartData
- newProxy
- onProgressChanged


## asynchttpserver
- minimalistic high performance async http server that should be fronted by a revproxy

asynchttpserver types
---------------------
- AsyncHttpServer ref object
  - socket AsyncSocket
  - reuseAddr
  - reusePort
  - maxBody read from incomging request bodies
  - maxFDs
- Request object
  - client AsyncSocket
  - reqMethod HttpMethod
  - headers HttpHeaders
  - protocol tuple[orig, major, minor]
  - url Uri
  - hostname of client that made the request
  - body

asynchttpserver consts
----------------------
- nimMaxDescriptorsFallback default 16000; set via -d:nimMaxDescriptorsFallback=n

asynchttpserver procs
---------------------
- acceptRequest
]##


import std/[strformat, strutils, json]

echo "############################ httpclient"

import std/[httpclient]

const
  timeout = 250
  endpoint = "https://postman-echo.com/"
  getmegood = endpoint & "status/200"
  getmebad = endpoint & "status/404"
  getmetimeout = endpoint & fmt"delay/{timeout + 10}"
  postme = endpoint & "post"
let
  data = %*{"data": { "user": "resu", "pass": "ssap"}}


echo "############################ httpclient sync"

let fetch = newHttpClient(timeout = timeout)

echo fmt"{fetch.getContent getmegood=}"
echo fmt"{fetch.get(getmegood).body=}"
echo fmt"{fetch.get(getmegood).headers=}"
echo fmt"{fetch.get(getmegood).version=}"
echo fmt"{fetch.get(getmegood).status=}"
echo fmt"{fetch.get(getmebad).status=}"

fetch.headers = newHttpHeaders({ "Content-Type": "application/json" })
echo fmt"{fetch.postContent postme, body = $data=}"

fetch.headers = newHttpHeaders({ "X-Vault-Token": "abc-123-321-cba" })
try: echo fmt"{fetch.getContent getmetimeout=}" except CatchableError: echo "gotta catchem all!"



fetch.close

echo "############################ httpclient async"
import std/[asyncdispatch, options] # httpclient already imported above

let afetch = newAsyncHttpClient()

proc agetContent(self: AsyncHttpClient, url: string): Future[Option[string]] {.async.} =
  ## wraps async calls to provide await for AsyncHttpClient
  let res = self.getContent url
  yield res;
  result = if res.failed: none string else: some res.read


echo fmt"{waitFor afetch.agetContent getmegood=}"


# FYI: this cause asyncnet to throw on v2
# echo fmt"{waitFor withTimeout(afetch.agetContent(getmegood), 1)=}"
# you should instead yield all async requests
proc fetchWithTimeout: Future[void] {.async.} =
  let aResponse = withTimeout(afetch.agetContent(getmegood), 1)
  yield aResponse
  echo if aResponse.failed: "failed with error" else: fmt"request success: {aResponse.read=}"
waitFor fetchWithTimeout()

afetch.close

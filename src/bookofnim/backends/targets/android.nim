import std/locks

var
  thr: array[2, Thread[string]]
  L: Lock

proc sendString(msg: string): void =
  L.acquire()
  echo msg
  L.release()

initLock(L)
for i in 0..len(thr):
  echo i
  if(i == 1): thr[i].createThread(sendString, "hello")
  else: thr[i].createThread(sendString, "Goodbye")

joinThreads(thr)
deinitLock(L)

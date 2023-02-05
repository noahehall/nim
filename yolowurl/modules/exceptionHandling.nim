
echo "############################ raise "
# throw an exception
# system.Exception provides the interface
# have to be allocated on the heap (var) because their lifetime is unknown

var
  err: ref OSError
new(err)
err.msg = "the request to the OS failed"
# raise e
# alternatively, you can raise without defining a custom err
# raise newException(OSError, "the request to the os Failed")
# raise # raising without an error rethrows the previous exception

# this proc/child calls arent allowed to raise any errs
proc safe_echo(this = "I cant raise any errors"): void {.raises: [].} =
  echo this, " or compiler will throw error"

safe_echo "nothing is safe"
echo "############################ try/catch/finally "

if true:
  try:
    let f: File = open "this file doesnt exist"

  except OverflowDefect:
    echo "wrong error type"
  except ValueError:
    echo "cmd dude you know what kind of error this is"
  # except IOError:
  except:
    echo "unknown exception! this is bad code"
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
    # raise <-- would rethrow whatever the previous err was
  finally:
    echo "Glad we survived this horrible day"
    echo "if you didnt catch the err in an except"
    echo "this will be the last line before exiting"

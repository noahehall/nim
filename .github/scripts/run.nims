proc run*(p: proc(): (string, int)): void =
  let (result, code) = p()
  debugEcho result
  if code != 0: quit code

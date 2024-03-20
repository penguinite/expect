from std/options import Option, isNone, get
from std/strutils import join

func expect*[T](opt: Option[T], err_str: varargs[string, `$`]): T =
  if isNone(opt):
    debugEcho(err_str.join)
    when defined(expectDontQuit):
      return
    else:
      quit(1)
  return opt.get()

proc expectProc*[T](opt: Option[T], err_proc: proc): T =
  if isNone(opt):
    err_proc()
    when defined(expectDontQuit):
      return
    else:
      quit(1)
  return opt.get()
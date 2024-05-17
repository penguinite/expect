## This module implements a bunch of Rust-style `expect` procedures that you can use to get slightly cleaner code when dealing with 
## `Option` objects.
## 
## Basically, this module contains 2 procedures, that basically do the same thing.
## * The first one, when given a null `Option` result will print an error message and quit
## * The second one when given a null `Option` will instead call the provided procedure and do nothing else.
## 
## Here is an example of how to use these
runnableExamples "-r:off":
  import std/options
  # Let's say we are fetching some user data
  var
    user_submitted_data = some("Hello World!")
    user_didnt_submit_data = none(string)
  
  echo expect(user_submitted_data, "Error! User didn't submit data")
  # This will print "Hello World!"

  echo expect(user_didnt_submit_data, "Error! User didn't submit data")
  # This will print "Error! User didn't submit data" and quit

from std/options import Option, isNone, get
from std/strutils import join

func expect*[T](opt: Option[T], err_str: varargs[string, `$`] = ""): T =
  ## When given a result (or more accurately, an Option object) it will check whether or not it's empty.
  ## And if it is then it will simply print the error message that is provided and quit with an error code of "1"
  ## 
  ## Here is an example
  runnableExamples "-r:off":
    import std/options
    type TokenKind = enum
      Symbol, Sign
    
    # Some random data
    # We can use expect to filter out any unknown tokens when we parse it.
    let data: seq[Option[TokenKind]] = @[
      some(Symbol), some(Symbol), none(TokenKind),
    ]
    
    for i in data:
      # Here we use expect as a kind of safety mechanism.
      discard i.expect("Unknown token encountered!")

  if isNone(opt):
    debugEcho(err_str.join)
    when not defined(expectDontQuit):
      quit(1)
  else:
    return opt.get()

proc expect*[T](opt: Option[T], err_proc: proc): T =
  ## This procedure does the same things that `expect()` does, but it allows you to pass a procedure instead of printing an error message and quitting.
  ## 
  ## You sadly can't pass data to the procedure that will be called, but you can access variables in the function scope instead.
  ## That might serve as a suitable alternative.
  runnableExamples "-r:off":
    import std/options
    type TokenKind = enum
      Symbol, Sign
    
    # Some random data
    # We can use expect to filter out any unknown tokens when we parse it.
    let data: seq[Option[TokenKind]] = @[
      some(Symbol), some(Symbol), none(TokenKind),
    ]

    var count = 0
    proc log() =
      echo "Unknown token encountered at position ", count, "!"
      
    for i in data:
      discard i.expect(log)
  if isNone(opt):
    err_proc()
  return opt.get()

func expectFunc*[T](opt: Option[T], err_func: func): T =
  ## This procedure does the same things that `expect()` does, but it allows you to pass a procedure instead of printing an error message and quitting.
  ## 
  ## You sadly can't pass data to the procedure that will be called, but you can access variables in the function scope instead.
  ## That might serve as a suitable alternative.
  ## 
  ## *This is just a `func`ified version, for functional no-side-effect calls.*
  if isNone(opt):
    err_func()
  return opt.get()


proc expectProc*[T](opt: Option[T], err_proc: proc): T 
  {.deprecated: "expectProc is now simply called expect(), Rename it if you'd like to".} =
  ## This procedure does the same things that `expect()` does, but it allows you to pass a procedure instead of just a string.
  return expect(opt, err_proc)
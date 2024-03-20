# To run these tests, simply execute `nimble test`.

{.define: expectDontQuit.}

import std/[options, strutils]
import expect

let opt: Option[string] = some("Hello")
let opt2: Option[string] = none(string)

# Test successful object
assert opt.expect("What?") == "Hello"

var i = 0
proc onFail() =
  inc(i)
  echo "Obj failed ", i

# Test successful object (proc version)
assert opt.expectProc(onFail) == "Hello"

# Test failure object
assert opt2.expect("World") != "Hello"

# Test failure object (proc version)
assert opt2.expectProc(onFail) != "Hello"
# expect

Rust-style `expect` procedures for Nim.

Note: `expect` only works with the `Option` object from [`std/options`](https://nim-lang.github.io/Nim/options.html)

Proper documentation on how to use `expect` can be found [here](https://penguinite.github.io/expect/)

## How to use

Install with nimble: `nimble install expect` or `nimble install https://github.com/penguinite/expect.git`

Add it to your nimble dependencies:

```
require "expect"
# OR
require "https://github.com/penguinite/expect.git"
```

And now you can import it:

```
import expect
```

And here is how you use it:

```nim
# Let's say we are parsing a Token tree.
# Of course, this is probably different from how you'd actually use expect()
# This is just a demonstration.
type
  TokenKind = enum
    Symbol, Sign

# Some random data
# Notice how some parts of it are missing?
# We can use expect to filter out any unknown tokens when we parse it.
let data: seq[Option[TokenKind]] = @[
  some(Symbol), some(Symbol), none(TokenKind),
]

for i in data:
  # Here we use expect as a kind of safety mechanism.
  # When expect() encounters an unknown token, it will quit the program and print the error message. "Unknown token encountered!"
  discard i.expect("Unknown token encountered!")

var count = 0
for i in data:
  inc count
  # We can also use our own procedure instead of simply having expect() quit by itself.
  # This allows for even more flexibility, you can use your own logging procedures,
  # or maybe run a failsafe procedure, or anything else you'd like.
  #
  # The possibilities are endless, except, we can't pass any data to these procs
  # so they can only access variables in their scope.
  proc log() = 
    echo "Unknown token encountered at position ", count, "!"

  # Here we tell expect to run the log() procedure instead of printing a message and quitting.
  # This will print "Unknown token encountered at position 3!" and simply continue parsing
  discard i.expect(log)
```

# expect

Rust-style `expect` procedures for Nim.

Note: `expect` only works with the `Option` object from [`std/options`](https://nim-lang.github.io/Nim/options.html)
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
import expect, std/options

# Let's say we are parsing a Token tree.
# Of course, this isn't efficient whatsoever but...
# This is just a demonstration.
type
  TokenKind = enum
    Symbol, Sign

# Some random data
# Notice how some parts of it are missing?
# We can use expect to filter out any unknown tokens.
let data: seq[Option[TokenKind]] = @[
  some(Symbol), some(Symbol), some(Symbol),
  none(TokenKind),
  some(Sign), some(Sign), some(Sign),
  none(TokenKind)
]

for i in data:
  # Here we use expect as a kind of safety mechanism.
  # When expect() encounters an unknown token, it will quit the program and print the error message. "Unknown token encountered!"
  discard i.expect("Unknown token encountered!")
```

That is quite a poor example, but you can use it this way.
And you can use `expect` in many other ways.
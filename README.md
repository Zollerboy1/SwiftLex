# SwiftLex

A simple extensible lexer inspired by `RegexLexer` from [Rouge](https://github.com/rouge-ruby/rouge).

## Installation

You can install this package by adding the following line to the dependencies of your package:

```swift
.package(url: "https://github.com/Zollerboy1/SwiftLex.git", from: "1.0.0")
```

Then you can add the `SwiftLex` product to your target's dependencies.

## Usage

Import the `SwiftLex` module.

Now you can create your own lexers by conforming a type to the `Lexer` protocol:

```swift
enum MyTokenType: LexerTokenType {
    case text
    case number
    case identifier
    case equals
    case error
}

struct MyLexer: Lexer {
    typealias TokenType = MyTokenType

    init() {}

    var root: State<Self> {
        Mixin(rulesOf: \.whitespace)

        Match(regex: /[0-9]+/, tokenType: .number)
        Match(regex: /[a-zA-Z_][a-zA-Z0-9_]*/, tokenType: .identifier, nextState: \.assignment)
    }

    @StateBuilder<Self>
    var whitespace: State<Self> {
        Match(regex: /[\s\n]+/, tokenType: .text)
    }

    @StateBuilder<Self>
    var assignment: State<Self> {
        Match(regex: /(\s*)(=)(\s*)([0-9]+)/) { context, match in
            context.appendTokens(forCapturesOf: match, withTypes: .text, .equals, .text, .number)
            context.popState()
        }
    }
}
```

This lexer would accept top level whitespace, simple variable assignments and numbers:

```swift
let string = """
a = 4
b = 5
6

c=8
"""

let tokens = SwiftLex.tokenize(string: string, using: MyLexer.self)
// tokens is an array of 'Token<MyTokenType>'s.
```

For some more examples of tokenization, take a look into `Tests/SwiftLexTests/SwiftLexTests.swift`.

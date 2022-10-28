import XCTest
@testable import SwiftLex

enum TestTokenType: LexerTokenType {
    case text
    case number
    case identifier
    case equals
    case error
}

struct TestLexer: Lexer {
    typealias TokenType = TestTokenType

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


final class SwiftLexTests: XCTestCase {
    func testWhitespace() {
        let string = " "
        let tokens: [Token<TestTokenType>] = [
            Token(type: .text, string: " ")
        ]

        for (token, correctToken) in zip(SwiftLex.tokenize(string: string, using: TestLexer.self), tokens) {
            XCTAssertEqual(token, correctToken)
        }
    }

    func testNumber() {
        let string = "56"
        let tokens: [Token<TestTokenType>] = [
            Token(type: .number, string: "56")
        ]

        for (token, correctToken) in zip(SwiftLex.tokenize(string: string, using: TestLexer.self), tokens) {
            XCTAssertEqual(token, correctToken)
        }
    }

    func testAssignment() {
        let string = "ab = 519"
        let tokens: [Token<TestTokenType>] = [
            Token(type: .identifier, string: "ab"),
            Token(type: .text, string: " "),
            Token(type: .equals, string: "="),
            Token(type: .text, string: " "),
            Token(type: .number, string: "519")
        ]

        for (token, correctToken) in zip(SwiftLex.tokenize(string: string, using: TestLexer.self), tokens) {
            XCTAssertEqual(token, correctToken)
        }
    }

    func testErroneousAssignment() {
        let string = "a b = 519"
        let tokens: [Token<TestTokenType>] = [
            Token(type: .identifier, string: "a"),
            Token(type: .error, string: " "),
            Token(type: .error, string: "b"),
            Token(type: .text, string: " "),
            Token(type: .equals, string: "="),
            Token(type: .text, string: " "),
            Token(type: .number, string: "519")
        ]

        for (token, correctToken) in zip(SwiftLex.tokenize(string: string, using: TestLexer.self), tokens) {
            XCTAssertEqual(token, correctToken)
        }
    }

    func testTopLevelEquals() {
        let string = "="
        let tokens: [Token<TestTokenType>] = [
            Token(type: .error, string: "=")
        ]

        for (token, correctToken) in zip(SwiftLex.tokenize(string: string, using: TestLexer.self), tokens) {
            XCTAssertEqual(token, correctToken)
        }
    }

    func testMultiline() {
        let string = """
        a = 4
        b = 5
        6

        c=8
        """
        let tokens: [Token<TestTokenType>] = [
            Token(type: .identifier, string: "a"),
            Token(type: .text, string: " "),
            Token(type: .equals, string: "="),
            Token(type: .text, string: " "),
            Token(type: .number, string: "4"),
            Token(type: .text, string: "\n"),
            Token(type: .identifier, string: "b"),
            Token(type: .text, string: " "),
            Token(type: .equals, string: "="),
            Token(type: .text, string: " "),
            Token(type: .number, string: "5"),
            Token(type: .text, string: "\n"),
            Token(type: .number, string: "6"),
            Token(type: .text, string: "\n\n"),
            Token(type: .identifier, string: "c"),
            Token(type: .equals, string: "="),
            Token(type: .number, string: "8")
        ]

        for (token, correctToken) in zip(SwiftLex.tokenize(string: string, using: TestLexer.self), tokens) {
            XCTAssertEqual(token, correctToken)
        }
    }
}

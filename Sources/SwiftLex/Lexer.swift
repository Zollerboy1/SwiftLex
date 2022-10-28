public protocol LexerTokenType: Equatable {
    static var error: Self { get }
}

public protocol Lexer {
    associatedtype TokenType: LexerTokenType

    @StateBuilder<Self>
    var root: State<Self> { get }

    init()
}

public enum SwiftLex {
    public static func tokenize<L: Lexer>(string: String, using lexer: L.Type) -> [Token<L.TokenType>] {
        let lexerContext = LexerContext<L>(string: string)
        return lexerContext.tokenize()
    }
}

public struct Token<L: LexerTokenType>: Equatable {
    public let type: L
    public let string: Substring

    public init<S>(type: L, string: S) where S: StringProtocol {
        self.type = type
        self.string = .init(string)
    }
}

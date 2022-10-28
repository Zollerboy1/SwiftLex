@resultBuilder
public enum StateBuilder<L: Lexer> {
    public static func buildExpression(_ match: Match<L>) -> [State<L>.Rule] {
        [.match(match)]
    }

    public static func buildExpression(_ mixin: Mixin<L>) -> [State<L>.Rule] {
        [.mixin(mixin.state)]
    }

    public static func buildEither(first rules: [State<L>.Rule]) -> [State<L>.Rule] {
        rules
    }

    public static func buildEither(second rules: [State<L>.Rule]) -> [State<L>.Rule] {
        rules
    }

    public static func buildArray(_ rules: [[State<L>.Rule]]) -> [State<L>.Rule] {
        rules.flatMap { $0 }
    }

    public static func buildBlock(_ rules: [State<L>.Rule]...) -> State<L> {
        Self.buildBlock(rules.flatMap { $0 })
    }

    public static func buildBlock(_ rules: [State<L>.Rule]) -> State<L> {
        .init(rules: rules)
    }
}

public struct State<L: Lexer> {
    public enum Rule {
        case match(Match<L>)
        case mixin(KeyPath<L, State<L>>)
    }

    internal let rules: [Rule]
}

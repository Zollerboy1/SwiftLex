public struct Mixin<L: Lexer> {
    internal let state: KeyPath<L, State<L>>

    public init(rulesOf state: KeyPath<L, State<L>>) {
        self.state = state
    }
}

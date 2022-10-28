public class LexerContext<L: Lexer> {
    internal let lexer: L

    private let string: String
    private var currentIndex: String.Index
    private var stack: [State<L>]
    private var tokens: [Token<L.TokenType>]
    private var emptySteps: Int

    internal var currentState: State<L> {
        stack.last!
    }

    internal init(string: String) {
        self.lexer = .init()

        self.string = string
        self.currentIndex = self.string.startIndex
        self.stack = [self.lexer.root]
        self.tokens = []
        self.emptySteps = 0
    }


    internal func tokenize() -> [Token<L.TokenType>] {
        while self.currentIndex != self.string.endIndex {
            if !self.step(state: self.currentState) {
                let startIndex = self.currentIndex
                self.string.formIndex(after: &self.currentIndex)

                self.appendToken(withType: .error, string: self.string[startIndex..<self.currentIndex])
            }
        }

        return self.tokens.filter { !$0.string.isEmpty }
    }

    internal func step(state: State<L>) -> Bool {
        for rule in state.rules {
            switch rule {
            case let .match(match):
                if let regexMatch = try? match.regex.prefixMatch(in: self.string[currentIndex...]) {
                    self.currentIndex = regexMatch[0].substring!.endIndex

                    match.action(self, regexMatch)

                    if regexMatch[0].substring!.isEmpty {
                        self.emptySteps += 1
                        if self.emptySteps > 5 {
                            return false
                        }
                    } else {
                        self.emptySteps = 0
                    }

                    return true
                }
            case let .mixin(state):
                if self.step(state: self.lexer[keyPath: state]) {
                    return true
                }
            }
        }

        return false
    }


    public func push(state: State<L>) {
        self.stack.append(state)
    }

    public func push(states: State<L>...) {
        self.stack.append(contentsOf: states)
    }

    public func popState() {
        precondition(self.stack.count > 1, "Cannot pop root state.")

        self.stack.removeLast()
    }

    public func popStates(_ count: Int) {
        precondition(self.stack.count > count, "Cannot pop root state.")

        self.stack.removeLast(count)
    }


    public func appendToken(_ token: Token<L.TokenType>) {
        self.tokens.append(token)
    }

    public func appendToken<S>(withType type: L.TokenType, string: S) where S: StringProtocol {
        self.tokens.append(.init(type: type, string: string))
    }

    // - MARK: One Capture
    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring)>.Match,
        withTypes type1: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }
    }

    // - MARK: Two Captures
    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }
    }

    // - MARK: Three Captures
    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))
        self.tokens.append(.init(type: type3, string: match.output.3))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))
        self.tokens.append(.init(type: type3, string: match.output.3))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        self.tokens.append(.init(type: type3, string: match.output.3))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        self.tokens.append(.init(type: type3, string: match.output.3))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }
    }

    // - MARK: Four Captures
    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))
        self.tokens.append(.init(type: type3, string: match.output.3))
        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))
        self.tokens.append(.init(type: type3, string: match.output.3))
        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        self.tokens.append(.init(type: type3, string: match.output.3))
        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?, Substring, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        self.tokens.append(.init(type: type3, string: match.output.3))
        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?, Substring?, Substring)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        self.tokens.append(.init(type: type4, string: match.output.4))
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))
        self.tokens.append(.init(type: type3, string: match.output.3))

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))
        self.tokens.append(.init(type: type3, string: match.output.3))

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        self.tokens.append(.init(type: type3, string: match.output.3))

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?, Substring, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        self.tokens.append(.init(type: type3, string: match.output.3))

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))
        self.tokens.append(.init(type: type2, string: match.output.2))

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        self.tokens.append(.init(type: type2, string: match.output.2))

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring, Substring?, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        self.tokens.append(.init(type: type1, string: match.output.1))

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }

    public func appendTokens(
        forCapturesOf match: Regex<(Substring, Substring?, Substring?, Substring?, Substring?)>.Match,
        withTypes type1: L.TokenType,
        _ type2: L.TokenType,
        _ type3: L.TokenType,
        _ type4: L.TokenType
    ) {
        if let capture1 = match.output.1 {
            self.tokens.append(.init(type: type1, string: capture1))
        }

        if let capture2 = match.output.2 {
            self.tokens.append(.init(type: type2, string: capture2))
        }

        if let capture3 = match.output.3 {
            self.tokens.append(.init(type: type3, string: capture3))
        }

        if let capture4 = match.output.4 {
            self.tokens.append(.init(type: type4, string: capture4))
        }
    }
}

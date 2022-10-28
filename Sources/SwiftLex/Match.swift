public struct Match<L: Lexer> {
    public enum Action {
        case push
        case pop
    }

    internal let regex: Regex<AnyRegexOutput>
    internal let action: (_ context: LexerContext<L>, _ match: Regex<AnyRegexOutput>.Match) -> ()
}

extension Match {
    public init(regex: Regex<Substring>, tokenType: L.TokenType, nextState: KeyPath<L, State<L>>? = nil) {
        precondition(nextState != nil || !"".contains(regex), "Regex '\(regex)' matches empty string but does not change the state.")

        self.regex = .init(regex)
        self.action = { context, match in
            context.appendToken(withType: tokenType, string: match[0].substring!)

            if let nextState {
                context.push(state: context.lexer[keyPath: nextState])
            }
        }
    }

    public init<S>(string: S, tokenType: L.TokenType, nextState: KeyPath<L, State<L>>? = nil) where S: StringProtocol {
        precondition(!string.isEmpty, "Cannot match an empty string.")

        self.regex = .init(verbatim: String(string))
        self.action = { context, match in
            context.appendToken(withType: tokenType, string: match[0].substring!)

            if let nextState {
                context.push(state: context.lexer[keyPath: nextState])
            }
        }
    }

    public init(regex: Regex<Substring>, tokenType: L.TokenType, action: Action) {
        self.regex = .init(regex)
        self.action = { context, match in
            context.appendToken(withType: tokenType, string: match[0].substring!)

            switch action {
            case .push:
                context.push(state: context.currentState)
            case .pop:
                context.popState()
            }
        }
    }

    public init<S>(string: S, tokenType: L.TokenType, action: Action) where S: StringProtocol {
        precondition(!string.isEmpty, "Cannot match an empty string.")

        self.regex = .init(verbatim: String(string))
        self.action = { context, match in
            context.appendToken(withType: tokenType, string: match[0].substring!)

            switch action {
            case .push:
                context.push(state: context.currentState)
            case .pop:
                context.popState()
            }
        }
    }

    public init(regex: Regex<Substring>, body: @escaping (_ context: LexerContext<L>, _ match: Substring) -> ()) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, match[0].substring!)
        }
    }

    public init<S>(string: S, body: @escaping (_ context: LexerContext<L>, _ match: Substring) -> ()) where S: StringProtocol {
        precondition(!string.isEmpty, "Cannot match an empty string.")

        self.regex = .init(verbatim: String(string))
        self.action = { context, match in
            body(context, match[0].substring!)
        }
    }

    public init(regex: Regex<AnyRegexOutput>, body: @escaping (_ context: LexerContext<L>, _ match: Regex<AnyRegexOutput>.Match) -> ()) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, match)
        }
    }

    // - MARK: One Capture
    public init(
        regex: Regex<(Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    // - MARK: Two Captures
    public init(
        regex: Regex<(Substring, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    // - MARK: Three Captures
    public init(
        regex: Regex<(Substring, Substring, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    // - MARK: Four Captures
    public init(
        regex: Regex<(Substring, Substring, Substring, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?, Substring, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?, Substring, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?, Substring?, Substring)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?, Substring?, Substring)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?, Substring, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?, Substring, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring, Substring?, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring, Substring?, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }

    public init(
        regex: Regex<(Substring, Substring?, Substring?, Substring?, Substring?)>,
        body: @escaping (_ context: LexerContext<L>, _ match: Regex<(Substring, Substring?, Substring?, Substring?, Substring?)>.Match) -> ()
    ) {
        self.regex = .init(regex)
        self.action = { context, match in
            body(context, try! regex.wholeMatch(in: match[0].substring!)!)
        }
    }
}

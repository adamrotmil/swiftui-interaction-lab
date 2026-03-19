import SwiftUI

// MARK: - Code Block View

/// A styled code display component with basic syntax highlighting,
/// dark background, monospaced font, and an explanatory caption.
struct CodeBlockView: View {
    let code: String
    let caption: String

    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Code area
            ZStack(alignment: .topTrailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    highlightedCode
                        .padding(20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(white: 0.13))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: caption.isEmpty ? 12 : 0,
                        bottomTrailingRadius: caption.isEmpty ? 12 : 0,
                        topTrailingRadius: 12
                    )
                )

                // Copy button
                Button {
                    copyToClipboard()
                } label: {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .font(.caption)
                        .foregroundStyle(copied ? .green : .white.opacity(0.5))
                        .padding(8)
                        .background(.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .padding(10)
            }

            // Caption
            if !caption.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text(caption)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(white: 0.93))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 12,
                        bottomTrailingRadius: 12,
                        topTrailingRadius: 0
                    )
                )
            }
        }
    }

    // MARK: - Syntax Highlighting

    /// Parses Swift code and applies basic color highlighting.
    private var highlightedCode: some View {
        let tokens = tokenize(code)
        return tokens.reduce(Text("")) { result, token in
            result + Text(token.text)
                .foregroundColor(token.color)
        }
        .font(.system(.callout, design: .monospaced))
        .lineSpacing(4)
    }

    // MARK: - Tokenizer

    private struct Token {
        let text: String
        let color: Color
    }

    private func tokenize(_ source: String) -> [Token] {
        var tokens: [Token] = []
        var remaining = source[...]

        let keywords: Set<String> = [
            "import", "struct", "class", "enum", "func", "var", "let",
            "if", "else", "switch", "case", "default", "for", "while",
            "return", "guard", "self", "Self", "true", "false", "nil",
            "private", "public", "internal", "static", "mutating",
            "some", "any", "in", "where", "protocol", "extension",
            "withAnimation", "await", "async", "throws", "throw", "try",
            "@State", "@Binding", "@Published", "@ObservedObject",
            "@StateObject", "@EnvironmentObject", "@Environment",
            "@ViewBuilder", "@MainActor", "@Observable",
        ]

        let typeKeywords: Set<String> = [
            "View", "Color", "Text", "Image", "Button", "VStack", "HStack",
            "ZStack", "NavigationStack", "ScrollView", "ForEach", "Group",
            "Spacer", "Divider", "GeometryReader", "AnyView", "EmptyView",
            "DragGesture", "MagnifyGesture", "LongPressGesture",
            "GestureState", "Animation", "Spring", "CGSize", "CGFloat",
            "Bool", "Int", "Double", "String", "UUID",
        ]

        while !remaining.isEmpty {
            // Comments: //
            if remaining.hasPrefix("//") {
                if let newline = remaining.firstIndex(of: "\n") {
                    let comment = String(remaining[remaining.startIndex..<newline])
                    tokens.append(Token(text: comment, color: Color(white: 0.45)))
                    remaining = remaining[newline...]
                } else {
                    tokens.append(Token(text: String(remaining), color: Color(white: 0.45)))
                    remaining = remaining[remaining.endIndex...]
                }
            }
            // Strings: "..."
            else if remaining.hasPrefix("\"") {
                var end = remaining.index(after: remaining.startIndex)
                var escaped = false
                while end < remaining.endIndex {
                    if escaped {
                        escaped = false
                    } else if remaining[end] == "\\" {
                        escaped = true
                    } else if remaining[end] == "\"" {
                        end = remaining.index(after: end)
                        break
                    }
                    end = remaining.index(after: end)
                }
                let str = String(remaining[remaining.startIndex..<end])
                tokens.append(Token(text: str, color: Color(red: 0.9, green: 0.4, blue: 0.35)))
                remaining = remaining[end...]
            }
            // Dot-prefixed modifiers
            else if remaining.hasPrefix(".") {
                var end = remaining.index(after: remaining.startIndex)
                while end < remaining.endIndex && (remaining[end].isLetter || remaining[end].isNumber || remaining[end] == "_") {
                    end = remaining.index(after: end)
                }
                let dotWord = String(remaining[remaining.startIndex..<end])
                tokens.append(Token(text: dotWord, color: Color(red: 0.6, green: 0.8, blue: 0.95)))
                remaining = remaining[end...]
            }
            // Numbers
            else if remaining.first?.isNumber == true {
                var end = remaining.startIndex
                while end < remaining.endIndex && (remaining[end].isNumber || remaining[end] == ".") {
                    end = remaining.index(after: end)
                }
                let num = String(remaining[remaining.startIndex..<end])
                tokens.append(Token(text: num, color: Color(red: 0.85, green: 0.75, blue: 0.45)))
                remaining = remaining[end...]
            }
            // Words
            else if remaining.first?.isLetter == true || remaining.first == "_" || remaining.first == "@" {
                var end = remaining.startIndex
                if remaining.first == "@" {
                    end = remaining.index(after: end)
                }
                while end < remaining.endIndex && (remaining[end].isLetter || remaining[end].isNumber || remaining[end] == "_") {
                    end = remaining.index(after: end)
                }
                let word = String(remaining[remaining.startIndex..<end])
                if keywords.contains(word) {
                    tokens.append(Token(text: word, color: Color(red: 0.85, green: 0.5, blue: 0.85)))
                } else if typeKeywords.contains(word) {
                    tokens.append(Token(text: word, color: Color(red: 0.4, green: 0.8, blue: 0.75)))
                } else {
                    tokens.append(Token(text: word, color: Color(white: 0.9)))
                }
                remaining = remaining[end...]
            }
            // Whitespace and symbols
            else {
                let ch = String(remaining.first!)
                tokens.append(Token(text: ch, color: Color(white: 0.75)))
                remaining = remaining[remaining.index(after: remaining.startIndex)...]
            }
        }

        return tokens
    }

    // MARK: - Copy

    private func copyToClipboard() {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(code, forType: .string)
        #else
        UIPasteboard.general.string = code
        #endif
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copied = false
        }
    }
}

// MARK: - Inline Code

/// Inline code text styled with monospaced font and background.
struct InlineCode: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(.callout, design: .monospaced))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(white: 0.92))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            CodeBlockView(
                code: "withAnimation(.spring(response: 0.5)) {\n    isExpanded.toggle()\n}",
                caption: "A spring animation with medium bounce"
            )
        }
        .padding(24)
    }
}

import SwiftUI

// MARK: - Chapter 7: Command Palette â Raycast's Search-First Interface

/// An interactive Treehouse-style lesson analyzing Raycast's command palette
/// pattern and building a working version in SwiftUI.
struct Chapter07_CommandPalette: View {
    var body: some View {
        LessonView(
            lesson: allLessons[6],
            steps: [
                LessonStep("Product Analysis") {
                    Step1_PaletteAnalysis()
                },
                LessonStep("The Pattern Deconstructed") {
                    Step2_PatternBreakdown()
                },
                LessonStep("Build It: Search + Filter") {
                    Step3_SearchFilter()
                },
                LessonStep("Build It: Keyboard-First") {
                    Step4_KeyboardFirst()
                },
                LessonStep("Why It Works") {
                    Step5_WhyItWorks()
                },
                LessonStep("Try This") {
                    Step6_PaletteChallenge()
                },
            ]
        )
    }
}

// MARK: - Step 1: Product Analysis

private struct Step1_PaletteAnalysis: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Raycast reimagined the app launcher. Instead of wrapping features in traditional navigation chrome, they collapse everything behind a single text input. Invoke â type â act. That's the entire interaction model for hundreds of features.")

            LessonText("If your app has more than ~10 distinct actions, a command palette isn't a power-user feature â it's a primary navigation surface. VS Code proved this for code editors. Linear adopted it for project management. Even Figma has Cmd+/ now.")

            // Visual: invoke â type â act flow
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    flowStep(icon: "command", label: "Invoke", sublabel: "âK", color: .purple)
                    flowArrow()
                    flowStep(icon: "character.cursor.ibeam", label: "Type", sublabel: "filter", color: .blue)
                    flowArrow()
                    flowStep(icon: "play.fill", label: "Act", sublabel: "execute", color: .green)
                }
                .padding(20)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.95))
            )

            LessonText("The mental model is radically simple: one surface to find anything, do anything. The system scales linearly â adding a new feature means adding a new command, not redesigning navigation hierarchy.")
        }
    }

    private func flowStep(icon: String, label: String, sublabel: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 48, height: 48)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(label)
                .font(.callout)
                .fontWeight(.semibold)
            Text(sublabel)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func flowArrow() -> some View {
        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(.tertiary)
            .frame(width: 24)
    }
}

// MARK: - Step 2: Pattern Breakdown

private struct Step2_PatternBreakdown: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Let's break down the anatomy. Every command palette has four layers working together:")

            // Anatomy card
            VStack(alignment: .leading, spacing: 2) {
                anatomyRow(number: 1, label: "Search Input", detail: "Always focused, filters as you type", icon: "magnifyingglass")
                anatomyRow(number: 2, label: "Results List", detail: "Filtered, ranked by relevance/recency", icon: "list.bullet")
                anatomyRow(number: 3, label: "Keyboard Nav", detail: "Arrow keys to select, Return to execute", icon: "keyboard")
                anatomyRow(number: 4, label: "Action Execution", detail: "Runs the command, dismisses the palette", icon: "bolt.fill")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.95))
            )

            // Web comparison
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .foregroundStyle(.blue)
                    Text("Web Equivalent")
                        .font(.callout)
                        .fontWeight(.bold)
                }

                LessonText("On the web, you'd build this with a modal + input + filtered list + keyboard event listeners. You'd wire up onKeyDown for arrow keys, manage a selectedIndex, handle focus trapping, and debounce the search input.")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.blue.opacity(0.15), lineWidth: 1)
                    )
            )

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "swift")
                        .foregroundStyle(.orange)
                    Text("SwiftUI Equivalent")
                        .font(.callout)
                        .fontWeight(.bold)
                }

                LessonText("In SwiftUI, we get .searchable(), List with selection binding, and .keyboardShortcut() for free. The framework handles focus, keyboard navigation, and accessibility automatically.")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.orange.opacity(0.15), lineWidth: 1)
                    )
            )
        }
    }

    private func anatomyRow(number: Int, label: String, detail: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Text("\(number)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Color.purple)
                .clipShape(Circle())

            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(.purple)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Step 3: Search + Filter (Live Interactive)

private struct PaletteCommand: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
    let shortcut: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

private let sampleCommands: [PaletteCommand] = [
    PaletteCommand(name: "Open Settings", icon: "gear", category: "Navigation", shortcut: "â,"),
    PaletteCommand(name: "New Document", icon: "doc.badge.plus", category: "Actions", shortcut: "âN"),
    PaletteCommand(name: "Toggle Dark Mode", icon: "moon.fill", category: "Appearance", shortcut: nil),
    PaletteCommand(name: "Copy Link", icon: "link", category: "Actions", shortcut: "ââ§C"),
    PaletteCommand(name: "Show Clipboard History", icon: "clipboard", category: "Tools", shortcut: "ââ§V"),
    PaletteCommand(name: "Search Files", icon: "doc.text.magnifyingglass", category: "Navigation", shortcut: "âP"),
    PaletteCommand(name: "Run Command", icon: "terminal", category: "Tools", shortcut: nil),
    PaletteCommand(name: "Toggle Sidebar", icon: "sidebar.left", category: "Appearance", shortcut: "â\\"),
    PaletteCommand(name: "Open Recent", icon: "clock.arrow.circlepath", category: "Navigation", shortcut: nil),
    PaletteCommand(name: "Export as PDF", icon: "arrow.down.doc", category: "Actions", shortcut: nil),
    PaletteCommand(name: "Find and Replace", icon: "magnifyingglass", category: "Tools", shortcut: "ââ§F"),
    PaletteCommand(name: "Zoom to Fit", icon: "arrow.up.left.and.arrow.down.right", category: "Appearance", shortcut: "â0"),
]

private struct Step3_SearchFilter: View {
    @State private var searchText = ""
    @State private var executedCommand: String?

    private var filteredCommands: [PaletteCommand] {
        if searchText.isEmpty { return sampleCommands }
        return sampleCommands.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Here's a working command palette. Type to filter â the list updates in real time. Tap a command to \"execute\" it. The search matches against both the command name and its category.")

            // Live command palette
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Type a commandâ¦", text: $searchText)
                        .font(.body)
                    #if os(iOS)
                        .textInputAutocapitalization(.never)
                    #endif
                        .autocorrectionDisabled()

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.tertiary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(14)
                .background(Color(white: 0.95))

                Divider()

                // Results
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if filteredCommands.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.tertiary)
                                Text("No commands match \"\(searchText)\"")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                        } else {
                            ForEach(filteredCommands) { command in
                                Button {
                                    executeCommand(command)
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: command.icon)
                                            .font(.callout)
                                            .foregroundStyle(.purple)
                                            .frame(width: 28, height: 28)
                                            .background(Color.purple.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))

                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(command.name)
                                                .font(.callout)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.primary)
                                            Text(command.category)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        if let shortcut = command.shortcut {
                                            Text(shortcut)
                                                .font(.system(.caption, design: .monospaced))
                                                .foregroundStyle(.tertiary)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(white: 0.92))
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .frame(maxHeight: 280)

                // Execution feedback
                if let executed = executedCommand {
                    Divider()
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Executed: \(executed)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.green)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.green.opacity(0.08))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(white: 0.85), lineWidth: 1)
            )

            Text("Type to filter, tap to execute")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)

            CodeBlockView(
                code: """
                @State private var searchText = ""

                var filteredCommands: [Command] {
                    if searchText.isEmpty { return allCommands }
                    return allCommands.filter {
                        $0.name.localizedCaseInsensitiveContains(searchText)
                    }
                }

                // In body:
                VStack(spacing: 0) {
                    TextField("Type a commandâ¦", text: $searchText)
                    ForEach(filteredCommands) { command in
                        CommandRow(command: command)
                    }
                }
                """,
                caption: "A computed property re-filters on every keystroke. SwiftUI handles the diff."
            )

            LessonText("The key insight: filteredCommands is a computed property, not stored state. Every time searchText changes, SwiftUI recalculates the list and diffs only the rows that changed. On the web you'd debounce this â in SwiftUI, it's fast enough to run on every keystroke.")
        }
    }

    private func executeCommand(_ command: PaletteCommand) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            executedCommand = command.name
            searchText = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.3)) {
                executedCommand = nil
            }
        }
    }
}

// MARK: - Step 4: Keyboard-First

private struct Step4_KeyboardFirst: View {
    @State private var showPalette = false
    @State private var selectedIndex = 0
    @State private var searchText = ""

    private var filteredCommands: [PaletteCommand] {
        if searchText.isEmpty { return Array(sampleCommands.prefix(6)) }
        return sampleCommands.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("A command palette lives or dies by keyboard interaction. On macOS, you invoke it with a shortcut, navigate with arrow keys, and execute with Return â your hands never leave the keyboard.")

            // Interactive keyboard demo
            VStack(spacing: 16) {
                // Toggle button (simulates âK)
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        showPalette.toggle()
                        if showPalette {
                            selectedIndex = 0
                            searchText = ""
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: showPalette ? "xmark" : "magnifyingglass")
                            .font(.callout)
                        Text(showPalette ? "Dismiss" : "Open Command Palette")
                            .font(.callout)
                            .fontWeight(.medium)
                        Spacer()
                        Text("âK")
                            .font(.system(.caption, design: .monospaced))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(white: 0.88))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding(14)
                    .background(showPalette ? Color.purple.opacity(0.1) : Color(white: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(showPalette ? Color.purple.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            #if os(macOS)
                .keyboardShortcut("k", modifiers: .command)
            #endif

                if showPalette {
                    VStack(spacing: 0) {
                        // Search
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Searchâ¦", text: $searchText)
                                .font(.body)
                            #if os(iOS)
                                .textInputAutocapitalization(.never)
                            #endif
                                .autocorrectionDisabled()
                        }
                        .padding(14)
                        .background(Color(white: 0.95))

                        Divider()

                        // Results with selection highlight
                        VStack(spacing: 0) {
                            ForEach(Array(filteredCommands.enumerated()), id: \.element.id) { index, command in
                                Button {
                                    selectedIndex = index
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: command.icon)
                                            .font(.callout)
                                            .foregroundStyle(index == selectedIndex ? .white : .purple)
                                            .frame(width: 24)

                                        Text(command.name)
                                            .font(.callout)
                                            .fontWeight(.medium)
                                            .foregroundStyle(index == selectedIndex ? .white : .primary)

                                        Spacer()

                                        if index == selectedIndex {
                                            Text("âµ")
                                                .font(.system(.caption, design: .monospaced))
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(index == selectedIndex ? Color.purple : Color.clear)
                                    )
                                    .padding(.horizontal, 4)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)

                        Divider()

                        // Keyboard hint bar
                        HStack(spacing: 16) {
                            keyHint(keys: "ââ", action: "navigate")
                            keyHint(keys: "âµ", action: "execute")
                            keyHint(keys: "esc", action: "dismiss")
                            Spacer()
                        }
                        .padding(10)
                        .background(Color(white: 0.96))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.purple.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 16, y: 8)
                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                }
            }

            // Navigation buttons
            if showPalette {
                HStack(spacing: 12) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedIndex = max(0, selectedIndex - 1)
                        }
                    } label: {
                        Label("Up", systemImage: "arrow.up")
                            .font(.callout)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedIndex = min(filteredCommands.count - 1, selectedIndex + 1)
                        }
                    } label: {
                        Label("Down", systemImage: "arrow.down")
                            .font(.callout)
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Text("Tap rows or use arrows to navigate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            CodeBlockView(
                code: """
                Button("Open Palette") {
                    showPalette.toggle()
                }
                .keyboardShortcut("k", modifiers: .command)

                // Selection via List binding:
                List(filteredCommands, selection: $selected) { cmd in
                    CommandRow(command: cmd)
                }

                // Or manual tracking:
                .onKeyPress(.upArrow) {
                    selectedIndex = max(0, selectedIndex - 1)
                    return .handled
                }
                .onKeyPress(.downArrow) {
                    selectedIndex = min(commands.count - 1, selectedIndex + 1)
                    return .handled
                }
                """,
                caption: ".keyboardShortcut() and .onKeyPress() give you keyboard-first interaction."
            )

            LessonText("On macOS, .keyboardShortcut(\"k\", modifiers: .command) registers a global shortcut for the window. The .onKeyPress modifier (iOS 17+ / macOS 14+) lets you handle individual key events. On iOS, this works with hardware keyboards and the simulator.")
        }
    }

    private func keyHint(keys: String, action: String) -> some View {
        HStack(spacing: 4) {
            Text(keys)
                .font(.system(.caption2, design: .monospaced))
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
                .padding(.vertical, 1)
                .background(Color(white: 0.88))
                .clipShape(RoundedRectangle(cornerRadius: 3))
            Text(action)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Step 5: Why It Works

private struct Step5_WhyItWorks: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Raycast's genius isn't the command palette itself â it's the consistency. Context menus, keyboard shortcuts, extension UIs â every surface behaves identically. Zero relearning as the product grows.")

            // Three pillars
            VStack(spacing: 12) {
                pillar(
                    icon: "arrow.triangle.branch",
                    title: "Scales Linearly",
                    detail: "Adding a feature = adding a command. No nav redesign needed. The palette is an append-only interface.",
                    color: .green
                )

                pillar(
                    icon: "bolt.fill",
                    title: "Sub-Frame Fast",
                    detail: "Results filter as you type, within the same frame. No loading spinners, no debouncing. The search feels native because it is.",
                    color: .orange
                )

                pillar(
                    icon: "rectangle.on.rectangle",
                    title: "Enforced Consistency",
                    detail: "The extension API mandates a fixed UI structure. Third-party commands look and behave exactly like built-in ones.",
                    color: .purple
                )
            }

            LessonText("This maps cleanly to SwiftUI's architecture. Your command list is just data â an array of structs. The view layer is a single, reusable component. Adding features means appending to an array, not refactoring a view hierarchy.")

            CodeBlockView(
                code: """
                // Adding a new command is one line:
                let commands: [Command] = [
                    // ... existing commands
                    Command(name: "New Feature", icon: "star",
                            action: { openNewFeature() })
                ]
                // The palette UI never changes.
                """,
                caption: "Append-only architecture. The UI scales with the data."
            )
        }
    }

    private func pillar(icon: String, title: String, detail: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(color.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

// MARK: - Step 6: Try This

private struct Step6_PaletteChallenge: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryThisCard(
                prompt: "Add 'recent commands' that appear when the search field is empty. Track the last 3 executed commands in a @State array and show them in a \"Recent\" section above the full list."
            )

            LessonText("Here's a second challenge: add category section headers. Group commands by their category and show headers like \"Navigation\", \"Actions\", \"Tools\", \"Appearance\" using SwiftUI's Section view.")

            CodeBlockView(
                code: """
                @State private var recentCommands: [Command] = []

                var groupedCommands: [(String, [Command])] {
                    Dictionary(grouping: filteredCommands, by: \\.category)
                        .sorted { $0.key < $1.key }
                }

                // Show recents when empty:
                if searchText.isEmpty && !recentCommands.isEmpty {
                    Section("Recent") {
                        ForEach(recentCommands) { cmd in
                            CommandRow(command: cmd)
                        }
                    }
                }

                // Grouped results:
                ForEach(groupedCommands, id: \\.0) { category, commands in
                    Section(category) {
                        ForEach(commands) { cmd in
                            CommandRow(command: cmd)
                        }
                    }
                }
                """,
                caption: "Dictionary(grouping:by:) is your friend for sectioned lists."
            )

            LessonText("Bonus: add a .sensoryFeedback(.success, trigger: executedCommand) on the palette container so executing a command gives a subtle haptic tap on iOS. This tiny detail makes the interaction feel physical.")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Chapter07_CommandPalette()
    }
}

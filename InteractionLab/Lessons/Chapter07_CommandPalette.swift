import SwiftUI

struct Chapter07_CommandPalette: View {
    @State private var currentStep = 0
    private let totalSteps = 6

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step \(currentStep + 1) of \(totalSteps)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                        .tint(.purple)
                }
                .padding(.horizontal)

                Group {
                    switch currentStep {
                    case 0: productAnalysis
                    case 1: patternDeconstructed
                    case 2: buildSearchFilter
                    case 3: buildKeyboardFirst
                    case 4: whyItWorks
                    case 5: tryThis
                    default: productAnalysis
                    }
                }

                HStack {
                    if currentStep > 0 {
                        Button { withAnimation { currentStep -= 1 } } label: {
                            Label("Back", systemImage: "chevron.left")
                        }
                    }
                    Spacer()
                    if currentStep < totalSteps - 1 {
                        Button { withAnimation { currentStep += 1 } } label: {
                            Label("Next", systemImage: "chevron.right")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 24)
        }
        .navigationTitle("Ch 7: Command Palette")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Step 1
    private var productAnalysis: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "command").font(.title).foregroundStyle(.purple)
                Text("Raycast").font(.title2).fontWeight(.bold)
            }.padding(.horizontal)
            Text("Raycast reimagined the app launcher. Instead of wrapping features in traditional navigation chrome, they collapse everything behind a single text input.").font(.title3).padding(.horizontal)
            Text("Invoke → type → act. That's the entire interaction model for hundreds of features — clipboard history, snippets, window management, AI chat, extensions.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) {
                Label("Design Insight", systemImage: "lightbulb.fill").font(.headline).foregroundStyle(.orange)
                Text("If your app has more than ~10 distinct actions, a command palette isn't a power-user feature — it's a primary navigation surface. Design it first, not last.").font(.subheadline)
            }.padding().background(Color.orange.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
        }
    }

    // MARK: - Step 2
    private var patternDeconstructed: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("The Pattern Deconstructed").font(.title2).fontWeight(.bold).padding(.horizontal)
            VStack(spacing: 12) {
                patternRow(icon: "magnifyingglass", label: "Search Input", desc: "Always focused, filters as you type")
                patternRow(icon: "list.bullet", label: "Results List", desc: "Filtered, ranked, keyboard-navigable")
                patternRow(icon: "keyboard", label: "Keyboard Nav", desc: "Arrow keys + Enter to execute")
                patternRow(icon: "bolt.fill", label: "Action Execution", desc: "Immediate feedback, then dismiss")
            }.padding().background(Color(white: 0.95)).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) {
                Label("Coming from the Web", systemImage: "globe").font(.headline)
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Web").font(.caption).fontWeight(.bold).foregroundStyle(.orange)
                        Text("Modal + input + filtered list + keyboard listeners + focus management").font(.caption)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "arrow.right").foregroundStyle(.secondary).padding(.top, 12)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SwiftUI").font(.caption).fontWeight(.bold).foregroundStyle(.blue)
                        Text(".searchable(), List with selection, .keyboardShortcut() — all built in").font(.caption)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding().background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
        }
    }

    // MARK: - Step 3
    @State private var searchText = ""
    private let commands: [(String, String, String)] = [
        ("gearshape", "Open Settings", "Navigation"),
        ("doc.badge.plus", "New Document", "Actions"),
        ("moon.fill", "Toggle Dark Mode", "Appearance"),
        ("link", "Copy Link", "Actions"),
        ("clipboard", "Show Clipboard History", "Tools"),
        ("magnifyingglass", "Search Files", "Navigation"),
        ("trash", "Move to Trash", "Actions"),
        ("arrow.clockwise", "Refresh Data", "Actions"),
        ("bell", "Notification Settings", "Navigation"),
        ("person.2", "Switch Workspace", "Navigation"),
    ]
    private var filteredCommands: [(String, String, String)] {
        if searchText.isEmpty { return commands }
        return commands.filter { $0.1.localizedCaseInsensitiveContains(searchText) }
    }

    private var buildSearchFilter: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Build It: Search + Filter").font(.title2).fontWeight(.bold).padding(.horizontal)
            Text("Type in the search field below. The list filters in real time.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search commands...", text: $searchText).textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }.buttonStyle(.plain)
                    }
                }.padding(12).background(Color(white: 0.95))
                Divider()
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredCommands, id: \.1) { cmd in
                            commandRow(icon: cmd.0, name: cmd.1, category: cmd.2)
                        }
                    }
                }.frame(height: 240)
            }.clipShape(RoundedRectangle(cornerRadius: 12)).overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color(white: 0.85), lineWidth: 1)).padding(.horizontal)
            codeBlock("var filteredCommands: [Command] {\n    if searchText.isEmpty { return allCommands }\n    return allCommands.filter {\n        $0.name.localizedCaseInsensitiveContains(searchText)\n    }\n}", caption: "Computed properties make filtering declarative. The view re-renders automatically when searchText changes.")
        }
    }

    // MARK: - Step 4
    @State private var showPaletteOverlay = false
    @State private var selectedCommandIndex = 0

    private var buildKeyboardFirst: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Keyboard-First Design").font(.title2).fontWeight(.bold).padding(.horizontal)
            Text("Raycast is invoked with a hotkey and navigated entirely by keyboard. In SwiftUI, .keyboardShortcut() makes this trivial.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            VStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) { showPaletteOverlay.toggle() }
                } label: {
                    HStack { Image(systemName: "command"); Text("K") }
                        .font(.headline).padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color(white: 0.15)).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }.buttonStyle(.plain)
                #if os(macOS)
                .keyboardShortcut("k", modifiers: .command)
                #endif
                Text("Click the button (or press ⌘K on Mac)").font(.caption).foregroundStyle(.secondary)
                if showPaletteOverlay {
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            Text("Type a command...").foregroundStyle(.tertiary)
                            Spacer()
                            Text("ESC").font(.caption2).padding(4).background(Color(white: 0.9)).clipShape(RoundedRectangle(cornerRadius: 4))
                        }.padding(12)
                        Divider()
                        ForEach(0..<3, id: \.self) { i in
                            HStack {
                                Image(systemName: commands[i].0).frame(width: 20)
                                Text(commands[i].1); Spacer()
                                Text(commands[i].2).font(.caption).foregroundStyle(.secondary)
                            }.padding(.horizontal, 12).padding(.vertical, 8)
                            .background(i == selectedCommandIndex ? Color.blue.opacity(0.15) : .clear)
                        }
                    }.background(Color(white: 0.98)).clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }.padding().frame(minHeight: 200).background(Color(white: 0.92)).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal)
            codeBlock("Button(\"Open Palette\") { showPalette = true }\n    .keyboardShortcut(\"k\", modifiers: .command)", caption: ".keyboardShortcut() adds system-standard keyboard shortcuts.")
        }
    }

    // MARK: - Step 5
    private var whyItWorks: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Why Raycast Works").font(.title2).fontWeight(.bold).padding(.horizontal)
            VStack(alignment: .leading, spacing: 16) {
                qualityPoint(icon: "bolt.fill", title: "Sub-frame Fast", detail: "Search results appear before you finish typing.")
                qualityPoint(icon: "paintbrush.fill", title: "Native Feel", detail: "Correct vibrancy, blur, typography. Themes respect system appearance.")
                qualityPoint(icon: "puzzlepiece.fill", title: "Extension Consistency", detail: "Third-party extensions look indistinguishable from first-party.")
                qualityPoint(icon: "brain.fill", title: "One Pattern to Learn", detail: "Context menus, shortcuts, extensions all behave identically.")
            }.padding(.horizontal)
        }
    }

    // MARK: - Step 6
    private var tryThis: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles").font(.title2).foregroundStyle(.orange)
                Text("Try This").font(.title2).fontWeight(.bold)
            }.padding(.horizontal)
            VStack(alignment: .leading, spacing: 12) {
                Text("Extend the command palette:").font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Label("Add 'recent commands' when search is empty", systemImage: "1.circle")
                    Label("Group commands by category with section headers", systemImage: "2.circle")
                    Label("Add .sensoryFeedback on command execution", systemImage: "3.circle")
                }.font(.body)
                Text("Hint: Use Dictionary(grouping:by:) on the category field.").font(.subheadline).foregroundStyle(.secondary)
            }.padding().background(Color.orange.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) {
                Label("Builds on: Navigation (Ch 4), SF Symbols (Ch 3)", systemImage: "arrow.turn.right.up").font(.caption).foregroundStyle(.secondary)
                Label("Next up: Linear's Calm Dashboard (Ch 8)", systemImage: "arrow.right.circle").font(.caption).foregroundStyle(.secondary)
            }.padding(.horizontal)
        }
    }

    // MARK: - Helpers
    private func patternRow(icon: String, label: String, desc: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.title3).foregroundStyle(.purple).frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.subheadline).fontWeight(.semibold)
                Text(desc).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
    private func commandRow(icon: String, name: String, category: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(.purple).frame(width: 24)
            Text(name).font(.subheadline); Spacer()
            Text(category).font(.caption2).foregroundStyle(.secondary).padding(.horizontal, 8).padding(.vertical, 2).background(Color(white: 0.9)).clipShape(Capsule())
        }.padding(.horizontal, 12).padding(.vertical, 8).contentShape(Rectangle())
    }
    private func qualityPoint(icon: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).font(.title3).foregroundStyle(.purple).frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }
    private func codeBlock(_ code: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code).font(.system(.caption, design: .monospaced)).padding(12)
            }.background(Color(white: 0.12)).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 8))
            Text(caption).font(.caption).foregroundStyle(.secondary)
        }.padding(.horizontal)
    }
}

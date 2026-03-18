import SwiftUI

/// Experiment 11: Menu Bar & Toolbar
///
/// Demonstrates SwiftUI toolbar items, contextual menus, and keyboard shortcuts.
/// On macOS, toolbars integrate with the title bar. On iOS, they appear in the
/// navigation bar and bottom bar. The same `.toolbar` API adapts to both platforms.
struct MenuBarToolbarView: View {
    @State private var selectedColor: Color = .blue
    @State private var fontSize: CGFloat = 16
    @State private var isBold = false
    @State private var isItalic = false
    @State private var textContent = "Try the toolbar buttons above and the context menu (right-click / long-press on this text). Keyboard shortcuts work on macOS."
    @State private var showInspector = false
    @State private var alignment: TextAlignment = .leading

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Menu Bar & Toolbar")
                    .experimentHeader()
                Text("Toolbars adapt to each platform: navigation bar on iOS, title bar on macOS. Same API, native feel.")
                    .experimentDescription()

                // MARK: - Interactive Text Editor
                textEditorSection

                // MARK: - Toolbar Placement Guide
                placementGuide

                // MARK: - Keyboard Shortcuts
                keyboardShortcutsSection
            }
            .padding()
        }
        .navigationTitle("11 — Toolbars")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            // Primary actions (trailing on iOS, leading on macOS)
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isBold.toggle()
                } label: {
                    Image(systemName: "bold")
                        .foregroundStyle(isBold ? .blue : .secondary)
                }
                .keyboardShortcut("b", modifiers: .command)

                Button {
                    isItalic.toggle()
                } label: {
                    Image(systemName: "italic")
                        .foregroundStyle(isItalic ? .blue : .secondary)
                }
                .keyboardShortcut("i", modifiers: .command)
            }

            // Secondary actions
            ToolbarItemGroup(placement: .secondaryAction) {
                Button {
                    fontSize = min(32, fontSize + 2)
                } label: {
                    Label("Increase Size", systemImage: "plus.magnifyingglass")
                }
                .keyboardShortcut("+", modifiers: .command)

                Button {
                    fontSize = max(10, fontSize - 2)
                } label: {
                    Label("Decrease Size", systemImage: "minus.magnifyingglass")
                }
                .keyboardShortcut("-", modifiers: .command)

                Divider()

                Menu("Text Color") {
                    Button("Blue") { selectedColor = .blue }
                    Button("Red") { selectedColor = .red }
                    Button("Green") { selectedColor = .green }
                    Button("Purple") { selectedColor = .purple }
                    Button("Orange") { selectedColor = .orange }
                }

                Menu("Alignment") {
                    Button("Leading") { alignment = .leading }
                    Button("Center") { alignment = .center }
                    Button("Trailing") { alignment = .trailing }
                }
            }

            #if os(iOS)
            // Bottom bar on iOS
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    showInspector.toggle()
                } label: {
                    Label("Inspector", systemImage: "sidebar.right")
                }

                Spacer()

                Text("Size: \(Int(fontSize))pt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            #endif
        }
    }

    // MARK: - Text Editor Section

    private var textEditorSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Interactive Editor", systemImage: "pencil.and.outline")
                .font(.headline)
            Text("Use the toolbar buttons to style this text. Right-click (or long-press) for the context menu.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(textContent)
                .font(.system(size: fontSize))
                .fontWeight(isBold ? .bold : .regular)
                .italic(isItalic)
                .foregroundStyle(selectedColor)
                .multilineTextAlignment(alignment)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.05), radius: 2)
                .contextMenu {
                    Button {
                        isBold.toggle()
                    } label: {
                        Label("Bold", systemImage: "bold")
                    }

                    Button {
                        isItalic.toggle()
                    } label: {
                        Label("Italic", systemImage: "italic")
                    }

                    Divider()

                    Menu("Color") {
                        Button("Blue") { selectedColor = .blue }
                        Button("Red") { selectedColor = .red }
                        Button("Green") { selectedColor = .green }
                    }

                    Divider()

                    Button {
                        fontSize = 16
                        isBold = false
                        isItalic = false
                        selectedColor = .blue
                        alignment = .leading
                    } label: {
                        Label("Reset Formatting", systemImage: "arrow.counterclockwise")
                    }
                }

            // Current state display
            HStack(spacing: 16) {
                Label("\(Int(fontSize))pt", systemImage: "textformat.size")
                if isBold { Label("Bold", systemImage: "bold") }
                if isItalic { Label("Italic", systemImage: "italic") }
                Circle()
                    .fill(selectedColor)
                    .frame(width: 12, height: 12)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Placement Guide

    private var placementGuide: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Toolbar Placements", systemImage: "rectangle.split.3x1")
                .font(.headline)

            let placements: [(String, String, String)] = [
                (".primaryAction", "Leading actions on macOS, trailing on iOS", "star.fill"),
                (".secondaryAction", "Overflow menu or additional bar items", "ellipsis.circle"),
                (".navigation", "Back button area (system-managed)", "chevron.left"),
                (".bottomBar", "iOS bottom toolbar (not available on macOS)", "rectangle.bottomhalf.filled"),
                (".principal", "Center of the toolbar (custom title area)", "text.aligncenter"),
                (".cancellationAction", "Cancel button in sheets and dialogs", "xmark"),
                (".confirmationAction", "Confirm button in sheets and dialogs", "checkmark"),
            ]

            ForEach(placements, id: \.0) { name, description, icon in
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(.caption.monospaced().bold())
                        Text(description)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Keyboard Shortcuts

    private var keyboardShortcutsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Keyboard Shortcuts", systemImage: "keyboard")
                .font(.headline)
            Text("SwiftUI's .keyboardShortcut modifier adds platform-native shortcuts. On macOS, these appear in the menu bar.")
                .font(.caption)
                .foregroundStyle(.secondary)

            let shortcuts: [(String, String)] = [
                ("⌘B", "Toggle Bold"),
                ("⌘I", "Toggle Italic"),
                ("⌘+", "Increase Font Size"),
                ("⌘-", "Decrease Font Size"),
            ]

            ForEach(shortcuts, id: \.0) { key, action in
                HStack {
                    Text(key)
                        .font(.caption.monospaced().bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text(action)
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        MenuBarToolbarView()
    }
}

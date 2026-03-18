import SwiftUI

/// Experiment 12: Multi-Window & Settings (macOS-Focused)
///
/// Demonstrates macOS-specific windowing: opening new windows, the Settings
/// scene, and managing window state. These concepts have no web equivalent —
/// web apps run in a single viewport controlled by the browser.
struct MultiWindowView: View {
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #endif

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Multi-Window & Settings")
                    .experimentHeader()
                Text("macOS apps can manage multiple windows and scenes — a concept absent from web development.")
                    .experimentDescription()

                #if os(macOS)
                macOSContent
                #else
                iOSFallback
                #endif

                windowConceptsSection
                sceneTypesSection
            }
            .padding()
        }
        .navigationTitle("12 — Multi-Window")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - macOS Content

    #if os(macOS)
    private var macOSContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Window Actions", systemImage: "macwindow.badge.plus")
                .font(.headline)
            Text("These buttons use OpenWindowAction to open new windows defined in the App struct.")
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                Button {
                    openWindow(id: "experiment-viewer")
                } label: {
                    Label("Open Experiment Viewer Window", systemImage: "macwindow.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Text("Note: The Settings window is opened via ⌘, (Command+Comma) — the standard macOS convention.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
                    .background(.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    #endif

    // MARK: - iOS Fallback

    #if os(iOS)
    private var iOSFallback: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("iPad Multi-Window", systemImage: "rectangle.split.2x1")
                .font(.headline)
            Text("On iPad, your app can support multiple windows via the multitasking system. On iPhone, apps are single-window.")
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                iPadFeature(
                    icon: "rectangle.split.2x1.fill",
                    title: "Split View",
                    description: "Two apps side by side — system managed"
                )
                iPadFeature(
                    icon: "rectangle.on.rectangle",
                    title: "Slide Over",
                    description: "Floating narrow app panel"
                )
                iPadFeature(
                    icon: "rectangle.stack",
                    title: "Stage Manager",
                    description: "Resizable overlapping windows (iPadOS 16+)"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func iPadFeature(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.purple)
                .frame(width: 32)
            VStack(alignment: .leading) {
                Text(title).font(.subheadline.bold())
                Text(description).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    #endif

    // MARK: - Window Concepts

    private var windowConceptsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Key Window Concepts", systemImage: "lightbulb")
                .font(.headline)

            let concepts: [(String, String, String)] = [
                ("WindowGroup", "A scene that creates one or more windows from a view template. Each window is an independent instance.", "macwindow"),
                ("Settings", "macOS-only scene for the Preferences window (⌘,). Appears in the app menu automatically.", "gear"),
                ("OpenWindowAction", "Environment action to programmatically open a new window by its identifier.", "plus.rectangle"),
                ("Window", "A single-instance window scene. Unlike WindowGroup, it only allows one window of this type.", "macwindow"),
                ("MenuBarExtra", "macOS menu bar app — the icon that lives in the system menu bar.", "menubar.rectangle"),
            ]

            ForEach(concepts, id: \.0) { name, description, icon in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.subheadline.bold())
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Scene Types

    private var sceneTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("App Struct Example", systemImage: "doc.text")
                .font(.headline)
            Text("This is what a multi-scene macOS App struct looks like:")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("""
            @main
            struct MyApp: App {
                var body: some Scene {
                    // Main window (multi-instance)
                    WindowGroup {
                        ContentView()
                    }

                    // Single-instance utility window
                    Window("Activity", id: "activity") {
                        ActivityView()
                    }
                    .keyboardShortcut("0", modifiers: .command)

                    // Settings (⌘,)
                    #if os(macOS)
                    Settings {
                        SettingsView()
                    }
                    #endif
                }
            }
            """)
            .font(.caption.monospaced())
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        MultiWindowView()
    }
}

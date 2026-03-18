import SwiftUI

/// The main entry point for the Interaction Lab app.
/// This app serves as a hub for exploring SwiftUI interaction patterns
/// targeting both iOS 17+ and macOS 14+.
@main
struct InteractionLabApp: App {
    var body: some Scene {
        WindowGroup {
            LabDirectory()
        }

        #if os(macOS)
        // macOS Settings scene — accessible via Cmd+,
        Settings {
            SettingsView()
        }

        // Additional window for experiment isolation
        WindowGroup("Experiment Viewer", id: "experiment-viewer") {
            Text("Open an experiment from the main directory.")
                .frame(minWidth: 400, minHeight: 300)
                .padding()
        }
        #endif
    }
}

// MARK: - macOS Settings View

#if os(macOS)
struct SettingsView: View {
    @AppStorage("showExperimentNumbers") private var showExperimentNumbers = true
    @AppStorage("preferGridLayout") private var preferGridLayout = true

    var body: some View {
        Form {
            Toggle("Show experiment numbers", isOn: $showExperimentNumbers)
            Toggle("Prefer grid layout in directory", isOn: $preferGridLayout)
        }
        .padding()
        .frame(width: 350, height: 120)
    }
}
#endif

import SwiftUI

// MARK: - Experiment Model

/// Represents a single experiment entry in the lab directory.
struct Experiment: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let icon: String
    let platform: Platform

    enum Platform: String, CaseIterable {
        case iOS = "iOS"
        case macOS = "macOS"
        case both = "Both"

        var color: Color {
            switch self {
            case .iOS: return .blue
            case .macOS: return .purple
            case .both: return .green
            }
        }
    }
}

// MARK: - Experiment Registry

/// Central registry of all experiments. Add new experiments here.
let allExperiments: [Experiment] = [
    Experiment(
        id: 1, name: "Gesture Playground",
        description: "Drag, pinch, long-press — native gesture recognizers with spring snap-back.",
        icon: "hand.draw", platform: .both
    ),
    Experiment(
        id: 2, name: "Navigation Patterns",
        description: "NavigationStack, NavigationSplitView, and programmatic navigation paths.",
        icon: "arrow.triangle.branch", platform: .both
    ),
    Experiment(
        id: 3, name: "Spring Animations",
        description: "Real-time spring parameter tuning: response, damping, blend duration.",
        icon: "waveform.path.ecg", platform: .both
    ),
    Experiment(
        id: 4, name: "Matched Geometry",
        description: "Hero transitions between grid and detail using matchedGeometryEffect.",
        icon: "rectangle.on.rectangle.angled", platform: .both
    ),
    Experiment(
        id: 5, name: "Scroll Effects",
        description: "Parallax headers, scaling cards, and visual effects driven by scroll position.",
        icon: "scroll", platform: .both
    ),
    Experiment(
        id: 6, name: "Haptics & Feedback",
        description: "Impact, notification, and selection haptic patterns on iOS.",
        icon: "iphone.radiowaves.left.and.right", platform: .iOS
    ),
    Experiment(
        id: 7, name: "Sheets & Modals",
        description: "Sheet, full-screen cover, popover, and custom presentation detents.",
        icon: "rectangle.bottomhalf.inset.filled", platform: .both
    ),
    Experiment(
        id: 8, name: "TabView & Paging",
        description: "Tab bars with badges, page-style carousels, and programmatic tab switching.",
        icon: "rectangle.split.3x1", platform: .both
    ),
    Experiment(
        id: 9, name: "SF Symbols Showcase",
        description: "Rendering modes, symbol effects, and animated SF Symbol experiments.",
        icon: "star.square.on.square", platform: .both
    ),
    Experiment(
        id: 10, name: "Adaptive Layout",
        description: "ViewThatFits, AnyLayout, and size-class-driven responsive design.",
        icon: "rectangle.split.2x2", platform: .both
    ),
    Experiment(
        id: 11, name: "Menu Bar & Toolbar",
        description: "Toolbar items, menu bar commands, and keyboard shortcuts on macOS.",
        icon: "menubar.rectangle", platform: .macOS
    ),
    Experiment(
        id: 12, name: "Multi-Window & Settings",
        description: "Opening new windows with OpenWindowAction and the Settings scene.",
        icon: "macwindow.on.rectangle", platform: .macOS
    ),
]

// MARK: - Lab Directory View

/// The main hub that lists all available experiments.
/// Uses NavigationSplitView on macOS/iPad and NavigationStack on iPhone.
struct LabDirectory: View {
    @State private var selectedExperiment: Experiment?
    @State private var searchText = ""

    private var filteredExperiments: [Experiment] {
        if searchText.isEmpty { return allExperiments }
        return allExperiments.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        #if os(macOS)
        NavigationSplitView {
            experimentList
                .navigationSplitViewColumnWidth(min: 280, ideal: 320)
        } detail: {
            if let experiment = selectedExperiment {
                experimentDestination(for: experiment)
            } else {
                ContentUnavailableView(
                    "Select an Experiment",
                    systemImage: "flask",
                    description: Text("Choose an experiment from the sidebar to get started.")
                )
            }
        }
        #else
        NavigationStack {
            experimentList
        }
        #endif
    }

    // MARK: - Experiment List

    private var experimentList: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 280, maximum: 400), spacing: 16)],
                spacing: 16
            ) {
                ForEach(filteredExperiments) { experiment in
                    #if os(macOS)
                    ExperimentCard(experiment: experiment)
                        .onTapGesture { selectedExperiment = experiment }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedExperiment == experiment ? Color.accentColor : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    #else
                    NavigationLink(value: experiment) {
                        ExperimentCard(experiment: experiment)
                    }
                    .buttonStyle(.plain)
                    #endif
                }
            }
            .padding()
        }
        .navigationTitle("Interaction Lab")
        .searchable(text: $searchText, prompt: "Search experiments")
        #if !os(macOS)
        .navigationDestination(for: Experiment.self) { experiment in
            experimentDestination(for: experiment)
        }
        #endif
    }

    // MARK: - Experiment Routing

    @ViewBuilder
    private func experimentDestination(for experiment: Experiment) -> some View {
        switch experiment.id {
        case 1:  GesturePlaygroundView()
        case 2:  NavigationPatternsView()
        case 3:  SpringAnimationsView()
        case 4:  MatchedGeometryView()
        case 5:  ScrollEffectsView()
        case 6:  HapticsView()
        case 7:  SheetsAndModalsView()
        case 8:  TabViewPagingView()
        case 9:  SFSymbolsView()
        case 10: AdaptiveLayoutView()
        case 11: MenuBarToolbarView()
        case 12: MultiWindowView()
        default: Text("Unknown experiment")
        }
    }
}

#Preview {
    LabDirectory()
}

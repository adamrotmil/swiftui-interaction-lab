import SwiftUI

// MARK: - Experiment Model

/// Represents a single experiment entry in the lab directory.
struct Experiment: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let icon: String
    let platform: Platform
    let learningOrder: Int

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

/// Central registry of all experiments, ordered by learning progression.
/// The learning order builds from foundational concepts (springs, gestures)
/// toward advanced patterns (matched geometry, multi-window).
let allExperiments: [Experiment] = [
    Experiment(
        id: 3,
        name: "Spring Animations",
        description: "Real-time spring parameter tuning: response, damping, blend duration.",
        icon: "waveform.path.ecg",
        platform: .both,
        learningOrder: 1
    ),
    Experiment(
        id: 1,
        name: "Gesture Playground",
        description: "Drag, pinch, long-press \u{2014} native gesture recognizers with spring snap-back.",
        icon: "hand.draw",
        platform: .both,
        learningOrder: 2
    ),
    Experiment(
        id: 9,
        name: "SF Symbols Showcase",
        description: "Rendering modes, symbol effects, and animated SF Symbol experiments.",
        icon: "star.square.on.square",
        platform: .both,
        learningOrder: 3
    ),
    Experiment(
        id: 2,
        name: "Navigation Patterns",
        description: "NavigationStack, NavigationSplitView, and programmatic navigation paths.",
        icon: "arrow.triangle.branch",
        platform: .both,
        learningOrder: 4
    ),
    Experiment(
        id: 7,
        name: "Sheets & Modals",
        description: "Sheet, full-screen cover, popover, and custom presentation detents.",
        icon: "rectangle.bottomhalf.inset.filled",
        platform: .both,
        learningOrder: 5
    ),
    Experiment(
        id: 8,
        name: "TabView & Paging",
        description: "Tab bars with badges, page-style carousels, and programmatic tab switching.",
        icon: "rectangle.split.3x1",
        platform: .both,
        learningOrder: 6
    ),
    Experiment(
        id: 5,
        name: "Scroll Effects",
        description: "Parallax headers, scaling cards, and visual effects driven by scroll position.",
        icon: "scroll",
        platform: .both,
        learningOrder: 7
    ),
    Experiment(
        id: 4,
        name: "Matched Geometry",
        description: "Hero transitions between grid and detail using matchedGeometryEffect.",
        icon: "rectangle.on.rectangle.angled",
        platform: .both,
        learningOrder: 8
    ),
    Experiment(
        id: 6,
        name: "Haptics & Feedback",
        description: "Impact, notification, and selection haptic patterns on iOS.",
        icon: "iphone.radiowaves.left.and.right",
        platform: .iOS,
        learningOrder: 9
    ),
    Experiment(
        id: 10,
        name: "Adaptive Layout",
        description: "ViewThatFits, AnyLayout, and size-class-driven responsive design.",
        icon: "rectangle.split.2x2",
        platform: .both,
        learningOrder: 10
    ),
    Experiment(
        id: 11,
        name: "Menu Bar & Toolbar",
        description: "Toolbar items, menu bar commands, and keyboard shortcuts on macOS.",
        icon: "menubar.rectangle",
        platform: .macOS,
        learningOrder: 11
    ),
    Experiment(
        id: 12,
        name: "Multi-Window & Settings",
        description: "Opening new windows with OpenWindowAction and the Settings scene.",
        icon: "macwindow.on.rectangle",
        platform: .macOS,
        learningOrder: 12
    ),
]

// MARK: - Lab Directory View

/// Main hub view displaying lesson chapters and experiment cards.
struct LabDirectory: View {
    @State private var selectedExperiment: Experiment?
    @State private var selectedLesson: Lesson?
    @State private var searchText = ""

    private var filteredExperiments: [Experiment] {
        if searchText.isEmpty {
            return allExperiments
        }
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
            if let lesson = selectedLesson {
                lessonDestination(for: lesson)
            } else if let experiment = selectedExperiment {
                experimentDestination(for: experiment)
            } else {
                ContentUnavailableView(
                    "Select an Experiment",
                    systemImage: "flask",
                    description: Text("Choose a lesson or experiment from the sidebar to get started.")
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
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Lessons Section
                VStack(alignment: .leading, spacing: 12) {
                    Label("Lessons", systemImage: "book.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 4)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 280, maximum: 400), spacing: 16)],
                        spacing: 16
                    ) {
                        ForEach(allLessons) { lesson in
                            #if os(macOS)
                            LessonCard(lesson: lesson)
                                .onTapGesture {
                                    selectedExperiment = nil
                                    selectedLesson = lesson
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            selectedLesson == lesson
                                                ? lesson.accentColor
                                                : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                            #else
                            NavigationLink(value: lesson) {
                                LessonCard(lesson: lesson)
                            }
                            .buttonStyle(.plain)
                            #endif
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 4)

                // MARK: Experiments Section
                VStack(alignment: .leading, spacing: 12) {
                    Label("Experiments", systemImage: "flask")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 4)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 280, maximum: 400), spacing: 16)],
                        spacing: 16
                    ) {
                        ForEach(filteredExperiments) { experiment in
                            #if os(macOS)
                            ExperimentCard(experiment: experiment)
                                .onTapGesture {
                                    selectedLesson = nil
                                    selectedExperiment = experiment
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            selectedExperiment == experiment
                                                ? experiment.platform.color
                                                : Color.clear,
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
                }
            }
            .padding()
        }
        .searchable(text: $searchText, prompt: "Search experiments")
        .navigationTitle("Interaction Lab")
        #if !os(macOS)
        .navigationDestination(for: Experiment.self) { experiment in
            experimentDestination(for: experiment)
        }
        .navigationDestination(for: Lesson.self) { lesson in
            lessonDestination(for: lesson)
        }
        #endif
    }

    // MARK: - Lesson Routing

    /// Routes each lesson to its chapter view.
    @ViewBuilder
    private func lessonDestination(for lesson: Lesson) -> some View {
        switch lesson.id {
        case 1: Chapter01_SpringAnimations()
        case 2: Chapter02_Gestures()
        case 3: Chapter03_SFSymbols()
        case 4: Chapter04_Navigation()
        case 5: Chapter05_SheetsModals()
        case 6: Chapter06_TabViewPaging()
        case 7: Chapter07_CommandPalette()
        case 8: Chapter08_CalmDashboard()
        default: Text("Unknown lesson")
        }
    }

    // MARK: - Experiment Routing

    /// Routes each experiment to its view, wrapped in LabGuideView
    /// when guide content is available.
    @ViewBuilder
    private func experimentDestination(for experiment: Experiment) -> some View {
        if let guideData = guide(forExperimentID: experiment.id) {
            switch experiment.id {
            case 1:
                LabGuideView(guide: guideData) { GesturePlaygroundView() }
            case 2:
                LabGuideView(guide: guideData) { NavigationPatternsView() }
            case 3:
                LabGuideView(guide: guideData) { SpringAnimationsView() }
            case 4:
                LabGuideView(guide: guideData) { MatchedGeometryView() }
            case 5:
                LabGuideView(guide: guideData) { ScrollEffectsView() }
            case 6:
                LabGuideView(guide: guideData) { HapticsView() }
            case 7:
                LabGuideView(guide: guideData) { SheetsAndModalsView() }
            case 8:
                LabGuideView(guide: guideData) { TabViewPagingView() }
            case 9:
                LabGuideView(guide: guideData) { SFSymbolsView() }
            case 10:
                LabGuideView(guide: guideData) { AdaptiveLayoutView() }
            case 11:
                LabGuideView(guide: guideData) { MenuBarToolbarView() }
            case 12:
                LabGuideView(guide: guideData) { MultiWindowView() }
            default:
                Text("Unknown experiment")
            }
        } else {
            // Fallback without guide wrapper
            switch experiment.id {
            case 1: GesturePlaygroundView()
            case 2: NavigationPatternsView()
            case 3: SpringAnimationsView()
            case 4: MatchedGeometryView()
            case 5: ScrollEffectsView()
            case 6: HapticsView()
            case 7: SheetsAndModalsView()
            case 8: TabViewPagingView()
            case 9: SFSymbolsView()
            case 10: AdaptiveLayoutView()
            case 11: MenuBarToolbarView()
            case 12: MultiWindowView()
            default: Text("Unknown experiment")
            }
        }
    }
}

#Preview {
    LabDirectory()
}

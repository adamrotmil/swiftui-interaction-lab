# SwiftUI Interaction Lab

A collection of hands-on experiments exploring native iOS and macOS UI patterns in SwiftUI. Each experiment is a self-contained, interactive demonstration of a specific SwiftUI capability — designed for learning, experimentation, and portfolio reference.

**Targets:** iOS 17+ / macOS 14+ (Sonoma)

## Experiments

| # | Experiment | Description | Key APIs | Platform |
|---|-----------|-------------|----------|----------|
| 01 | Gesture Playground | Drag, pinch, and long-press gesture recognizers with spring snap-back | `DragGesture`, `MagnifyGesture`, `LongPressGesture` | Both |
| 02 | Navigation Patterns | NavigationStack, NavigationSplitView, and programmatic navigation paths | `NavigationStack`, `NavigationPath`, `NavigationSplitView` | Both |
| 03 | Spring Animations | Real-time spring parameter tuning with interactive controls | `.spring()`, `withAnimation`, `.animation()` | Both |
| 04 | Matched Geometry | Hero transitions between grid and detail using shared geometry | `matchedGeometryEffect`, `@Namespace` | Both |
| 05 | Scroll Effects | Parallax headers, scaling/rotating cards driven by scroll position | `.scrollTransition`, `GeometryReader`, `.visualEffect` | Both |
| 06 | Haptics & Feedback | Impact, notification, and selection haptic patterns | `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator` | iOS |
| 07 | Sheets & Modals | Sheet, full-screen cover, popover, and custom presentation detents | `.sheet`, `.fullScreenCover`, `.popover`, `.presentationDetents` | Both |
| 08 | TabView & Paging | Tab bars with badges, page-style carousels, programmatic switching | `TabView`, `.tabViewStyle(.page)`, `.badge()` | Both |
| 09 | SF Symbols Showcase | Rendering modes, symbol effects, and variable value symbols | `.symbolRenderingMode`, `.symbolEffect`, variable values | Both |
| 10 | Adaptive Layout | ViewThatFits, AnyLayout toggling, and size-class-driven layout | `ViewThatFits`, `AnyLayout`, `horizontalSizeClass` | Both |
| 11 | Menu Bar & Toolbar | Toolbar items, context menus, and keyboard shortcuts | `.toolbar`, `.contextMenu`, `.keyboardShortcut` | macOS |
| 12 | Multi-Window & Settings | Opening new windows, Settings scene, and multi-scene architecture | `OpenWindowAction`, `Settings`, `WindowGroup` | macOS |

## Getting Started

1. Clone the repository
2. Open `Package.swift` in Xcode (File → Open → select `Package.swift`)
3. Select your target device (iPhone, iPad, or Mac)
4. Build and run (⌘R)

The app launches as a hub with cards for each experiment. Tap any card to explore that interaction pattern.

## Adding a New Experiment

1. Create a new folder under `InteractionLab/Experiments/` following the naming convention: `XX-ExperimentName/`
2. Create your SwiftUI view file inside that folder (e.g., `MyExperimentView.swift`)
3. Register the experiment in `LabDirectory.swift`:
   - Add an `Experiment` entry to the `allExperiments` array
   - Add a case in the `experimentDestination(for:)` switch statement
4. Build and run — your experiment will appear in the hub

## Project Structure

```
InteractionLab/
├── App/                        # App entry point and main directory
├── Shared/                     # Reusable extensions and components
│   ├── Extensions/             # View modifiers (debug border, onFirstAppear)
│   └── Components/             # ExperimentCard and other shared UI
└── Experiments/                # One folder per experiment
    ├── 01-GesturePlayground/
    ├── 02-NavigationPatterns/
    └── ...
```

## Learning Resources

- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui) — Official step-by-step tutorials
- [Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui) — Paul Hudson's comprehensive SwiftUI guide
- [SwiftUI Lab](https://swiftui-lab.com) — Advanced SwiftUI techniques and deep dives
- [WWDC SwiftUI Sessions](https://developer.apple.com/videos/swiftui) — Apple's annual conference sessions
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines) — Apple's design principles and patterns

## Notes

This is a learning and portfolio project. Each experiment is designed to be self-contained and well-commented, making it easy to understand individual SwiftUI concepts in isolation. The experiments highlight patterns that are unique to native development and differ significantly from web-based UI approaches.

## License

MIT

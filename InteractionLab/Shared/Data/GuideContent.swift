import Foundation

// MARK: - Guide Content

/// All experiment guide data, ordered by the recommended learning progression.
/// Each guide maps to an experiment by ID and provides context for web developers
/// transitioning to SwiftUI.
let allGuides: [ExperimentGuide] = [

    // ---------------------------------------------------------------
    // 1. Spring Animations
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 3,
        title: "Spring Animations",
        icon: "waveform.path.ecg",
        concept: "SwiftUI animations are fundamentally different from CSS. Instead of specifying duration and easing, you describe physical properties like response and damping. Animations are also interruptible by default \u{2014} tap mid-animation and it smoothly redirects.",
        webComparison: WebComparison(
            web: "CSS transitions with duration, easing, keyframes",
            swiftUI: ".animation(.spring()) with response, dampingFraction \u{2014} physics-based and interruptible"
        ),
        codeSnippet: """
        @State private var isExpanded = false

        RoundedRectangle(cornerRadius: 12)
            .frame(height: isExpanded ? 300 : 100)

        Button("Toggle") {
            withAnimation(.spring(
                response: 0.6,
                dampingFraction: 0.7
            )) {
                isExpanded.toggle()
            }
        }
        """,
        codeExplanation: "withAnimation wraps state changes and .spring() defines the physics. Tap during animation and it redirects smoothly.",
        prerequisite: nil,
        nextUp: "Gesture Playground",
        learningOrder: 1
    ),

    // ---------------------------------------------------------------
    // 2. Gesture Playground
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 1,
        title: "Gesture Playground",
        icon: "hand.draw",
        concept: "Gestures in SwiftUI are declarative modifiers, not imperative event listeners. You describe what gesture you want and SwiftUI handles the touch tracking. Combine gestures with animations for fluid, responsive interactions.",
        webComparison: WebComparison(
            web: "addEventListener for mouse/touch, manual state tracking",
            swiftUI: "DragGesture(), .gesture() modifier \u{2014} declarative and composable"
        ),
        codeSnippet: """
        @State private var offset = CGSize.zero

        Circle()
            .frame(width: 100, height: 100)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
        """,
        codeExplanation: "DragGesture tracks touch movement declaratively. The .onEnded spring animation snaps the view back.",
        prerequisite: "Spring Animations",
        nextUp: "SF Symbols Showcase",
        learningOrder: 2
    ),

    // ---------------------------------------------------------------
    // 3. SF Symbols Showcase
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 9,
        title: "SF Symbols Showcase",
        icon: "star.square.on.square",
        concept: "Apple provides 5,000+ built-in vector symbols that scale with text, support multiple colors, and animate natively. No icon imports needed.",
        webComparison: WebComparison(
            web: "Import icon libraries (Font Awesome, Heroicons), manage SVG assets",
            swiftUI: "Image(systemName:) with .symbolEffect() \u{2014} built-in and animated"
        ),
        codeSnippet: """
        @State private var isAnimating = false

        Image(systemName: "star.fill")
            .font(.system(size: 40))
            .foregroundStyle(.yellow)
            .symbolEffect(.bounce, value: isAnimating)
            .onTapGesture {
                isAnimating.toggle()
            }
        """,
        codeExplanation: "symbolEffect adds physics-based animations to SF Symbols. No sprite sheets or animation libraries required.",
        prerequisite: nil,
        nextUp: "Navigation Patterns",
        learningOrder: 3
    ),
    // ---------------------------------------------------------------
    // 4. Navigation Patterns
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 2,
        title: "Navigation Patterns",
        icon: "arrow.triangle.branch",
        concept: "Navigation in SwiftUI is state-driven. Instead of URL routing, you push values onto a NavigationPath and the system manages the view stack.",
        webComparison: WebComparison(
            web: "React Router, URL-based routes, useNavigate()",
            swiftUI: "NavigationStack + NavigationPath \u{2014} type-safe, state-driven"
        ),
        codeSnippet: """
        @State private var path = NavigationPath()

        NavigationStack(path: $path) {
            List(items) { item in
                NavigationLink(value: item) {
                    Text(item.name)
                }
            }
            .navigationDestination(for: Item.self) { item in
                DetailView(item: item)
            }
        }
        """,
        codeExplanation: "NavigationStack manages the view stack. NavigationLink pushes typed values, and .navigationDestination handles routing.",
        prerequisite: nil,
        nextUp: "Sheets & Modals",
        learningOrder: 4
    ),

    // ---------------------------------------------------------------
    // 5. Sheets & Modals
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 7,
        title: "Sheets & Modals",
        icon: "rectangle.bottomhalf.inset.filled",
        concept: "iOS has rich presentation options: sheets that slide up with configurable heights, full-screen covers, and popovers. The half-sheet pattern (like Apple Maps) is unique to native.",
        webComparison: WebComparison(
            web: "CSS modals, z-index management, overlay divs",
            swiftUI: ".sheet(), .presentationDetents([.medium, .large]) \u{2014} system-managed layers"
        ),
        codeSnippet: """
        @State private var showSheet = false

        Button("Show Sheet") { showSheet = true }
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text("Sheet Content")
                    Button("Dismiss") { showSheet = false }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        """,
        codeExplanation: "presentationDetents controls the sheet heights. The system handles the drag gesture and snap points automatically.",
        prerequisite: "Navigation Patterns",
        nextUp: "TabView & Paging",
        learningOrder: 5
    ),

    // ---------------------------------------------------------------
    // 6. TabView & Paging
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 8,
        title: "TabView & Paging",
        icon: "rectangle.split.3x1",
        concept: "TabView provides app-level navigation structure. It integrates with the system for badge counts, state restoration, and swipe-to-page.",
        webComparison: WebComparison(
            web: "Tab components, manual state management",
            swiftUI: "TabView with .badge(), .tabViewStyle(.page) \u{2014} system-integrated"
        ),
        codeSnippet: """
        @State private var selectedTab = 0

        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .badge(5)
                .tag(0)

            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
                .tag(1)
        }
        """,
        codeExplanation: "TabView manages tab state and badges natively. Switch to .tabViewStyle(.page) for a swipeable carousel.",
        prerequisite: nil,
        nextUp: "Scroll Effects",
        learningOrder: 6
    ),
    // ---------------------------------------------------------------
    // 7. Scroll Effects
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 5,
        title: "Scroll Effects",
        icon: "scroll",
        concept: "ScrollView in SwiftUI can drive visual effects. Cards can scale, rotate, and fade as they scroll into view using declarative modifiers.",
        webComparison: WebComparison(
            web: "Intersection Observer, scroll event listeners, CSS scroll-snap",
            swiftUI: ".scrollTransition(), .visualEffect() \u{2014} declarative scroll-driven effects"
        ),
        codeSnippet: """
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { item in
                    CardView(item: item)
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                .opacity(phase.isIdentity ? 1 : 0.6)
                        }
                }
            }
        }
        """,
        codeExplanation: "scrollTransition provides the phase (appearing, identity, disappearing) so you can drive visual effects declaratively.",
        prerequisite: nil,
        nextUp: "Matched Geometry",
        learningOrder: 7
    ),

    // ---------------------------------------------------------------
    // 8. Matched Geometry
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 4,
        title: "Matched Geometry",
        icon: "rectangle.on.rectangle.angled",
        concept: "Hero transitions between views using shared geometry. Tag elements with the same ID and SwiftUI interpolates their frames automatically.",
        webComparison: WebComparison(
            web: "Framer Motion layoutId, FLIP technique, complex JS calculations",
            swiftUI: "matchedGeometryEffect + @Namespace \u{2014} one modifier, automatic interpolation"
        ),
        codeSnippet: """
        @Namespace private var heroNamespace
        @State private var isExpanded = false

        if isExpanded {
            DetailView()
                .matchedGeometryEffect(
                    id: "card", in: heroNamespace
                )
        } else {
            ThumbnailView()
                .matchedGeometryEffect(
                    id: "card", in: heroNamespace
                )
        }
        """,
        codeExplanation: "@Namespace creates a shared coordinate space. matchedGeometryEffect with the same ID animates frame changes automatically.",
        prerequisite: "Spring Animations",
        nextUp: "Haptics & Feedback",
        learningOrder: 8
    ),

    // ---------------------------------------------------------------
    // 9. Haptics & Feedback
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 6,
        title: "Haptics & Feedback",
        icon: "iphone.radiowaves.left.and.right",
        concept: "iOS provides a rich haptic engine with precise feedback patterns. Taps, impacts, and notifications all have distinct physical sensations.",
        webComparison: WebComparison(
            web: "navigator.vibrate() \u{2014} basic, limited, poorly supported",
            swiftUI: "UIImpactFeedbackGenerator, .sensoryFeedback() \u{2014} precise, expressive, expected by users"
        ),
        codeSnippet: """
        // UIKit approach
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()

        // SwiftUI declarative approach (iOS 17+)
        Button("Tap Me") { tapped.toggle() }
            .sensoryFeedback(
                .impact(flexibility: .soft, intensity: 0.8),
                trigger: tapped
            )
        """,
        codeExplanation: "UIImpactFeedbackGenerator gives imperative control. The newer .sensoryFeedback modifier is fully declarative.",
        prerequisite: nil,
        nextUp: "Adaptive Layout",
        learningOrder: 9
    ),
    // ---------------------------------------------------------------
    // 10. Adaptive Layout
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 10,
        title: "Adaptive Layout",
        icon: "rectangle.split.2x2",
        concept: "SwiftUI replaces media queries with compositional layout tools. ViewThatFits picks the best layout for available space. AnyLayout smoothly animates between layouts.",
        webComparison: WebComparison(
            web: "CSS media queries, container queries, flexbox/grid",
            swiftUI: "ViewThatFits, AnyLayout, horizontalSizeClass \u{2014} compositional, not conditional"
        ),
        codeSnippet: """
        @Environment(\\.horizontalSizeClass) var sizeClass

        let layout = sizeClass == .compact
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(spacing: 12))

        layout {
            ForEach(cards) { card in
                CardView(card: card)
            }
        }
        .animation(.spring, value: sizeClass)
        """,
        codeExplanation: "AnyLayout lets you swap between HStack and VStack with animation. ViewThatFits automatically picks the best layout.",
        prerequisite: "Spring Animations",
        nextUp: "Menu Bar & Toolbar",
        learningOrder: 10
    ),

    // ---------------------------------------------------------------
    // 11. Menu Bar & Toolbar (macOS)
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 11,
        title: "Menu Bar & Toolbar",
        icon: "menubar.rectangle",
        concept: "macOS apps use toolbars and menu bar commands. SwiftUI provides .toolbar and .commands modifiers to add keyboard shortcuts and menu items declaratively.",
        webComparison: WebComparison(
            web: "No equivalent \u{2014} web apps don\u{2019}t have system menu bars",
            swiftUI: ".toolbar, .commands, .keyboardShortcut \u{2014} native OS integration"
        ),
        codeSnippet: """
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addItem) {
                    Label("Add", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
        .commands {
            CommandMenu("Experiments") {
                Button("Run All") { runAll() }
                    .keyboardShortcut("r", modifiers: [.command, .shift])
            }
        }
        """,
        codeExplanation: ".toolbar adds toolbar buttons, .commands creates menu bar items, and .keyboardShortcut binds hotkeys \u{2014} all declaratively.",
        prerequisite: "Navigation Patterns",
        nextUp: "Multi-Window & Settings",
        learningOrder: 11
    ),

    // ---------------------------------------------------------------
    // 12. Multi-Window & Settings (macOS)
    // ---------------------------------------------------------------
    ExperimentGuide(
        id: 12,
        title: "Multi-Window & Settings",
        icon: "macwindow.on.rectangle",
        concept: "macOS apps can open multiple windows and have a dedicated Settings scene. SwiftUI makes this declarative with WindowGroup and Settings.",
        webComparison: WebComparison(
            web: "window.open(), browser manages windows",
            swiftUI: "WindowGroup, OpenWindowAction, Settings scene \u{2014} first-class multi-window"
        ),
        codeSnippet: """
        @main
        struct MyApp: App {
            var body: some Scene {
                WindowGroup { ContentView() }

                Window("Companion", id: "companion") {
                    CompanionView()
                }

                #if os(macOS)
                Settings { SettingsView() }
                #endif
            }
        }

        // Open from anywhere:
        @Environment(\\.openWindow) var openWindow
        Button("Open") { openWindow(id: "companion") }
        """,
        codeExplanation: "WindowGroup and Window define scenes. OpenWindowAction opens them programmatically. Settings is a dedicated macOS scene.",
        prerequisite: "Navigation Patterns",
        nextUp: nil,
        learningOrder: 12
    ),
]

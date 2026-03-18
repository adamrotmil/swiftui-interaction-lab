import SwiftUI

// MARK: - Lab Guide View

/// A reusable view that wraps any experiment with a three-tab interface:
/// - **Guide**: Design vocabulary, web-to-native comparison, and key code
/// - **Playground**: The raw experiment view at full size
/// - **Device Preview**: The experiment rendered inside iPhone, iPad, or Mac frames
struct LabGuideView<Content: View>: View {
    let guide: ExperimentGuide
    let experiment: Content
    @State private var selectedTab = 0
    @State private var selectedDevice: DeviceType = .iPhone

    init(guide: ExperimentGuide, @ViewBuilder experiment: () -> Content) {
        self.guide = guide
        self.experiment = experiment()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            guideTab
                .tabItem { Label("Guide", systemImage: "book.fill") }
                .tag(0)

            experiment
                .tabItem { Label("Playground", systemImage: "play.fill") }
                .tag(1)

            devicePreviewTab
                .tabItem { Label("Device Preview", systemImage: "iphone") }
                .tag(2)
        }
        .navigationTitle(guide.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Guide Tab

    private var guideTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Concept
                VStack(alignment: .leading, spacing: 8) {
                    Label("Concept", systemImage: "lightbulb.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)
                    Text(guide.concept)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // Web vs Native Comparison
                VStack(alignment: .leading, spacing: 12) {
                    Label("Web vs SwiftUI", systemImage: "arrow.left.arrow.right")
                        .font(.headline)
                        .foregroundStyle(.blue)

                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Web / CSS")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            Text(guide.webComparison.web)
                                .font(.callout)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(white: 0.95).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("SwiftUI")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            Text(guide.webComparison.swiftUI)
                                .font(.callout)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(white: 0.95).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                Divider()

                // Code Snippet
                VStack(alignment: .leading, spacing: 8) {
                    Label("Key Code", systemImage: "chevron.left.forwardslash.chevron.right")
                        .font(.headline)
                        .foregroundStyle(.purple)

                    Text(guide.codeSnippet)
                        .font(.system(.caption, design: .monospaced))
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(white: 0.12))
                        .foregroundStyle(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text(guide.codeExplanation)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // Try It prompt
                VStack(alignment: .leading, spacing: 8) {
                    Label("Try It", systemImage: "hand.tap.fill")
                        .font(.headline)
                        .foregroundStyle(.green)
                    Text("Switch to the **Playground** tab to interact with the live experiment, or use **Device Preview** to see how it looks on different Apple devices.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                // Learning Path
                if let next = guide.nextUp {
                    Divider()
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundStyle(.blue)
                        Text("Next up: **\(next)**")
                            .font(.callout)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Device Preview Tab

    private var devicePreviewTab: some View {
        VStack(spacing: 0) {
            // Device picker toolbar
            HStack {
                DeviceFramePicker(selectedDevice: $selectedDevice)
                Spacer()
                Text(deviceDimensionLabel)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Divider()

            // Device frame with experiment content
            DeviceFrameView(deviceType: selectedDevice) {
                experiment
            }
            .padding()
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedDevice)
        }
    }

    /// Shows the logical dimensions of the selected device
    private var deviceDimensionLabel: String {
        let size = selectedDevice.screenSize
        return "\(Int(size.width)) x \(Int(size.height)) pt"
    }
}


// MARK: - Preview

#Preview {
    NavigationStack {
        LabGuideView(
            guide: ExperimentGuide(
                id: 0,
                title: "Preview Guide",
                icon: "star",
                concept: "This is a preview of the LabGuideView with device frames.",
                webComparison: WebComparison(
                    web: "CSS transitions & transforms",
                    swiftUI: ".animation(), withAnimation {}"
                ),
                codeSnippet: "withAnimation(.spring) {\n    isExpanded.toggle()\n}",
                codeExplanation: "SwiftUI animates any state change wrapped in withAnimation.",
                prerequisite: nil,
                nextUp: "Gesture Playground",
                learningOrder: 0
            )
        ) {
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)
                Text("Sample Experiment")
                    .font(.title.bold())
                Text("This content appears inside the device frame")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.05))
        }
    }
}

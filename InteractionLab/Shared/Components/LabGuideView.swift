import SwiftUI

// MARK: - Lab Guide View

/// A reusable view that wraps any experiment with a "Guide" / "Playground"
/// tab interface. The guide tab provides context, web-to-native comparison,
/// and a key code snippet before the user dives into the interactive demo.
struct LabGuideView<Content: View>: View {
    let guide: ExperimentGuide
    let experiment: Content
    @State private var selectedTab = 0

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
                headerSection
                conceptSection
                webComparisonSection
                codeSection
                playgroundButton
                progressionSection
            }
            .padding()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Text("Lab \(guide.id)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.secondary.opacity(0.15))
                .clipShape(Capsule())
            Spacer()
            Image(systemName: guide.icon)
                .font(.title2)
                .foregroundStyle(.tint)
        }
    }

    // MARK: - Concept

    private var conceptSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("The Concept")
                .font(.headline)
            Text(guide.concept)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Web Comparison

    private var webComparisonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Coming from the Web", systemImage: "globe")
                .font(.headline)

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Web")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                    Text(guide.webComparison.web)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 4) {
                    Text("SwiftUI")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    Text(guide.webComparison.swiftUI)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Code Snippet

    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Key Code", systemImage: "chevron.left.forwardslash.chevron.right")
                .font(.headline)

            Text(guide.codeExplanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                Text(guide.codeSnippet)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
            }
            #if os(iOS)
            .background(Color(.systemGray6))
            #else
            .background(Color.gray.opacity(0.2))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    // MARK: - Playground Button

    private var playgroundButton: some View {
        Button {
            withAnimation { selectedTab = 1 }
        } label: {
            Label("Open Playground", systemImage: "play.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 8)
    }

    // MARK: - Progression Links

    @ViewBuilder
    private var progressionSection: some View {
        if guide.prerequisite != nil || guide.nextUp != nil {
            VStack(alignment: .leading, spacing: 8) {
                if let prereq = guide.prerequisite {
                    Label("Builds on: \(prereq)", systemImage: "arrow.turn.right.up")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let next = guide.nextUp {
                    Label("Next up: \(next)", systemImage: "arrow.right.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 4)
        }
    }
}

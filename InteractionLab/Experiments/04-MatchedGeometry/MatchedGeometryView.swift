import SwiftUI

/// Experiment 04: Matched Geometry Effect
///
/// Demonstrates hero-style transitions between a grid view and a detail view
/// using `matchedGeometryEffect`. This is SwiftUI's answer to the web's
/// View Transitions API, but it works at the framework level with no DOM diffing.
struct MatchedGeometryView: View {
    @Namespace private var heroNamespace
    @State private var selectedItem: GridItem?

    let items: [GridItem] = [
        GridItem(title: "Mountains", color: .blue, icon: "mountain.2.fill", subtitle: "Explore alpine terrain and rocky peaks"),
        GridItem(title: "Ocean", color: .cyan, icon: "water.waves", subtitle: "Deep sea adventures and coastal views"),
        GridItem(title: "Forest", color: .green, icon: "tree.fill", subtitle: "Dense woodland trails and wildlife"),
        GridItem(title: "Desert", color: .orange, icon: "sun.max.fill", subtitle: "Vast dunes under endless skies"),
        GridItem(title: "Arctic", color: .indigo, icon: "snowflake", subtitle: "Frozen landscapes and northern lights"),
        GridItem(title: "Volcano", color: .red, icon: "flame.fill", subtitle: "Molten earth and dramatic eruptions"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Matched Geometry")
                    .experimentHeader()
                Text("Tap a card to see it expand with a hero transition using matchedGeometryEffect and @Namespace.")
                    .experimentDescription()
            }
            .padding(.horizontal)

            ZStack {
                // Grid of cards
                gridView
                    .opacity(selectedItem == nil ? 1 : 0)

                // Expanded detail
                if let item = selectedItem {
                    detailView(for: item)
                        .transition(.asymmetric(
                            insertion: .opacity,
                            removal: .opacity.animation(.easeIn(duration: 0.15))
                        ))
                }
            }
            .animation(.spring(response: 0.45, dampingFraction: 0.82), value: selectedItem)
        }
        .navigationTitle("04 — Matched Geometry")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Grid View

    private var gridView: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)],
            spacing: 16
        ) {
            ForEach(items) { item in
                gridCard(for: item)
                    .onTapGesture {
                        selectedItem = item
                    }
            }
        }
        .padding()
    }

    private func gridCard(for item: GridItem) -> some View {
        VStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.system(size: 32))
                .matchedGeometryEffect(id: "\(item.id)-icon", in: heroNamespace)

            Text(item.title)
                .font(.headline)
                .matchedGeometryEffect(id: "\(item.id)-title", in: heroNamespace)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(item.color.gradient)
                .matchedGeometryEffect(id: "\(item.id)-bg", in: heroNamespace)
        )
    }

    // MARK: - Detail View

    private func detailView(for item: GridItem) -> some View {
        VStack(spacing: 0) {
            // Hero header
            VStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.system(size: 56))
                    .matchedGeometryEffect(id: "\(item.id)-icon", in: heroNamespace)

                Text(item.title)
                    .font(.largeTitle.bold())
                    .matchedGeometryEffect(id: "\(item.id)-title", in: heroNamespace)

                Text(item.subtitle)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(item.color.gradient)
                    .matchedGeometryEffect(id: "\(item.id)-bg", in: heroNamespace)
            )

            // Detail content
            VStack(alignment: .leading, spacing: 16) {
                Text("About this destination")
                    .font(.title3.bold())

                Text("This is the expanded detail view for \"\(item.title)\". The transition you just saw uses `matchedGeometryEffect` to smoothly interpolate the position, size, and shape of matched elements between two different view hierarchies.")
                    .foregroundStyle(.secondary)

                Text("Key Concept")
                    .font(.headline)
                    .padding(.top, 8)

                Text("Each element that participates in the transition is tagged with the same ID and namespace. SwiftUI computes the geometry difference and animates it. Unlike web FLIP animations, you don't manually measure bounding rects.")
                    .foregroundStyle(.secondary)
            }
            .padding(24)

            Button {
                selectedItem = nil
            } label: {
                Label("Close", systemImage: "xmark.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(item.color)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
}

// MARK: - Grid Item Model

fileprivate struct GridItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let color: Color
    let icon: String
    let subtitle: String
}

#Preview {
    NavigationStack {
        MatchedGeometryView()
    }
}

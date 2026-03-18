import SwiftUI

/// Experiment 10: Adaptive Layout
///
/// Demonstrates SwiftUI's responsive layout tools: ViewThatFits, AnyLayout,
/// and environment-driven size classes. Unlike CSS media queries that respond
/// to viewport width, SwiftUI layouts respond to the container they're in.
struct AdaptiveLayoutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Adaptive Layout")
                    .experimentHeader()
                Text("SwiftUI's layout system is container-relative, not viewport-relative like CSS media queries.")
                    .experimentDescription()

                viewThatFitsSection
                anyLayoutSection
                sizeClassSection
                responsiveGridSection
            }
            .padding()
        }
        .navigationTitle("10 — Adaptive Layout")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - ViewThatFits

    private var viewThatFitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("ViewThatFits", systemImage: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                .font(.headline)
            Text("SwiftUI tries each child view in order and picks the first one that fits the available space. Resize the window (macOS) or rotate (iOS) to see the effect.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ViewThatFitsDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - AnyLayout Toggle

    private var anyLayoutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("AnyLayout Toggle", systemImage: "rectangle.split.2x2")
                .font(.headline)
            Text("Toggle between HStack and VStack using AnyLayout. The transition is animated — children maintain their identity.")
                .font(.caption)
                .foregroundStyle(.secondary)

            AnyLayoutDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Size Class

    private var sizeClassSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Size Class Awareness", systemImage: "iphone.and.ipad")
                .font(.headline)
            Text("Read @Environment(\\.horizontalSizeClass) to adapt layout. Compact = phone portrait, Regular = iPad/Mac/landscape.")
                .font(.caption)
                .foregroundStyle(.secondary)

            SizeClassDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Responsive Grid

    private var responsiveGridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Responsive Card Grid", systemImage: "square.grid.3x3")
                .font(.headline)
            Text("LazyVGrid with adaptive columns automatically adjusts column count based on available width — like CSS Grid's auto-fill/minmax().")
                .font(.caption)
                .foregroundStyle(.secondary)

            ResponsiveGridDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - ViewThatFits Demo

private struct ViewThatFitsDemo: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            // First choice: full horizontal layout
            HStack(spacing: 16) {
                ForEach(sampleCards.indices, id: \.self) { index in
                    miniCard(sampleCards[index])
                }
            }

            // Second choice: 2x2 grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(sampleCards.indices, id: \.self) { index in
                    miniCard(sampleCards[index])
                }
            }

            // Last resort: vertical stack
            VStack(spacing: 8) {
                ForEach(sampleCards.indices, id: \.self) { index in
                    miniCard(sampleCards[index])
                }
            }
        }
    }

    private let sampleCards = [
        ("bolt.fill", "Fast", Color.yellow),
        ("shield.fill", "Secure", Color.green),
        ("star.fill", "Quality", Color.orange),
        ("heart.fill", "Loved", Color.red),
    ]

    private func miniCard(_ data: (String, String, Color)) -> some View {
        HStack(spacing: 8) {
            Image(systemName: data.0)
                .foregroundStyle(data.2)
            Text(data.1)
                .font(.caption.bold())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(data.2.opacity(0.1))
        .clipShape(Capsule())
    }
}

// MARK: - AnyLayout Demo

private struct AnyLayoutDemo: View {
    @State private var isHorizontal = true

    var body: some View {
        VStack(spacing: 12) {
            Toggle("Horizontal Layout", isOn: $isHorizontal)
                .font(.subheadline)

            let layout = isHorizontal ? AnyLayout(HStackLayout(spacing: 12)) : AnyLayout(VStackLayout(spacing: 12))

            layout {
                ForEach(0..<3) { index in
                    let colors: [Color] = [.blue, .green, .purple]
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colors[index].gradient)
                        .frame(height: 60)
                        .overlay(
                            Text("Item \(index + 1)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        )
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isHorizontal)
        }
    }
}

// MARK: - Size Class Demo

private struct SizeClassDemo: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var body: some View {
        VStack(spacing: 12) {
            #if os(iOS)
            let isCompact = horizontalSizeClass == .compact

            HStack(spacing: 16) {
                Image(systemName: isCompact ? "iphone" : "ipad.landscape")
                    .font(.title)
                    .foregroundStyle(isCompact ? .blue : .purple)

                VStack(alignment: .leading) {
                    Text("Current: \(isCompact ? "Compact" : "Regular")")
                        .font(.headline)
                    Text(isCompact ? "iPhone portrait or iPad slide-over" : "iPad full screen, Mac, or iPhone landscape")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isCompact ? Color.blue.opacity(0.1) : Color.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // Conditionally show different layouts
            if isCompact {
                VStack(spacing: 8) {
                    compactCard(title: "Stacked", subtitle: "Compact layout uses VStack")
                    compactCard(title: "Vertically", subtitle: "To fit narrow width")
                }
            } else {
                HStack(spacing: 8) {
                    compactCard(title: "Side by Side", subtitle: "Regular layout uses HStack")
                    compactCard(title: "Horizontal", subtitle: "For wider displays")
                }
            }
            #else
            HStack(spacing: 16) {
                Image(systemName: "macwindow")
                    .font(.title)
                    .foregroundStyle(.purple)
                VStack(alignment: .leading) {
                    Text("macOS — Always Regular")
                        .font(.headline)
                    Text("macOS doesn't have compact size class. Use GeometryReader or ViewThatFits for responsive layouts.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            #endif
        }
    }

    private func compactCard(title: String, subtitle: String) -> some View {
        VStack(spacing: 4) {
            Text(title).font(.subheadline.bold())
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.05), radius: 2)
    }
}

// MARK: - Responsive Grid Demo

private struct ResponsiveGridDemo: View {
    let items = (1...12).map { "Item \($0)" }

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 80, maximum: 120))],
            spacing: 12
        ) {
            ForEach(items, id: \.self) { item in
                let hue = Double(items.firstIndex(of: item) ?? 0) / 12.0
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hue: hue, saturation: 0.6, brightness: 0.85).gradient)
                        .frame(height: 60)
                    Text(item)
                        .font(.caption2.bold())
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AdaptiveLayoutView()
    }
}

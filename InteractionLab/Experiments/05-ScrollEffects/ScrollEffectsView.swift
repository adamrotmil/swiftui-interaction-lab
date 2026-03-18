import SwiftUI

/// Experiment 05: Scroll Effects
///
/// Demonstrates scroll-driven visual effects — parallax, scale, rotation, and
/// opacity changes based on scroll position. SwiftUI's `.scrollTransition` and
/// `.visualEffect` modifiers replace the web's Intersection Observer + scroll listeners.
struct ScrollEffectsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Parallax Header
                parallaxHeader

                VStack(spacing: 24) {
                    Text("Scroll Effects")
                        .experimentHeader()
                    Text("Scroll down to see cards animate in. Each card uses .scrollTransition to scale, rotate, and fade based on its position in the viewport.")
                        .experimentDescription()

                    // MARK: - Scroll Transition Cards
                    scrollTransitionCards

                    // MARK: - Horizontal Scroll with Effects
                    horizontalScrollSection
                }
                .padding()
            }
        }
        .navigationTitle("05 — Scroll Effects")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Parallax Header

    private var parallaxHeader: some View {
        GeometryReader { geometry in
            let minY = geometry.frame(in: .global).minY
            let height: CGFloat = 250

            ZStack {
                LinearGradient(
                    colors: [.purple, .blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 8) {
                    Image(systemName: "scroll.fill")
                        .font(.system(size: 48))
                    Text("Parallax Header")
                        .font(.title2.bold())
                    Text("Pull down to see the stretch effect")
                        .font(.caption)
                        .opacity(0.8)
                }
                .foregroundStyle(.white)
                // Subtle parallax: text moves slower than the scroll
                .offset(y: minY > 0 ? -minY * 0.3 : 0)
            }
            // Stretch effect on overscroll
            .frame(
                width: geometry.size.width,
                height: minY > 0 ? height + minY : height
            )
            .offset(y: minY > 0 ? -minY : 0)
            .clipped()
        }
        .frame(height: 250)
    }

    // MARK: - Scroll Transition Cards

    private var scrollTransitionCards: some View {
        VStack(spacing: 16) {
            Label("Scroll Transition Cards", systemImage: "rectangle.stack")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(0..<8) { index in
                let colors: [Color] = [.blue, .purple, .orange, .green, .pink, .cyan, .indigo, .red]
                let icons = ["star.fill", "heart.fill", "bolt.fill", "leaf.fill", "flame.fill", "drop.fill", "moon.fill", "sun.max.fill"]

                HStack(spacing: 16) {
                    Image(systemName: icons[index])
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(colors[index].gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Effect Card \(index + 1)")
                            .font(.headline)
                        Text("This card animates in as you scroll. Watch the scale and opacity change smoothly.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                .scrollTransition(.animated(.spring())) { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.3)
                        .scaleEffect(phase.isIdentity ? 1 : 0.85)
                        .offset(x: phase.isIdentity ? 0 : (index.isMultiple(of: 2) ? -30 : 30))
                }
            }
        }
    }

    // MARK: - Horizontal Scroll Section

    private var horizontalScrollSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Horizontal Scroll Effects", systemImage: "arrow.left.arrow.right")
                .font(.headline)
            Text("Cards rotate and scale as they approach the center of the viewport.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10) { index in
                        let hue = Double(index) / 10.0

                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hue: hue, saturation: 0.7, brightness: 0.9).gradient)
                            .frame(width: 150, height: 200)
                            .overlay(
                                VStack {
                                    Text("\(index + 1)")
                                        .font(.largeTitle.bold())
                                    Text("Card")
                                        .font(.caption)
                                }
                                .foregroundStyle(.white)
                            )
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .scaleEffect(1 - abs(phase.value) * 0.15)
                                    .rotation3DEffect(
                                        .degrees(phase.value * 15),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                    .opacity(1 - abs(phase.value) * 0.3)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 220)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        ScrollEffectsView()
    }
}

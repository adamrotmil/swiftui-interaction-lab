import SwiftUI

/// Experiment 03: Spring Animations
///
/// Demonstrates spring-based animations with real-time parameter tuning.
/// Spring animations are the heart of iOS feel — they're physically modeled
/// and feel fundamentally different from CSS ease-in-out curves.
struct SpringAnimationsView: View {
    // Spring parameters
    @State private var response: Double = 0.55
    @State private var dampingFraction: Double = 0.6
    @State private var blendDuration: Double = 0.0

    // Animation trigger
    @State private var isAnimating = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Spring Animations")
                    .experimentHeader()
                Text("Adjust spring parameters in real-time. Unlike CSS transitions, these are physics-based and interruptible.")
                    .experimentDescription()

                // MARK: - Interactive Spring Preview
                springPreview

                Divider()

                // MARK: - Parameter Controls
                parameterControls

                Divider()

                // MARK: - Comparison: withAnimation vs .animation
                comparisonSection

                Divider()

                // MARK: - Preset Gallery
                presetGallery
            }
            .padding()
        }
        .navigationTitle("03 — Springs")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Spring Preview

    private var springPreview: some View {
        VStack(spacing: 16) {
            Label("Live Spring Preview", systemImage: "waveform.path.ecg")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                // Track line
                Capsule()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 4)

                // Animated circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: .orange.opacity(0.4), radius: 8)
                    .offset(x: isAnimating ? 120 : -120)
            }
            .frame(height: 60)

            // Animated scale
            RoundedRectangle(cornerRadius: 12)
                .fill(.blue.gradient)
                .frame(
                    width: isAnimating ? 280 : 80,
                    height: 40
                )
                .overlay(
                    Text("Width")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                )

            // Animated rotation
            RoundedRectangle(cornerRadius: 8)
                .fill(.purple.gradient)
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isAnimating ? 180 : 0))
                .scaleEffect(isAnimating ? 1.3 : 0.7)

            Button {
                withAnimation(.spring(
                    response: response,
                    dampingFraction: dampingFraction,
                    blendDuration: blendDuration
                )) {
                    isAnimating.toggle()
                }
            } label: {
                Label("Animate", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Parameter Controls

    private var parameterControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Spring Parameters", systemImage: "slider.horizontal.3")
                .font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Response")
                    Spacer()
                    Text("\(response, specifier: "%.2f")s")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
                Slider(value: $response, in: 0.1...2.0, step: 0.05)
                    .tint(.orange)
                Text("How long it takes to settle. Lower = snappier.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Damping Fraction")
                    Spacer()
                    Text("\(dampingFraction, specifier: "%.2f")")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
                Slider(value: $dampingFraction, in: 0.0...1.5, step: 0.05)
                    .tint(.blue)
                Text("0 = infinite bounce, 1 = critical damping (no overshoot), >1 = overdamped.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Blend Duration")
                    Spacer()
                    Text("\(blendDuration, specifier: "%.2f")s")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
                Slider(value: $blendDuration, in: 0.0...1.0, step: 0.05)
                    .tint(.green)
                Text("Duration to blend with other running animations.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            // Current spring code
            Text("`.spring(response: \(response, specifier: "%.2f"), dampingFraction: \(dampingFraction, specifier: "%.2f"), blendDuration: \(blendDuration, specifier: "%.2f"))`")
                .font(.caption.monospaced())
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - withAnimation vs .animation

    private var comparisonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("withAnimation vs .animation Modifier", systemImage: "arrow.left.arrow.right")
                .font(.headline)

            Text("`.animation()` is implicit — it watches a value and animates any change. `withAnimation` is explicit — you wrap the state change yourself. Both are valid; explicit gives more control.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ComparisonRow()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Presets

    private var presetGallery: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Spring Presets", systemImage: "sparkles")
                .font(.headline)

            let presets: [(String, Double, Double)] = [
                ("Bouncy", 0.5, 0.3),
                ("Snappy", 0.3, 0.8),
                ("Gentle", 1.0, 0.7),
                ("Stiff", 0.15, 0.86),
                ("Wobbly", 0.8, 0.2),
                ("Overdamped", 0.5, 1.3),
            ]

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                ForEach(presets, id: \.0) { name, resp, damp in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            response = resp
                            dampingFraction = damp
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(name)
                                .font(.caption.bold())
                            Text("r:\(resp, specifier: "%.1f") d:\(damp, specifier: "%.1f")")
                                .font(.caption2.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Comparison Row

private struct ComparisonRow: View {
    @State private var toggled = false

    var body: some View {
        HStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("withAnimation")
                    .font(.caption.bold())
                Circle()
                    .fill(.orange)
                    .frame(width: 30, height: 30)
                    .offset(y: toggled ? -30 : 30)
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 8) {
                Text(".animation")
                    .font(.caption.bold())
                Circle()
                    .fill(.blue)
                    .frame(width: 30, height: 30)
                    .offset(y: toggled ? -30 : 30)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5), value: toggled)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 100)
        .onTapGesture {
            // Only the orange one uses withAnimation — the blue one
            // animates automatically via its .animation modifier.
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                toggled.toggle()
            }
        }

        Text("Tap to see both animate. They look the same here, but withAnimation lets you choose different animations for different state changes.")
            .font(.caption2)
            .foregroundStyle(.tertiary)
    }
}

#Preview {
    NavigationStack {
        SpringAnimationsView()
    }
}

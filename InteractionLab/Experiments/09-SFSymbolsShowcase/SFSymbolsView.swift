import SwiftUI

/// Experiment 09: SF Symbols Showcase
///
/// Demonstrates SF Symbols rendering modes and symbol effects.
/// SF Symbols is Apple's icon system — over 5,000 vector symbols that
/// automatically match the weight and size of surrounding text.
/// There's nothing equivalent on the web; Material Icons are the closest analog.
struct SFSymbolsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("SF Symbols Showcase")
                    .experimentHeader()
                Text("Explore rendering modes, symbol effects, and variable values. Over 5,000 symbols that adapt to font weight and size.")
                    .experimentDescription()

                renderingModesSection
                symbolEffectsSection
                variableValueSection
                popularSymbolsGrid
            }
            .padding()
        }
        .navigationTitle("09 — SF Symbols")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Rendering Modes

    private var renderingModesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Rendering Modes", systemImage: "paintpalette")
                .font(.headline)
            Text("The same symbol rendered in four different modes. Each mode changes how color layers are applied.")
                .font(.caption)
                .foregroundStyle(.secondary)

            let symbol = "cloud.sun.rain.fill"

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 16) {
                renderingCard("Monochrome", symbol: symbol) {
                    Image(systemName: symbol)
                        .symbolRenderingMode(.monochrome)
                        .foregroundStyle(.blue)
                }

                renderingCard("Hierarchical", symbol: symbol) {
                    Image(systemName: symbol)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                }

                renderingCard("Palette", symbol: symbol) {
                    Image(systemName: symbol)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.orange, .blue, .cyan)
                }

                renderingCard("Multicolor", symbol: symbol) {
                    Image(systemName: symbol)
                        .symbolRenderingMode(.multicolor)
                }
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func renderingCard(_ mode: String, symbol: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(spacing: 8) {
            content()
                .font(.system(size: 40))
                .frame(height: 50)
            Text(mode)
                .font(.caption.bold())
            Text(symbol)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Symbol Effects

    private var symbolEffectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Symbol Effects", systemImage: "sparkle")
                .font(.headline)
            Text("iOS 17+ adds built-in animations to SF Symbols. Tap each button to trigger the effect.")
                .font(.caption)
                .foregroundStyle(.secondary)

            SymbolEffectDemo(
                name: "Bounce",
                icon: "bell.fill",
                color: .orange,
                description: "A single bounce — great for notifications"
            )

            SymbolEffectDemo(
                name: "Pulse",
                icon: "heart.fill",
                color: .red,
                description: "Continuous pulsing — use for active/live states"
            )

            SymbolEffectDemo(
                name: "Variable Color",
                icon: "wifi",
                color: .blue,
                description: "Animates through color layers — perfect for signal strength"
            )

            SymbolEffectDemo(
                name: "Scale",
                icon: "star.fill",
                color: .yellow,
                description: "Scale up/down — good for favoriting actions"
            )

            SymbolEffectDemo(
                name: "Rotate",
                icon: "gear",
                color: .gray,
                description: "Rotation — ideal for loading/processing states"
            )
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Variable Value

    private var variableValueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Variable Value Symbols", systemImage: "slider.horizontal.3")
                .font(.headline)
            Text("Some SF Symbols accept a percentage value (0.0–1.0) to fill progressively. Drag the slider to see it in action.")
                .font(.caption)
                .foregroundStyle(.secondary)

            VariableValueDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Popular Symbols Grid

    private var popularSymbolsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Popular Symbols", systemImage: "square.grid.3x3")
                .font(.headline)

            let symbols: [(String, Color)] = [
                ("house.fill", .blue), ("magnifyingglass", .gray), ("person.fill", .green),
                ("gear", .gray), ("bell.fill", .orange), ("heart.fill", .red),
                ("star.fill", .yellow), ("cart.fill", .purple), ("bookmark.fill", .blue),
                ("paperplane.fill", .cyan), ("folder.fill", .brown), ("trash.fill", .red),
                ("camera.fill", .gray), ("photo.fill", .indigo), ("map.fill", .green),
                ("lock.fill", .gray), ("key.fill", .yellow), ("wifi", .blue),
                ("battery.100", .green), ("bolt.fill", .yellow), ("flame.fill", .orange),
                ("drop.fill", .cyan), ("leaf.fill", .green), ("globe", .blue),
            ]

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                ForEach(symbols, id: \.0) { name, color in
                    VStack(spacing: 4) {
                        Image(systemName: name)
                            .font(.title2)
                            .foregroundStyle(color)
                            .frame(width: 44, height: 44)
                        Text(name)
                            .font(.system(size: 7))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Symbol Effect Demo

private struct SymbolEffectDemo: View {
    let name: String
    let icon: String
    let color: Color
    let description: String

    @State private var bounceCount = 0
    @State private var isPulsing = false
    @State private var isActive = false

    var body: some View {
        HStack(spacing: 16) {
            Group {
                switch name {
                case "Bounce":
                    Image(systemName: icon)
                        .symbolEffect(.bounce, value: bounceCount)
                case "Pulse":
                    Image(systemName: icon)
                        .symbolEffect(.pulse, isActive: isPulsing)
                case "Variable Color":
                    Image(systemName: icon)
                        .symbolEffect(.variableColor.iterative, isActive: isActive)
                case "Scale":
                    Image(systemName: icon)
                        .symbolEffect(.scale.up, isActive: isActive)
                case "Rotate":
                    Image(systemName: icon)
                        .symbolEffect(.rotate, isActive: isActive)
                default:
                    Image(systemName: icon)
                }
            }
            .font(.title)
            .foregroundStyle(color)
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Play") {
                switch name {
                case "Bounce":
                    bounceCount += 1
                case "Pulse":
                    isPulsing.toggle()
                default:
                    isActive.toggle()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Variable Value Demo

private struct VariableValueDemo: View {
    @State private var value: Double = 0.5

    let symbols = ["speaker.wave.3.fill", "wifi", "chart.bar.fill"]

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                ForEach(symbols, id: \.self) { symbol in
                    VStack(spacing: 8) {
                        Image(systemName: symbol, variableValue: value)
                            .font(.system(size: 36))
                            .foregroundStyle(.blue)
                            .frame(height: 44)
                        Text(symbol)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack {
                Text("0%")
                    .font(.caption.monospaced())
                Slider(value: $value, in: 0...1)
                    .tint(.blue)
                Text("100%")
                    .font(.caption.monospaced())
            }

            Text("Value: \(value, specifier: "%.0f%%")")
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SFSymbolsView()
    }
}

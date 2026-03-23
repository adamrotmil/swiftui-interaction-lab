import SwiftUI

// MARK: - Chapter 3: SF Symbols — 5,000 Icons You Already Have

/// An interactive Treehouse-style lesson on SF Symbols.
struct Chapter03_SFSymbols: View {
    var body: some View {
        LessonView(
            lesson: allLessons[2],
            steps: [
                LessonStep("Welcome") { SymbolStep1_Welcome() },
                LessonStep("Your First Symbol") { SymbolStep2_FirstSymbol() },
                LessonStep("Rendering Modes") { SymbolStep3_RenderingModes() },
                LessonStep("Symbol Effects") { SymbolStep4_Effects() },
                LessonStep("Variable Values") { SymbolStep5_VariableValues() },
                LessonStep("Try This") { SymbolStep6_Challenge() },
            ]
        )
    }
}

// MARK: - Step 1: Welcome

private struct SymbolStep1_Welcome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("On the web, you'd import Font Awesome or Heroicons, manage SVG sprites, tree-shake unused icons, and worry about bundle size and render performance.")

            LessonText("Apple gives you 5,000+ production-ready symbols built right into the system. They scale with Dynamic Type, support multiple rendering modes, animate natively, and look pixel-perfect at every size.")

            LessonText("Best part? Zero bundle size impact. They're already on every Apple device.")
        }
    }
}

// MARK: - Step 2: Your First Symbol

private struct SymbolStep2_FirstSymbol: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Using a symbol is as simple as using an Image with a system name. The magic is that symbols scale with text — they're designed to sit alongside type at any size.")

            // Live size comparison
            VStack(spacing: 20) {
                symbolRow("caption", font: .caption)
                symbolRow("body", font: .body)
                symbolRow("title", font: .title)
                symbolRow("largeTitle", font: .largeTitle)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: "Image(systemName: \"star.fill\")\n    .font(.title)\n    .foregroundStyle(.yellow)",
                caption: "Symbols respond to .font() just like Text — they scale automatically."
            )

            LessonText("Notice how the star aligns perfectly with the text at every size. SF Symbols are designed to match Apple's San Francisco font metrics, so they always look right inline with text.")
        }
    }

    private func symbolRow(_ label: String, font: Font) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .font(font)
                .foregroundStyle(.yellow)

            Text(".\(label)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                Text("Inline text")
            }
            .font(font)

            Spacer()
        }
    }
}

// MARK: - Step 3: Rendering Modes

private struct SymbolStep3_RenderingModes: View {
    @State private var selectedMode = 0
    private let modes = ["Monochrome", "Hierarchical", "Palette", "Multicolor"]
    private let demoSymbols = [
        "cloud.sun.rain.fill",
        "chart.bar.doc.horizontal.fill",
        "person.crop.circle.badge.checkmark",
        "externaldrive.badge.wifi",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Every SF Symbol supports four rendering modes. Each mode changes how color is applied to the symbol's layers. Try switching between them:")

            // Mode picker
            Picker("Rendering Mode", selection: $selectedMode) {
                ForEach(0..<modes.count, id: \.self) { index in
                    Text(modes[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)

            // Symbol grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach(demoSymbols, id: \.self) { symbolName in
                    VStack(spacing: 8) {
                        symbolInMode(symbolName, mode: selectedMode)
                            .font(.system(size: 32))
                            .frame(height: 44)

                        Text(symbolName.components(separatedBy: ".").first ?? symbolName)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(white: 0.97))
                    )
                }
            }

            // Explanation for each mode
            modeExplanation(for: selectedMode)

            CodeBlockView(
                code: codeForMode(selectedMode),
                caption: "\(modes[selectedMode]) rendering"
            )
        }
    }

    @ViewBuilder
    private func symbolInMode(_ name: String, mode: Int) -> some View {
        switch mode {
        case 0:
            Image(systemName: name)
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.purple)
        case 1:
            Image(systemName: name)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.purple)
        case 2:
            Image(systemName: name)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.purple, .blue, .cyan)
        case 3:
            Image(systemName: name)
                .symbolRenderingMode(.multicolor)
        default:
            Image(systemName: name)
        }
    }

    @ViewBuilder
    private func modeExplanation(for mode: Int) -> some View {
        switch mode {
        case 0:
            LessonText("Monochrome: Every layer gets the same single color. Simple and clean.")
        case 1:
            LessonText("Hierarchical: One base color, but layers get automatic opacity variation to create depth.")
        case 2:
            LessonText("Palette: You assign specific colors to each layer. Up to three colors via foregroundStyle.")
        default:
            LessonText("Multicolor: The symbol uses its built-in default colors — designed by Apple to look natural.")
        }
    }

    private func codeForMode(_ mode: Int) -> String {
        switch mode {
        case 0:
            return "Image(systemName: \"cloud.sun.rain.fill\")\n    .symbolRenderingMode(.monochrome)\n    .foregroundStyle(.purple)"
        case 1:
            return "Image(systemName: \"cloud.sun.rain.fill\")\n    .symbolRenderingMode(.hierarchical)\n    .foregroundStyle(.purple)"
        case 2:
            return "Image(systemName: \"cloud.sun.rain.fill\")\n    .symbolRenderingMode(.palette)\n    .foregroundStyle(.purple, .blue, .cyan)"
        default:
            return "Image(systemName: \"cloud.sun.rain.fill\")\n    .symbolRenderingMode(.multicolor)"
        }
    }
}

// MARK: - Step 4: Symbol Effects

private struct SymbolStep4_Effects: View {
    @State private var bounceCount = 0
    @State private var isPulsing = false
    @State private var isActive = false
    @State private var wiggleCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("This is where it gets fun. SF Symbols can animate with built-in effects — no keyframes, no CoreAnimation, no hassle. Tap each icon to see its effect.")

            // Effects grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 16) {
                // Bounce
                effectCard("Bounce", color: .blue) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)
                        .symbolEffect(.bounce, value: bounceCount)
                }
                .onTapGesture { bounceCount += 1 }

                // Pulse
                effectCard("Pulse", color: .red) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.red)
                        .symbolEffect(.pulse, isActive: isPulsing)
                }
                .onTapGesture { isPulsing.toggle() }

                // Variable Color
                effectCard("Variable Color", color: .green) {
                    Image(systemName: "wifi")
                        .font(.system(size: 36))
                        .foregroundStyle(.green)
                        .symbolEffect(.variableColor.iterative, isActive: isActive)
                }
                .onTapGesture { isActive.toggle() }

                // Bounce (replaces .wiggle which requires macOS 15+)
                effectCard("Bounce", color: .orange) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.orange)
                        .symbolEffect(.bounce, value: wiggleCount)
                }
                .onTapGesture { wiggleCount += 1 }
            }

            CodeBlockView(
                code: "// Trigger once per value change\nImage(systemName: \"arrow.down.circle.fill\")\n    .symbolEffect(.bounce, value: tapCount)\n\n// Continuous while active\nImage(systemName: \"wifi\")\n    .symbolEffect(.variableColor.iterative, isActive: isScanning)",
                caption: "Use 'value:' for one-shot effects, 'isActive:' for continuous ones."
            )

            LessonText("The .symbolEffect modifier handles all the animation timing and interpolation. You just say what effect you want and when to trigger it.")
        }
    }

    private func effectCard<Content: View>(
        _ title: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 12) {
            content()
                .frame(height: 50)

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text("Tap me")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.97))
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Step 5: Variable Values

private struct SymbolStep5_VariableValues: View {
    @State private var value: Double = 0.5

    private let variableSymbols = [
        "speaker.wave.3.fill",
        "chart.bar.fill",
        "wifi",
        "cellularbars",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Some SF Symbols support variable values — a number from 0.0 to 1.0 that controls how \"full\" the symbol appears. Think volume levels, signal strength, or progress.")

            LessonText("Drag the slider to see the symbols respond:")

            // Variable value symbols
            HStack(spacing: 24) {
                ForEach(variableSymbols, id: \.self) { name in
                    VStack(spacing: 8) {
                        Image(systemName: name, variableValue: value)
                            .font(.system(size: 30))
                            .foregroundStyle(.purple)
                            .frame(height: 36)

                        Text(name.components(separatedBy: ".").first ?? name)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            // Slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("variableValue")
                        .font(.system(.callout, design: .monospaced))
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", value))
                        .font(.system(.callout, design: .monospaced))
                        .foregroundStyle(.purple)
                }

                Slider(value: $value, in: 0...1, step: 0.01)
                    .tint(.purple)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: "Image(systemName: \"speaker.wave.3.fill\", variableValue: volume)\n    .font(.title)\n    .foregroundStyle(.purple)",
                caption: "variableValue: 0.0 (empty) to 1.0 (full). Perfect for audio, signal, progress."
            )

            LessonText("Variable values are great for continuous state — volume controls, upload progress, signal strength indicators. The symbol animates smoothly between values.")
        }
    }
}

// MARK: - Step 6: Try This Challenge

private struct SymbolStep6_Challenge: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryThisCard(
                prompt: "Build a download button: start with \"arrow.down.circle\" that bounces when tapped, then transition to a \"checkmark.circle.fill\" using .contentTransition(.symbolEffect(.replace)). Hint: use a Bool state and a ternary for the symbol name."
            )

            LessonText("More ideas to explore:")

            VStack(alignment: .leading, spacing: 12) {
                challengeItem("Use .symbolRenderingMode(.palette) to create a custom-branded tab bar with two-tone icons.")
                challengeItem("Build a music player with variable-value speaker icons that respond to a volume slider.")
                challengeItem("Create a weather widget that uses multicolor symbols and switches between them with .contentTransition(.symbolEffect(.replace)).")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            LessonText("Open the SF Symbols app (free from Apple) to browse all 5,000+ symbols. You can search by keyword, filter by category, and preview every rendering mode.")
        }
    }

    private func challengeItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundStyle(.purple)
                .padding(.top, 3)
            LessonText(text)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Chapter03_SFSymbols()
    }
}

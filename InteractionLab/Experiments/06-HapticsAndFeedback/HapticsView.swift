import SwiftUI

/// Experiment 06: Haptics & Feedback
///
/// Demonstrates UIKit haptic feedback generators wrapped for SwiftUI.
/// Haptics are an iOS-exclusive feature with no web equivalent — they provide
/// tactile confirmation of user actions and are a key part of native iOS feel.
struct HapticsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Haptics & Feedback")
                    .experimentHeader()
                Text("Tap buttons to trigger different haptic patterns. Works on physical iOS devices only (no simulator haptics).")
                    .experimentDescription()

                #if os(iOS)
                impactSection
                notificationSection
                selectionSection
                customPatternSection
                #else
                macOSFallback
                #endif
            }
            .padding()
        }
        .navigationTitle("06 — Haptics")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - iOS Haptic Sections

    #if os(iOS)
    private var impactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Impact Feedback", systemImage: "hand.point.up.braille")
                .font(.headline)
            Text("Physical tap sensation at different intensities. Use for button presses, collisions, and UI element interactions.")
                .font(.caption)
                .foregroundStyle(.secondary)

            let impacts: [(String, UIImpactFeedbackGenerator.FeedbackStyle, Color)] = [
                ("Light", .light, .green),
                ("Medium", .medium, .orange),
                ("Heavy", .heavy, .red),
                ("Rigid", .rigid, .purple),
                ("Soft", .soft, .blue),
            ]

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                ForEach(impacts, id: \.0) { name, style, color in
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: style)
                        generator.prepare()
                        generator.impactOccurred()
                    } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(color.gradient)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "hand.tap.fill")
                                        .foregroundStyle(.white)
                                )
                            Text(name)
                                .font(.caption.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(color.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Notification Feedback", systemImage: "bell.badge")
                .font(.headline)
            Text("Semantic haptics for outcomes: success, warning, error. The system varies the pattern to convey meaning.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                notificationButton("Success", type: .success, icon: "checkmark.circle.fill", color: .green)
                notificationButton("Warning", type: .warning, icon: "exclamationmark.triangle.fill", color: .orange)
                notificationButton("Error", type: .error, icon: "xmark.circle.fill", color: .red)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func notificationButton(
        _ title: String,
        type: UINotificationFeedbackGenerator.FeedbackType,
        icon: String,
        color: Color
    ) -> some View {
        Button {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var selectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Selection Feedback", systemImage: "hand.point.up.left.and.text")
                .font(.headline)
            Text("A subtle tick for UI selection changes — like scrolling through a picker or toggling a switch.")
                .font(.caption)
                .foregroundStyle(.secondary)

            SelectionHapticPicker()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var customPatternSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Rapid-Fire Pattern", systemImage: "waveform")
                .font(.headline)
            Text("Tap to play a sequence of impacts with increasing intensity, creating a ramp-up effect.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                playRapidPattern()
            } label: {
                Label("Play Pattern", systemImage: "play.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func playRapidPattern() {
        let styles: [UIImpactFeedbackGenerator.FeedbackStyle] = [
            .light, .light, .medium, .medium, .heavy, .heavy, .rigid
        ]
        for (index, style) in styles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.impactOccurred()
            }
        }
    }
    #endif

    // MARK: - macOS Fallback

    #if os(macOS)
    private var macOSFallback: some View {
        ContentUnavailableView {
            Label("Haptics Not Available", systemImage: "iphone.slash")
        } description: {
            Text("Haptic feedback is an iOS-only feature using the Taptic Engine. macOS does not have equivalent haptic hardware, though the Force Touch trackpad can provide limited tactile feedback via NSHapticFeedbackManager.")
        }
    }
    #endif
}

// MARK: - Selection Haptic Picker

#if os(iOS)
private struct SelectionHapticPicker: View {
    @State private var selected = 0
    let options = ["Small", "Medium", "Large", "XL"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button {
                    let generator = UISelectionFeedbackGenerator()
                    generator.prepare()
                    generator.selectionChanged()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selected = index
                    }
                } label: {
                    Text(options[index])
                        .font(.subheadline.weight(selected == index ? .bold : .regular))
                        .foregroundStyle(selected == index ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selected == index
                                ? AnyShapeStyle(.blue)
                                : AnyShapeStyle(.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .background(.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
#endif

#Preview {
    NavigationStack {
        HapticsView()
    }
}

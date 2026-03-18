import SwiftUI

/// Experiment 01: Gesture Playground
///
/// Demonstrates native gesture recognizers that have no direct web equivalent.
/// On the web you'd use pointer events and manual math; SwiftUI gives you
/// composable, physics-aware gesture types out of the box.
struct GesturePlaygroundView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Gesture Playground")
                    .experimentHeader()
                Text("Explore DragGesture, MagnificationGesture, and LongPressGesture — native primitives with no direct web equivalent.")
                    .experimentDescription()

                DraggableCardDemo()
                PinchToZoomDemo()
                LongPressProgressDemo()
            }
            .padding()
        }
        .navigationTitle("01 — Gestures")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Draggable Card

/// A card that can be dragged freely and snaps back to center with a spring.
/// Note: On web, implementing this requires `pointermove`, `requestAnimationFrame`,
/// and manual spring physics. SwiftUI handles it declaratively.
private struct DraggableCardDemo: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Draggable Card", systemImage: "hand.draw")
                .font(.headline)
            Text("Drag the card and release — it springs back to center.")
                .font(.caption)
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 120)
                .overlay(
                    VStack {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .font(.title)
                        Text("Drag me!")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(.white)
                )
                .scaleEffect(isDragging ? 1.05 : 1.0)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                            withAnimation(.easeOut(duration: 0.1)) {
                                isDragging = true
                            }
                        }
                        .onEnded { _ in
                            // Spring back to origin
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                offset = .zero
                                isDragging = false
                            }
                        }
                )
                .frame(maxWidth: .infinity)
                .frame(height: 180)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Pinch to Zoom

/// Demonstrates MagnificationGesture for pinch-to-zoom.
/// On macOS, this responds to trackpad pinch gestures.
private struct PinchToZoomDemo: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Pinch to Zoom", systemImage: "arrow.up.left.and.arrow.down.right")
                .font(.headline)
            Text("Use pinch gesture (or trackpad) to zoom the image. Double-tap to reset.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Image(systemName: "photo.artframe")
                .font(.system(size: 80))
                .foregroundStyle(.indigo)
                .frame(width: 200, height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.indigo.opacity(0.1))
                )
                .scaleEffect(scale)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            scale = lastScale * value.magnification
                        }
                        .onEnded { value in
                            lastScale = scale
                            // Clamp to reasonable range
                            if scale < 0.5 {
                                withAnimation(.spring()) { scale = 0.5; lastScale = 0.5 }
                            } else if scale > 3.0 {
                                withAnimation(.spring()) { scale = 3.0; lastScale = 3.0 }
                            }
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scale = 1.0
                        lastScale = 1.0
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)

            Text("Scale: \(scale, specifier: "%.2f")×")
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Long Press Progress

/// A button that fills up as you hold it down.
/// Uses LongPressGesture composed with a timer for the fill animation.
private struct LongPressProgressDemo: View {
    @State private var isHolding = false
    @State private var isComplete = false
    @State private var progress: CGFloat = 0

    private let holdDuration: Double = 2.0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Long Press to Confirm", systemImage: "hand.tap")
                .font(.headline)
            Text("Press and hold the button to fill the progress bar. Release early to cancel.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                // Tap does nothing — you must hold
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 56)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(isComplete ? .green : .orange)
                        .frame(width: max(0, progress * 300), height: 56)
                        .animation(.linear(duration: 0.05), value: progress)

                    HStack {
                        Image(systemName: isComplete ? "checkmark.circle.fill" : "hand.tap.fill")
                        Text(isComplete ? "Confirmed!" : "Hold to Confirm")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(isComplete ? .white : .primary)
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 300, height: 56)
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: holdDuration)
                    .onChanged { _ in
                        guard !isComplete else { return }
                        isHolding = true
                        // Animate progress over holdDuration
                        withAnimation(.linear(duration: holdDuration)) {
                            progress = 1.0
                        }
                    }
                    .onEnded { _ in
                        isComplete = true
                        isHolding = false
                        // Reset after a moment
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                isComplete = false
                                progress = 0
                            }
                        }
                    }
            )
            .onChange(of: isHolding) { _, newValue in
                if !newValue && !isComplete {
                    // Released early — cancel
                    withAnimation(.easeOut(duration: 0.2)) {
                        progress = 0
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Color Compatibility

#if os(macOS)
extension Color {
    static let systemGray6 = Color(nsColor: .controlBackgroundColor)
}
#endif

#Preview {
    NavigationStack {
        GesturePlaygroundView()
    }
}

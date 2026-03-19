import SwiftUI

// MARK: - Chapter 2: Gestures — Touch as a First-Class Citizen

/// An interactive Treehouse-style lesson on SwiftUI gestures.
struct Chapter02_Gestures: View {
    var body: some View {
        LessonView(
            lesson: allLessons[1],
            steps: [
                LessonStep("Welcome") { GestureStep1_Welcome() },
                LessonStep("Drag It") { GestureStep2_DragIt() },
                LessonStep("Spring Snap-Back") { GestureStep3_SnapBack() },
                LessonStep("Long Press") { GestureStep4_LongPress() },
                LessonStep("Gesture Composition") { GestureStep5_Composition() },
                LessonStep("Try This") { GestureStep6_Challenge() },
            ]
        )
    }
}

// MARK: - Step 1: Welcome

private struct GestureStep1_Welcome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("On the web, handling touch means addEventListener, tracking clientX/clientY, calculating deltas, and managing cleanup. It's a lot of plumbing for something that should feel natural.")

            LessonText("In SwiftUI, gestures are declarative. You describe what kind of interaction you want — a drag, a long press, a rotation — and the system handles all the tracking, hit testing, and state management for you.")

            LessonText("Let's build up from the simplest gesture to composing multiple gestures together.")
        }
    }
}

// MARK: - Step 2: Drag It

private struct GestureStep2_DragIt: View {
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Drag the card below. It follows your finger (or cursor) in real time. When you let go, it snaps back to its original position.")

            // Live draggable card
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.gradient)
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: "hand.draw")
                                .font(.title2)
                            Text("Drag me")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white)
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 12)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                            }
                            .onEnded { _ in
                                offset = .zero
                            }
                    )
                Spacer()
            }
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            LessonText("Notice how there's no animation on release — it teleports back. We'll fix that in the next step.")

            CodeBlockView(
                code: ".gesture(\n    DragGesture()\n        .onChanged { value in\n            offset = value.translation\n        }\n        .onEnded { _ in\n            offset = .zero\n        }\n)",
                caption: "DragGesture gives you a translation (CGSize) on every frame."
            )

            LessonText("The .onChanged closure fires every frame while the finger is moving. value.translation gives you the total distance from the starting point — not the delta since last frame. That's an important difference from web touch events.")
        }
    }
}

// MARK: - Step 3: Spring Snap-Back

private struct GestureStep3_SnapBack: View {
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Remember springs from Chapter 1? Let's combine them. When you release the card, it springs back instead of teleporting.")

            // Draggable card with spring
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.gradient)
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.title2)
                            Text("Spring back")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white)
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 12)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    offset = .zero
                                }
                            }
                    )
                Spacer()
            }
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            LessonText("Feel the difference? The spring makes the release feel physical — like the card is attached to a rubber band.")

            LessonText("The only change is wrapping the onEnded reset in withAnimation:")

            CodeBlockView(
                code: ".onEnded { _ in\n    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {\n        offset = .zero\n    }\n}",
                caption: "One line turns a jarring snap into a satisfying bounce."
            )
        }
    }
}

// MARK: - Step 4: Long Press

private struct GestureStep4_LongPress: View {
    @State private var isPressed = false
    @State private var isComplete = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Long press gestures are perfect for destructive actions or confirmations. Hold the button below and watch it fill up.")

            // Long press button
            HStack {
                Spacer()
                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(white: 0.92))
                        .frame(width: 200, height: 56)

                    // Fill progress
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isComplete ? Color.green.gradient : Color.blue.gradient)
                        .frame(width: 200, height: 56)
                        .scaleEffect(x: isPressed || isComplete ? 1 : 0, anchor: .leading)
                        .animation(.easeInOut(duration: isPressed ? 1.0 : 0.3), value: isPressed)

                    // Label
                    HStack(spacing: 8) {
                        Image(systemName: isComplete ? "checkmark.circle.fill" : "hand.tap")
                        Text(isComplete ? "Done!" : "Hold to confirm")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(isPressed || isComplete ? .white : .primary)
                }
                .onLongPressGesture(minimumDuration: 1.0) {
                    isComplete = true
                    #if os(iOS)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    #endif
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            isComplete = false
                        }
                    }
                } onPressingChanged: { pressing in
                    isPressed = pressing
                }
                Spacer()
            }
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: ".onLongPressGesture(minimumDuration: 1.0) {\n    // Fires when the hold completes\n    isComplete = true\n} onPressingChanged: { pressing in\n    // Fires immediately on press/release\n    isPressed = pressing\n}",
                caption: "onPressingChanged gives you the pressing state in real time."
            )

            LessonText("The onPressingChanged callback fires immediately when the finger touches down (pressing = true) and when it lifts (pressing = false). The completion handler only fires if the user held long enough.")
        }
    }
}

// MARK: - Step 5: Gesture Composition

private struct GestureStep5_Composition: View {
    @State private var isUnlocked = false
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("SwiftUI lets you combine gestures. A long press that unlocks a drag? That's .sequenced(before:). The first gesture must succeed before the second one activates.")

            LessonText("Long-press the card below to unlock it, then drag it around.")

            // Sequenced gesture demo
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .fill(isUnlocked ? Color.green.gradient : Color.gray.gradient)
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                                .font(.title2)
                            Text(isUnlocked ? "Drag me!" : "Hold to unlock")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white)
                    )
                    .shadow(color: (isUnlocked ? Color.green : Color.gray).opacity(0.3), radius: 12)
                    .offset(offset)
                    .scaleEffect(isUnlocked ? 1.05 : 1.0)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .sequenced(before: DragGesture())
                            .onChanged { value in
                                switch value {
                                case .first(true):
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isUnlocked = true
                                    }
                                case .second(true, let drag):
                                    if let drag = drag {
                                        offset = drag.translation
                                    }
                                default:
                                    break
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    offset = .zero
                                    isUnlocked = false
                                }
                            }
                    )
                Spacer()
            }
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: "LongPressGesture(minimumDuration: 0.5)\n    .sequenced(before: DragGesture())\n    .onChanged { value in\n        switch value {\n        case .first(true):\n            isUnlocked = true\n        case .second(true, let drag):\n            offset = drag?.translation ?? .zero\n        default: break\n        }\n    }",
                caption: ".sequenced(before:) chains two gestures — first must complete before second activates."
            )

            LessonText("You can also use .simultaneously(with:) for gestures that should both be active at once (like pinch + rotate), or .exclusively(before:) when you want only one to win.")
        }
    }
}

// MARK: - Step 6: Try This Challenge

private struct GestureStep6_Challenge: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryThisCard(
                prompt: "Make the drag card snap to the nearest edge instead of springing back to center. Hint: check if translation.width is positive or negative in .onEnded, then animate to an offset that puts the card on that side."
            )

            LessonText("Bonus challenges:")

            VStack(alignment: .leading, spacing: 12) {
                challengeItem("Add velocity to the snap — use value.predictedEndTranslation to account for how fast the user was swiping.")
                challengeItem("Build a Tinder-style card that rotates as you drag, then flies off screen when released past a threshold.")
                challengeItem("Create a simultaneously combined pinch + drag gesture that lets you scale and move an image.")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )
        }
    }

    private func challengeItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundStyle(.blue)
                .padding(.top, 3)
            LessonText(text)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Chapter02_Gestures()
    }
}

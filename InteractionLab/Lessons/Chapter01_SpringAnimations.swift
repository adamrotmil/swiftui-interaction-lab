import SwiftUI

// MARK: - Chapter 1: Springs — How SwiftUI Thinks About Motion

/// An interactive Treehouse-style lesson on spring animations.
struct Chapter01_SpringAnimations: View {
    var body: some View {
        LessonView(
            lesson: allLessons[0],
            steps: [
                LessonStep("Welcome") { Step1_Welcome() },
                LessonStep("Your First Spring") { Step2_FirstSpring() },
                LessonStep("The Two Magic Numbers") { Step3_MagicNumbers() },
                LessonStep("Interruptible by Default") { Step4_Interruptible() },
                LessonStep("withAnimation vs .animation") { Step5_Comparison() },
                LessonStep("Try This") { Step6_Challenge() },
            ]
        )
    }
}

// MARK: - Step 1: Welcome

private struct Step1_Welcome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("If you're coming from CSS, you're used to thinking about animations in terms of duration and easing curves — ease-in, ease-out, cubic-bezier.")

            LessonText("SwiftUI flips this on its head. Instead of telling the system how long an animation should take, you describe how it should feel — bouncy, stiff, smooth.")

            LessonText("This is a fundamentally different mental model. And once it clicks, you'll never want to go back to specifying durations manually.")

            LessonText("Let's see how.")
        }
    }
}

// MARK: - Step 2: Your First Spring

private struct Step2_FirstSpring: View {
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Tap the circle below. Watch how it moves — there's a slight overshoot, then it settles. That's a spring.")

            // Live interactive demo
            HStack {
                Spacer()
                Circle()
                    .fill(Color.orange.gradient)
                    .frame(width: isExpanded ? 120 : 60, height: isExpanded ? 120 : 60)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            isExpanded.toggle()
                        }
                    }
                    .shadow(color: .orange.opacity(0.3), radius: isExpanded ? 20 : 8)
                Spacer()
            }
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            LessonText("Here's the code that makes it happen:")

            CodeBlockView(
                code: "withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {\n    isExpanded.toggle()\n}",
                caption: "The spring parameters control feel, not duration."
            )

            LessonText("No duration. No easing curve. Just two numbers that describe the physical behavior of the animation. SwiftUI figures out the rest.")
        }
    }
}

// MARK: - Step 3: The Two Magic Numbers

private struct Step3_MagicNumbers: View {
    @State private var response: Double = 0.5
    @State private var damping: Double = 0.6
    @State private var animate = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Every spring in SwiftUI is defined by two parameters. Play with the sliders to build intuition for what they do.")

            // Live animated rectangle
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange.gradient)
                    .frame(width: 80, height: 80)
                    .offset(x: animate ? 80 : -80)
                    .shadow(color: .orange.opacity(0.3), radius: 12)
                Spacer()
            }
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )
            .onTapGesture {
                withAnimation(.spring(response: response, dampingFraction: damping)) {
                    animate.toggle()
                }
            }

            Text("Tap the card above to trigger the animation")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)

            // Response slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("response")
                        .font(.system(.callout, design: .monospaced))
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", response))
                        .font(.system(.callout, design: .monospaced))
                        .foregroundStyle(.orange)
                }

                Slider(value: $response, in: 0.1...2.0, step: 0.05)
                    .tint(.orange)

                LessonText("How fast the animation plays out. Lower = snappier. Higher = more languid.")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            // Damping slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("dampingFraction")
                        .font(.system(.callout, design: .monospaced))
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", damping))
                        .font(.system(.callout, design: .monospaced))
                        .foregroundStyle(.orange)
                }

                Slider(value: $damping, in: 0.0...1.0, step: 0.05)
                    .tint(.orange)

                LessonText("How bouncy it is. 0 = infinite bounce (try it!). 1 = no bounce at all. 0.6–0.8 is the sweet spot for most UI.")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: ".spring(response: \(String(format: "%.2f", response)), dampingFraction: \(String(format: "%.2f", damping)))",
                caption: "Your current spring configuration"
            )
        }
    }
        }

// MARK: - Step 4: Interruptible by Default

private struct Step4_Interruptible: View {
    @State private var onRight = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Here's the magic part. Tap the circle while it's still moving. In CSS, you'd need to track the current computed position, cancel the running transition, and restart from where it is. That's painful.")

            LessonText("In SwiftUI, it just works — the animation smoothly redirects mid-flight. Tap rapidly to see it.")

            // Interactive bouncing circle
            HStack {
                Spacer()
                Circle()
                    .fill(Color.orange.gradient)
                    .frame(width: 60, height: 60)
                    .offset(x: onRight ? 80 : -80)
                    .shadow(color: .orange.opacity(0.3), radius: 10)
                Spacer()
            }
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.5)) {
                    onRight.toggle()
                }
            }

            Text("Tap rapidly while it's moving!")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)

            LessonText("SwiftUI springs are interruptible by default. The system knows the current velocity and position of every animating value and can seamlessly transition to a new target. This is one of the biggest advantages of the spring model over duration-based animation.")
        }
    }
}

// MARK: - Step 5: withAnimation vs .animation

private struct Step5_Comparison: View {
    @State private var expanded1 = false
    @State private var expanded2 = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("SwiftUI gives you two ways to apply animations. They look similar but work very differently.")

            // withAnimation example
            VStack(alignment: .leading, spacing: 8) {
                Text("withAnimation")
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)

                LessonText("You control exactly when the animation fires. Wrap a state change in withAnimation and every view that depends on that state animates.")

                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.gradient)
                        .frame(width: expanded1 ? 200 : 80, height: 50)
                    Spacer()
                }
                .frame(height: 70)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        expanded1.toggle()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: "// Explicit — you decide when to animate\nwithAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {\n    expanded.toggle()\n}",
                caption: "withAnimation: fires only when you call it"
            )

            // .animation example
            VStack(alignment: .leading, spacing: 8) {
                Text(".animation(_:value:)")
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)

                LessonText("The view animates automatically whenever the tracked value changes. Less control, but more declarative.")

                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.gradient)
                        .frame(width: expanded2 ? 200 : 80, height: 50)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: expanded2)
                    Spacer()
                }
                .frame(height: 70)
                .contentShape(Rectangle())
                .onTapGesture {
                    expanded2.toggle()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )

            CodeBlockView(
                code: "// Declarative — animates whenever value changes\nRoundedRectangle(cornerRadius: 12)\n    .frame(width: expanded ? 200 : 80)\n    .animation(.spring(), value: expanded)",
                caption: ".animation: fires automatically on value change"
            )

            LessonText("Rule of thumb: use withAnimation when you want precise control (tap handlers, async completions). Use .animation(_:value:) when a view should always animate in response to a specific value changing.")
        }
    }
}

// MARK: - Step 6: Try This Challenge

private struct Step6_Challenge: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryThisCard(
                prompt: "Set dampingFraction to 0 and watch what happens — the animation will bounce forever. Then try response: 0.1 with damping: 0.3 for a snappy micro-interaction. What combination feels like a satisfying button press to you?"
            )

            LessonText("Some combinations to try:")

            VStack(alignment: .leading, spacing: 8) {
                springPreset("Bouncy button", response: 0.3, damping: 0.5)
                springPreset("Gentle float", response: 1.0, damping: 0.7)
                springPreset("Snappy toggle", response: 0.15, damping: 0.65)
                springPreset("Jello", response: 0.5, damping: 0.2)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )
        }
    }

    private func springPreset(_ name: String, response: Double, damping: Double) -> some View {
        HStack {
            Text(name)
                .font(.callout)
                .fontWeight(.medium)
            Spacer()
            Text("response: \(String(format: "%.2f", response)), damping: \(String(format: "%.2f", damping))")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Chapter01_SpringAnimations()
    }
}

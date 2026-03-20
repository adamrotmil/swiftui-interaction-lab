import SwiftUI

// MARK: - Chapter 5: Sheets & Modals — Layers on Top of Your World

/// An interactive Treehouse-style lesson on presenting content modally.
struct Chapter05_SheetsModals: View {
    var body: some View {
        LessonView(
            lesson: allLessons[4],
            steps: [
                LessonStep("Welcome") { Step1_SheetWelcome() },
                LessonStep("Basic Sheets") { Step2_BasicSheet() },
                LessonStep("Detents") { Step3_Detents() },
                LessonStep("Full-Screen Cover") { Step4_FullScreenCover() },
                LessonStep("Popovers") { Step5_Popovers() },
                LessonStep("Try This") { Step6_SheetChallenge() },
            ]
        )
    }
}

// MARK: - Step 1: Welcome

private struct Step1_SheetWelcome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Modal presentations are how your app says \"Hey, pay attention to this for a moment.\" In SwiftUI, you get several flavors: sheets that slide up from the bottom, full-screen covers that take over entirely, and popovers that float near their source.")

            LessonText("The key idea: all of these are driven by state. A boolean or an optional flips to true, the modal appears. It flips back, the modal vanishes. SwiftUI handles the animation, the backdrop dimming, and the dismiss gesture automatically.")

            LessonText("Let's build each one and see how they feel.")
        }
    }
}

// MARK: - Step 2: Basic Sheets

private struct Step2_BasicSheet: View {
    @State private var showSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("The simplest modal in SwiftUI is .sheet(). Attach it to any view, bind it to a boolean, and provide the content. The user can swipe down to dismiss by default.")

            Button {
                showSheet = true
            } label: {
                Label("Show a Sheet", systemImage: "rectangle.bottomhalf.inset.filled")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showSheet) {
                SheetContent(title: "Hello from a Sheet!", message: "Swipe down to dismiss, or tap the button below.")
            }

            CodeBlockView(
                code: """
                @State private var showSheet = false

                Button("Show Sheet") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    MySheetContent()
                }
                """,
                caption: "The basic sheet pattern — state in, content out"
            )

            LessonText("Notice you never call dismiss() to show or hide it. The presentation is a function of state, just like everything else in SwiftUI.")
        }
    }
}

// MARK: - Step 3: Detents

private struct Step3_Detents: View {
    @State private var showDetentSheet = false
    @State private var selectedDetent: PresentationDetent = .medium

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Since iOS 16, sheets can stop at different heights called \"detents.\" This is how Apple Maps shows that half-height card — and you can do the same thing in one line.")

            Button {
                showDetentSheet = true
            } label: {
                Label("Half-Height Sheet", systemImage: "rectangle.bottomhalf.filled")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .sheet(isPresented: $showDetentSheet) {
                VStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(white: 0.8))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)

                    Text("Drag me up or down")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("This sheet has two detents: medium and large. The user can drag between them freely.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()
                }
                .presentationDetents([.medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
            }

            CodeBlockView(
                code: """
                .sheet(isPresented: $show) {
                    MyContent()
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
                """,
                caption: "Detents control how tall the sheet can be"
            )

            LessonText("You can also define custom detents with .fraction() or .height() for precise control over the sheet's resting positions.")
        }
    }
}

// MARK: - Step 4: Full-Screen Cover

private struct Step4_FullScreenCover: View {
    @State private var showCover = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Sometimes you need a modal that takes over the whole screen and blocks the swipe-to-dismiss gesture. That's .fullScreenCover(). It's perfect for onboarding flows, login screens, or anything the user must explicitly dismiss.")

            Button {
                showCover = true
            } label: {
                Label("Full-Screen Cover", systemImage: "rectangle.inset.filled")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .fullScreenCover(isPresented: $showCover) {
                FullScreenContent(dismiss: { showCover = false })
            }

            CodeBlockView(
                code: """
                .fullScreenCover(isPresented: $showCover) {
                    OnboardingFlow()
                }
                """,
                caption: "No swipe-to-dismiss — you control the exit"
            )

            LessonText("The API is nearly identical to .sheet(). The only difference is the presentation style and the fact that the user can't swipe away. You must provide your own dismiss mechanism.")
        }
    }
}

// MARK: - Step 5: Popovers

private struct Step5_Popovers: View {
    @State private var showPopover = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Popovers float next to their anchor view and are great for contextual info or quick actions. On iPad and Mac they appear as floating bubbles with an arrow; on iPhone they fall back to a sheet automatically.")

            Button {
                showPopover = true
            } label: {
                Label("Show Popover", systemImage: "text.bubble")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)
            .popover(isPresented: $showPopover, arrowEdge: .top) {
                VStack(spacing: 12) {
                    Text("I'm a Popover")
                        .font(.headline)
                    Text("On iPad I float with an arrow. On iPhone I become a sheet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(minWidth: 200)
            }

            CodeBlockView(
                code: """
                .popover(isPresented: $show, arrowEdge: .top) {
                    PopoverContent()
                }
                """,
                caption: "Same state-driven pattern, different presentation"
            )

            LessonText("The beautiful thing about SwiftUI modals: they all follow the same pattern. Boolean state drives presentation. The framework picks the right animation and chrome for the platform.")
        }
    }
}

// MARK: - Step 6: Challenge

private struct Step6_SheetChallenge: View {
    @State private var showChallenge = false
    @State private var rating: Int = 0
    @State private var submitted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Time to put it together! Build a feedback form that appears as a half-height sheet with a star rating and a submit button. Here's a working version to play with:")

            Button {
                showChallenge = true
                submitted = false
                rating = 0
            } label: {
                Label("Rate This Lesson", systemImage: "star.bubble")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)
            .sheet(isPresented: $showChallenge) {
                VStack(spacing: 20) {
                    Text(submitted ? "Thanks!" : "How was this chapter?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 24)

                    if submitted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.green)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title)
                                    .foregroundStyle(star <= rating ? .yellow : Color(white: 0.8))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            rating = star
                                        }
                                    }
                            }
                        }

                        Button("Submit") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                submitted = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showChallenge = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(rating == 0)
                    }

                    Spacer()
                }
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(submitted)
            }

            CodeBlockView(
                code: """
                .sheet(isPresented: $showFeedback) {
                    FeedbackForm()
                        .presentationDetents([.fraction(0.35)])
                        .interactiveDismissDisabled(isSubmitting)
                }
                """,
                caption: "Combine detents with interactiveDismissDisabled"
            )

            LessonText("Challenge: Try adding .presentationBackground(.thinMaterial) to make the sheet translucent, or add .presentationCornerRadius(24) to customize the shape.")
        }
    }
}

// MARK: - Helper Views

private struct SheetContent: View {
    let title: String
    let message: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 32)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Dismiss") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
    }
}

private struct FullScreenContent: View {
    let dismiss: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.orange.opacity(0.3), .pink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "rectangle.inset.filled")
                    .font(.system(size: 48))
                    .foregroundStyle(.orange)

                Text("Full-Screen Cover")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("This takes over the entire screen. The user cannot swipe to dismiss — you must provide an explicit way out.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark.circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    Chapter05_SheetsModals()
}

import SwiftUI

// MARK: - Lesson Step Model

/// A single step in a lesson — one concept, one card.
struct LessonStep: Identifiable {
    let id = UUID()
    let title: String
    let content: AnyView

    init<Content: View>(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = AnyView(content())
    }
}

// MARK: - Lesson Model

/// Metadata for a lesson chapter.
struct Lesson: Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: Color

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Lesson Registry

let allLessons: [Lesson] = [
    Lesson(
        id: 1,
        title: "Springs",
        subtitle: "How SwiftUI Thinks About Motion",
        icon: "waveform.path.ecg",
        accentColor: .orange
    ),
    Lesson(
        id: 2,
        title: "Gestures",
        subtitle: "Touch as a First-Class Citizen",
        icon: "hand.draw",
        accentColor: .blue
    ),
    Lesson(
        id: 3,
        title: "SF Symbols",
        subtitle: "5,000 Icons You Already Have",
        icon: "star.square.on.square",
        accentColor: .purple
    ),
]

// MARK: - Lesson View Container

/// A Treehouse-style lesson container with progress tracking,
/// spacious layout, and step-by-step pacing.
struct LessonView: View {
    let lesson: Lesson
    let steps: [LessonStep]

    @State private var currentStep: Int = 0
    @Environment(\.dismiss) private var dismiss

    private var progress: Double {
        guard steps.count > 1 else { return 1.0 }
        return Double(currentStep) / Double(steps.count - 1)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    lessonHeader
                    progressBar
                    stepContent(proxy: proxy)
                }
                .padding(.bottom, 80)
            }
        }
        .background(Color(white: 0.97))
        .navigationTitle(lesson.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Header

    private var lessonHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: lesson.icon)
                    .font(.title)
                    .foregroundStyle(lesson.accentColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Chapter \(lesson.id)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(lesson.accentColor)

                    Text(lesson.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }

            Text(lesson.subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Step \(currentStep + 1) of \(steps.count)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(white: 0.88))
                        .frame(height: 6)

                    Capsule()
                        .fill(lesson.accentColor)
                        .frame(width: max(6, geo.size.width * progress), height: 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // MARK: - Step Content

    private func stepContent(proxy: ScrollViewProxy) -> some View {
        LazyVStack(alignment: .leading, spacing: 24) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                LessonStepCard(
                    step: step,
                    stepNumber: index + 1,
                    isActive: index <= currentStep,
                    accentColor: lesson.accentColor
                )
                .id(index)
                .onAppear {
                    if index > currentStep {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = index
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Lesson Step Card

/// A single card within the lesson flow.
struct LessonStepCard: View {
    let step: LessonStep
    let stepNumber: Int
    let isActive: Bool
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Step badge + title
            HStack(spacing: 10) {
                Text("\(stepNumber)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(accentColor)
                    .clipShape(Circle())

                Text(step.title)
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            // Step content
            step.content
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
        .opacity(isActive ? 1 : 0.5)
    }
}

// MARK: - Lesson Card (for the Hub)

/// Card shown in the LabDirectory hub linking to a lesson chapter.
struct LessonCard: View {
    let lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: lesson.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(lesson.accentColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Chapter \(lesson.id)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(lesson.accentColor)

                    Text(lesson.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Text(lesson.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(lesson.accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Helpers

/// Conversational body text style used in lessons.
struct LessonText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.body)
            .lineSpacing(6)
            .foregroundStyle(.primary.opacity(0.85))
            .fixedSize(horizontal: false, vertical: true)
    }
}

/// A "Try This" challenge card at the end of a lesson.
struct TryThisCard: View {
    let prompt: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Try This")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            Text(prompt)
                .font(.body)
                .lineSpacing(6)
                .foregroundStyle(.primary.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.yellow.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.yellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        LessonView(
            lesson: allLessons[0],
            steps: [
                LessonStep("Welcome") {
                    LessonText("This is a preview of the lesson system.")
                },
                LessonStep("Step Two") {
                    LessonText("Each step appears as its own card.")
                },
            ]
        )
    }
}

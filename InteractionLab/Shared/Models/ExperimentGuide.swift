import SwiftUI

// MARK: - Experiment Guide Model

/// Data model for the guided learning content that wraps each experiment.
/// Each guide provides context, web-to-native comparison, and a key code snippet
/// to build SwiftUI fluency before diving into the interactive demo.
struct ExperimentGuide: Identifiable {
    let id: Int
    let title: String
    let icon: String
    let concept: String
    let webComparison: WebComparison
    let codeSnippet: String
    let codeExplanation: String
    let prerequisite: String?
    let nextUp: String?
    let learningOrder: Int
}

/// A brief comparison between web and SwiftUI approaches.
struct WebComparison {
    let web: String
    let swiftUI: String
}

// MARK: - Learning Progression

/// Returns experiments sorted by the recommended learning progression.
func guidesInLearningOrder() -> [ExperimentGuide] {
    allGuides.sorted { $0.learningOrder < $1.learningOrder }
}

/// Maps an experiment ID to its guide content.
func guide(forExperimentID id: Int) -> ExperimentGuide? {
    allGuides.first { $0.id == id }
}

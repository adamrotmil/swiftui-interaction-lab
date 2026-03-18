import SwiftUI

/// A reusable card component displayed in the Lab Directory.
/// Shows the experiment icon, number, title, description, and platform tag.
struct ExperimentCard: View {
    let experiment: Experiment

    var body: some View {
        HStack(spacing: 16) {
            // Icon circle
            Image(systemName: experiment.icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(
                    LinearGradient(
                        colors: [experiment.platform.color, experiment.platform.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // Text content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(String(format: "%02d", experiment.id))
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)

                    Text(experiment.name)
                        .font(.headline)
                        .lineLimit(1)
                }

                Text(experiment.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                // Platform tag
                Text(experiment.platform.rawValue)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(experiment.platform.color.opacity(0.15))
                    .foregroundStyle(experiment.platform.color)
                    .clipShape(Capsule())
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        ExperimentCard(experiment: allExperiments[0])
        ExperimentCard(experiment: allExperiments[5])
        ExperimentCard(experiment: allExperiments[10])
    }
    .padding()
}

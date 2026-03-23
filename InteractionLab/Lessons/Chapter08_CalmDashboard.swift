import SwiftUI

struct Chapter08_CalmDashboard: View {
    @State private var currentStep = 0
    private let totalSteps = 6

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step \(currentStep + 1) of \(totalSteps)")
                        .font(.caption).foregroundStyle(.secondary)
                    ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                        .tint(.indigo)
                }.padding(.horizontal)
                Group {
                    switch currentStep {
                    case 0: productAnalysis
                    case 1: calmColorRule
                    case 2: buildMetricCard
                    case 3: buildDashboardGrid
                    case 4: typographyOverColor
                    case 5: tryThis
                    default: productAnalysis
                    }
                }
                HStack {
                    if currentStep > 0 {
                        Button { withAnimation { currentStep -= 1 } } label: { Label("Back", systemImage: "chevron.left") }
                    }
                    Spacer()
                    if currentStep < totalSteps - 1 {
                        Button { withAnimation { currentStep += 1 } } label: { Label("Next", systemImage: "chevron.right") }
                        .buttonStyle(.borderedProminent)
                    }
                }.padding(.horizontal)
            }.padding(.vertical, 24)
        }
        .navigationTitle("Ch 8: Calm Dashboard")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Step 1
    private var productAnalysis: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.text.clipboard").font(.title).foregroundStyle(.indigo)
                Text("Linear").font(.title2).fontWeight(.bold)
            }.padding(.horizontal)
            Text("Linear's latest refresh focuses on reducing visual noise in a data-dense interface. Quieter default states. Muted colors. Less saturated status indicators.").font(.title3).padding(.horizontal)
            Text("Project management tools are used 4-8 hours a day. The calmer visual treatment reduces fatigue without sacrificing density.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) {
                Label("Design Principle", systemImage: "lightbulb.fill").font(.headline).foregroundStyle(.orange)
                Text("Desaturate your default states. Let color earn its place through interaction. A \"calm by default, vivid on intent\" approach scales better in data-dense UIs.").font(.subheadline)
            }.padding().background(Color.orange.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
        }
    }

    // MARK: - Step 2
    @State private var useCalmColors = true
    @State private var tappedStatus: String? = nil

    private var calmColorRule: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("The Calm Color Rule").font(.title2).fontWeight(.bold).padding(.horizontal)
            Text("Tap any status below to see it pop. It fades back after 2 seconds. Toggle between saturated and calm modes.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            Toggle("Calm Colors (Linear style)", isOn: $useCalmColors).padding(.horizontal)
            HStack(spacing: 16) {
                statusPill(label: "To Do", vividColor: .blue)
                statusPill(label: "In Progress", vividColor: .orange)
                statusPill(label: "Done", vividColor: .green)
                statusPill(label: "Cancelled", vividColor: .red)
            }.padding().background(Color(white: 0.95)).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal)
            codeBlock("Circle()\n    .fill(isActive ? vividColor : .gray.opacity(0.5))\n    .animation(.easeInOut(duration: 0.3), value: isActive)\n    .onTapGesture {\n        isActive = true\n        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {\n            withAnimation { isActive = false }\n        }\n    }", caption: "Gray by default. Color on interaction. Auto-fade. That's the entire pattern.")
        }
    }

    // MARK: - Step 3
    private var buildMetricCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Build It: Metric Card").font(.title2).fontWeight(.bold).padding(.horizontal)
            Text("Tap the trend indicator to see the real color for 2 seconds.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            VStack(spacing: 16) {
                MetricCardView(label: "Active Users", value: "12,847", trend: "+14.2%", isPositive: true, sparkData: [3, 5, 4, 7, 6, 8, 9, 7, 10, 12])
                MetricCardView(label: "Churn Rate", value: "2.3%", trend: "-0.8%", isPositive: true, sparkData: [8, 7, 6, 5, 6, 4, 3, 4, 3, 2])
                MetricCardView(label: "Avg Response", value: "342ms", trend: "+23ms", isPositive: false, sparkData: [2, 3, 2, 4, 3, 5, 4, 5, 6, 5])
            }.padding(.horizontal)
        }
    }

    // MARK: - Step 4
    private var buildDashboardGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dashboard Grid").font(.title2).fontWeight(.bold).padding(.horizontal)
            Text("Four cards in an adaptive grid. 2 columns on wide screens, 1 on narrow.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            let columns = [GridItem(.adaptive(minimum: 250), spacing: 16)]
            LazyVGrid(columns: columns, spacing: 16) {
                MetricCardView(label: "Revenue", value: "$48.2K", trend: "+8.5%", isPositive: true, sparkData: [4, 5, 6, 5, 7, 8, 7, 9, 10, 11])
                MetricCardView(label: "Signups", value: "1,247", trend: "+22%", isPositive: true, sparkData: [3, 4, 5, 6, 5, 7, 8, 9, 10, 12])
                MetricCardView(label: "Bounce Rate", value: "34%", trend: "+2.1%", isPositive: false, sparkData: [5, 4, 5, 6, 5, 6, 7, 6, 7, 7])
                MetricCardView(label: "Avg Session", value: "4m 12s", trend: "-18s", isPositive: false, sparkData: [8, 7, 7, 6, 7, 6, 5, 6, 5, 4])
            }.padding(.horizontal)
            codeBlock("let columns = [\n    GridItem(.adaptive(minimum: 250), spacing: 16)\n]\nLazyVGrid(columns: columns, spacing: 16) {\n    ForEach(metrics) { MetricCardView(metric: $0) }\n}", caption: "GridItem(.adaptive) handles responsiveness without platform checks.")
        }
    }

    // MARK: - Step 5
    @State private var useTypographyHierarchy = true
    private var typographyOverColor: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Typography Over Color").font(.title2).fontWeight(.bold).padding(.horizontal)
            Text("Linear maintains hierarchy through spacing and font weight rather than color saturation.").font(.body).foregroundStyle(.secondary).padding(.horizontal)
            Toggle("Typography hierarchy (Linear)", isOn: $useTypographyHierarchy).padding(.horizontal)
            VStack(alignment: .leading, spacing: 12) {
                Text("Active Issues").font(.title3).fontWeight(.bold).foregroundStyle(useTypographyHierarchy ? .primary : .blue)
                Text("Sprint 24 · 3 days remaining").font(.subheadline).foregroundStyle(useTypographyHierarchy ? .secondary : .orange)
                Divider()
                issueRow(priority: "Urgent", title: "Fix auth token refresh", assignee: "Sarah", useColor: !useTypographyHierarchy)
                issueRow(priority: "High", title: "Update onboarding flow", assignee: "Mike", useColor: !useTypographyHierarchy)
                issueRow(priority: "Medium", title: "Refactor API layer", assignee: "Alex", useColor: !useTypographyHierarchy)
            }.padding().background(Color(white: 0.95)).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal)
            .animation(.easeInOut(duration: 0.3), value: useTypographyHierarchy)
        }
    }

    // MARK: - Step 6
    private var tryThis: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles").font(.title2).foregroundStyle(.orange)
                Text("Try This").font(.title2).fontWeight(.bold)
            }.padding(.horizontal)
            VStack(alignment: .leading, spacing: 12) {
                Text("Extend the calm dashboard:").font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Label("Long-press a card to show a detail popover", systemImage: "1.circle")
                    Label("Popover uses full-saturation colors (user intentionally engaged)", systemImage: "2.circle")
                    Label("Verify calm colors work in both light and dark mode", systemImage: "3.circle")
                }.font(.body)
                Text("Hint: .popover(isPresented:) with .onLongPressGesture(minimumDuration: 0.5)").font(.subheadline).foregroundStyle(.secondary)
            }.padding().background(Color.orange.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) {
                Label("Builds on: Springs (Ch 1), Sheets & Modals (Ch 5)", systemImage: "arrow.turn.right.up").font(.caption).foregroundStyle(.secondary)
                Label("Next up: Craft's Cross-Platform Navigation (Ch 9)", systemImage: "arrow.right.circle").font(.caption).foregroundStyle(.secondary)
            }.padding(.horizontal)
        }
    }

    // MARK: - Helpers
    private func statusPill(label: String, vividColor: Color) -> some View {
        let isActive = tappedStatus == label
        let displayColor = useCalmColors ? (isActive ? vividColor : Color.gray.opacity(0.5)) : vividColor
        return VStack(spacing: 4) {
            Circle().fill(displayColor).frame(width: 12, height: 12)
            Text(label).font(.caption2).foregroundStyle(isActive ? .primary : .secondary)
        }
        .animation(.easeInOut(duration: 0.3), value: isActive)
        .onTapGesture {
            tappedStatus = label
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { if tappedStatus == label { tappedStatus = nil } }
            }
        }
    }

    private func issueRow(priority: String, title: String, assignee: String, useColor: Bool) -> some View {
        let color: Color = priority == "Urgent" ? .red : priority == "High" ? .orange : .yellow
        return HStack(spacing: 12) {
            Circle().fill(useColor ? color : Color.gray.opacity(0.4)).frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(priority == "Urgent" ? .bold : .regular)
                Text(assignee).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(priority).font(.caption2).fontWeight(.medium)
                .foregroundStyle(useColor ? color : .secondary)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .background(useColor ? color.opacity(0.15) : Color(white: 0.9))
                .clipShape(Capsule())
        }
    }

    private func codeBlock(_ code: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code).font(.system(.caption, design: .monospaced)).padding(12)
            }.background(Color(white: 0.12)).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 8))
            Text(caption).font(.caption).foregroundStyle(.secondary)
        }.padding(.horizontal)
    }
}

// MARK: - MetricCardView
struct MetricCardView: View {
    let label: String; let value: String; let trend: String; let isPositive: Bool; let sparkData: [Int]
    @State private var showTrendColor = false
    private var trendColor: Color { showTrendColor ? (isPositive ? .green : .red) : .gray }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(label).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.title2).fontWeight(.bold)
                HStack(spacing: 4) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right").font(.caption2)
                    Text(trend).font(.caption).fontWeight(.medium)
                }
                .foregroundStyle(trendColor)
                .animation(.easeInOut(duration: 0.3), value: showTrendColor)
                .onTapGesture {
                    showTrendColor = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { showTrendColor = false }
                    }
                }
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(sparkData.indices, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 4, height: CGFloat(sparkData[i]) / CGFloat(sparkData.max() ?? 1) * 40)
                }
            }.frame(height: 40)
        }.padding().background(Color(white: 0.97)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

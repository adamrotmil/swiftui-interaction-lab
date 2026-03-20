import SwiftUI

// MARK: - Chapter 4: Navigation — How Screens Connect

/// An interactive Treehouse-style lesson on SwiftUI navigation.
struct Chapter04_Navigation: View {
    var body: some View {
        LessonView(
            lesson: allLessons[3],
            steps: [
                LessonStep("Welcome") { Step1_NavWelcome() },
                LessonStep("NavigationStack") { Step2_NavStack() },
                LessonStep("Programmatic Navigation") { Step3_ProgrammaticNav() },
                LessonStep("NavigationSplitView") { Step4_SplitView() },
                LessonStep("The Mental Model Shift") { Step5_MentalModel() },
                LessonStep("Try This") { Step6_NavChallenge() },
            ]
        )
    }
}

// MARK: - Step 1: Welcome

private struct Step1_NavWelcome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("In React, you'd reach for React Router — define routes as URLs, useNavigate() to push, useParams() to read. SwiftUI flips this completely.")

            LessonText("Navigation is state-driven: you push values onto a path, and the system figures out what view to show. No URLs, no string matching.")

            LessonText("If React Router is a phone book (look up a name → get a page), SwiftUI navigation is a stack of cards — you push a card on, pop it off, and the top card is always what's visible.")

            LessonText("Let's build up from the basics.")
        }
    }
}

// MARK: - Step 2: NavigationStack

private struct NavItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

private struct Step2_NavStack: View {
    private let items: [NavItem] = [
        NavItem(name: "Springs", icon: "waveform.path.ecg", color: .orange),
        NavItem(name: "Gestures", icon: "hand.draw", color: .blue),
        NavItem(name: "Symbols", icon: "star.fill", color: .purple),
        NavItem(name: "Layout", icon: "rectangle.split.2x2", color: .green),
    ]

    @State private var selectedItem: NavItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("NavigationStack is the foundation. You put a list inside it, use NavigationLink to make rows tappable, and .navigationDestination tells SwiftUI what to show when a value is pushed.")

            // Live interactive demo
            VStack(spacing: 0) {
                if let selected = selectedItem {
                    // Detail view
                    VStack(spacing: 16) {
                        Image(systemName: selected.icon)
                            .font(.system(size: 48))
                            .foregroundStyle(selected.color)

                        Text(selected.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("This is the detail view for \(selected.name). In a real app, this would show rich content.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                selectedItem = nil
                            }
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                                .font(.callout)
                                .fontWeight(.medium)
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                } else {
                    // List view
                    VStack(spacing: 1) {
                        ForEach(items) { item in
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    selectedItem = item
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.icon)
                                        .font(.title3)
                                        .foregroundStyle(item.color)
                                        .frame(width: 32)
                                    Text(item.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(white: 1.0))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
            }
            .frame(minHeight: 200)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.95))
            )

            Text("Tap a row to push a detail view")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)

            CodeBlockView(
                code: """
                NavigationStack {
                    List(items) { item in
                        NavigationLink(value: item) {
                            Text(item.name)
                        }
                    }
                    .navigationDestination(for: Item.self) { item in
                        DetailView(item: item)
                    }
                }
                """,
                caption: "NavigationLink pushes a value, .navigationDestination resolves it."
            )

            LessonText("Notice the pattern: NavigationLink doesn't contain the destination view directly. It pushes a value, and .navigationDestination maps that value type to a view. This decoupling is what makes programmatic navigation possible.")
        }
    }
}

// MARK: - Step 3: Programmatic Navigation

private struct Step3_ProgrammaticNav: View {
    @State private var pathStack: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Here's where it gets powerful. NavigationPath is like a stack you control directly — push values on, pop them off, all from code.")

            // Live stack visualization
            VStack(spacing: 12) {
                Text("Navigation Stack")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if pathStack.isEmpty {
                    Text("Root View")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } else {
                    ForEach(Array(pathStack.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text("\(index + 1)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(width: 22, height: 22)
                                .background(Color.green)
                                .clipShape(Circle())

                            Text(item)
                                .font(.system(.callout, design: .monospaced))
                                .fontWeight(.medium)

                            Spacer()

                            if index == pathStack.count - 1 {
                                Text("← top")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(index == pathStack.count - 1 ? 0.15 : 0.05))
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.95))
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: pathStack.count)

            // Control buttons
            HStack(spacing: 12) {
                Button {
                    let screens = ["Settings", "Profile", "Notifications", "Privacy", "About", "Help"]
                    let next = screens[pathStack.count % screens.count]
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        pathStack.append(next)
                    }
                } label: {
                    Label("Push", systemImage: "plus.circle.fill")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button {
                    if !pathStack.isEmpty {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            pathStack.removeLast()
                        }
                    }
                } label: {
                    Label("Pop", systemImage: "minus.circle.fill")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                .buttonStyle(.bordered)
                .disabled(pathStack.isEmpty)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        pathStack.append(contentsOf: ["Categories", "Electronics", "Detail"])
                    }
                } label: {
                    Text("Push 3")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                .buttonStyle(.bordered)

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        pathStack.removeAll()
                    }
                } label: {
                    Text("Pop to Root")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .disabled(pathStack.isEmpty)
            }

            CodeBlockView(
                code: """
                @State private var path = NavigationPath()

                NavigationStack(path: $path) {
                    Button("Go to Settings") {
                        path.append("Settings")
                    }
                    .navigationDestination(for: String.self) { value in
                        Text("Screen: \\(value)")
                    }
                }

                // Pop to root from anywhere:
                path = NavigationPath()
                """,
                caption: "NavigationPath gives you full control over the stack."
            )

            LessonText("This is the SwiftUI equivalent of useNavigate() — but instead of imperatively pushing URLs, you're modifying a state value. The view tree reacts automatically.")
        }
    }
}

// MARK: - Step 4: NavigationSplitView

private struct Step4_SplitView: View {
    private let categories = ["Inbox", "Drafts", "Sent", "Archive", "Trash"]
    @State private var selectedCategory: String? = "Inbox"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("On iPad and Mac, you get a sidebar + detail layout for free. NavigationSplitView gives you the classic master-detail pattern that adapts across screen sizes.")

            // Live demo - simulated split view
            HStack(spacing: 0) {
                // Sidebar
                VStack(alignment: .leading, spacing: 2) {
                    Text("Mailboxes")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 4)

                    ForEach(categories, id: \.self) { category in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedCategory = category
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: iconForCategory(category))
                                    .font(.callout)
                                    .frame(width: 20)
                                Text(category)
                                    .font(.callout)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(selectedCategory == category ? Color.green.opacity(0.2) : Color.clear)
                            )
                            .foregroundStyle(selectedCategory == category ? .green : .primary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 140)
                .padding(.vertical, 12)

                // Divider
                Rectangle()
                    .fill(Color(white: 0.85))
                    .frame(width: 1)

                // Detail
                VStack {
                    if let selected = selectedCategory {
                        Image(systemName: iconForCategory(selected))
                            .font(.system(size: 32))
                            .foregroundStyle(.green)
                        Text(selected)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("3 messages")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 220)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.97))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Tap sidebar items to switch the detail pane")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)

            CodeBlockView(
                code: """
                NavigationSplitView {
                    List(categories, selection: $selected) { cat in
                        Text(cat.name)
                    }
                } detail: {
                    if let selected {
                        DetailView(category: selected)
                    } else {
                        Text("Select a category")
                    }
                }
                """,
                caption: "On iPhone this collapses to a stack automatically."
            )

            LessonText("There's also a three-column variant with a content parameter in the middle — think Mail.app with its sidebar, message list, and message detail. SwiftUI handles the responsive collapse across device sizes.")
        }
    }

    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Inbox": return "tray.fill"
        case "Drafts": return "doc.text"
        case "Sent": return "paperplane.fill"
        case "Archive": return "archivebox.fill"
        case "Trash": return "trash.fill"
        default: return "folder.fill"
        }
    }
}

// MARK: - Step 5: The Mental Model Shift

private struct Step5_MentalModel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LessonText("Let's put this side by side so the difference is crystal clear.")

            // React Router model
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .foregroundStyle(.blue)
                    Text("React Router")
                        .font(.callout)
                        .fontWeight(.bold)
                }

                VStack(alignment: .leading, spacing: 6) {
                    modelRow(number: "1", text: "URL changes", color: .blue)
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    modelRow(number: "2", text: "Route pattern matches", color: .blue)
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    modelRow(number: "3", text: "Component renders", color: .blue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            )

            // SwiftUI model
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "swift")
                        .foregroundStyle(.green)
                    Text("SwiftUI Navigation")
                        .font(.callout)
                        .fontWeight(.bold)
                }

                VStack(alignment: .leading, spacing: 6) {
                    modelRow(number: "1", text: "State value changes", color: .green)
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    modelRow(number: "2", text: "Path updates", color: .green)
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    modelRow(number: "3", text: "Destination resolves", color: .green)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.green.opacity(0.2), lineWidth: 1)
                    )
            )

            LessonText("The view hierarchy IS the navigation. There's no router sitting outside your views. The navigation state lives right alongside your other @State properties, and SwiftUI's diffing engine handles all the transitions.")

            LessonText("This means deep links are just \"set the path state to these values\" — no URL parsing required.")
        }
    }

    private func modelRow(number: String, text: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Text(number)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(color)
                .clipShape(Circle())
            Text(text)
                .font(.callout)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Step 6: Try This Challenge

private struct Step6_NavChallenge: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryThisCard(
                prompt: "Build a 3-level drill-down: Categories → Items → Detail. Use NavigationPath and add a 'Back to Categories' button on the Detail view that pops to root."
            )

            LessonText("Here's a skeleton to get you started:")

            CodeBlockView(
                code: """
                struct DrillDownView: View {
                    @State private var path = NavigationPath()

                    let categories = ["Electronics", "Books", "Clothing"]

                    var body: some View {
                        NavigationStack(path: $path) {
                            List(categories, id: \\.self) { cat in
                                NavigationLink(value: cat) {
                                    Text(cat)
                                }
                            }
                            .navigationTitle("Categories")
                            .navigationDestination(for: String.self) { cat in
                                ItemsView(category: cat, path: $path)
                            }
                        }
                    }
                }
                """,
                caption: "You'll need to add the Items and Detail levels."
            )

            LessonText("Bonus: can you make the 'Back to Categories' button animate with a spring? Hint: wrap path = NavigationPath() in withAnimation.")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Chapter04_Navigation()
    }
}

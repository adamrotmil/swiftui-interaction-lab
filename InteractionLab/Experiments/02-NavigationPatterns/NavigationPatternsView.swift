import SwiftUI

/// Experiment 02: Navigation Patterns
///
/// Demonstrates SwiftUI's navigation system — a declarative, type-safe approach
/// that replaces web-style URL routing with value-driven navigation.
/// Key difference from web: navigation state is a typed array, not a URL string.
struct NavigationPatternsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Navigation Patterns")
                    .experimentHeader()
                Text("SwiftUI replaces URL-based routing with value-driven NavigationStack and NavigationSplitView.")
                    .experimentDescription()

                StackNavigationDemo()
                ProgrammaticNavigationDemo()
                SplitViewDemo()
            }
            .padding()
        }
        .navigationTitle("02 — Navigation")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Stack Navigation Demo

/// Basic NavigationLink usage inside a NavigationStack.
private struct StackNavigationDemo: View {
    let items = [
        ("star.fill", "Favorites", "Your saved items"),
        ("clock.fill", "Recent", "Recently viewed experiments"),
        ("gear", "Settings", "App configuration"),
        ("person.circle", "Profile", "User information"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("NavigationLink List", systemImage: "list.bullet")
                .font(.headline)
            Text("Each row pushes a detail view onto the NavigationStack. The back gesture is automatic.")
                .font(.caption)
                .foregroundStyle(.secondary)

            // We embed a NavigationStack here so it works standalone.
            // In a real app, this would be the outermost container.
            NavigationStack {
                List(items, id: \.1) { icon, title, subtitle in
                    NavigationLink {
                        DetailPageView(title: title, icon: icon)
                    } label: {
                        Label {
                            VStack(alignment: .leading) {
                                Text(title).font(.body)
                                Text(subtitle).font(.caption).foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: icon)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Programmatic Navigation

/// Demonstrates programmatic navigation using NavigationPath.
/// Unlike web routing where you push URL strings, SwiftUI pushes typed values.
private struct ProgrammaticNavigationDemo: View {
    @State private var path = NavigationPath()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Programmatic Navigation", systemImage: "arrow.right.circle")
                .font(.headline)
            Text("Tap buttons to push views onto the path programmatically — like React Router's navigate(), but type-safe.")
                .font(.caption)
                .foregroundStyle(.secondary)

            NavigationStack(path: $path) {
                VStack(spacing: 12) {
                    Text("Path depth: \(path.count)")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        Button("Push 'A'") { path.append("Screen A") }
                        Button("Push 'B'") { path.append("Screen B") }
                        Button("Push 'C'") { path.append("Screen C") }
                    }
                    .buttonStyle(.bordered)

                    if !path.isEmpty {
                        Button("Pop to Root") {
                            path = NavigationPath()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                .navigationDestination(for: String.self) { value in
                    VStack(spacing: 16) {
                        Text(value)
                            .font(.largeTitle.bold())
                        Text("Pushed programmatically via NavigationPath.append()")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button("Push another") {
                            path.append("Nested from \(value)")
                        }
                        .buttonStyle(.bordered)
                    }
                    .navigationTitle(value)
                }
                .frame(height: 160)
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Split View Demo

/// Shows NavigationSplitView, which is the iPad/macOS sidebar pattern.
/// On iPhone it collapses to a stack automatically.
private struct SplitViewDemo: View {
    let categories = ["Gestures", "Animation", "Layout", "Data Flow"]
    @State private var selectedCategory: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("NavigationSplitView", systemImage: "sidebar.left")
                .font(.headline)
            Text("Sidebar + detail pattern for iPad/Mac. Automatically collapses on compact widths.")
                .font(.caption)
                .foregroundStyle(.secondary)

            NavigationSplitView {
                List(categories, id: \.self, selection: $selectedCategory) { category in
                    Label(category, systemImage: "folder")
                }
                .navigationTitle("Categories")
            } detail: {
                if let selected = selectedCategory {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                        Text("Selected: \(selected)")
                            .font(.title3.bold())
                    }
                } else {
                    ContentUnavailableView("No Selection", systemImage: "sidebar.left")
                }
            }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Detail Page

private struct DetailPageView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            Text(title)
                .font(.title.bold())
            Text("This is the detail view for \"\(title)\". The back button and swipe-to-go-back gesture are provided automatically by NavigationStack.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        NavigationPatternsView()
    }
}

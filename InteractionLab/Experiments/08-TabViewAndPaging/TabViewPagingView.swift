import SwiftUI

/// Experiment 08: TabView & Paging
///
/// Demonstrates SwiftUI TabView in two modes: standard tab bar (like UITabBarController)
/// and page-style (like UIPageViewController / a web carousel).
/// Key difference from web: the tab bar is a system component with automatic
/// badge rendering, SF Symbol integration, and adaptive layout.
struct TabViewPagingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("TabView & Paging")
                    .experimentHeader()
                Text("Two TabView modes: standard tab bar with badges, and page-style for onboarding carousels.")
                    .experimentDescription()

                // MARK: - Standard Tab View
                standardTabSection

                // MARK: - Page-Style Tab View
                pageStyleSection

                // MARK: - Programmatic Tab Switching
                programmaticTabSection
            }
            .padding()
        }
        .navigationTitle("08 — TabView & Paging")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Standard Tab View

    private var standardTabSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Standard Tab Bar", systemImage: "rectangle.split.3x1")
                .font(.headline)
            Text("A full tab bar with badges. On iPad, this moves to the sidebar. Badges update in real time.")
                .font(.caption)
                .foregroundStyle(.secondary)

            StandardTabDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Page Style Section

    private var pageStyleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Page-Style Carousel", systemImage: "book.pages")
                .font(.headline)
            Text("TabView with .tabViewStyle(.page) creates a swipeable carousel — perfect for onboarding flows.")
                .font(.caption)
                .foregroundStyle(.secondary)

            OnboardingCarousel()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Programmatic Tab Section

    private var programmaticTabSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Programmatic Tab Switching", systemImage: "arrow.right.arrow.left")
                .font(.headline)
            Text("Control the active tab from code using a @State binding — useful for deep linking and notification handling.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ProgrammaticTabDemo()
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Standard Tab Demo

private struct StandardTabDemo: View {
    @State private var selectedTab = 0
    @State private var messageCount = 3

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            VStack {
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                Text("Home Tab")
                    .font(.headline)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            // Messages Tab with badge
            VStack(spacing: 8) {
                Image(systemName: "message.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                Text("Messages")
                    .font(.headline)
                Button("Clear Badge") {
                    messageCount = 0
                }
                .buttonStyle(.bordered)
            }
            .tabItem {
                Label("Messages", systemImage: "message.fill")
            }
            .badge(messageCount)
            .tag(1)

            // Profile Tab
            VStack {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.purple)
                Text("Profile")
                    .font(.headline)
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
            .tag(2)

            // Settings Tab
            VStack {
                Image(systemName: "gear")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                Text("Settings")
                    .font(.headline)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .badge("!")
            .tag(3)
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Onboarding Carousel

private struct OnboardingCarousel: View {
    @State private var currentPage = 0

    let pages: [(icon: String, title: String, description: String, color: Color)] = [
        ("hand.wave.fill", "Welcome", "Discover the power of SwiftUI interactions", .blue),
        ("paintbrush.fill", "Design", "Build beautiful, native interfaces with ease", .purple),
        ("bolt.fill", "Performance", "60fps animations out of the box", .orange),
        ("checkmark.seal.fill", "Ready", "You're all set to start building!", .green),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 16) {
                        Image(systemName: pages[index].icon)
                            .font(.system(size: 50))
                            .foregroundStyle(pages[index].color)

                        Text(pages[index].title)
                            .font(.title2.bold())

                        Text(pages[index].description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .tag(index)
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .always))
            #endif
            .frame(height: 220)

            // Navigation buttons
            HStack {
                Button("Previous") {
                    withAnimation {
                        currentPage = max(0, currentPage - 1)
                    }
                }
                .disabled(currentPage == 0)

                Spacer()

                // Page indicator dots
                HStack(spacing: 6) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? pages[index].color : .gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }

                Spacer()

                Button(currentPage == pages.count - 1 ? "Done" : "Next") {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            currentPage = 0
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Programmatic Tab Demo

private struct ProgrammaticTabDemo: View {
    @State private var activeTab = 0

    var body: some View {
        VStack(spacing: 12) {
            // External control buttons
            HStack(spacing: 8) {
                ForEach(0..<4) { index in
                    let labels = ["Red", "Green", "Blue", "Gold"]
                    let colors: [Color] = [.red, .green, .blue, .orange]
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            activeTab = index
                        }
                    } label: {
                        Text(labels[index])
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(activeTab == index ? colors[index] : colors[index].opacity(0.2))
                            .foregroundStyle(activeTab == index ? .white : colors[index])
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }

            TabView(selection: $activeTab) {
                ForEach(0..<4) { index in
                    let colors: [Color] = [.red, .green, .blue, .orange]
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors[index].gradient)
                        .overlay(
                            Text("Tab \(index + 1)")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        )
                        .tag(index)
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Active tab: \(activeTab + 1) — controlled by both swipe gestures and the buttons above.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        TabViewPagingView()
    }
}

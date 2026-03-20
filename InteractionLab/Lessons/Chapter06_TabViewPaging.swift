import SwiftUI

// MARK: - Chapter 6: TabView & Paging — Organizing Your App's Top Level

/// An interactive Treehouse-style lesson on tab bars and page-style carousels.
struct Chapter06_TabViewPaging: View {
    var body: some View {
        LessonView(
            lesson: allLessons[5],
            steps: [
                LessonStep("Welcome") { Step1_TabWelcome() },
                LessonStep("Basic Tabs") { Step2_BasicTabs() },
                LessonStep("Badges") { Step3_Badges() },
                LessonStep("Page Style") { Step4_PageStyle() },
                LessonStep("Programmatic Switching") { Step5_ProgrammaticTabs() },
                LessonStep("Try This") { Step6_TabChallenge() },
            ]
        )
    }
}

// MARK: - Step 1: Welcome

private struct Step1_TabWelcome: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Almost every app you use has a tab bar at the bottom. Instagram, Spotify, App Store — they all use tabs as the primary way to organize top-level destinations.")

            LessonText("In SwiftUI, TabView does double duty. It can be a traditional tab bar with icons and labels at the bottom, or it can become a horizontal paging carousel — the kind you see in onboarding flows or photo galleries.")

            LessonText("Both modes are driven by the same view. Let's explore each one.")
        }
    }
}

// MARK: - Step 2: Basic Tabs

private struct Step2_BasicTabs: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("A basic TabView is just a container. Each child gets a .tabItem() modifier with a label and icon. SwiftUI handles the tab bar rendering, selection highlighting, and switching animation.")

            TabView(selection: $selectedTab) {
                TabDemoPage(icon: "house.fill", title: "Home", color: .blue, index: 0)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)

                TabDemoPage(icon: "magnifyingglass", title: "Search", color: .green, index: 1)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)

                TabDemoPage(icon: "person.fill", title: "Profile", color: .purple, index: 2)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(2)
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            CodeBlockView(
                code: """
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    SearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                }
                """,
                caption: "Each child view gets a .tabItem with icon and label"
            )

            LessonText("The tag() modifier connects each tab to a selection value. Without tags, SwiftUI uses the tab's position index — but explicit tags are safer and clearer.")
        }
    }
}

// MARK: - Step 3: Badges

private struct Step3_Badges: View {
    @State private var messageCount = 3
    @State private var showBadges = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Tab badges are those little red circles you see on app icons. In SwiftUI, adding one is a single modifier. Badges can show numbers or short text.")

            HStack {
                Text("Messages: \(messageCount)")
                    .font(.callout)
                Stepper("", value: $messageCount, in: 0...99)
                    .labelsHidden()
            }
            .padding(.horizontal, 4)

            TabView {
                Text("Inbox")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(white: 0.95))
                    .tabItem {
                        Image(systemName: "envelope.fill")
                        Text("Inbox")
                    }
                    .badge(messageCount)

                Text("Updates")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(white: 0.95))
                    .tabItem {
                        Image(systemName: "bell.fill")
                        Text("Updates")
                    }
                    .badge("New")

                Text("Settings")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(white: 0.95))
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            CodeBlockView(
                code: """
                TabView {
                    InboxView()
                        .tabItem { Label("Inbox", systemImage: "envelope") }
                        .badge(unreadCount)

                    UpdatesView()
                        .tabItem { Label("Updates", systemImage: "bell") }
                        .badge("New")
                }
                """,
                caption: "Badges accept Int or String values"
            )

            LessonText("Set the badge to 0 or nil to hide it. The badge automatically animates when the value changes — no extra work needed.")
        }
    }
}

// MARK: - Step 4: Page Style

private struct Step4_PageStyle: View {
    @State private var currentPage = 0
    private let pageColors: [Color] = [.blue, .green, .orange, .purple]
    private let pageIcons = ["sun.max.fill", "leaf.fill", "flame.fill", "moon.stars.fill"]
    private let pageLabels = ["Morning", "Afternoon", "Evening", "Night"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Switch TabView to .tabViewStyle(.page) and it transforms into a swipeable carousel. This is perfect for onboarding screens, image galleries, or any horizontal paging experience.")

            TabView(selection: $currentPage) {
                ForEach(0..<4) { index in
                    VStack(spacing: 12) {
                        Image(systemName: pageIcons[index])
                            .font(.system(size: 36))
                            .foregroundStyle(.white)
                        Text(pageLabels[index])
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text("Page \(index + 1) of 4")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(pageColors[index].gradient)
                    )
                    .padding(.horizontal, 8)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            CodeBlockView(
                code: """
                TabView {
                    ForEach(pages) { page in
                        PageContent(page: page)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                """,
                caption: "One modifier transforms tabs into a swipeable carousel"
            )

            LessonText("The page dots at the bottom come free with .page(indexDisplayMode: .always). Use .never to hide them, or .automatic to let SwiftUI decide.")
        }
    }
}

// MARK: - Step 5: Programmatic Switching

private struct Step5_ProgrammaticTabs: View {
    @State private var activeTab: AppTab = .home

    enum AppTab: String, CaseIterable {
        case home = "Home"
        case search = "Search"
        case cart = "Cart"
        case profile = "Profile"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .search: return "magnifyingglass"
            case .cart: return "cart.fill"
            case .profile: return "person.fill"
            }
        }

        var color: Color {
            switch self {
            case .home: return .blue
            case .search: return .green
            case .cart: return .orange
            case .profile: return .purple
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Just like NavigationStack, you can control the selected tab programmatically. Bind the selection to an enum and you can switch tabs from anywhere — deep links, notifications, buttons.")

            HStack(spacing: 8) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            activeTab = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.title3)
                            Text(tab.rawValue)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(activeTab == tab ? tab.color.opacity(0.15) : Color.clear)
                        )
                        .foregroundStyle(activeTab == tab ? tab.color : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.95))
            )

            TabView(selection: $activeTab) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    VStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 32))
                            .foregroundStyle(tab.color)
                        Text(tab.rawValue)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(white: 0.95))
                    .tag(tab)
                }
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            CodeBlockView(
                code: """
                enum AppTab: Hashable {
                    case home, search, cart, profile
                }

                @State private var activeTab: AppTab = .home

                TabView(selection: $activeTab) {
                    HomeView().tag(AppTab.home)
                    SearchView().tag(AppTab.search)
                }

                // Switch from anywhere:
                activeTab = .cart
                """,
                caption: "Enum-based selection gives you type-safe tab control"
            )

            LessonText("Pro tip: Use an enum for your tabs. It makes programmatic switching type-safe and lets you add computed properties for icons, titles, and colors in one place.")
        }
    }
}

// MARK: - Step 6: Challenge

private struct Step6_TabChallenge: View {
    @State private var currentStep = 0
    private let totalSteps = 3
    private let stepTitles = ["Welcome", "Customize", "Get Started"]
    private let stepIcons = ["hand.wave.fill", "paintbrush.fill", "rocket.fill"]
    private let stepColors: [Color] = [.blue, .purple, .orange]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LessonText("Here's a challenge: build an onboarding flow using a page-style TabView with a \"Next\" button that advances through steps. Play with this working example:")

            VStack(spacing: 0) {
                TabView(selection: $currentStep) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        VStack(spacing: 12) {
                            Image(systemName: stepIcons[step])
                                .font(.system(size: 40))
                                .foregroundStyle(stepColors[step])
                            Text(stepTitles[step])
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Step \(step + 1) of \(totalSteps)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(step)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 160)

                HStack {
                    // Page indicators
                    HStack(spacing: 6) {
                        ForEach(0..<totalSteps, id: \.self) { step in
                            Circle()
                                .fill(step == currentStep ? stepColors[currentStep] : Color(white: 0.8))
                                .frame(width: step == currentStep ? 10 : 7, height: step == currentStep ? 10 : 7)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
                        }
                    }

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if currentStep < totalSteps - 1 {
                                currentStep += 1
                            } else {
                                currentStep = 0
                            }
                        }
                    } label: {
                        Text(currentStep < totalSteps - 1 ? "Next" : "Start Over")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(stepColors[currentStep])
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(white: 0.95))
            )

            CodeBlockView(
                code: """
                @State private var currentStep = 0

                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \\.self) { i in
                        StepView(step: steps[i]).tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                Button("Next") {
                    withAnimation { currentStep += 1 }
                }
                """,
                caption: "Combine page-style with programmatic control"
            )

            LessonText("Challenge: Try adding a \"Skip\" button that jumps to the last step, or add a custom transition animation between pages using .transition() on each step's content.")
        }
    }
}

// MARK: - Helper Views

private struct TabDemoPage: View {
    let icon: String
    let title: String
    let color: Color
    let index: Int

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color)
            Text(title)
                .font(.headline)
            Text("Tab \(index + 1)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.95))
    }
}

// MARK: - Preview

#Preview {
    Chapter06_TabViewPaging()
}

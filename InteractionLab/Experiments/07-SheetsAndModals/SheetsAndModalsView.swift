import SwiftUI

/// Experiment 07: Sheets & Modals
///
/// Demonstrates SwiftUI's modal presentation system. Unlike web modals (which
/// are just positioned divs with z-index), SwiftUI sheets are system-managed
/// with built-in gestures, accessibility, and presentation detents.
struct SheetsAndModalsView: View {
    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var showPopover = false
    @State private var showCustomDetent = false
    @State private var showConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Sheets & Modals")
                    .experimentHeader()
                Text("SwiftUI modals are system-managed presentations with built-in gestures, not CSS z-index tricks.")
                    .experimentDescription()

                // MARK: - Standard Sheet
                sheetSection

                // MARK: - Full Screen Cover
                fullScreenSection

                // MARK: - Popover
                popoverSection

                // MARK: - Custom Detents (Half-Sheet)
                customDetentSection

                // MARK: - Confirmation Dialog
                confirmationSection
            }
            .padding()
        }
        .navigationTitle("07 — Sheets & Modals")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Sheet

    private var sheetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Standard Sheet (.sheet)", systemImage: "rectangle.bottomhalf.inset.filled")
                .font(.headline)
            Text("The default modal presentation. User can dismiss by swiping down or tapping the dimmed background.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                showSheet = true
            } label: {
                Label("Present Sheet", systemImage: "arrow.up.doc")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showSheet) {
                SheetContentView(title: "Standard Sheet", description: "This is a regular .sheet presentation. Swipe down to dismiss, or tap the button below.")
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Full Screen Cover

    private var fullScreenSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Full Screen Cover", systemImage: "rectangle.fill")
                .font(.headline)
            Text("Takes over the entire screen. Cannot be dismissed by swiping — you must provide an explicit dismiss action.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                showFullScreen = true
            } label: {
                Label("Present Full Screen", systemImage: "arrow.up.left.and.arrow.down.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .fullScreenCover(isPresented: $showFullScreen) {
                FullScreenContentView()
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Popover

    private var popoverSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Popover", systemImage: "text.bubble")
                .font(.headline)
            Text("On iPad/Mac, this floats as an arrow-pointed popover. On iPhone, it falls back to a sheet.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                showPopover = true
            } label: {
                Label("Show Popover", systemImage: "bubble.left.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .popover(isPresented: $showPopover) {
                VStack(spacing: 12) {
                    Text("Popover Content")
                        .font(.headline)
                    Text("On iPad and Mac, this appears as an anchored floating panel with an arrow. On iPhone, it presents as a sheet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Image(systemName: "ipad.landscape")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                }
                .padding()
                .frame(minWidth: 250)
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Custom Detents

    private var customDetentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Presentation Detents (Half-Sheet)", systemImage: "rectangle.split.1x2")
                .font(.headline)
            Text("iOS 16+ supports custom sheet heights. This shows the half-sheet pattern popularized by Apple Maps.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                showCustomDetent = true
            } label: {
                Label("Show Half-Sheet", systemImage: "rectangle.bottomhalf.filled")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .sheet(isPresented: $showCustomDetent) {
                DetentSheetView()
                    .presentationDetents([
                        .fraction(0.25),
                        .medium,
                        .large,
                    ])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Confirmation Dialog

    private var confirmationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Confirmation Dialog", systemImage: "exclamationmark.questionmark")
                .font(.headline)
            Text("The native action sheet / alert replacement. Presents platform-appropriate options.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                showConfirmation = true
            } label: {
                Label("Show Confirmation", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .confirmationDialog(
                "Delete this item?",
                isPresented: $showConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) { }
                Button("Archive") { }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
        }
        .padding()
        .background(Color(white: 0.95).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Sheet Content View

private struct SheetContentView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let description: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)

                Text(title)
                    .font(.title2.bold())

                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Full Screen Content View

private struct FullScreenContentView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                Text("Full Screen Cover")
                    .font(.largeTitle.bold())
                Text("This takes over the entire screen. You must provide an explicit way to dismiss it — swipe-to-dismiss is disabled.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    dismiss()
                } label: {
                    Label("Dismiss", systemImage: "xmark.circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.purple)
            }
            .foregroundStyle(.white)
        }
    }
}

// MARK: - Detent Sheet View

private struct DetentSheetView: View {
    let items = [
        ("mappin.circle.fill", "Current Location", "San Francisco, CA"),
        ("magnifyingglass", "Search Nearby", "Restaurants, coffee, gas"),
        ("clock.fill", "Recent Searches", "3 recent places"),
        ("star.fill", "Favorites", "Home, Work, Gym"),
        ("map.fill", "Offline Maps", "2 downloaded regions"),
    ]

    var body: some View {
        NavigationStack {
            List(items, id: \.1) { icon, title, subtitle in
                Label {
                    VStack(alignment: .leading) {
                        Text(title)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: icon)
                        .foregroundStyle(.green)
                }
            }
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    NavigationStack {
        SheetsAndModalsView()
    }
}

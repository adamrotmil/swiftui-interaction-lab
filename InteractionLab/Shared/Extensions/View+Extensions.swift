import SwiftUI

// MARK: - Debug Border

extension View {
    /// Adds a colored border around the view for layout debugging.
    /// Usage: `.debugBorder()` or `.debugBorder(color: .red)`
    func debugBorder(color: Color = .red, width: CGFloat = 1) -> some View {
        self.border(color, width: width)
    }
}

// MARK: - First Appear Modifier

/// A view modifier that executes a closure only on the first appearance.
/// Unlike `.onAppear`, this won't re-fire when the view reappears
/// after being off-screen (e.g., in a NavigationStack).
struct FirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                action()
            }
    }
}

extension View {
    /// Runs a closure only on the first appearance of this view.
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(action: action))
    }
}

// MARK: - Conditional Modifier

extension View {
    /// Applies a modifier conditionally.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Section Header Style

extension View {
    /// Styles a text view as an experiment section header.
    func experimentHeader() -> some View {
        self
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 4)
    }

    /// Styles a text view as an experiment description.
    func experimentDescription() -> some View {
        self
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 16)
    }
}

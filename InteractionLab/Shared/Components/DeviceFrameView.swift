import SwiftUI

// MARK: - Device Type

/// Represents the device form factors available for previewing experiments.
enum DeviceType: String, CaseIterable, Identifiable {
    case iPhone = "iPhone"
    case iPad = "iPad"
    case mac = "Mac"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .iPhone: return "iphone"
        case .iPad: return "ipad"
        case .mac: return "macwindow"
        }
    }

    /// Logical screen size (points) for the device frame
    var screenSize: CGSize {
        switch self {
        case .iPhone: return CGSize(width: 393, height: 852)   // iPhone 15 Pro
        case .iPad: return CGSize(width: 820, height: 1180)    // iPad Air
        case .mac: return CGSize(width: 1280, height: 800)     // MacBook Air
        }
    }

    /// Corner radius of the device screen
    var screenCornerRadius: CGFloat {
        switch self {
        case .iPhone: return 47
        case .iPad: return 18
        case .mac: return 10
        }
    }

    /// Bezel width around the screen
    var bezelWidth: CGFloat {
        switch self {
        case .iPhone: return 12
        case .iPad: return 16
        case .mac: return 0  // Mac uses a window chrome instead
        }
    }
}


// MARK: - Device Frame View

/// Wraps any SwiftUI content in a realistic device mockup frame.
/// The content is scaled to fit within the available space while
/// maintaining the device's aspect ratio.
struct DeviceFrameView<Content: View>: View {
    let deviceType: DeviceType
    let content: Content

    init(deviceType: DeviceType, @ViewBuilder content: () -> Content) {
        self.deviceType = deviceType
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            let scale = calculateScale(in: geometry.size)
            let frameSize = CGSize(
                width: deviceType.screenSize.width * scale,
                height: deviceType.screenSize.height * scale
            )

            HStack {
                Spacer()
                VStack {
                    Spacer()

                    Group {
                        switch deviceType {
                        case .iPhone:
                            iPhoneFrame(size: frameSize, scale: scale)
                        case .iPad:
                            iPadFrame(size: frameSize, scale: scale)
                        case .mac:
                            macFrame(size: frameSize, scale: scale)
                        }
                    }

                    Spacer()
                }
                Spacer()
            }
        }
    }

    // MARK: - Scale Calculation

    private func calculateScale(in availableSize: CGSize) -> CGFloat {
        let padding: CGFloat = 40
        let availableWidth = availableSize.width - padding
        let availableHeight = availableSize.height - padding

        // For Mac, account for title bar
        let totalHeight = deviceType == .mac
            ? deviceType.screenSize.height + 38
            : deviceType.screenSize.height + (deviceType.bezelWidth * 2)
        let totalWidth = deviceType.screenSize.width + (deviceType.bezelWidth * 2)

        let scaleX = availableWidth / totalWidth
        let scaleY = availableHeight / totalHeight

        return min(scaleX, scaleY, 1.0) // Never scale above 1x
    }

    // MARK: - iPhone Frame

    private func iPhoneFrame(size: CGSize, scale: CGFloat) -> some View {
        ZStack {
            // Outer device shell
            RoundedRectangle(cornerRadius: (deviceType.screenCornerRadius + deviceType.bezelWidth) * scale)
                .fill(Color(white: 0.15))
                .frame(
                    width: size.width + (deviceType.bezelWidth * 2 * scale),
                    height: size.height + (deviceType.bezelWidth * 2 * scale)
                )

            // Screen area
            RoundedRectangle(cornerRadius: deviceType.screenCornerRadius * scale)
                .fill(Color(white: 0.98))
                .frame(width: size.width, height: size.height)

            // Content
            content
                .frame(width: deviceType.screenSize.width, height: deviceType.screenSize.height)
                .scaleEffect(scale)
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: deviceType.screenCornerRadius * scale))

            // Dynamic Island
            Capsule()
                .fill(Color.black)
                .frame(width: 126 * scale, height: 37 * scale)
                .offset(y: -(size.height / 2) + (60 * scale))
        }
    }

    // MARK: - iPad Frame

    private func iPadFrame(size: CGSize, scale: CGFloat) -> some View {
        ZStack {
            // Outer device shell
            RoundedRectangle(cornerRadius: (deviceType.screenCornerRadius + deviceType.bezelWidth) * scale)
                .fill(Color(white: 0.2))
                .frame(
                    width: size.width + (deviceType.bezelWidth * 2 * scale),
                    height: size.height + (deviceType.bezelWidth * 2 * scale)
                )

            // Screen area
            RoundedRectangle(cornerRadius: deviceType.screenCornerRadius * scale)
                .fill(Color(white: 0.98))
                .frame(width: size.width, height: size.height)

            // Content
            content
                .frame(width: deviceType.screenSize.width, height: deviceType.screenSize.height)
                .scaleEffect(scale)
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: deviceType.screenCornerRadius * scale))

            // Front camera dot
            Circle()
                .fill(Color(white: 0.25))
                .frame(width: 8 * scale, height: 8 * scale)
                .offset(y: -(size.height / 2) - (deviceType.bezelWidth * 0.5 * scale))
        }
    }

    // MARK: - Mac Frame

    private func macFrame(size: CGSize, scale: CGFloat) -> some View {
        let titleBarHeight: CGFloat = 38 * scale

        return VStack(spacing: 0) {
            // Title bar
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)

                HStack(spacing: 8 * scale) {
                    Circle().fill(Color.red.opacity(0.9)).frame(width: 12 * scale, height: 12 * scale)
                    Circle().fill(Color.yellow.opacity(0.9)).frame(width: 12 * scale, height: 12 * scale)
                    Circle().fill(Color.green.opacity(0.9)).frame(width: 12 * scale, height: 12 * scale)
                    Spacer()
                    Text("Interaction Lab")
                        .font(.system(size: 13 * scale, weight: .medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    // Balance the traffic lights
                    Color.clear.frame(width: 52 * scale, height: 12 * scale)
                }
                .padding(.horizontal, 14 * scale)
            }
            .frame(width: size.width, height: titleBarHeight)

            // Content area
            ZStack {
                Rectangle()
                    .fill(Color(white: 0.98))

                content
                    .frame(width: deviceType.screenSize.width, height: deviceType.screenSize.height)
                    .scaleEffect(scale)
                    .frame(width: size.width, height: size.height)
            }
            .frame(width: size.width, height: size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: deviceType.screenCornerRadius * scale))
        .overlay(
            RoundedRectangle(cornerRadius: deviceType.screenCornerRadius * scale)
                .stroke(Color(white: 0.7), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
    }
}


// MARK: - Device Frame Picker

/// A segmented control for selecting the device preview frame.
struct DeviceFramePicker: View {
    @Binding var selectedDevice: DeviceType

    var body: some View {
        Picker("Device", selection: $selectedDevice) {
            ForEach(DeviceType.allCases) { device in
                Label(device.rawValue, systemImage: device.icon)
                    .tag(device)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 300)
    }
}


// MARK: - Preview

#Preview("iPhone Frame") {
    DeviceFrameView(deviceType: .iPhone) {
        VStack {
            Text("Hello, iPhone!")
                .font(.largeTitle)
            Text("This is a preview inside a device frame")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.1))
    }
    .padding()
}

#Preview("Device Picker") {
    struct PickerDemo: View {
        @State private var device: DeviceType = .iPhone
        var body: some View {
            VStack(spacing: 20) {
                DeviceFramePicker(selectedDevice: $device)
                    .padding(.horizontal)

                DeviceFrameView(deviceType: device) {
                    VStack(spacing: 12) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)
                        Text("Experiment Preview")
                            .font(.title2.bold())
                        Text("Device: \(device.rawValue)")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
            }
            .padding()
        }
    }
    return PickerDemo()
}

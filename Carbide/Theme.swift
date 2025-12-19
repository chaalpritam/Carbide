
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum Theme {
    static let primary = Color(hex: "4285F4") // Google Blue
    static let secondary = Color(hex: "EA4335") // Google Red
    static let tertiary = Color(hex: "FBBC05") // Google Yellow
    static let quaternary = Color(hex: "34A853") // Google Green
    
    static let background = Color(hex: "F8F9FA")
    static let surface = Color.white
    static let surfaceSecondary = Color(hex: "F1F3F4")
    
    static let textMain = Color(hex: "202124")
    static let textSecondary = Color(hex: "5F6368")
    
    static let cardShadow = Color.black.opacity(0.05)
    static let cardRadius: CGFloat = 16
    
    static func glassmorphic(opacity: CGFloat = 0.7) -> AnyView {
        #if os(iOS)
        return AnyView(
            VisualEffectView(effect: .systemUltraThinMaterial)
                .opacity(opacity)
        )
        #elseif os(macOS)
        return AnyView(
            VisualEffectView(material: .headerView)
                .opacity(opacity)
        )
        #else
        return AnyView(Color.white.opacity(opacity))
        #endif
    }
}

#if os(iOS)
struct VisualEffectView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: effect))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: effect)
    }
}
#elseif os(macOS)
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .withinWindow
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
    }
}
#endif

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

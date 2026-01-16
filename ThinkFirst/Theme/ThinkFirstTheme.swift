//
//  ThinkFirstTheme.swift
//  ThinkFirst
//
//  Dark Focus design system
//

import SwiftUI

struct ThinkFirstTheme {
    // MARK: - Colors (Dark Focus Aesthetic)
    struct Colors {
        // Backgrounds
        static let voidGrey = Color(hex: "#121212")
        static let pureBlack = Color(hex: "#000000")
        static let surfaceGlass = Color(red: 20/255, green: 20/255, blue: 20/255, opacity: 0.95)
        
        // Text
        static let ghostWhite = Color(hex: "#EDEDED")
        static let textSecondary = Color.white.opacity(0.7)
        static let textTertiary = Color.white.opacity(0.5)
        
        // Accents
        static let electricViolet = Color(hex: "#8B5CF6")
        static let cyberMint = Color(hex: "#00FF94")
        static let safetyOrange = Color(hex: "#FF5F1F")
        static let electricPurple = Color(hex: "#8A2BE2")
        static let cyan = Color(hex: "#22D3EE")
        
        // Status
        static let success = Color(hex: "#10B981")
        static let warning = Color(hex: "#F59E0B")
        static let error = Color(hex: "#EF4444")
        
        // Family/Gold
        static let gold = Color(hex: "#FFBF00")
        static let amber = Color(hex: "#FF8C00")
        
        // Glassmorphism border
        static let glassBorder = Color.white.opacity(0.1)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title1 = Font.system(size: 28, weight: .bold)
        static let title2 = Font.system(size: 22, weight: .semibold)
        static let title3 = Font.system(size: 20, weight: .semibold)
        static let headline = Font.system(size: 17, weight: .semibold)
        static let body = Font.system(size: 17, weight: .regular)
        static let callout = Font.system(size: 16, weight: .regular)
        static let subheadline = Font.system(size: 15, weight: .regular)
        static let footnote = Font.system(size: 13, weight: .regular)
        static let caption = Font.system(size: 12, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
    }
    
    // MARK: - Animation Durations
    struct Animation {
        static let fast: Double = 0.15
        static let standard: Double = 0.22
        static let slow: Double = 0.3
        static let unlock: Double = 0.3
    }
}

// MARK: - Color Extension for Hex
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
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers
struct GlassmorphicCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ThinkFirstTheme.Colors.surfaceGlass)
            .overlay(
                RoundedRectangle(cornerRadius: ThinkFirstTheme.CornerRadius.medium)
                    .stroke(ThinkFirstTheme.Colors.glassBorder, lineWidth: 1)
            )
            .cornerRadius(ThinkFirstTheme.CornerRadius.medium)
            .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

extension View {
    func glassmorphicCard() -> some View {
        modifier(GlassmorphicCard())
    }
}

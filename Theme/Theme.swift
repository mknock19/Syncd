import SwiftUI

// MARK: - SYNC'D Design System
// "Girly Pop" aesthetic with rounded corners, soft shadows, and vibrant colors

struct SyncdTheme {
    
    // MARK: - Color Palette (from reference image)
    struct Colors {
        // Backgrounds
        static let backgroundPrimary = Color(hex: "FDF8F5")      // Off-white/cream
        static let backgroundSecondary = Color(hex: "F5EDE8")    // Pale pinkish-white
        static let backgroundSage = Color(hex: "B8D4C8")         // Sage green (for sections)
        static let backgroundPeach = Color(hex: "FFDAB3")        // Light peach (for sections)
        static let backgroundLavender = Color(hex: "C9B8D9")     // Lavender (for tip cards)
        
        // Primary Accents
        static let coral = Color(hex: "FF7F6E")                  // Bright coral (buttons, danger)
        static let hotPink = Color(hex: "FF6B9D")                // Hot pink (active states)
        
        // Secondary Accents
        static let lavender = Color(hex: "C9B8D9")               // Lavender (tags)
        static let mutedOrange = Color(hex: "FFCB99")            // Muted orange (highlights)
        
        // Safety Score Colors
        static let safeGreen = Color(hex: "B8D4C8")              // Sage green (safe/clean)
        static let cautionYellow = Color(hex: "FFDAB3")          // Peach (moderate)
        static let dangerCoral = Color(hex: "FF7F6E")            // Coral (toxic/danger)
        
        // Text Colors (using deep plum/brown instead of pure black)
        static let textPrimary = Color(hex: "4A3728")            // Dark brown
        static let textSecondary = Color(hex: "6B5B4F")          // Medium brown
        static let textPlum = Color(hex: "5C3D5E")               // Deep plum
        static let textMuted = Color(hex: "9A8A7C")              // Muted brown
        
        // UI Elements
        static let cardBackground = Color.white
        static let divider = Color(hex: "E8DDD5")
        static let tabBarBackground = Color.white
        static let tabBarInactive = Color(hex: "9A8A7C")
        static let tabBarActive = Color(hex: "FF6B9D")           // Hot pink
    }
    
    // MARK: - Typography (SF Rounded)
    struct Typography {
        static func largeTitle() -> Font {
            .system(size: 34, weight: .bold, design: .rounded)
        }
        
        static func title() -> Font {
            .system(size: 28, weight: .bold, design: .rounded)
        }
        
        static func title2() -> Font {
            .system(size: 22, weight: .semibold, design: .rounded)
        }
        
        static func title3() -> Font {
            .system(size: 20, weight: .semibold, design: .rounded)
        }
        
        static func headline() -> Font {
            .system(size: 17, weight: .semibold, design: .rounded)
        }
        
        static func body() -> Font {
            .system(size: 17, weight: .regular, design: .rounded)
        }
        
        static func callout() -> Font {
            .system(size: 16, weight: .regular, design: .rounded)
        }
        
        static func subheadline() -> Font {
            .system(size: 15, weight: .regular, design: .rounded)
        }
        
        static func footnote() -> Font {
            .system(size: 13, weight: .regular, design: .rounded)
        }
        
        static func caption() -> Font {
            .system(size: 12, weight: .regular, design: .rounded)
        }
    }
    
    // MARK: - Component Styles
    struct Styles {
        // Corner radius (30px+ for "girly pop" aesthetic)
        static let cornerRadiusSmall: CGFloat = 16
        static let cornerRadiusMedium: CGFloat = 24
        static let cornerRadiusLarge: CGFloat = 32
        
        // Shadows
        static let shadowColor = Color.black.opacity(0.08)
        static let shadowRadius: CGFloat = 12
        static let shadowY: CGFloat = 4
        
        // Card styling
        static func cardShadow() -> some View {
            EmptyView()
        }
    }
}

// MARK: - Color Extension for Hex Support
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
            (a, r, g, b) = (255, 0, 0, 0)
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

// MARK: - View Modifiers
struct SyncdCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(SyncdTheme.Colors.cardBackground)
            .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
            .shadow(
                color: SyncdTheme.Styles.shadowColor,
                radius: SyncdTheme.Styles.shadowRadius,
                x: 0,
                y: SyncdTheme.Styles.shadowY
            )
    }
}

struct GlassmorphismStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
    }
}

extension View {
    func syncdCard() -> some View {
        modifier(SyncdCardStyle())
    }
    
    func glassmorphism() -> some View {
        modifier(GlassmorphismStyle())
    }
}

// MARK: - Score Color Helper
extension SyncdTheme {
    static func scoreColor(for score: Int) -> Color {
        switch score {
        case 70...100:
            return Colors.safeGreen
        case 40..<70:
            return Colors.cautionYellow
        default:
            return Colors.dangerCoral
        }
    }
    
    static func scoreLabel(for score: Int) -> String {
        switch score {
        case 80...100:
            return "Clean & Safe"
        case 70..<80:
            return "Mostly Clean"
        case 50..<70:
            return "Use Caution"
        case 30..<50:
            return "Concerning"
        default:
            return "Avoid"
        }
    }
}

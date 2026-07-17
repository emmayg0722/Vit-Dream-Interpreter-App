import SwiftUI

/// Design tokens for the "night garden" system (PDD 9.3).
/// Canonical values come from `design/prototype.jsx` — do not restyle.
enum Tokens {

    // MARK: Ink (text)

    /// Primary text `#F4F1FF`.
    static let ink = Color(hex: 0xF4F1FF)
    /// Secondary text — ink at 64%.
    static let inkSoft = ink.opacity(0.64)
    /// Tertiary text — ink at 40%.
    static let inkFaint = ink.opacity(0.40)

    // MARK: Accents

    static let lavender = Color(hex: 0xB9A8F7)
    static let teal = Color(hex: 0x8FE3D2)
    static let rose = Color(hex: 0xEEA7C4)
    static let peach = Color(hex: 0xF2B8A2)

    // MARK: Background

    /// Night-sky gradient stops, top → bottom (prototype: 175°).
    static let backgroundTop = Color(hex: 0x0B0A1E)
    static let backgroundMid = Color(hex: 0x171233)
    static let backgroundBottom = Color(hex: 0x221A44)

    /// The base screen gradient. Prototype's 175° ≈ vertical with a slight tilt.
    static let backgroundGradient = LinearGradient(
        stops: [
            .init(color: backgroundTop, location: 0.0),
            .init(color: backgroundMid, location: 0.48),
            .init(color: backgroundBottom, location: 1.0),
        ],
        startPoint: UnitPoint(x: 0.54, y: 0),
        endPoint: UnitPoint(x: 0.46, y: 1)
    )

    /// Aurora glow colors (used at low opacity in `AuroraBackground`).
    static let glowLavender = Color(hex: 0x7C6AE8)
    static let glowTeal = teal
    static let glowRose = rose

    // MARK: Lens colors (PDD 9.3)

    static let lensZhougong = peach
    static let lensFreud = rose
    static let lensJung = lavender
    static let lensNeuro = teal
    static let lensCulture = Color(hex: 0xA8C7F5)
    static let lensSpirit = Color(hex: 0xF5DFA8)

    /// Tone-chip palette (prototype `RESULT.tones`), cycled by index since
    /// the wire contract carries only labels (PDD 7.3 `Reading.tones: [String]`).
    static let toneColors: [Color] = [lavender, rose, teal, peach]

    static func toneColor(at index: Int) -> Color {
        toneColors[index % toneColors.count]
    }

    static func color(for lens: Lens) -> Color {
        switch lens {
        case .zhougong: lensZhougong
        case .freud: lensFreud
        case .jung: lensJung
        case .neuro: lensNeuro
        case .culture: lensCulture
        case .spirit: lensSpirit
        }
    }

    // MARK: Glass surface (prototype `glass()`)

    enum Glass {
        /// White 6.5% fill over the blur material.
        static let fill = Color.white.opacity(0.065)
        /// White 14% hairline border.
        static let stroke = Color.white.opacity(0.14)
        /// Inner top highlight (prototype: inset 0 1px white 8%).
        static let innerHighlight = Color.white.opacity(0.08)
        /// Drop shadow `rgba(6,4,22,0.35)`.
        static let shadow = Color(hex: 0x060416).opacity(0.35)
        static let shadowRadius: CGFloat = 16
        static let shadowY: CGFloat = 8
        static let cornerRadius: CGFloat = 24
        /// Denser variant used by the tab bar / floating chrome `rgba(20,16,42,…)`.
        static let chromeFill = Color(hex: 0x14102A)
    }

    // MARK: Primary CTA

    /// Gradient capsule `#CFC2FA → #9FE8D8`; one accent action per screen.
    static let ctaGradient = LinearGradient(
        colors: [Color(hex: 0xCFC2FA), Color(hex: 0x9FE8D8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    /// Dark ink used on the CTA gradient `#171233`.
    static let ctaInk = backgroundMid

    // MARK: Motion (PDD 9.3 — everything stills under Reduce Motion)

    enum Motion {
        /// Orb breathe cycle.
        static let breathe: Double = 4.5
        /// Screen transition fade+rise.
        static let transition: Double = 0.42
        /// Aurora drift cycles (three glows drift at different speeds).
        static let drifts: [Double] = [16, 19, 22]
    }
}

extension Color {
    /// Color from a 24-bit RGB hex literal, e.g. `Color(hex: 0xB9A8F7)`.
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

import SwiftUI

/// The breathing orb: radial-gradient sphere + pulsing halo ring
/// (prototype `Orb`). Motion stops entirely under Reduce Motion (NFR-004).
struct OrbView: View {
    var size: CGFloat = 120
    var breathing: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animate = false

    private var isBreathing: Bool { breathing && !reduceMotion }

    var body: some View {
        ZStack {
            // Outer halo ring, inset -18 in the prototype (≈ 16% of a 110pt orb).
            Circle()
                .strokeBorder(Color.white.opacity(0.10), lineWidth: 1)
                .frame(width: size + size * 0.327, height: size + size * 0.327)
                .scaleEffect(animate ? 1.12 : 1.0)
                .opacity(animate ? 0.15 : 0.6)

            // The sphere itself.
            Circle()
                .fill(
                    RadialGradient(
                        stops: [
                            .init(color: .white.opacity(0.55), location: 0.0),
                            .init(color: Tokens.lavender.opacity(0.55), location: 0.32),
                            .init(color: Tokens.teal.opacity(0.35), location: 0.62),
                            .init(color: Tokens.rose.opacity(0.28), location: 1.0),
                        ],
                        center: UnitPoint(x: 0.32, y: 0.30),
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .blur(radius: 1)
                .shadow(color: Tokens.lavender.opacity(0.45), radius: 30)
                .shadow(color: Tokens.teal.opacity(0.18), radius: 60)
        }
        .scaleEffect(animate ? 1.06 : 1.0)
        .animation(
            isBreathing
                ? .easeInOut(duration: Tokens.Motion.breathe).repeatForever(autoreverses: true)
                : .default,
            value: animate
        )
        .onAppear { animate = isBreathing }
        .onChange(of: reduceMotion) { _, _ in animate = isBreathing }
        .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        OrbView(size: 140)
    }
}

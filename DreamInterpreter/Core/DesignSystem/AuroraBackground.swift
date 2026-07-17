import SwiftUI

/// Full-screen night-garden backdrop: the 175° night-sky gradient with three
/// slowly drifting aurora glows and faint stars (prototype "Aurora atmosphere").
/// Drift stops entirely under Reduce Motion (NFR-004).
struct AuroraBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drifting = false

    /// Star positions as fractions of the screen (from the prototype).
    private static let stars: [UnitPoint] = [
        UnitPoint(x: 0.12, y: 0.18), UnitPoint(x: 0.78, y: 0.09),
        UnitPoint(x: 0.64, y: 0.30), UnitPoint(x: 0.22, y: 0.44),
        UnitPoint(x: 0.88, y: 0.52), UnitPoint(x: 0.34, y: 0.70),
        UnitPoint(x: 0.70, y: 0.82), UnitPoint(x: 0.10, y: 0.88),
    ]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Tokens.backgroundGradient

                // Aurora glows — position/size/opacity per prototype.
                glow(Tokens.glowLavender, opacity: 0.34, diameter: 320, blur: 38,
                     x: -0.22 * size.width, y: -0.08 * size.height,
                     drift: CGSize(width: 30, height: -24), duration: Tokens.Motion.drifts[0])
                glow(Tokens.glowTeal, opacity: 0.20, diameter: 300, blur: 42,
                     x: size.width * 1.26 - 300, y: 0.26 * size.height,
                     drift: CGSize(width: -26, height: 20), duration: Tokens.Motion.drifts[1])
                glow(Tokens.glowRose, opacity: 0.16, diameter: 280, blur: 44,
                     x: 0.08 * size.width, y: size.height * 1.06 - 280,
                     drift: CGSize(width: 30, height: -24), duration: Tokens.Motion.drifts[2])

                // Faint stars.
                ForEach(Array(Self.stars.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 2, height: 2)
                        .opacity(0.5)
                        .position(x: point.x * size.width, y: point.y * size.height)
                }
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
        .onAppear {
            guard !reduceMotion else { return }
            drifting = true
        }
        .onChange(of: reduceMotion) { _, newValue in
            drifting = !newValue
        }
    }

    /// One blurred radial glow, drifting between its rest and offset positions.
    private func glow(
        _ color: Color, opacity: Double, diameter: CGFloat, blur: CGFloat,
        x: CGFloat, y: CGFloat, drift: CGSize, duration: Double
    ) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color.opacity(opacity), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: diameter * 0.68 / 2
                )
            )
            .frame(width: diameter, height: diameter)
            .blur(radius: blur)
            .offset(
                x: x + (drifting ? drift.width : 0),
                y: y + (drifting ? drift.height : 0)
            )
            .animation(
                drifting
                    ? .easeInOut(duration: duration / 2).repeatForever(autoreverses: true)
                    : .default,
                value: drifting
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    AuroraBackground()
}

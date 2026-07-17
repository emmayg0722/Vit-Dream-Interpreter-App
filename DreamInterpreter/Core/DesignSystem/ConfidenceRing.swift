import SwiftUI

/// Circular progress ring showing interpretation confidence (prototype
/// `ConfidenceRing`): lavender→teal gradient stroke over a faint track,
/// animating to value on appear.
struct ConfidenceRing: View {
    var value: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animatedFraction: CGFloat = 0

    private let diameter: CGFloat = 88
    private let lineWidth: CGFloat = 7

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.10), lineWidth: lineWidth)

            // Diagonal gradient (prototype: linearGradient x1=0,y1=0 x2=1,y2=1),
            // fixed to the ring's bounding box rather than following the arc.
            Circle()
                .trim(from: 0, to: animatedFraction)
                .stroke(
                    LinearGradient(
                        colors: [Tokens.lavender, Tokens.teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 0) {
                Text("\(value)%")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Tokens.ink)
                Text("confidence")
                    .font(.system(size: 9.5))
                    .tracking(0.6)
                    .foregroundStyle(Tokens.inkFaint)
            }
        }
        .frame(width: diameter, height: diameter)
        .onAppear { setFraction(animated: !reduceMotion) }
        .onChange(of: value) { _, _ in setFraction(animated: !reduceMotion) }
        .accessibilityElement()
        .accessibilityLabel("Interpretation confidence \(value) percent")
    }

    private func setFraction(animated: Bool) {
        let target = CGFloat(value) / 100
        if animated {
            withAnimation(.timingCurve(0.22, 1, 0.36, 1, duration: 1.4)) {
                animatedFraction = target
            }
        } else {
            animatedFraction = target
        }
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        ConfidenceRing(value: 78)
    }
}

import SwiftUI

/// Staged progress while the interpretation request is in flight
/// (prototype `AnalyzingScreen`, NFR-002). Steps advance on a timer and
/// hold on the last one until the request resolves; the view itself owns
/// no request state (PDD 7.5).
struct AnalyzingView: View {
    private static let steps = [
        "Listening to the dream…",
        "Consulting six traditions…",
        "Weighing perspectives…",
        "Composing your reading…",
    ]
    private static let stepInterval: Duration = .seconds(1.8)

    @State private var stepIndex = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            OrbView(size: 140)
            Text(Self.steps[stepIndex])
                .font(.system(size: 15.5, weight: .medium))
                .foregroundStyle(Tokens.ink)
                .padding(.top, 34)
                .contentTransition(.opacity)

            HStack(spacing: 6) {
                ForEach(Self.steps.indices, id: \.self) { index in
                    Capsule()
                        .fill(
                            index <= stepIndex
                                ? Tokens.lavender
                                : Color.white.opacity(0.14)
                        )
                        .frame(width: index == stepIndex ? 18 : 6, height: 6)
                }
            }
            .padding(.top, 14)
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.updatesFrequently)
        .task {
            while stepIndex < Self.steps.count - 1 {
                try? await Task.sleep(for: Self.stepInterval)
                guard !Task.isCancelled else { return }
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.3)) {
                    stepIndex += 1
                }
            }
        }
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        AnalyzingView()
    }
}

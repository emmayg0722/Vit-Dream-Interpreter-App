import SwiftUI

/// A small labeled pill with a color dot (prototype's generic `Chip`),
/// used for emotional tone chips and similar tags.
struct ToneChip: View {
    var label: String
    var color: Color

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(label)
                .font(.system(size: 12.5, weight: .medium))
                .foregroundStyle(Tokens.ink)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.07), in: Capsule())
        .overlay(Capsule().strokeBorder(Tokens.Glass.stroke, lineWidth: 1))
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        ToneChip(label: "Anticipation", color: Tokens.lavender)
    }
}

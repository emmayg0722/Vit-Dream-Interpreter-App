import SwiftUI

/// Stacked segments showing each lens's weight, with a color-keyed legend
/// below (prototype "contribution bar"). Segments sum to 100% because
/// `ReadingDTO.decode` normalizes weights at parse time (PDD 7.5, FR-006).
struct ContributionBar: View {
    var lenses: [LensReadingDTO]

    private var accessibilitySummary: String {
        lenses.map { "\($0.lens.displayName) \($0.weight) percent" }.joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    ForEach(lenses, id: \.lens) { lensReading in
                        Rectangle()
                            .fill(Tokens.color(for: lensReading.lens).opacity(0.85))
                            .frame(width: proxy.size.width * CGFloat(lensReading.weight) / 100)
                    }
                }
            }
            .frame(height: 14)
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(Tokens.Glass.stroke, lineWidth: 1))
            .accessibilityElement()
            .accessibilityLabel("Contribution of each perspective to the final interpretation")
            .accessibilityValue(accessibilitySummary)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 92), spacing: 14)],
                alignment: .leading,
                spacing: 8
            ) {
                ForEach(lenses, id: \.lens) { lensReading in
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Tokens.color(for: lensReading.lens))
                            .frame(width: 8, height: 8)
                        Text("\(lensReading.lens.shortLabel) \(lensReading.weight)%")
                            .font(.system(size: 11.5))
                            .foregroundStyle(Tokens.inkSoft)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        GlassCard {
            ContributionBar(lenses: SampleDream.reading.lenses)
        }
        .padding(24)
    }
}

import SwiftUI

/// Reading-screen presentation metadata for each lens (display name, tag,
/// icon). Kept out of Core/Models so the wire contract stays UI-agnostic;
/// values are copied verbatim from `design/prototype.jsx` PERSPECTIVES.
extension Lens {
    var displayName: String {
        switch self {
        case .zhougong: "Zhougong (周公解梦)"
        case .freud: "Freudian"
        case .jung: "Jungian"
        case .neuro: "Neuroscience"
        case .culture: "Cultural symbolism"
        case .spirit: "Spiritual"
        }
    }

    var tag: String {
        switch self {
        case .zhougong: "Classical Chinese"
        case .freud: "Psychoanalysis"
        case .jung: "Analytical psychology"
        case .neuro: "Modern research"
        case .culture: "Cross-cultural"
        case .spirit: "Contemplative"
        }
    }

    /// First word of `displayName`, used in the contribution bar legend.
    var shortLabel: String {
        displayName.split(separator: " ").first.map(String.init) ?? displayName
    }

    /// SF Symbol standing in for the prototype's lucide-react icon.
    var symbolName: String {
        switch self {
        case .zhougong: "scroll"
        case .freud: "quote.bubble"
        case .jung: "theatermasks"
        case .neuro: "brain.head.profile"
        case .culture: "globe.asia.australia"
        case .spirit: "sun.max"
        }
    }
}

/// One expandable lens card (prototype `PerspectiveCard`): icon + name + tag
/// + weight, expanding to the full interpretation and a "Contributed" callout.
/// Only one card is expanded at a time (PDD 9.2), driven by the parent.
struct LensCard: View {
    var lensReading: LensReadingDTO
    var isExpanded: Bool
    var onToggle: () -> Void

    private var color: Color { Tokens.color(for: lensReading.lens) }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(color.opacity(0.13))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(color.opacity(0.33), lineWidth: 1)
                            )
                        Image(systemName: lensReading.lens.symbolName)
                            .font(.system(size: 16))
                            .foregroundStyle(color)
                    }
                    .frame(width: 38, height: 38)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(lensReading.lens.displayName)
                            .font(.system(size: 14.5, weight: .semibold))
                            .foregroundStyle(Tokens.ink)
                        Text("\(lensReading.lens.tag) · \(lensReading.weight)% weight")
                            .font(.system(size: 12))
                            .foregroundStyle(Tokens.inkFaint)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Tokens.inkFaint)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(minHeight: 56)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityAddTraits(.isButton)
            .accessibilityValue(isExpanded ? "Expanded" : "Collapsed")

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Text(lensReading.full)
                        .font(.system(size: 13.5))
                        .foregroundStyle(Tokens.inkSoft)
                        .lineSpacing(4)

                    (
                        Text("Contributed: ").fontWeight(.semibold).foregroundStyle(Tokens.ink)
                        + Text(lensReading.contributed).foregroundStyle(Tokens.ink)
                    )
                    .font(.system(size: 12.5))
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(color.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            } else {
                Text(lensReading.short)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Tokens.inkSoft)
                    .lineSpacing(3)
                    .padding(.leading, 66)
                    .padding(.trailing, 16)
                    .padding(.bottom, 14)
            }
        }
        .glassCard(cornerRadius: 20)
        .animation(.easeInOut(duration: 0.32), value: isExpanded)
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        LensCard(
            lensReading: SampleDream.reading.lenses[2],
            isExpanded: true,
            onToggle: {}
        )
        .padding(24)
    }
}

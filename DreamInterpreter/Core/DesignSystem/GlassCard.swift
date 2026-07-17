import SwiftUI

/// The prototype's `glass()` surface: blur, white 6.5% fill, white 14% hairline,
/// inner top highlight, soft drop shadow, radius 24 (PDD 9.3).
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = Tokens.Glass.cornerRadius

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background {
                shape
                    .fill(.ultraThinMaterial)
                    .overlay(shape.fill(Tokens.Glass.fill))
                    .overlay {
                        // Inner top highlight: inset 0 1px 0 white 8%.
                        shape
                            .stroke(
                                LinearGradient(
                                    colors: [Tokens.Glass.innerHighlight, .clear],
                                    startPoint: .top,
                                    endPoint: .center
                                ),
                                lineWidth: 1
                            )
                            .padding(1)
                    }
                    .overlay(shape.strokeBorder(Tokens.Glass.stroke, lineWidth: 1))
                    .shadow(
                        color: Tokens.Glass.shadow,
                        radius: Tokens.Glass.shadowRadius,
                        y: Tokens.Glass.shadowY
                    )
            }
            .environment(\.colorScheme, .dark)
    }
}

extension View {
    /// Wraps the view in a night-garden glass surface.
    func glassCard(cornerRadius: CGFloat = Tokens.Glass.cornerRadius) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}

/// Container form for card-shaped content; pads by default like prototype cards.
struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = Tokens.Glass.cornerRadius
    var padding: CGFloat = 18
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .glassCard(cornerRadius: cornerRadius)
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Glass card")
                    .font(.headline)
                    .foregroundStyle(Tokens.ink)
                Text("White 6.5% fill · 14% hairline · radius 24 · blurred")
                    .font(.footnote)
                    .foregroundStyle(Tokens.inkSoft)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
    }
}

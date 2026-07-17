import SwiftUI

/// Development-only screen for TASK-002 validation: compare every token
/// against `design/prototype.jsx` side by side. Not linked from the app shell.
struct TokenPreview: View {
    var body: some View {
        ZStack {
            AuroraBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Night garden tokens")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Tokens.ink)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            row("ink", Tokens.ink)
                            row("inkSoft", Tokens.inkSoft)
                            row("inkFaint", Tokens.inkFaint)
                            Divider().overlay(Tokens.Glass.stroke)
                            row("lavender", Tokens.lavender)
                            row("teal", Tokens.teal)
                            row("rose", Tokens.rose)
                            row("peach", Tokens.peach)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Lens colors")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Tokens.inkSoft)
                            ForEach(Lens.allCases, id: \.self) { lens in
                                row(lens.rawValue, Tokens.color(for: lens))
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Dream text is set in serif, softly italic.")
                                .fontDesign(.serif)
                                .italic()
                                .foregroundStyle(Tokens.ink)
                            Text("UI copy is system sans.")
                                .font(.subheadline)
                                .foregroundStyle(Tokens.inkSoft)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                    } label: {
                        Text("Interpret this dream")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Tokens.ctaInk)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Tokens.ctaGradient, in: Capsule())
                    }
                }
                .padding(22)
                .padding(.bottom, 40)
            }
        }
    }

    private func row(_ name: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(color)
                .frame(width: 40, height: 22)
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(Tokens.Glass.stroke, lineWidth: 1)
                )
            Text(name)
                .font(.footnote.monospaced())
                .foregroundStyle(Tokens.inkSoft)
        }
    }
}

#Preview {
    TokenPreview()
}

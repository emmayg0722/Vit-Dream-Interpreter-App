import SwiftUI

/// Renders a `ReadingDTO` in full (prototype `ResultScreen`): the dream,
/// summary + confidence + tones, six expandable lenses, contribution bar,
/// synthesis, and the five closing sections (FR-004 through FR-007).
struct ReadingView: View {
    var dreamText: String
    var reading: ReadingDTO
    var onBack: (() -> Void)?

    @State private var viewModel = ReadingViewModel()
    @Environment(\.dismiss) private var dismiss

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()

    var body: some View {
        ZStack {
            AuroraBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    header
                    dreamCard
                    summaryCard
                    lensesSection
                    contributionCard
                    synthesisCard

                    sectionCard(title: "Main message") {
                        Text(reading.mainMessage)
                            .font(.system(size: 14.5))
                            .foregroundStyle(Tokens.ink)
                            .lineSpacing(5)
                    }

                    sectionCard(title: "Possible subconscious concerns") {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(reading.concerns.enumerated()), id: \.offset) { _, concern in
                                ConcernRow(text: concern)
                            }
                        }
                    }

                    sectionCard(title: "Opportunities & warnings") {
                        VStack(spacing: 10) {
                            ForEach(Array(reading.opportunities.enumerated()), id: \.offset) { _, item in
                                OpportunityRow(item: item)
                            }
                        }
                    }

                    sectionCard(title: "Questions for reflection") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(reading.questions.enumerated()), id: \.offset) { _, question in
                                Text(question)
                                    .font(.system(size: 14))
                                    .fontDesign(.serif)
                                    .italic()
                                    .foregroundStyle(Tokens.ink)
                                    .lineSpacing(4)
                            }
                        }
                    }

                    sectionCard(title: "Gentle actions · next few days") {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(reading.actions.enumerated()), id: \.offset) { index, action in
                                ActionRow(index: index + 1, text: action)
                            }
                        }
                    }

                    saveButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 60)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Button {
                if let onBack { onBack() } else { dismiss() }
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Tokens.inkSoft)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.07), in: Circle())
                    .overlay(Circle().strokeBorder(Tokens.Glass.stroke, lineWidth: 1))
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 1) {
                Text("Your reading")
                    .font(.system(size: 15.5, weight: .semibold))
                    .foregroundStyle(Tokens.ink)
                Text("\(Self.dateFormatter.string(from: .now)) · six perspectives")
                    .font(.system(size: 11.5))
                    .foregroundStyle(Tokens.inkFaint)
            }
            Spacer()
        }
        .padding(.top, 18)
    }

    private var dreamCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel("The dream")
                Text("\u{201C}\(dreamText)\u{201D}")
                    .font(.system(size: 15))
                    .fontDesign(.serif)
                    .italic()
                    .foregroundStyle(Tokens.ink)
                    .lineSpacing(6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var summaryCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 16) {
                    ConfidenceRing(value: reading.confidence)
                    Text(reading.summary)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Tokens.ink)
                        .lineSpacing(4)
                }
                VStack(alignment: .leading, spacing: 10) {
                    SectionLabel("Emotional tone detected")
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 80), spacing: 8)],
                        alignment: .leading,
                        spacing: 8
                    ) {
                        ForEach(Array(reading.tones.enumerated()), id: \.offset) { index, tone in
                            ToneChip(label: tone, color: Tokens.toneColor(at: index))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var lensesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionLabel("Six lenses")
            VStack(spacing: 10) {
                ForEach(reading.lenses, id: \.lens) { lensReading in
                    LensCard(
                        lensReading: lensReading,
                        isExpanded: viewModel.expandedLens == lensReading.lens,
                        onToggle: { viewModel.toggle(lensReading.lens) }
                    )
                }
            }
        }
        .padding(.top, 12)
    }

    private var contributionCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("How each lens shaped the conclusion")
                ContributionBar(lenses: reading.lenses)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var synthesisCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Tokens.lavender)
                Text("SYNTHESIS")
                    .font(.system(size: 13, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Tokens.ink)
            }
            Text(reading.synthesis)
                .font(.system(size: 14.5))
                .foregroundStyle(Tokens.ink)
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Tokens.lavender.opacity(0.14), Tokens.teal.opacity(0.10)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Glass.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Glass.cornerRadius, style: .continuous)
                .strokeBorder(Tokens.lavender.opacity(0.35), lineWidth: 1)
        )
        .padding(.top, 12)
    }

    private func sectionCard<Content: View>(
        title: String, @ViewBuilder content: () -> Content
    ) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel(title)
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var saveButton: some View {
        Button {
            viewModel.save()
        } label: {
            HStack(spacing: 8) {
                if viewModel.isSaved {
                    Image(systemName: "checkmark")
                    Text("Saved to journal")
                } else {
                    Text("Save to dream journal")
                }
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(viewModel.isSaved ? Tokens.teal : Tokens.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                viewModel.isSaved ? Tokens.teal.opacity(0.12) : Color.white.opacity(0.08),
                in: Capsule()
            )
            .overlay(
                Capsule().strokeBorder(
                    viewModel.isSaved ? Tokens.teal.opacity(0.5) : Tokens.Glass.stroke,
                    lineWidth: 1
                )
            )
        }
        .disabled(viewModel.isSaved)
        .padding(.top, 8)
    }
}

#Preview {
    ReadingView(dreamText: SampleDream.text, reading: SampleDream.reading)
}

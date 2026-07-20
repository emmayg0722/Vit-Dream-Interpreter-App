import SwiftUI

/// Tonight tab — dream capture screen (prototype `InputScreen`, PDD 2.3 step 1-2).
/// The sample dream shows its canned reading fully offline (FR-011); any other
/// text goes Capture → Analyzing → Reading through `InterpretationService`
/// (FR-003), with the draft preserved on any failure (PDD 2.4).
struct CaptureView: View {
    @State private var viewModel = CaptureViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            AuroraBackground()
            if viewModel.isAnalyzing {
                AnalyzingView()
                    .transition(.opacity)
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        header
                        dreamCard
                        if viewModel.text.isEmpty {
                            sampleDreamButton
                        }
                        interpretButton
                        Text("Reflections, not predictions · For self-exploration only")
                            .font(.system(size: 11.5))
                            .foregroundStyle(Tokens.inkFaint)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 36)
                    .padding(.bottom, 140)
                }
                .scrollDismissesKeyboard(.interactively)
                .transition(.opacity)
            }
        }
        .animation(
            reduceMotion ? nil : .easeOut(duration: Tokens.Motion.transition),
            value: viewModel.isAnalyzing
        )
        .fullScreenCover(item: $viewModel.presentedReading) { presented in
            ReadingView(dreamText: presented.dreamText, reading: presented.reading)
        }
        .sheet(isPresented: $viewModel.showingKeySheet) {
            APIKeySheet(keyStore: viewModel.keyStore) {
                viewModel.apiKeySaved()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            OrbView(size: 110)
                .padding(.bottom, 10)
            Text("Good morning")
                .font(.system(size: 26, weight: .semibold))
                .tracking(-0.2)
                .foregroundStyle(Tokens.ink)
            Text("What did you dream last night?")
                .font(.system(size: 14.5))
                .foregroundStyle(Tokens.inkSoft)
                .multilineTextAlignment(.center)
        }
    }

    private var dreamCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if viewModel.text.isEmpty {
                        Text("Describe your dream while it's still fresh…")
                            .font(.system(size: 15.5))
                            .fontDesign(.serif)
                            .italic()
                            .foregroundStyle(Tokens.inkFaint)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: $viewModel.text)
                        .font(.system(size: 15.5))
                        .fontDesign(.serif)
                        .foregroundStyle(Tokens.ink)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 150)
                        .focused($isTextFieldFocused)
                        .accessibilityLabel("Describe your dream")
                }

                HStack(alignment: .top) {
                    micButton
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(viewModel.text.count) chars")
                            .font(.system(size: 11.5))
                            .foregroundStyle(Tokens.inkFaint)
                        if viewModel.isOverSoftLimit {
                            Text("Long dream — a shorter version sends faster")
                                .font(.system(size: 10.5))
                                .foregroundStyle(Tokens.rose)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
        }
    }

    private var micButton: some View {
        Button {
            viewModel.toggleVoice()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 14))
                if viewModel.isListening {
                    HStack(spacing: 4) {
                        Text("Listening")
                        WaveformIndicator()
                    }
                } else {
                    Text("Speak instead")
                }
            }
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(viewModel.isListening ? Tokens.rose : Tokens.inkSoft)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(minHeight: 44)
            .background(
                Capsule().fill(
                    viewModel.isListening ? Tokens.rose.opacity(0.18) : Color.white.opacity(0.07)
                )
            )
            .overlay(
                Capsule().strokeBorder(
                    viewModel.isListening ? Tokens.rose.opacity(0.5) : Tokens.Glass.stroke,
                    lineWidth: 1
                )
            )
        }
        .accessibilityLabel(viewModel.isListening ? "Stop voice input" : "Start voice input")
    }

    private var sampleDreamButton: some View {
        Button {
            viewModel.loadSampleDream()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Tokens.lavender)
                (
                    Text("Try the sample dream — ").foregroundStyle(Tokens.inkSoft)
                    + Text("a giant mosquito at a park in Japan").foregroundStyle(Tokens.ink).italic()
                )
                .font(.system(size: 13))
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundStyle(Tokens.inkFaint)
            }
            .padding(14)
            .glassCard(cornerRadius: 18)
        }
        .accessibilityLabel("Try the sample dream, a giant mosquito at a park in Japan")
    }

    private var interpretButton: some View {
        VStack(spacing: 8) {
            Button {
                isTextFieldFocused = false
                viewModel.interpretTapped()
            } label: {
                Text("Interpret this dream")
                    .font(.system(size: 15.5, weight: .semibold))
                    .foregroundStyle(viewModel.canInterpret ? Tokens.ctaInk : Tokens.inkFaint)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        if viewModel.canInterpret {
                            Tokens.ctaGradient
                        } else {
                            Color.white.opacity(0.06)
                        }
                    }
                    .clipShape(Capsule())
                    .shadow(
                        color: viewModel.canInterpret ? Tokens.lavender.opacity(0.35) : .clear,
                        radius: 14, y: 6
                    )
            }
            .disabled(!viewModel.canInterpret)

            if !viewModel.text.isEmpty, !viewModel.canInterpret {
                Text("A few more words will help the reading.")
                    .font(.system(size: 11.5))
                    .foregroundStyle(Tokens.inkFaint)
            }

            if let errorMessage = viewModel.errorMessage {
                errorCard(message: errorMessage)
            }
        }
    }

    /// Calm failure state (PDD 2.4): the draft stays untouched, the CTA above
    /// remains the retry, and key problems offer the key sheet directly.
    private func errorCard(message: String) -> some View {
        VStack(spacing: 10) {
            Text(message)
                .font(.system(size: 13))
                .foregroundStyle(Tokens.inkSoft)
                .multilineTextAlignment(.center)
            if viewModel.errorIsKeyProblem {
                Button {
                    viewModel.showingKeySheet = true
                } label: {
                    Text("Update API key")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Tokens.lavender)
                        .frame(minHeight: 44)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 18)
        .transition(.opacity)
    }
}

/// Four animated bars for the mic button's "Listening" state
/// (prototype `wave` keyframes); freezes under Reduce Motion.
private struct WaveformIndicator: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animate = false

    var body: some View {
        HStack(spacing: 2.5) {
            ForEach(0..<4) { i in
                Capsule()
                    .fill(Tokens.rose)
                    .frame(width: 3, height: animate ? 14 : 5)
                    .animation(
                        reduceMotion
                            ? .default
                            : .easeInOut(duration: 0.9)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.12),
                        value: animate
                    )
            }
        }
        .accessibilityHidden(true)
        .onAppear { animate = !reduceMotion }
    }
}

#Preview {
    CaptureView()
}

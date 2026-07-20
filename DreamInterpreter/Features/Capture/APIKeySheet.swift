import SwiftUI

/// One-time setup for live interpretation (Q-001 interim decision): the user
/// pastes their own Anthropic API key, which goes to the device Keychain only
/// (PDD 10.2 — never the repo, binary, logs, or UserDefaults).
struct APIKeySheet: View {
    let keyStore: APIKeyStoring
    var onSaved: () -> Void = {}

    @State private var keyInput = ""
    @State private var hadExistingKey = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AuroraBackground()
            VStack(spacing: 18) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 36, height: 4)
                    .padding(.top, 10)

                VStack(spacing: 6) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Tokens.lavender)
                        .padding(.bottom, 4)
                    Text(hadExistingKey ? "Update your API key" : "Connect the interpreter")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Tokens.ink)
                    Text("Live readings use your own Anthropic API key. It stays in this device's Keychain and is only ever sent to Anthropic.")
                        .font(.system(size: 13.5))
                        .foregroundStyle(Tokens.inkSoft)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 8)

                GlassCard {
                    SecureField("sk-ant-…", text: $keyInput)
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundStyle(Tokens.ink)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(minHeight: 44)
                        .accessibilityLabel("Anthropic API key")
                }

                Button {
                    keyStore.save(keyInput)
                    dismiss()
                    onSaved()
                } label: {
                    Text("Save key")
                        .font(.system(size: 15.5, weight: .semibold))
                        .foregroundStyle(canSave ? Tokens.ctaInk : Tokens.inkFaint)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background {
                            if canSave {
                                Tokens.ctaGradient
                            } else {
                                Color.white.opacity(0.06)
                            }
                        }
                        .clipShape(Capsule())
                }
                .disabled(!canSave)

                if hadExistingKey {
                    Button {
                        keyStore.clear()
                        dismiss()
                    } label: {
                        Text("Remove saved key")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Tokens.rose)
                            .frame(minHeight: 44)
                    }
                }

                Text("Get a key at console.anthropic.com · Your dreams are sent only to generate the reading")
                    .font(.system(size: 11.5))
                    .foregroundStyle(Tokens.inkFaint)
                    .multilineTextAlignment(.center)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
        .onAppear {
            hadExistingKey = keyStore.apiKey != nil
        }
    }

    private var canSave: Bool {
        !keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    APIKeySheet(keyStore: InMemoryAPIKeyStore())
}

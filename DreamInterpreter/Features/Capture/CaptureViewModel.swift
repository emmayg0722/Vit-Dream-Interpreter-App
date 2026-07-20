import SwiftUI

/// A reading ready to present full-screen, with the dream text it answers.
struct PresentedReading: Identifiable {
    let id = UUID()
    let dreamText: String
    let reading: ReadingDTO
}

/// Tonight tab state: draft text, its persistence, the placeholder voice
/// interaction, and the interpret flow (FR-001, FR-003, PDD 2.4 edge cases).
/// The sample dream keeps its fully offline canned reading (FR-011); any
/// other text goes through `InterpretationService`.
@MainActor
@Observable
final class CaptureViewModel {
    static let minimumLength = 10
    static let softLimit = 2000
    private static let draftKey = "capture.draftText"

    var text: String {
        didSet { defaults.set(text, forKey: Self.draftKey) }
    }
    var isListening = false
    var isAnalyzing = false
    var presentedReading: PresentedReading?
    var showingKeySheet = false
    /// Calm failure copy under the CTA (PDD 2.4); the draft is never touched.
    var errorMessage: String?
    /// When the failure was about the key, recovery is the key sheet.
    var errorIsKeyProblem = false

    let keyStore: APIKeyStoring
    private let defaults: UserDefaults
    private let service: Interpreting
    private var listeningTask: Task<Void, Never>?
    private(set) var interpretationTask: Task<Void, Never>?

    init(
        defaults: UserDefaults = .standard,
        keyStore: APIKeyStoring = KeychainAPIKeyStore(),
        service: Interpreting? = nil
    ) {
        self.defaults = defaults
        self.keyStore = keyStore
        self.service = service ?? InterpretationService(keyStore: keyStore)
        self.text = defaults.string(forKey: Self.draftKey) ?? ""
    }

    var canInterpret: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).count >= Self.minimumLength
    }

    var isOverSoftLimit: Bool {
        text.count > Self.softLimit
    }

    /// FR-011: the sample dream produces its canned reading fully offline.
    var canShowSampleReading: Bool {
        text == SampleDream.text
    }

    func loadSampleDream() {
        text = SampleDream.text
    }

    // MARK: - Interpret flow (FR-003)

    func interpretTapped() {
        guard canInterpret, !isAnalyzing else { return }
        clearError()
        if canShowSampleReading {
            presentedReading = PresentedReading(dreamText: text, reading: SampleDream.reading)
            return
        }
        guard keyStore.apiKey != nil else {
            showingKeySheet = true
            return
        }
        startInterpretation()
    }

    /// Called by the key sheet after a save so the tap that opened it
    /// completes without a second tap.
    func apiKeySaved() {
        clearError()
        if canInterpret, !canShowSampleReading, keyStore.apiKey != nil {
            startInterpretation()
        }
    }

    private func startInterpretation() {
        guard !isAnalyzing else { return }
        isAnalyzing = true
        let dreamText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        interpretationTask = Task {
            do {
                let reading = try await service.interpret(dreamText: dreamText)
                presentedReading = PresentedReading(dreamText: dreamText, reading: reading)
            } catch let error as InterpretationError {
                errorMessage = error.userMessage
                errorIsKeyProblem = error.isKeyProblem
            } catch {
                errorMessage = InterpretationError.serverUnavailable.userMessage
            }
            isAnalyzing = false
        }
    }

    private func clearError() {
        errorMessage = nil
        errorIsKeyProblem = false
    }

    // MARK: - Voice placeholder

    /// Mirrors the prototype's own placeholder voice interaction — a timed
    /// "Listening" state that fills in the sample dream. Real dictation via
    /// SFSpeechRecognizer is FR-002 / M2 (`SpeechService`, not yet built).
    func toggleVoice() {
        if isListening {
            listeningTask?.cancel()
            isListening = false
            return
        }
        isListening = true
        listeningTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(2.2))
            guard !Task.isCancelled, let self else { return }
            self.text = SampleDream.text
            self.isListening = false
        }
    }
}

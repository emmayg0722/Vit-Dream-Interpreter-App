import SwiftUI

/// Tonight tab state: draft text, its persistence, and the placeholder
/// voice interaction. Wiring to `InterpretationService` arrives with M2
/// (FR-003, Q-001) — this view model only owns what the capture screen
/// itself is responsible for (FR-001, PDD 2.4 edge cases).
@Observable
final class CaptureViewModel {
    static let minimumLength = 10
    static let softLimit = 2000
    private static let draftKey = "capture.draftText"

    var text: String {
        didSet { defaults.set(text, forKey: Self.draftKey) }
    }
    var isListening = false

    private let defaults: UserDefaults
    private var listeningTask: Task<Void, Never>?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.text = defaults.string(forKey: Self.draftKey) ?? ""
    }

    var canInterpret: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).count >= Self.minimumLength
    }

    var isOverSoftLimit: Bool {
        text.count > Self.softLimit
    }

    /// FR-011: the sample dream produces its canned reading fully offline,
    /// regardless of whether `InterpretationService` (M2, Q-001) exists yet.
    var canShowSampleReading: Bool {
        text == SampleDream.text
    }

    func loadSampleDream() {
        text = SampleDream.text
    }

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

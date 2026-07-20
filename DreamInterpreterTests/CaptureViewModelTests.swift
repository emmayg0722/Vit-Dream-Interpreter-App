import Testing
import Foundation
@testable import DreamInterpreter

@MainActor
struct CaptureViewModelTests {

    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: "CaptureViewModelTests.\(UUID().uuidString)")!
    }

    private func makeViewModel(
        keyStore: APIKeyStoring = InMemoryAPIKeyStore(),
        service: Interpreting = MockInterpreting(result: .success(SampleDream.reading))
    ) -> CaptureViewModel {
        CaptureViewModel(defaults: makeDefaults(), keyStore: keyStore, service: service)
    }

    /// FR-001 acceptance criterion: draft survives app relaunch. A fresh
    /// view model reading the same store stands in for relaunch here; the
    /// manual kill/relaunch pass is tracked separately in PDD 8.3.
    @Test func draftPersistsAcrossInstances() {
        let defaults = makeDefaults()
        let first = CaptureViewModel(defaults: defaults)
        first.text = "A dream about flying over the city."

        let second = CaptureViewModel(defaults: defaults)
        #expect(second.text == "A dream about flying over the city.")
    }

    @Test func emptyDraftStartsEmptyAndCannotInterpret() {
        let viewModel = CaptureViewModel(defaults: makeDefaults())
        #expect(viewModel.text.isEmpty)
        #expect(!viewModel.canInterpret)
    }

    /// PDD 2.4: empty or <10-character dream text disables the interpret button.
    @Test func canInterpretRequiresMinimumLength() {
        let viewModel = CaptureViewModel(defaults: makeDefaults())
        viewModel.text = "short"
        #expect(!viewModel.canInterpret)
        viewModel.text = "A long enough dream description."
        #expect(viewModel.canInterpret)
    }

    @Test func loadSampleDreamFillsSampleText() {
        let viewModel = CaptureViewModel(defaults: makeDefaults())
        viewModel.loadSampleDream()
        #expect(viewModel.text == SampleDream.text)
    }

    /// PDD 2.4: very long dream (> 2,000 chars) surfaces a soft counter warning.
    @Test func overSoftLimitDetectsLongText() {
        let viewModel = CaptureViewModel(defaults: makeDefaults())
        viewModel.text = String(repeating: "a", count: 2001)
        #expect(viewModel.isOverSoftLimit)
    }

    // MARK: - Interpret flow (FR-003 / FR-011)

    /// FR-011: the sample dream presents its canned reading with no service
    /// call and no API key.
    @Test func sampleDreamShowsCannedReadingOffline() {
        let service = MockInterpreting(result: .success(SampleDream.reading))
        let viewModel = makeViewModel(keyStore: InMemoryAPIKeyStore(), service: service)
        viewModel.loadSampleDream()

        viewModel.interpretTapped()

        #expect(viewModel.presentedReading?.reading == SampleDream.reading)
        #expect(!viewModel.isAnalyzing)
        #expect(service.callCount == 0)
    }

    /// Q-001 interim: without a stored key, the tap opens the key sheet
    /// instead of firing a request.
    @Test func missingKeyOpensKeySheet() {
        let service = MockInterpreting(result: .success(SampleDream.reading))
        let viewModel = makeViewModel(keyStore: InMemoryAPIKeyStore(), service: service)
        viewModel.text = "A long swim through a glowing green sea."

        viewModel.interpretTapped()

        #expect(viewModel.showingKeySheet)
        #expect(viewModel.presentedReading == nil)
        #expect(service.callCount == 0)
    }

    @Test func successfulInterpretationPresentsReading() async {
        let service = MockInterpreting(result: .success(SampleDream.reading))
        let viewModel = makeViewModel(
            keyStore: InMemoryAPIKeyStore(apiKey: "sk-test"),
            service: service
        )
        viewModel.text = "A long swim through a glowing green sea."

        viewModel.interpretTapped()
        #expect(viewModel.isAnalyzing)
        await viewModel.interpretationTask?.value

        #expect(viewModel.presentedReading?.reading == SampleDream.reading)
        #expect(viewModel.presentedReading?.dreamText == viewModel.text)
        #expect(!viewModel.isAnalyzing)
        #expect(viewModel.errorMessage == nil)
        #expect(service.callCount == 1)
    }

    /// PDD 2.4: failure shows calm copy and never touches the draft.
    @Test func failurePreservesDraftAndShowsError() async {
        let service = MockInterpreting(result: .failure(InterpretationError.offline))
        let viewModel = makeViewModel(
            keyStore: InMemoryAPIKeyStore(apiKey: "sk-test"),
            service: service
        )
        let dream = "A long swim through a glowing green sea."
        viewModel.text = dream

        viewModel.interpretTapped()
        await viewModel.interpretationTask?.value

        #expect(viewModel.text == dream)
        #expect(viewModel.errorMessage == InterpretationError.offline.userMessage)
        #expect(!viewModel.errorIsKeyProblem)
        #expect(viewModel.presentedReading == nil)
        #expect(!viewModel.isAnalyzing)
    }

    /// A rejected key routes recovery to the key sheet.
    @Test func unauthorizedFailureFlagsKeyProblem() async {
        let service = MockInterpreting(result: .failure(InterpretationError.unauthorized))
        let viewModel = makeViewModel(
            keyStore: InMemoryAPIKeyStore(apiKey: "sk-wrong"),
            service: service
        )
        viewModel.text = "A long swim through a glowing green sea."

        viewModel.interpretTapped()
        await viewModel.interpretationTask?.value

        #expect(viewModel.errorIsKeyProblem)
    }

    /// After saving a key from the sheet, the interpretation the user asked
    /// for continues without a second tap.
    @Test func apiKeySavedResumesInterpretation() async {
        let service = MockInterpreting(result: .success(SampleDream.reading))
        let keyStore = InMemoryAPIKeyStore()
        let viewModel = makeViewModel(keyStore: keyStore, service: service)
        viewModel.text = "A long swim through a glowing green sea."

        viewModel.interpretTapped()
        #expect(viewModel.showingKeySheet)

        keyStore.save("sk-test")
        viewModel.apiKeySaved()
        await viewModel.interpretationTask?.value

        #expect(viewModel.presentedReading != nil)
        #expect(service.callCount == 1)
    }
}

/// Scripted `Interpreting` double.
final class MockInterpreting: Interpreting {
    let result: Result<ReadingDTO, Error>
    private(set) var callCount = 0

    init(result: Result<ReadingDTO, Error>) {
        self.result = result
    }

    func interpret(dreamText: String) async throws -> ReadingDTO {
        callCount += 1
        return try result.get()
    }
}

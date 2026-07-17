import Testing
import Foundation
@testable import DreamInterpreter

struct CaptureViewModelTests {

    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: "CaptureViewModelTests.\(UUID().uuidString)")!
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
}

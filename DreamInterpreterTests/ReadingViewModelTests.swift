import Testing
@testable import DreamInterpreter

struct ReadingViewModelTests {

    @Test func startsWithJungExpanded() {
        let viewModel = ReadingViewModel()
        #expect(viewModel.expandedLens == .jung)
    }

    @Test func toggleCollapsesTheOpenLens() {
        let viewModel = ReadingViewModel()
        viewModel.toggle(.jung)
        #expect(viewModel.expandedLens == nil)
    }

    /// PDD 9.2: only one lens card is expanded at a time.
    @Test func togglingADifferentLensReplacesTheOpenOne() {
        let viewModel = ReadingViewModel()
        viewModel.toggle(.neuro)
        #expect(viewModel.expandedLens == .neuro)
    }

    @Test func saveSetsIsSaved() {
        let viewModel = ReadingViewModel()
        #expect(!viewModel.isSaved)
        viewModel.save()
        #expect(viewModel.isSaved)
    }
}

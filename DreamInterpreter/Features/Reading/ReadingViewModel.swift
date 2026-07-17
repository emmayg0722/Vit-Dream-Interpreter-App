import SwiftUI

/// Reading screen state: which lens is expanded, and the local "saved" flag.
/// Persisting the reading to SwiftData is FR-008/M3 — this only owns what the
/// screen itself is responsible for rendering (TASK-006 scope).
@Observable
final class ReadingViewModel {
    var expandedLens: Lens?
    var isSaved = false

    init(initiallyExpanded: Lens? = .jung) {
        self.expandedLens = initiallyExpanded
    }

    /// One lens expanded at a time (PDD 9.2 accordion behavior).
    func toggle(_ lens: Lens) {
        expandedLens = (expandedLens == lens) ? nil : lens
    }

    func save() {
        isSaved = true
    }
}

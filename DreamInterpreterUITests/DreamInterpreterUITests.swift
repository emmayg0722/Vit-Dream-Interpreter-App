import XCTest

final class DreamInterpreterUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// TASK-001: the app launches and shows the three-tab shell.
    @MainActor
    func testTabShellLaunches() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Tonight"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Journal"].exists)
        XCTAssertTrue(app.tabBars.buttons["Insights"].exists)

        app.tabBars.buttons["Journal"].tap()
        app.tabBars.buttons["Insights"].tap()
        app.tabBars.buttons["Tonight"].tap()
    }

    /// TASK-004: the sample dream fills the draft and enables the CTA
    /// (FR-001, FR-011, PDD 2.4 — interpret disabled below the minimum length).
    @MainActor
    func testSampleDreamEnablesInterpretButton() throws {
        let app = XCUIApplication()
        app.launch()

        let interpretButton = app.buttons["Interpret this dream"]
        XCTAssertTrue(interpretButton.waitForExistence(timeout: 5))
        XCTAssertFalse(interpretButton.isEnabled)

        app.buttons["Try the sample dream, a giant mosquito at a park in Japan"].tap()
        XCTAssertTrue(interpretButton.isEnabled)
    }

    /// TASK-006: the sample dream's canned reading (FR-011) renders every
    /// section — summary, six lenses, contribution bar, synthesis, and the
    /// four closing sections (FR-004 through FR-007).
    @MainActor
    func testSampleReadingRendersAllSections() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Try the sample dream, a giant mosquito at a park in Japan"].tap()
        app.buttons["Interpret this dream"].tap()

        XCTAssertTrue(app.staticTexts["Your reading"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["SIX LENSES"].exists)
        // Jungian is the default-expanded lens (ReadingViewModel); its card
        // is a single accessibility element, so match on the button's label
        // rather than a nested static text.
        XCTAssertTrue(
            app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Jungian'")).firstMatch.exists
        )
        XCTAssertTrue(app.staticTexts["SYNTHESIS"].exists)
        XCTAssertTrue(app.staticTexts["MAIN MESSAGE"].exists)
        XCTAssertTrue(app.staticTexts["POSSIBLE SUBCONSCIOUS CONCERNS"].exists)
        XCTAssertTrue(app.staticTexts["OPPORTUNITIES & WARNINGS"].exists)
        XCTAssertTrue(app.buttons["Save to dream journal"].exists)

        app.buttons["Back"].tap()
        XCTAssertTrue(app.buttons["Interpret this dream"].waitForExistence(timeout: 5))
    }
}

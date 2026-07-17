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
}

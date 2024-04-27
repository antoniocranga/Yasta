//
//  YastaUITestsLaunchTests.swift
//  YastaUITests
//
//  Created by Antonio Cranga on 06.04.2024.
//

import XCTest

final class YastaUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

// MARK: Activity UI Tests

extension YastaUITestsLaunchTests {
    func testActivityLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.firstMatch
        let activityTab = tabBar.buttons["Activity"]
        XCTAssertTrue(activityTab.waitForExistence(timeout: 5))
        activityTab.tap()
        
        let exists = NSPredicate(format: "exists == true")
        let navigationTitle = app.staticTexts["Acitvity"]
        let expectation = expectation(for: exists, evaluatedWith: navigationTitle, handler: nil)
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, .completed, "The Activity title didn't appear within 5 seconds")
        
        XCTAssertTrue(navigationTitle.exists)
    }
}

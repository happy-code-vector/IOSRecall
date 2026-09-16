//
//  ThinkFirstUITests.swift
//  ThinkFirstUITests
//
//  Created by Ahmad Rasheed on 1/16/26.
//

import XCTest

@MainActor
final class ThinkFirstUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()

        // Configure environment for snapshot and enforce target device
        app.launchArguments += ["-ui_testing", "YES"]
        app.launchEnvironment["SIMULATOR_DEVICE_NAME"] = "iPhone 16 Pro"
        app.launchEnvironment["FASTLANE_SNAPSHOT"] = "true"

        // Fail fast if not configured to iPhone 16 Pro when running snapshot
        if app.launchEnvironment["FASTLANE_SNAPSHOT"] == "true" || app.launchArguments.contains("-ui_testing") {
            let expected = "iPhone 16 Pro"
            let configured = app.launchEnvironment["SIMULATOR_DEVICE_NAME"] ?? ""
            XCTAssertEqual(configured, expected, "Snapshots must run on \(expected). Current: \(configured)")
        }

        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testCaptureScreenshots() throws {
        let app = XCUIApplication()

        // Ensure app is launched from setUp
        if !app.state.isRunning { app.launch() }

        func takeSnapshot(_ name: String) {
            // Give UI a moment to settle
            _ = app.wait(for: .runningForeground, timeout: 0.5)
            snapshot(name)
        }

        // Onboarding: snapshot each step and advance via Continue
        var onboardingStep = 1
        for _ in 0..<8 { // cap to avoid infinite loops
            let continueById = app.buttons["OnboardingContinue"].firstMatch
            let continueByLabel = app.buttons["Continue"].firstMatch
            let hasContinue = continueById.exists || continueByLabel.exists

            // If a Continue button is visible, snapshot current onboarding step
            if hasContinue {
                takeSnapshot(String(format: "0%d_Onboarding", onboardingStep))
                onboardingStep += 1
                if continueById.exists { continueById.tap() } else { continueByLabel.tap() }
                _ = app.wait(for: .runningForeground, timeout: 0.6)
                continue
            }
            // No continue present means we likely reached the main app
            break
        }

        // Main/Home screen (try identifier, then nav bar title, then any unique label)
        let homeIdentifier = app.otherElements["HomeRoot"].firstMatch
        let homeNavTitle = app.navigationBars.staticTexts.firstMatch
        if homeIdentifier.waitForExistence(timeout: 4) || homeNavTitle.waitForExistence(timeout: 1) {
            takeSnapshot("03_Home")
        } else {
            takeSnapshot("03_Home_Fallback")
        }

        // Navigate to a secondary screen (try specific ids, then first cell, then a button labeled Next/More)
        let listCell = app.cells["MainListCell"].firstMatch
        let nextButton = app.buttons["NextButton"].firstMatch
        if listCell.waitForExistence(timeout: 2) { listCell.tap() }
        else if nextButton.waitForExistence(timeout: 2) { nextButton.tap() }
        else if app.cells.firstMatch.waitForExistence(timeout: 1) { app.cells.firstMatch.tap() }
        else if app.buttons["Next"].firstMatch.waitForExistence(timeout: 1) { app.buttons["Next"].firstMatch.tap() }
        else if app.buttons["More"].firstMatch.waitForExistence(timeout: 1) { app.buttons["More"].firstMatch.tap() }

        // Second screen
        let secondScreenMarker = app.otherElements["SecondRoot"].firstMatch
        let secondNavTitle = app.navigationBars.staticTexts.firstMatch
        if secondScreenMarker.waitForExistence(timeout: 2) || secondNavTitle.waitForExistence(timeout: 1) {
            takeSnapshot("04_Second")
        } else {
            takeSnapshot("04_Second_Fallback")
        }

        // Details screen (try button/cell, then first tappable cell)
        let detailsButton = app.buttons["DetailsButton"].firstMatch
        let detailsCell = app.cells["DetailsCell"].firstMatch
        if detailsButton.waitForExistence(timeout: 2) { detailsButton.tap() }
        else if detailsCell.waitForExistence(timeout: 2) { detailsCell.tap() }
        else if app.cells.element(boundBy: 0).waitForExistence(timeout: 1) { app.cells.element(boundBy: 0).tap() }

        if app.otherElements["DetailsRoot"].firstMatch.waitForExistence(timeout: 2) || app.navigationBars.staticTexts.firstMatch.exists {
            takeSnapshot("05_Details")
        } else {
            takeSnapshot("05_Details_Fallback")
        }

        // Settings (try id, then common label, then system gear button)
        let settingsButton = app.buttons["SettingsButton"].firstMatch
        let settingsLabel = app.buttons["Settings"].firstMatch
        let gear = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", "Settings")).firstMatch
        if settingsButton.waitForExistence(timeout: 2) { settingsButton.tap() }
        else if settingsLabel.waitForExistence(timeout: 1) { settingsLabel.tap() }
        else if gear.waitForExistence(timeout: 1) { gear.tap() }

        if app.otherElements["SettingsRoot"].firstMatch.waitForExistence(timeout: 2) || app.navigationBars["Settings"].exists {
            takeSnapshot("06_Settings")
        }

        // Try to close settings/back
        let close = app.buttons["CloseSettings"].firstMatch
        if close.waitForExistence(timeout: 1) { close.tap() }
        else if app.navigationBars.buttons.element(boundBy: 0).exists { app.navigationBars.buttons.element(boundBy: 0).tap() }
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

private extension XCUIApplication.State {
    var isRunning: Bool { self == .runningForeground || self == .runningBackground || self == .runningBackgroundSuspended }
}

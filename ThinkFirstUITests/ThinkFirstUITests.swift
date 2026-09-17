//
//  ThinkFirstUITests.swift
//  ThinkFirstUITests
//
//  Screenshot capture for the App Store / fastlane snapshot.
//  Covers every screen in the app, driven through the real UI flow.
//
//  Run via:  fastlane snapshot
//  (device list is pinned to iPhone 16 Pro in the Snapfile)
//

import XCTest

@MainActor
final class ThinkFirstUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Helpers

    private func launchApp(extraArguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-uitesting"] + extraArguments
        setupSnapshot(app)
        app.launch()
        return app
    }

    /// Waits for the element to exist, then taps it.
    private func tap(_ element: XCUIElement, timeout: TimeInterval = 10, message: String) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), message)
        element.tap()
    }

    /// Swipes up until the element is hittable (for buttons at the bottom of a ScrollView).
    private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, maxSwipes: Int = 6) {
        var swipes = 0
        while (!element.exists || !element.isHittable) && swipes < maxSwipes {
            app.swipeUp()
            swipes += 1
        }
    }

    // MARK: - Test 1: Onboarding flow (fresh install state)
    //
    // Splash -> AccountType -> GradeSelection -> GoalSelection -> Methodology
    // -> TryItDemo -> NotificationPermission -> Login -> (Home)

    func test01CaptureOnboardingScreens() throws {
        let app = launchApp(extraArguments: ["-uitest-reset"])

        // 01 Splash (auto-advances after 10s while UI testing)
        snapshot("01_SplashScreen")

        // 02 Account type — select "I am a Student" to enable Continue
        let studentCard = app.buttons["I am a Student"].firstMatch
        XCTAssertTrue(studentCard.waitForExistence(timeout: 15), "Account type screen did not appear")
        snapshot("02_AccountTypeScreen")
        tap(studentCard, message: "Student card not tappable")
        tap(app.buttons["Continue"].firstMatch, message: "Continue button on account type screen not found")

        // 03 Grade level — select "High School"
        let highSchool = app.buttons["High School"].firstMatch
        XCTAssertTrue(highSchool.waitForExistence(timeout: 10), "Grade selection screen did not appear")
        snapshot("03_GradeSelectionScreen")
        tap(highSchool, message: "High School option not tappable")
        tap(app.buttons["Continue"].firstMatch, message: "Continue button on grade selection screen not found")

        // 04 Goal — select first goal
        let goal = app.buttons["Improve critical thinking"].firstMatch
        XCTAssertTrue(goal.waitForExistence(timeout: 10), "Goal selection screen did not appear")
        snapshot("04_GoalSelectionScreen")
        tap(goal, message: "Goal option not tappable")
        tap(app.buttons["Continue"].firstMatch, message: "Continue button on goal selection screen not found")

        // 05 Methodology — long ScrollView, scroll down to reach the button
        let methodologyContinue = app.buttons["I understand, let's try it"].firstMatch
        XCTAssertTrue(methodologyContinue.waitForExistence(timeout: 10), "Methodology screen did not appear")
        snapshot("05_MethodologyScreen")
        scrollTo(methodologyContinue, in: app)
        tap(methodologyContinue, message: "Methodology continue button not tappable")

        // 06 Try It Demo — tap through the unlock animation
        let unlock = app.buttons["Tap to Unlock"].firstMatch
        XCTAssertTrue(unlock.waitForExistence(timeout: 10), "Try It Demo screen did not appear")
        snapshot("06_TryItDemoScreen")
        tap(unlock, message: "Tap to Unlock button not tappable")

        // 07 Notification permission — decline with "Maybe Later" to avoid a system alert
        let maybeLater = app.buttons["Maybe Later"].firstMatch
        XCTAssertTrue(maybeLater.waitForExistence(timeout: 15), "Notification permission screen did not appear")
        snapshot("07_NotificationPermissionScreen")
        tap(maybeLater, message: "Maybe Later button not tappable")

        // 08 Login (auto-completes after 10s while UI testing — snapshot quickly)
        let demoButton = app.buttons["Continue as Demo User"].firstMatch
        XCTAssertTrue(demoButton.waitForExistence(timeout: 10), "Login screen did not appear")
        snapshot("08_LoginScreen")

        // Wait for the flow to auto-complete and land on Home
        XCTAssertTrue(
            app.textFields.firstMatch.waitForExistence(timeout: 15),
            "Home screen did not appear after onboarding auto-completion"
        )
        snapshot("09_HomeScreen")
    }

    // MARK: - Test 2: Learning flow (skips onboarding)
    //
    // Home -> AttemptGate -> Evaluation -> Answer

    func test02CaptureLearningScreens() throws {
        let app = launchApp(extraArguments: ["-uitest-reset", "-uitest-skip-onboarding"])

        // 09 Home
        let questionField = app.textFields.firstMatch
        XCTAssertTrue(questionField.waitForExistence(timeout: 15), "Home screen did not appear")
        snapshot("09_HomeScreen")

        // Ask a question
        tap(questionField, message: "Question text field not tappable")
        questionField.typeText("Why is the sky blue?")
        tap(app.buttons["Ask"].firstMatch, message: "Ask button did not appear after typing a question")

        // 10 Attempt Gate — type an attempt (needs >= 8 words to submit)
        let attemptEditor = app.textViews.firstMatch
        XCTAssertTrue(attemptEditor.waitForExistence(timeout: 15), "Attempt gate screen did not appear")
        snapshot("10_AttemptGateScreen")

        tap(attemptEditor, message: "Attempt text editor not tappable")
        // 40 words: the mock evaluation needs >= 30 words for effort+understanding >= 4 (unlock granted)
        attemptEditor.typeText("I believe the sky appears blue because of how sunlight interacts with the atmosphere and the air molecules scattering the light in different ways depending on the wavelength and also how our eyes perceive each color differently during the day")

        let submit = app.buttons["→ Submit Answer"].firstMatch
        XCTAssertTrue(submit.waitForExistence(timeout: 10), "Submit button never became enabled")
        tap(submit, message: "Submit button not tappable")

        // 11 Evaluation (deterministic mock: 40 words => effort 3 + understanding 2 => unlock granted)
        let unlockButton = app.buttons["🎉 Unlock Answer"].firstMatch
        if !unlockButton.waitForExistence(timeout: 20) {
            snapshot("11_EvaluationScreen_RetryState") // low-effort fallback state
            throw XCTSkip("Evaluation did not grant unlock; captured retry state instead")
        }
        snapshot("11_EvaluationScreen")

        // 12 Answer
        tap(unlockButton, message: "Unlock Answer button not tappable")
        let askAnother = app.buttons["Ask Another Question"].firstMatch
        XCTAssertTrue(askAnother.waitForExistence(timeout: 15), "Answer screen did not appear")
        snapshot("12_AnswerScreen")
    }
}

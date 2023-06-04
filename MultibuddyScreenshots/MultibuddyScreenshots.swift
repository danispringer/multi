//
//  MultibuddyScreenshots.swift
//  MultibuddyScreenshots
//
//  Created by Daniel Springer on 5/20/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import XCTest

class MultibuddyScreenshots: XCTestCase {

    // xcodebuild -testLanguage en -scheme Multibuddy -project ./Multibuddy.xcodeproj
    // -derivedDataPath '/tmp/MultibuddyDerivedData/' -destination
    // "platform=iOS Simulator,name=iPhone 13 Pro Max" build test
    // https://blog.winsmith.de/english/ios/2020/04/14/xcuitest-screenshots.html

    var app: XCUIApplication!


    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--multibuddyScreenshots")
    }


    func anAction() {
        // game
        XCTAssertTrue(app.staticTexts["Spot Multiples of 2"].firstMatch
            .waitForExistence(timeout: 5))
        takeScreenshot(named: "1-home")
        app.staticTexts["Spot Multiples of 2"].firstMatch.tap()
        takeScreenshot(named: "2-level-start")
        for _ in 0...2 {
            XCTAssertTrue(app.buttons["\(Const.yesMessage)"].firstMatch
                .waitForExistence(timeout: 5))
            app.buttons["\(Const.yesMessage)"].firstMatch.tap()
        }
        takeScreenshot(named: "3-level-mid")
        XCTAssertTrue(app.buttons[Const.appName].firstMatch
            .waitForExistence(timeout: 5))
        app.buttons[Const.appName].firstMatch.tap()

        // tips
        XCTAssertTrue(app.staticTexts["\(Const.tipsTitle)"].firstMatch
            .waitForExistence(timeout: 5))
        app.staticTexts["\(Const.tipsTitle)"].tap()

        XCTAssertTrue(app.staticTexts["Multiples of 2"].firstMatch
            .waitForExistence(timeout: 5))
        app.swipeDown()
        XCTAssertTrue(app.staticTexts["Multiples of 2"].firstMatch
            .waitForExistence(timeout: 5))
        takeScreenshot(named: "4-tips-top")
        app.swipeUp()
        XCTAssertTrue(app.staticTexts["Multiples of 6"].firstMatch
            .waitForExistence(timeout: 5))
        takeScreenshot(named: "5-tips-mid")
    }


    func testMakeScreenshots() {
        app.launch()
        anAction()
    }


    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()

        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)

        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways

        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }

}

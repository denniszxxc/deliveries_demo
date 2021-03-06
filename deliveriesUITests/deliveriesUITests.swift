//
//  DeliveriesUITests.swift
//  DeliveriesUITests
//
//  Created by Dennis Li on 20/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import XCTest

class DeliveriesUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeliverytListUI() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let scrollViewsQuery = XCUIApplication().scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let deliveryStaticText = elementsQuery.staticTexts["Delivery"]
        XCTAssertTrue(deliveryStaticText.exists)
        XCTAssertTrue(elementsQuery.buttons["Refresh"].exists)

        elementsQuery.staticTexts["Delivery"].swipeUp()
        elementsQuery.staticTexts["Delivery"].swipeDown()
        elementsQuery.staticTexts["Delivery"].swipeDown()
    }

    func testNavigateToDetailPage() {
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let firstTableViewCell = elementsQuery.tables.children(matching: .cell).element(boundBy: 0)

        let titleTextView = firstTableViewCell.staticTexts.firstMatch

        let label = titleTextView.label

        firstTableViewCell.tap()

        let deliverDocumentsToAndrioStaticText = elementsQuery.staticTexts[label]
        deliverDocumentsToAndrioStaticText.tap()
        deliverDocumentsToAndrioStaticText.swipeUp()
        deliverDocumentsToAndrioStaticText.swipeDown()
        elementsQuery.buttons["ic dismiss"].tap()
    }
}

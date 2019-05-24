//
//  BudTransactionsUITests.swift
//  BudTransactionsUITests
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import XCTest

class BudTransactionsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING"]
        app.launch()
    }

    // we're only testing the happy path for now, but the 
    func testDeletionWorks() {

        let app = XCUIApplication()
        app.buttons["Load Transactions"].tap()
        app.navigationBars["Transactions"].buttons["Edit"].tap()

        let cellsWithBlizzard = app.staticTexts.matching(identifier: "Blizzard entertainment")
        XCTAssert(cellsWithBlizzard.count == 1)
        cellsWithBlizzard.firstMatch.tap()
        app.buttons["Remove"].tap()

        XCTAssert(cellsWithBlizzard.firstMatch.exists == false)

        app.swipeUp()

        let cellsWithJustEat = app.staticTexts.matching(identifier: "Just eat")
        XCTAssert(cellsWithJustEat.count == 1)
        cellsWithJustEat.firstMatch.tap()

        let cellsWithFiveGuys = app.staticTexts.matching(identifier: "Five guys")
        XCTAssert(cellsWithFiveGuys.count == 1)
        cellsWithFiveGuys.firstMatch.tap()

        app.buttons["Remove"].tap()
        XCTAssert(cellsWithJustEat.firstMatch.exists == false)
        XCTAssert(cellsWithFiveGuys.firstMatch.exists == false)

        app.navigationBars["Transactions"].buttons["Done"].tap()

    }
}

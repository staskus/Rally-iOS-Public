//
//  RallyUITests.swift
//  RallyUITests
//
//  Created by Povilas Staskus on 9/23/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import XCTest

class RallyUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

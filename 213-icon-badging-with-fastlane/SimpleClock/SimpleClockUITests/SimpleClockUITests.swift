//
//  SimpleClockUITests.swift
//  SimpleClockUITests
//
//  Created by Ben Scheirman on 3/7/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import XCTest

class SimpleClockUITests: XCTestCase {
    
    var app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        setupSnapshot(app)
        app.launch()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        snapshot("0-Launch")
        let label = app.staticTexts.elementMatchingType(.Any, identifier: "timeLabel")
        label.tap()
        
        let mainView = app.windows.childrenMatchingType(.Any).elementBoundByIndex(0)
        let coords = mainView.coordinateWithNormalizedOffset(CGVector(dx: 0.05, dy: 0.05))
        coords.tap()
        
        snapshot("1-24htime")
        
//        let exp = expectationWithDescription("test")
//        
//        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
}

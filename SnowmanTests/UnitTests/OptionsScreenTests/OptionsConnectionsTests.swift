//
//  OptionsConnectionsTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest
@testable import Snowman

class OptionsConnectionsTests: XCTestCase {

    private var windowController: OptionsWindowController!
    private var sut: OptionsViewController!

    override func setUp() {
        super.setUp()

        windowController = OptionsWindowController.storyboardInstance()
        sut = windowController.contentViewController as? OptionsViewController
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_ConnectionsNotNil_OptionsViewController() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.boxAppOptions)
        XCTAssertNotNil(sut.boxWeatherOptions)
        XCTAssertNotNil(sut.boxSpecialOptions)
        XCTAssertNotNil(sut.buttonClose)

        XCTAssertNotNil(sut.labelDarkMode)
        XCTAssertNotNil(sut.labelLanguage)
        XCTAssertNotNil(sut.labelTimeFormat)
        XCTAssertNotNil(sut.labelOpenWeatherKey)
        XCTAssertNotNil(sut.labelStatusMenus)
        XCTAssertNotNil(sut.labelStatusMenusUpdate)

        XCTAssertNotNil(sut.controlDarkMode)
        XCTAssertNotNil(sut.controlLanguage)
        XCTAssertNotNil(sut.controlTimeFormat)
        XCTAssertNotNil(sut.controlOpenWeatherKey)
        XCTAssertNotNil(sut.controlUnlockButton)
        XCTAssertNotNil(sut.checkBoxStatusMenus)
        XCTAssertNotNil(sut.comboBoxStatusMenusUpdatePeriod)

        XCTAssertNotNil(sut.labelTemperature)
        XCTAssertNotNil(sut.labelWindSpeed)
        XCTAssertNotNil(sut.labelPressure)
        XCTAssertNotNil(sut.labelDistance)

        XCTAssertNotNil(sut.controlTemperature)
        XCTAssertNotNil(sut.controlWindSpeed)
        XCTAssertNotNil(sut.controlPressure)
        XCTAssertNotNil(sut.controlDistance)
    }
}

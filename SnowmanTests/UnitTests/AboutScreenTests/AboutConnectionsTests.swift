//
//  AboutConnectionsTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest
@testable import Snowman

class AboutConnectionsTests: XCTestCase {

    private var windowController: AboutWindowController!
    private var sut: AboutViewController!

    override func setUp() {
        super.setUp()

        windowController = AboutWindowController.storyboardInstance()
        sut = windowController.contentViewController as? AboutViewController
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_ConnectionsNotNil_OptionsViewController() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.buttonTheAppSourceCode)
        XCTAssertNotNil(sut.buttonTheTechnologicalTree)

        XCTAssertNotNil(sut.buttonPerseusDarkMode)
        XCTAssertNotNil(sut.buttonTheOpenWeatherClient)
        XCTAssertNotNil(sut.buttonPerseusGeoLocationKit)
        XCTAssertNotNil(sut.buttonPerseusLogger)

        XCTAssertNotNil(sut.buttonLicense)
        XCTAssertNotNil(sut.buttonTerms)
        XCTAssertNotNil(sut.buttonClose)
        XCTAssertNotNil(sut.labelTheAppName)
        XCTAssertNotNil(sut.labelTheAppVersionTitle)
        XCTAssertNotNil(sut.labelTheAppVersionValue)
        XCTAssertNotNil(sut.viewCopyrightText)
        XCTAssertNotNil(sut.viewCopyrightDetailsText)
        XCTAssertNotNil(sut.viewTheCreditsText)

    }
}

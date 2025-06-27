//
//  AboutLocalizationTests.swift
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

class AboutExpectationsTests: XCTestCase {

    private var windowController: AboutWindowController!
    private var sut: AboutViewController!

    override func setUp() {
        super.setUp()

        windowController = AboutWindowController.storyboardInstance()
        sut = windowController.contentViewController as? AboutViewController
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_Localization_of_OptionsScreen() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.view.window?.title, "")
        XCTAssertEqual(sut.buttonTheAppSourceCode.title,
                       "Button: The App Source Code".localizedValue)
        XCTAssertEqual(sut.buttonTheTechnologicalTree.title,
                       "Button: The Technological Tree".localizedValue)

        XCTAssertEqual(sut.labelTheAppName.stringValue,
                       "Product Name".localizedValue)

        XCTAssertEqual(sut.labelTheAppVersionTitle.stringValue,
                       "Label: The App Version".localizedValue + ":")

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        XCTAssertEqual(sut.labelTheAppVersionValue.stringValue,
                       (version as? String)!)

        XCTAssertEqual(sut.viewCopyrightText.string,
                       "Label: Star Copyright Notice".localizedValue)
        XCTAssertEqual(sut.viewCopyrightDetailsText.string,
                       "Label: Copyright Details".localizedValue)

        XCTAssertEqual(sut.buttonLicense.title,
                       "Button: License".localizedValue)
        XCTAssertEqual(sut.buttonTerms.title,
                       "Button: Terms & Conditions".localizedValue)
        XCTAssertEqual(sut.buttonClose.title,
                       "Button: Close".localizedValue)
    }
}

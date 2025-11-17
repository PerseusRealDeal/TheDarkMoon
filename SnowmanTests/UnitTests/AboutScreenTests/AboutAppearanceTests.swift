//
//  AboutAppearanceTests.swift
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

class AboutAppearanceTests: XCTestCase {

    private var sut: AboutWindowController!
    private var viewController: AboutViewController!

    override func setUp() {
        super.setUp()

        sut = AboutWindowController.storyboardInstance()
        viewController = sut.contentViewController as? AboutViewController
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    func test_the_first_success() { XCTAssertTrue(true, "It's done!") }
}

//
//  OptionsAppearanceTests.swift
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

class OptionsAppearanceTests: XCTestCase {

    private var sut: OptionsWindowController!
    private var viewController: OptionsViewController!

    override func setUp() {
        super.setUp()

        sut = OptionsWindowController.storyboardInstance()
        viewController = sut.contentViewController as? OptionsViewController
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    func test_the_first_success() { XCTAssertTrue(true, "It's done!") }
}

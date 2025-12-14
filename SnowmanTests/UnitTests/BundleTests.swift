//
//  BundleTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest
import Cocoa

@testable import Snowman

// MARK: - Release notes

let bundleShortVersion = "0.4.3"
let bundleVersion = "0"
let theAppIsAgent = true
let category = "public.app-category.weather"
let appIcon = "AppIcon"
let activationPolicy = NSApplication.ActivationPolicy.accessory

// MARK: - Customer expectations, requirements

let productName = "Product Name".localizedExpectation
let lacationUsageDescription = "Location Usage Description".localizedExpectation
let copyright = "Copyright".localizedExpectation
let greetings = "Greetings".localizedExpectation

// MARK: - Release check list

class BundleTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_BundleDisplayName() {

        // arrange

        // InfoPlist.strings localized.
        let bundleDisplayNameInfoPlist = "CFBundleDisplayName".localizedInfoPlist
        // Localizable.strings.
        let productNameLocalizable = "Product Name".localizedValue

        // assert

        XCTAssertEqual(productName, bundleDisplayNameInfoPlist)
        XCTAssertEqual(bundleDisplayNameInfoPlist, productNameLocalizable)
    }

    func test_BundleName() {

        // arrange

        // InfoPlist.strings localized.
        let bundleNameInfoPlist = "CFBundleName".localizedInfoPlist
        // Localizable.strings.
        let productNameLocalizable = "Product Name".localizedValue

        // assert

        XCTAssertEqual(productName, bundleNameInfoPlist)
        XCTAssertEqual(bundleNameInfoPlist, productNameLocalizable)
    }

    func test_BundleShortVersion() {

        // InfoPlist.strings.
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")

        XCTAssertEqual(bundleShortVersion, version as? String)
    }

    func test_BundleVersion() {

        // arrange

        // InfoPlist.strings.
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")

        // assert

        XCTAssertEqual(bundleVersion, version as? String)
    }

    func test_TheAppIsAgent() {

        // arrange

        // InfoPlist.strings.
        let itemInfoPlist = Bundle.main.object(forInfoDictionaryKey: "LSUIElement") as? Bool

        // assert

        XCTAssertEqual(theAppIsAgent, itemInfoPlist)
    }

    func test_LocationUsageDescription() {

        // arrange

        // InfoPlist.strings localized.
        let itemInfoPlist = "NSLocationUsageDescription".localizedInfoPlist

        // assert

        XCTAssertEqual(lacationUsageDescription, itemInfoPlist)
    }

    func test_Copyright() {

        // arrange

        // InfoPlist.strings localized.
        let itemInfoPlist = "NSHumanReadableCopyright".localizedInfoPlist

        // assert

        XCTAssertEqual(copyright, itemInfoPlist)
    }

    func test_ApplicationCategory() {

        // arrange

        // InfoPlist.strings.
        let appCategory = Bundle.main.object(forInfoDictionaryKey: "LSApplicationCategoryType")

        // assert

        XCTAssertEqual(category, appCategory as? String)
    }

    func test_BundleIcon() {

        // arrange

        // InfoPlist.strings.
        let iconName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIconFile")

        // assert

        XCTAssertEqual(appIcon, iconName as? String)
    }

    func test_Greetings() {

        // arrange

        // Localizable.strings.
        let greetingsLocalized = "Greetings".localizedValue

        // assert

        XCTAssertEqual(greetings, greetingsLocalized)
    }

    func test_ActivationPolicy() {

        // arrange

        let appActivationPolicy = NSApplication.shared.activationPolicy()
        let requirement = "ActivationPolicy must be in .accessory."

        // assert

        XCTAssertEqual(activationPolicy, appActivationPolicy, requirement)
    }
}

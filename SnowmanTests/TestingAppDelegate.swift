//
//  TestingAppDelegate.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7532 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest
@testable import Snowman

// MARK: - The Testing Application Delegate

@objc(TestingAppDelegate)
class TestingAppDelegate: NSResponder, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        applog.turned = .off

        log.message("[\(type(of: self))].\(#function)")
        log.message("> The app's test bundle start point...", .info)

        // Common configuration

        log.message("> Ready with testing matter purpose...", .info)
    }
}

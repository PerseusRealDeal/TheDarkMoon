//
//  main.swift
//  PerseusMeteo
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

import Cocoa
import ConsolePerseusLogger

// MARK: - The Logger

import class PerseusDarkMode.PerseusLogger
import class PerseusGeoKit.PerseusLogger
import class OpenWeatherAgent.PerseusLogger

// swiftlint:disable type_name
typealias applog = ConsolePerseusLogger.PerseusLogger // For test bundle, log is for main.
typealias pdmlog = PerseusDarkMode.PerseusLogger
typealias pgklog = PerseusGeoKit.PerseusLogger
typealias owclog = OpenWeatherAgent.PerseusLogger
// swiftlint:enable type_name

pdmlog.turned = .off
pgklog.turned = .off
owclog.turned = .off

// MARK: - The Start Line

log.message("> The app's start point...", .info)

let globals = AppGlobals()

let app = NSApplication.shared

let appPurpose = NSClassFromString("TestingAppDelegate") as? NSObject.Type
let appDelegate = appPurpose?.init() ?? AppDelegate()

let statusMenusButtonPresenter = StatusMenusButtonPresenter()

// MARK: - The Run

/*

 .accessory

 The application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be
 activated programmatically or by clicking on one of its windows.

 */

log.message("> The app in the beginning...", .info)

app.setActivationPolicy(.accessory)

app.delegate = appDelegate as? NSApplicationDelegate

app.activate(ignoringOtherApps: true)
app.run()

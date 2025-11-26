//
//  main.swift
//  PerseusMeteo
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

import Cocoa

// MARK: - The Start Line

let report = PerseusLogger.Report()

log.customActionOnMessage = report.report(_:)

log.level = .debug
log.output = .consoleapp

log.turned = .on

log.message("> The start line...", .info)

// AppOptions.removeAll()

let globals = AppGlobals()

let app = NSApplication.shared

let appPurpose = NSClassFromString("TestingAppDelegate") as? NSObject.Type
let appDelegate = appPurpose?.init() ?? AppDelegate()

let statusMenusPresenter = StatusMenusPresenter()

// MARK: - The Run

/*

 .accessory

 The application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be
 activated programmatically or by clicking on one of its windows.

 */

app.setActivationPolicy(.accessory)

app.delegate = appDelegate as? NSApplicationDelegate

app.activate(ignoringOtherApps: true)

log.message("> The app is ready to run...", .info)

app.run()

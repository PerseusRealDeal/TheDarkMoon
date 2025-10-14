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

// MARK: - Log Report

public let END_USER_MESSAGE_PREFIX = "End-User: "

public protocol EndUserMessageObject {
    var message: String { get set }
}

class LogReport: NSObject {

    public var objectEndUser: EndUserMessageObject?
    public var text: String { report }

    @objc dynamic var lastMessage: String = "" {
        didSet {
            let count = report.count
            if count > LIMIT {
                report = report.dropFirst(count - LIMIT).description

                if let position = report.range(of: newline)?.upperBound {
                    report.removeFirst(position.utf16Offset(in: report)-2)
                }
            }

            report.append(lastMessage + newline)
        }
    }

    private var report = ""

    private let LIMIT = 1000
    private let newline = "\r\n--\r\n"

}

typealias LogLevel = PerseusLogger.Level

func report(_ text: String, _ type: LogLevel, _ localTime: LocalTime, _ owner: PIDandTID) {
    geoReport.lastMessage = "[\(localTime.date)] [\(localTime.time)]\r\n> \(text)"

    if text.contains(END_USER_MESSAGE_PREFIX) {
        let tagRemoved = text.replacingOccurrences(of: type.tag + " ", with: "")
        let edited = tagRemoved .replacingOccurrences(of: END_USER_MESSAGE_PREFIX, with: "")
        geoReport.objectEndUser?.message = edited
    }
}

let geoReport = LogReport()

// MARK: - The Start

log.level = .debug
log.message("> The start point...", .info)

log.customActionOnMessage = report(_:_:_:_:)

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

log.message("> The app's beginning...", .info)

app.setActivationPolicy(.accessory)

app.delegate = appDelegate as? NSApplicationDelegate

app.activate(ignoringOtherApps: true)
app.run()

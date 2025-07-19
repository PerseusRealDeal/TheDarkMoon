//
//  AppGlobals.swift
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

// MARK: - App Globals

struct AppGlobals {

    // MARK: - Constants

    static let appKeyOpenWeather = "79eefe16f6e4714470502074369fc77b"

    static let statusMenusButtonIconName = "Icon"
    static let statusMenusButtonTitle = "Snowman"
    static let meteoProviderName = "/\\__/\\"

    // MARK: - Business Data

    static var currentLocation: GeoPoint? {
        didSet {
            let location = currentLocation?.description ?? "current location is erased"
            log.message("\(location) \(#function)", .info)
            // geolog.message("\(location) \(#function)", .debug, .custom)
        }
    }

    static var weather: Data? {
        didSet {
            let text = "JSON:\n\(weather?.prettyPrinted ?? "")"
            log.message("[\(type(of: self))].\(#function)\n\(text)")
        }
    }

    static var forecast: Data? {
        didSet {
            let text = "JSON:\n\(forecast?.prettyPrinted ?? "")"
            log.message("[\(type(of: self))].\(#function)\n\(text)")

            // Save the date and time of the last one.

            let src = statusMenusButtonPresenter.screenPopover.viewForecast.dataSource
            let currentTimeInUTC = Date().timeIntervalSince1970

            src.addResponseDateAndTime(dt: Int(currentTimeInUTC))
        }
    }

    // MARK: - System Services

    static let userDefaults = UserDefaults.standard
    static let notificationCenter = NotificationCenter.default

    // MARK: - Custom Services

    public let languageSwitcher: LanguageSwitcher
    public let dataDefender: PerseusDataDefender

    // MARK: - UI Data Parsers

    public let sourceCurrentWeather = CurrentDataSource()
    public let sourceForecast = ForecastDataSource()

    init() {

        log.message("[\(type(of: self))].\(#function)", .info)

        self.languageSwitcher = LanguageSwitcher.shared
        self.dataDefender = PerseusDataDefender.shared

        self.sourceCurrentWeather.path = { AppGlobals.weather ?? Data() }
        self.sourceForecast.path = { AppGlobals.forecast ?? Data() }

        // Geo Logic Setup

        GeoAgent.currentAccuracy = DEFAULT_ACCURACY

        GeoCoordinator.shared.onStatusAllowed = {
            LocationDealer.requestCurrent()
            // LocationDealer.requestUpdatingLocation()
        }

        GeoCoordinator.shared.notifier = AppGlobals.notificationCenter

        GeoCoordinator.shared.locationRecieved = { point in
            AppGlobals.currentLocation = point
        }

        GeoCoordinator.shared.locationUpdatesRecieved = { updates in
            if let thelastone = updates.last {
                log.message("Location Updates: \(updates.count)")
                // geolog.message("Location Updates: \(updates.count)", .debug, .custom)
                AppGlobals.currentLocation = thelastone
            }
        }
    }

    static func quitTheApp() {
        app.terminate(appDelegate)
    }

    static func openDefaultBrowser(string link: String) {

        log.message("[\(type(of: self))].\(#function)")

        guard let url = NSURL(string: link) as URL? else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        _ = NSWorkspace.shared.open(url) ?
        log.message("[\(type(of: self))].\(#function) - Default browser was opened.") :
        log.message("[\(type(of: self))].\(#function) - Default browser wasn't opened.")
    }
}

// MARK: - Constant Links

let linkTheAppSourceCode =
"https://github.com/perseusrealdeal/macOS.Weather"

let linkTheTechnologicalTree =
"https://github.com/perseusrealdeal/TheTechnologicalTree"

let linkPerseusDarkMode =
"https://github.com/perseusrealdeal/PerseusDarkMode"

let linkTheOpenWeatherClient =
"https://github.com/perseusrealdeal/OpenWeatherFreeClient"

let linkPerseusGeoLocationKit =
"https://github.com/perseusrealdeal/PerseusGeoLocationKit"

let linkPerseusCompassDirection =
"https://gist.github.com/perseusrealdeal/3b053b2390d704f561ec52c6477b5cf2"

let linkPerseusTimeFormat =
"https://gist.github.com/perseusrealdeal/7aa89d78d9b1c220cc06682be8908a97"

let linkPerseusLogger =
"https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5"

let linkConsolePerseusLogger =
"https://github.com/perseusrealdeal/ConsolePerseusLogger"

let linkTermsAndConditions =
"https://docs.google.com/document/d/1lwxSCjpwUYrHApivKoCXqdCpR4xeAuCBBWARUWHuaz8/"

let linkLicense =
"https://docs.google.com/document/d/1V9n-IQYl9VQeoQxXDdgohgXgGkDSGe5yWOGizOGr6a0/"

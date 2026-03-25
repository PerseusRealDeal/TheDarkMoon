//
//  AppGlobals.swift
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
import CoreLocation

// MARK: - App Globals

extension Notification.Name {
    public static let suggestionNotification = Notification.Name("suggestionNotification")
    public static let favoriteNotification = Notification.Name("favoriteNotification")
    public static let bookmarkNotification = Notification.Name("bookmarkNotification")
}

extension GeoPoint {
    public init(_ latitude: Double, _ longitude: Double) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}

// To adjust DarkMode appearance for HighSierra
var isHighSierra: Bool { // true for HighSierra
    if #available(macOS 10.14, *) {
        return false
    }
    return true
}

// Multiline status menus view not available in legacy OS line
var isLegacy: Bool { // true for High Sierra, Mojave, Catalina
    if #available(macOS 11.0, *) {
        return false
    }

    return true
}

struct AppGlobals {

    // MARK: - Constants

    // 79eefe16f6e4714470502074369fc77b
    static let appKeyOpenWeather = ""

    static let statusMenusButtonIconName = "Icon"
    static let meteoProviderName = "/\\__/\\"

    static let favoritesLimit: Int = 7
    static let useSuggestionsSample = false

    // MARK: - Business Data

    static var currentLocation: GeoPoint? {
        didSet {
            guard let description = currentLocation?.description else {
                log.message("[\(type(of: self))].\(#function) erased", .info)
                return
            }

            log.message("[\(type(of: self))].\(#function) \(description) setted", .info)
        }
    }

    static var suggestion: Location? {
        didSet {
            guard
                let description = suggestion?.description,
                let point = suggestion?.point
            else {
                log.message("[\(type(of: self))].\(#function) erased", .info)
                return
            }

            let selected = "\(description): \(point)"
            log.message("[\(type(of: self))].\(#function) \(selected) selected", .info)
        }
    }

    static var weather: Data? {
        didSet {

            guard let weather = weather else {
                globals.sourceWeather.resetDataCach()
                log.message("[\(type(of: self))].\(#function) erased and reseted", .info)
                return
            }

            log.message("JSON:\n\(weather.prettyPrinted ?? "")", .info)
        }
    }

    static var forecast: Data? {
        didSet {

            guard let forecast = forecast else {
                globals.sourceForecast.resetDataCach()
                log.message("[\(type(of: self))].\(#function) erased and reseted", .info)
                return
            }

            // log.message("JSON:\n\(forecast.prettyPrinted ?? "")", .info)
            log.message("JSON:\n\(forecast.prettyPrinted ?? "")", .info, .standard)

            // Save the date and time of the last one.

            let src = Coordinator.shared.screenPopover.viewForecast.dataSource
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

    public let sourceWeather = WeatherDataSource()
    public let sourceForecast = ForecastDataSource()

    init() {

        log.message("[\(type(of: self))].\(#function)", .notice)

        self.languageSwitcher = LanguageSwitcher.shared
        self.dataDefender = PerseusDataDefender.shared

        self.sourceWeather.path = { AppGlobals.weather ?? Data() }
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
                // log.message("Location Updates: \(updates.count)")
                // geolog.message("Location Updates: \(updates.count)", .debug, .custom)
                AppGlobals.currentLocation = thelastone
            }
        }
    }

    static func quitTheApp() {
        Coordinator.deinitTimer()
        app.terminate(appDelegate)
    }

    static func openDefaultBrowser(string link: String) {

        guard let url = NSURL(string: link) as URL? else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        _ = NSWorkspace.shared.open(url) ?
        log.message("[\(type(of: self))].\(#function) Default browser opened.") :
        log.message("[\(type(of: self))].\(#function) Default browser not opened.")

        log.message("[\(type(of: self))].\(#function) called: \(link)", .info)
    }
}

func loadCPLProfile(_ name: String) -> (status: Bool, info: String) {
    if let path = Bundle.main.url(forResource: name, withExtension: "json") {
        if log.loadConfig(path) {
            return (true, "Logging options successfully reseted.")
        } else {
            return (false, "Failed to reset options.")
        }
    } else {
        return (false, "Failed to create URL.")
    }
}

extension AppGlobals {
    static func permissionStatusLocalized() -> String {
        let status = GeoAgent.currentStatus.localizedKey.localizedValue
        return "Label: Permission".localizedValue + ": \(status)."
    }
}

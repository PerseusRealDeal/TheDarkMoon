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

let marketNameOpenWeather = "OpenWeather"
let marketNameOpenMeteo = "Open-Meteo"

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

// MARK: - App Globals

struct AppGlobals {

    // MARK: - Constants

    // Don't be shy. Step into the light: 79eefe16f6e4714470502074369fc77b
    static let keyOpenWeatherAPI = ""

    static let theAppLogoImageName = "Icon"
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
            ContentCoordinator.startUpdateTimerIfNeeded()
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

    static var weather: (data: Data, source: MeteoProvider)? {
        didSet {

            guard let weather = weather else {
                AppGlobals.currentWeatherReader.resetDataCach()
                log.message("[\(type(of: self))].\(#function) erased and reseted", .info)
                return
            }

            log.message("JSON:\n\(weather.data.prettyPrinted ?? "")", .info)
        }
    }

    static var forecast: (data: Data, source: MeteoProvider)? {
        didSet {

            guard let forecast = forecast else {
                AppGlobals.forecastReader.resetDataCach()
                log.message("[\(type(of: self))].\(#function) erased and reseted", .info)
                return
            }

            // log.message("JSON:\n\(forecast.prettyPrinted ?? "")", .info)
            log.message("JSON:\n\(forecast.data.prettyPrinted ?? "")", .info, .standard)

            // Save the date and time of the last one.

            let src = ContentCoordinator.shared.screenPopover.viewForecast.dataSource
            let currentTimeInUTC = Date().timeIntervalSince1970

            src.addResponseDateAndTime(dt: Int(currentTimeInUTC))
        }
    }

    // MARK: - System Services

    static let userDefaults = UserDefaults.standard
    static let notificationCenter = NotificationCenter.default

    // MARK: - Custom Services

    static let languageSwitcher = LanguageSwitcher.shared
    static let dataDefender = PerseusDataDefender.shared

    // MARK: - Business Data Reading Services

    static let currentWeatherReader = CurrentWeatherReader()
    static let forecastReader = ForecastReader()

    // MARK: - Common Services Setup

    static func setup() {

        log.message("[\(type(of: self))].\(#function)", .info, .standard)

        AppGlobals.currentWeatherReader.path = { AppGlobals.weather?.data ?? Data() }
        AppGlobals.forecastReader.path = { AppGlobals.forecast?.data ?? Data() }

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
}

// MARK: Global Functions

func quitTheApp() {
    app.terminate(appDelegate)
}

func openDefaultBrowser(string link: String) {

    guard let url = NSURL(string: link) as URL? else {
        log.message(#function, .error)
        return
    }

    _ = NSWorkspace.shared.open(url) ?
    log.message("\(#function) Default browser opened.") :
    log.message("\(#function) Default browser not opened.")

    log.message("\(#function) called: \(link)", .info)
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

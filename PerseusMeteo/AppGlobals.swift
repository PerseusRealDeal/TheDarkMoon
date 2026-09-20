//
//  AppGlobals.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7535 PerseusRealDeal
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
    static let theKeyOpenWeatherAPI = ""

    static let theAppLogoImageName = "Icon"
    static let theMeteoProviderName = "/\\__/\\"

    static let favoritesLimit: Int = 7

    // MARK: - Business Data

    static var currentLocation: GeoPoint? {
        didSet {
            guard let description = currentLocation?.description else {
                log.message("[\(type(of: self))].\(#function): Erased", .info)
                return
            }

            log.message("[\(type(of: self))].\(#function) \(description): Setted", .info)
            ContentCoordinator.startUpdateTimerIfNeeded()
        }
    }

    static var suggestion: Location? {
        didSet {
            guard
                let description = suggestion?.description,
                let point = suggestion?.point
            else {
                log.message("[\(type(of: self))].\(#function): Erased", .info)
                return
            }

            let selected = "\(description): \(point)"
            log.message("[\(type(of: self))].\(#function) \(selected): Selected", .info)
        }
    }

    static var weather: (data: Data, source: MeteoProvider)? {
        didSet {

            if weather == nil {
                currentReader.clearData()
                log.message("[\(type(of: self))].\(#function): Erased and reseted", .info)
                return
            }

            currentReader.refreshData()

            let logmsg = "\n\(weather?.data.prettyPrinted ?? "")"
            log.message("[\(type(of: self))].\(#function): Data:\(logmsg)", .info, .standard)
        }
    }

    static var forecast: (data: Data, source: MeteoProvider)? {
        didSet {

            if forecast == nil {
                forecastReader.clearData()
                log.message("[\(type(of: self))].\(#function): Erased and reseted", .info)
                return
            }

            forecastReader.addResponseDateAndTime(dt: Int(Date().timeIntervalSince1970))
            forecastReader.refreshData()

            let logmsg = "\n\(forecast?.data.prettyPrinted ?? "")"
            log.message("[\(type(of: self))].\(#function): Data:\(logmsg)", .info, .standard)
        }
    }

    // MARK: - System Services

    static let userDefaults = UserDefaults.standard
    static let notificationCenter = NotificationCenter.default

    // MARK: - Custom Services

    static let languageSwitcher = LanguageSwitcher.shared
    static let dataDefender = PerseusDataDefender.shared

    // MARK: - Business Data Reading Services

    static let currentReader = CurrentReader.shared
    static let forecastReader = ForecastReader.shared

    // MARK: - Common Services Setup

    static func setup() {

        log.message("[\(type(of: self))].\(#function)", .info, .standard)

        currentReader.path = { AppGlobals.weather }
        forecastReader.path = { AppGlobals.forecast }

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

    // MARK: - Contract Methods

    // To request meteo data (current, forecast or suggestions)
    static func getLocationPoint() -> GeoPoint? {

        log.message("[\(type(of: self))].\(#function)")

        var locationCardType: LocationCardType?

        if let type = ContentCoordinator.shared.screenPopover.viewLocation?.locationCard {
            locationCardType = type
        } else {
            locationCardType = AppOptions.favoriteLocationsOption.first(where: {
                $0.isOnDisplay && $0.isCurrentLocation }) != nil ? .current : .favorite
        }

        guard let locationCard = locationCardType else { return nil }

        var point: GeoPoint?

        switch locationCard {
        case .suggestion:
            point = AppGlobals.suggestion?.point
        case .favorite:
            point = AppOptions.favoriteLocationsOption.first(where: { $0.isOnDisplay })?.point
        case .current:
            point = AppGlobals.currentLocation
        }

        return point
    }
}

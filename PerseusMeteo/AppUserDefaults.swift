//
//  AppUserDefaults.swift
//  PerseusMeteo
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
// swiftlint:disable file_length
//

import Foundation

// MARK: - Keys

// public let OPEN_WEATHER_API_KEY_OPTION_KEY = "OPEN_WEATHER_API_OPTION_KEY"
public let OPEN_WEATHER_API_KEY_TEXT_LIMIT = 32

public let LANGUAGE_OPTION_KEY = "LANGUAGE_OPTION_KEY"
public let LANGUAGE_OPTION_DEFAULT = LanguageOption.system

public let TEMPERATURE_OPTION_KEY = "TEMPERATURE_OPTION_KEY"
public let TEMPERATURE_OPTION_DEFAULT = TemperatureOption.imperial

public let WINDSPEED_OPTION_KEY = "WINDSPEED_OPTION_KEY"
public let WINDSPEED_OPTION_DEFAULT = WindSpeedOption.mph

public let PRESSURE_OPTION_KEY = "PRESSURE_OPTION_KEY"
public let PRESSURE_OPTION_DEFAULT = PressureOption.mb

public let TIME_OPTION_KEY = "TIME_OPTION_KEY"
public let TIME_OPTION_DEFAULT = TimeFormatOption.system

public let DISTANCE_OPTION_KEY = "DISTANCE_OPTION_KEY"
public let DISTANCE_OPTION_DEFAULT = LengthOption.mile

public let SUGGESTIONS_REQUEST_OPTION_KEY = "SUGGESTIONS_REQUEST_OPTION_KEY"
public let SUGGESTIONS_REQUEST_OPTION_DEFAULT = false

public let FAVORITE_LOCATIONS_OPTION_KEY = "FAVORITE_LOCATIONS_OPTION_KEY"
public let FAVORITE_LOCATIONS_OPTION_DEFAULT: [Location] =
[
    Location(isCurrent: true, isOnDisplay: true)
]

public let STATUSMENUS_OPTION_KEY = "STATUSMENUS_OPTION_KEY"
public let STATUSMENUS_OPTION_DEFAULT = false

public let STATUSMENUS_PERIOD_OPTION_KEY = "STATUSMENUS_PERIOD_OPTION_KEY"
public let STATUSMENUS_PERIOD_OPTION_DEFAULT = StatusMenusUpdatePeriodOption.none

// MARK: - User Defaults

class AppOptions {

    // MARK: - Special options

    public static var autoSuggestionsRequestOption: Bool {
        get {
            let ud = AppGlobals.userDefaults

            let result = ud.valueExists(forKey: SUGGESTIONS_REQUEST_OPTION_KEY) ?
            ud.bool(forKey: SUGGESTIONS_REQUEST_OPTION_KEY) :
            SUGGESTIONS_REQUEST_OPTION_DEFAULT

            return result
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue, forKey: SUGGESTIONS_REQUEST_OPTION_KEY)
        }
    }

    public static var favoriteLocationsOption: [Location] {
        get {
            let ud = AppGlobals.userDefaults
            if let savedArray = ud.data(forKey: FAVORITE_LOCATIONS_OPTION_KEY) {
                let decoder = JSONDecoder()
                if let loadedArray = try? decoder.decode([Location].self, from: savedArray) {
                    return loadedArray
                }
            }
            return FAVORITE_LOCATIONS_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                ud.set(encoded, forKey: FAVORITE_LOCATIONS_OPTION_KEY)
            }
        }
    }

    public static var statusMenusOption: Bool {
        get {
            let ud = AppGlobals.userDefaults

            let result = ud.valueExists(forKey: STATUSMENUS_OPTION_KEY) ?
            ud.bool(forKey: STATUSMENUS_OPTION_KEY) : STATUSMENUS_OPTION_DEFAULT

            return result
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue, forKey: STATUSMENUS_OPTION_KEY)
        }
    }

    public static var statusMenusPeriodOption: StatusMenusUpdatePeriodOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: STATUSMENUS_PERIOD_OPTION_KEY) ?
            ud.integer(forKey: STATUSMENUS_PERIOD_OPTION_KEY) :
            STATUSMENUS_PERIOD_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = StatusMenusUpdatePeriodOption.init(rawValue: rawValue) {
                return result
            }

            // Return default saved value in any other case

            ud.setValue(STATUSMENUS_PERIOD_OPTION_DEFAULT.rawValue,
                        forKey: STATUSMENUS_PERIOD_OPTION_KEY)
            return STATUSMENUS_PERIOD_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: STATUSMENUS_PERIOD_OPTION_KEY)
        }
    }

    // MARK: - OpenWeather API Key Option

    public static var OpenWeatherAPIOption: String? {
        get {
            // Secret
            let defender = globals.dataDefender
            var secret: String?

            // Load value from Keychain
            do {
                secret = try defender.load(OpenWeatherCredentials())
            } catch DataDefenderError.unhandledError {
                return nil // Rejected to load a value
            } catch {
                return "" // There's no value
            }

            // The value should meet OPEN_WEATHER_API_KEY_TEXT_LIMIT
            guard let text = secret, !text.isEmpty else { return secret }

            let limit = OPEN_WEATHER_API_KEY_TEXT_LIMIT

            if text.count > limit {
                let secret = "[\(type(of: self))].\(#function), The key is out of length."
                log.message(secret, .error)
            }

            return secret
        }
        set {
            let value = newValue ?? ""

            // Update secret value
            let defender = globals.dataDefender
            let credentials = OpenWeatherCredentials(secret: value)

            if value.isEmpty {
                // Remove secret
                try? defender.remove(credentials)
            } else {
                // Save secret
                try? defender.save(credentials)
            }
        }
    }

    // MARK: - Language Option

    public static var languageOption: LanguageOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: LANGUAGE_OPTION_KEY) ?
                ud.integer(forKey: LANGUAGE_OPTION_KEY) : LANGUAGE_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = LanguageOption.init(rawValue: rawValue) { return result }

            // Return default saved value in any other case

            ud.setValue(LANGUAGE_OPTION_DEFAULT.rawValue, forKey: LANGUAGE_OPTION_KEY)
            return LANGUAGE_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: LANGUAGE_OPTION_KEY)
        }
    }

    // MARK: - Temperature Option

    public static var temperatureOption: TemperatureOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: TEMPERATURE_OPTION_KEY) ?
                ud.integer(forKey: TEMPERATURE_OPTION_KEY) :
                    TEMPERATURE_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = TemperatureOption.init(rawValue: rawValue) { return result }

            // Return default saved value in any other case

            ud.setValue(TEMPERATURE_OPTION_DEFAULT.rawValue, forKey: TEMPERATURE_OPTION_KEY)
            return TEMPERATURE_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: TEMPERATURE_OPTION_KEY)
        }
    }

    // MARK: - Wind Speed Option

    public static var windSpeedOption: WindSpeedOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: WINDSPEED_OPTION_KEY) ?
                ud.integer(forKey: WINDSPEED_OPTION_KEY) :
                    WINDSPEED_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = WindSpeedOption.init(rawValue: rawValue) { return result }

            // Return default saved value in any other case

            ud.setValue(WINDSPEED_OPTION_DEFAULT.rawValue, forKey: WINDSPEED_OPTION_KEY)
            return WINDSPEED_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: WINDSPEED_OPTION_KEY)
        }
    }

    // MARK: - Pressure

    public static var pressureOption: PressureOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: PRESSURE_OPTION_KEY) ?
                ud.integer(forKey: PRESSURE_OPTION_KEY) :
                    PRESSURE_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = PressureOption.init(rawValue: rawValue) { return result }

            // Return default saved value in any other case

            ud.setValue(PRESSURE_OPTION_DEFAULT.rawValue, forKey: PRESSURE_OPTION_KEY)
            return PRESSURE_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: PRESSURE_OPTION_KEY)
        }
    }

    // MARK: - Time Format

    public static var timeFormatOption: TimeFormatOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: TIME_OPTION_KEY) ?
                ud.integer(forKey: TIME_OPTION_KEY) :
                    TIME_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = TimeFormatOption.init(rawValue: rawValue) { return result }

            // Return default saved value in any other case

            ud.setValue(TIME_OPTION_DEFAULT.rawValue, forKey: TIME_OPTION_KEY)
            return TIME_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: TIME_OPTION_KEY)
        }
    }

    // MARK: - Length of Distance

    public static var distanceOption: LengthOption {
        get {
            // Load enum Int value

            let ud = AppGlobals.userDefaults

            let rawValue = ud.valueExists(forKey: DISTANCE_OPTION_KEY) ?
                ud.integer(forKey: DISTANCE_OPTION_KEY) :
                DISTANCE_OPTION_DEFAULT.rawValue

            // Try to cast Int value to enum

            if let result = LengthOption.init(rawValue: rawValue) { return result }

            // Return default saved value in any other case

            ud.setValue(DISTANCE_OPTION_DEFAULT.rawValue, forKey: DISTANCE_OPTION_KEY)
            return DISTANCE_OPTION_DEFAULT
        }
        set {
            let ud = AppGlobals.userDefaults
            ud.setValue(newValue.rawValue, forKey: DISTANCE_OPTION_KEY)
        }
    }
}

// MARK: - RESET OPTIONS

extension AppOptions {

    public static func removeAll() {

        log.message("[\(type(of: self))].\(#function)")

        let ud = AppGlobals.userDefaults

        ud.removeObject(forKey: DARK_MODE_USER_CHOICE_KEY)
        ud.removeObject(forKey: DARK_MODE_SETTINGS_KEY)
        ud.removeObject(forKey: LANGUAGE_OPTION_KEY)
        ud.removeObject(forKey: TEMPERATURE_OPTION_KEY)
        ud.removeObject(forKey: WINDSPEED_OPTION_KEY)
        ud.removeObject(forKey: PRESSURE_OPTION_KEY)
        ud.removeObject(forKey: TIME_OPTION_KEY)
        ud.removeObject(forKey: SUGGESTIONS_REQUEST_OPTION_KEY)

        self.OpenWeatherAPIOption = nil
    }
}

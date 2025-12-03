//
//  MeteoFactsDefaults.swift
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

import Foundation

public struct MeteoFactsDefaults {

    public static var lastOne: String {
        return "Label: Made with Love".localizedValue
    }

    public static var meteoDataProviderName: String {
        return AppGlobals.meteoProviderName
    }

    public static var weatherIconName: String {
        return AppGlobals.statusMenusButtonIconName
    }

    public static var forecastDaysItemWeatherDescription: String {
        return "Label: DayItem Weather Conditions".localizedValue
    }

    public static var temperature: String {
        return "\(temperatureCurrentFormat)\(AppOptions.temperatureOption.unit)"
    }

    public static var windSpeed: String {
        return "\(windSpeedFormat) \(AppOptions.windSpeedOption.unitLocalized)"
    }

    public static var windDirection: String {
        return  "___° : _/__"
    }

    public static var pressure: String {
        return  "____ \(AppOptions.pressureOption.unitLocalized)"
    }

    public static var humidity: String {
        return  "___%"
    }

    public static var cloudiness: String {
        return  "___%"
    }

    public static var visibility: String {
        return  "_____ \(AppOptions.distanceOption.unitLocalized)"
    }

    public static var sunrizesunset: String {

        var template = ""

        switch AppOptions.timeFormatOption {
        case .hour24:
            template = "--:--"
        case .hour12:
            template = "--:-- _._."
        case .system:
            template = Date.currentTimeFormat == .hour12 ? "--:-- _._." : "--:--"
        }

        return template
    }

    public static var conditions: String {
        return "Label: Weather Conditions".localizedValue
    }

    public static var weekday: String {
        return "Label: Weekday short".localizedValue
    }

    public static var forecastDate: String {
        return "Label: Forecast Date".localizedValue
    }

    public static var weatherConditions: WeatherConditions {
        return WeatherConditions(code: WeatherCode(rawValue: 99)!, name: "Icon")
    }

    // MARK: - Private Properties

    public static var temperatureCurrentFormat: String {

        var format = ""

        switch AppOptions.temperatureOption {
        case .standard:
            format = "___.__"
        case .metric:
            format = "-__"
        case .imperial:
            format = "-__"
        }

        return format
    }

    private static var windSpeedFormat: String {

        var format = ""

        switch AppOptions.windSpeedOption {
        case .ms:
            format = "__"
        case .kmh:
            format = "__"
        case .mph:
            format = "__"
        }

        return format
    }

}

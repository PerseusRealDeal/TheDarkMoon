//
//  CurrentDictionary.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public class CurrentDictionary: MeteoDataDictionary {

    public var parser: CurrentParserProtocol?

    // MARK: - Properties

    public var lastOne: Int? {

        guard let cach = data else { return nil }

        return parser?.getLastOne(from: cach)
    }

    public var timezone: Int? {

        guard let cach = data else { return nil }

        return parser?.getTimeZone(from: cach)
    }

    public var weatherIconName: String? {

        guard
            let cach = data,
            let name = parser?.getWeatherIconName(from: cach)
        else {
            return nil
        }

        return name
    }

    public var weatherDescription: String? {

        guard let cach = data else { return nil }

        return parser?.getWeatherDescription(from: cach)
    }

    public var temperature: String? {

        guard let cach = data else { return nil }

        return parser?.getTemperature(from: cach)
    }

    public var temperatureFeelsLike: String? {

        guard let cach = data else { return nil }

        return parser?.getTemperatureFeelsLike(from: cach)
    }

    public var temperatureMinimum: String? {

        guard let cach = data else { return nil }

        return parser?.getTemperatureMinimum(from: cach)
    }

    public var temperatureMaximum: String? {

        guard let cach = data else { return nil }

        return parser?.getTemperatureMaximum(from: cach)
    }

    public var windSpeed: String? {

        guard let cach = data else { return nil }

        return parser?.getWindSpeed(from: cach)
    }

    public var windGusts: String? {

        guard let cach = data else { return nil }

        return parser?.getWindGusts(from: cach)
    }

    public var windDirection: String? {

        guard let cach = data else { return nil }

        return parser?.getWindDirection(from: cach)
    }

    public var pressure: String? {

        guard let cach = data else { return nil }

        return parser?.getPressure(from: cach)
    }

    public var humidity: Int? {

        guard let cach = data else { return nil }

        return parser?.getHumidity(from: cach)
    }

    public var cloudiness: Int? {

        guard let cach = data else { return nil }

        return parser?.getCloudiness(from: cach)
    }

    public var visibility: Int? {

        guard let cach = data else { return nil }

        return parser?.getVisibility(from: cach)
    }

    public var sunrise: Int? {

        guard let cach = data else { return nil }

        return parser?.getSunrise(from: cach)
    }

    public var sunset: Int? {

        guard let cach = data else { return nil }

        return parser?.getSunset(from: cach)
    }

    public var weatherConditions: WeatherConditions {

        if let cach = data, let parser = parser {
            return parser.getWeatherConditions(from: cach)
        }

        return MeteoFactsDefaults.weatherConditions
    }
}

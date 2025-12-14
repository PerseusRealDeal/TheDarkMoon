//
//  WeatherDataSourceReader.swift
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

public class WeatherDataSourceReader: MeteoDataSourceReader {

    public var parser: WeatherParserProtocol?

    // MARK: - Properties

    public var lastOne: Int? {

        guard let dict = data else { return nil }

        return parser?.getLastOne(from: dict)
    }

    public var timezone: Int? {

        guard let dict = data else { return nil }

        return parser?.getTimeZone(from: dict)
    }

    public var weatherIconName: String? {

        guard let dict = data else { return nil }

        return parser?.getWeatherIconName(from: dict)
    }

    public var weatherDescription: String? {

        guard let dict = data else { return nil }

        return parser?.getWeatherDescription(from: dict)
    }

    public var temperature: String? {

        guard let dict = data else { return nil }

        return parser?.getTemperature(from: dict)
    }

    public var temperatureFeelsLike: String? {

        guard let dict = data else { return nil }

        return parser?.getTemperatureFeelsLike(from: dict)
    }

    public var temperatureMinimum: String? {

        guard let dict = data else { return nil }

        return parser?.getTemperatureMinimum(from: dict)
    }

    public var temperatureMaximum: String? {

        guard let dict = data else { return nil }

        return parser?.getTemperatureMaximum(from: dict)
    }

    public var windSpeed: String? {

        guard let dict = data else { return nil }

        return parser?.getWindSpeed(from: dict)
    }

    public var windGusts: String? {

        guard let dict = data else { return nil }

        return parser?.getWindGusts(from: dict)
    }

    public var windDirection: String? {

        guard let dict = data else { return nil }

        return parser?.getWindDirection(from: dict)
    }

    public var pressure: String? {

        guard let dict = data else { return nil }

        return parser?.getPressure(from: dict)
    }

    public var humidity: Int? {

        guard let dict = data else { return nil }

        return parser?.getHumidity(from: dict)
    }

    public var cloudiness: Int? {

        guard let dict = data else { return nil }

        return parser?.getCloudiness(from: dict)
    }

    public var visibility: Int? {

        guard let dict = data else { return nil }

        return parser?.getVisibility(from: dict)
    }

    public var sunrise: Int? {

        guard let dict = data else { return nil }

        return parser?.getSunrise(from: dict)
    }

    public var sunset: Int? {

        guard let dict = data else { return nil }

        return parser?.getSunset(from: dict)
    }

    public var weatherConditions: WeatherConditions {

        if let dict = data, let parser = parser {
            return parser.getWeatherConditions(from: dict)
        }

        return MeteoFactsDefaults.weatherConditions
    }
}

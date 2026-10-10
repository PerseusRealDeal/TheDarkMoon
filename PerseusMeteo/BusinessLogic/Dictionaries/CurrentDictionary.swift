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

    public var responseTime: Int? {

        guard let cach = data else { return nil }

        return parser?.responseTime(from: cach)
    }

    public var timezone: Int? {

        guard let cach = data else { return nil }

        return parser?.timeZone(from: cach)
    }

    public var weatherIconName: String? {

        guard
            let cach = data,
            let name = parser?.weatherIconName(from: cach)
        else {
            return nil
        }

        return name
    }

    public var weatherDescription: String? {

        guard let cach = data else { return nil }

        return parser?.weatherDescription(from: cach)
    }

    public var temperature: String? {

        guard let cach = data else { return nil }

        return parser?.temperature(from: cach)
    }

    public var temperatureFeelsLike: String? {

        guard let cach = data else { return nil }

        return parser?.temperatureFeelsLike(from: cach)
    }

    public var temperatureMinimum: String? {

        guard let cach = data else { return nil }

        return parser?.temperatureMinimum(from: cach)
    }

    public var temperatureMaximum: String? {

        guard let cach = data else { return nil }

        return parser?.temperatureMaximum(from: cach)
    }

    public var windSpeed: String? {

        guard let cach = data else { return nil }

        return parser?.windSpeed(from: cach)
    }

    public var windGusts: String? {

        guard let cach = data else { return nil }

        return parser?.windGusts(from: cach)
    }

    public var windDirection: String? {

        guard let cach = data else { return nil }

        return parser?.windDirection(from: cach)
    }

    public var pressure: String? {

        guard let cach = data else { return nil }

        return parser?.pressure(from: cach)
    }

    public var humidity: Int? {

        guard let cach = data else { return nil }

        return parser?.humidity(from: cach)
    }

    public var cloudiness: Int? {

        guard let cach = data else { return nil }

        return parser?.cloudiness(from: cach)
    }

    public var visibility: Int? {

        guard let cach = data else { return nil }

        return parser?.visibility(from: cach)
    }

    public var sunrise: Int? {

        guard let cach = data else { return nil }

        return parser?.sunrise(from: cach)
    }

    public var sunset: Int? {

        guard let cach = data else { return nil }

        return parser?.sunset(from: cach)
    }
}

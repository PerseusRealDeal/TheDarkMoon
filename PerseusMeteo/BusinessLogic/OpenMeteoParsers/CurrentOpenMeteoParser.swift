//
//  CurrentOpenMeteoParser.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (22.09.2026.)
//
//  Copyright © 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

public class CurrentOpenMeteoParser: CurrentParserProtocol {

    // TODO: Implement Open-Meteo current weather parser protocol

    public func timeZone(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func responseTime(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func weatherDescription(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func weatherIconName(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func weatherConditions(from source: [String: Any]) -> WeatherConditions {
        MeteoFactsDefaults.weatherConditions
    }

    public func temperature(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func temperatureFeelsLike(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func temperatureMinimum(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func temperatureMaximum(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func windSpeed(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func windGusts(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func windDirection(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func pressure(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func humidity(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func cloudiness(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func visibility(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func sunrise(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func sunset(from dictionary: [String: Any]) -> Int? {
        return nil
    }

}

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

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func getLastOne(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func getWeatherDescription(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getWeatherIconName(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getWeatherConditions(from source: [String: Any]) -> WeatherConditions {
        return MeteoFactsDefaults.weatherConditions
    }

    public func getTemperature(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getTemperatureFeelsLike(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getTemperatureMinimum(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getTemperatureMaximum(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getWindSpeed(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getWindGusts(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getWindDirection(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getPressure(from dictionary: [String: Any]) -> String? {
        return nil
    }

    public func getHumidity(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func getCloudiness(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func getVisibility(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func getSunrise(from dictionary: [String: Any]) -> Int? {
        return nil
    }

    public func getSunset(from dictionary: [String: Any]) -> Int? {
        return nil
    }
}

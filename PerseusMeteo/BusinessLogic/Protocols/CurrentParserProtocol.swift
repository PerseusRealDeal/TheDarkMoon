//
//  CurrentParserProtocol.swift
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

// MARK: - Protocols

public protocol CurrentParserProtocol {

    func getTimeZone(from dictionary: [String: Any]) -> Int?
    func getLastOne(from dictionary: [String: Any]) -> Int?

    func getWeatherDescription(from dictionary: [String: Any]) -> String?
    func getWeatherIconName(from dictionary: [String: Any]) -> String?
    func getWeatherConditions(from source: [String: Any]) -> WeatherConditions

    func getTemperature(from dictionary: [String: Any]) -> String?
    func getTemperatureFeelsLike(from dictionary: [String: Any]) -> String?
    func getTemperatureMinimum(from dictionary: [String: Any]) -> String?
    func getTemperatureMaximum(from dictionary: [String: Any]) -> String?

    func getWindSpeed(from dictionary: [String: Any]) -> String?
    func getWindGusts(from dictionary: [String: Any]) -> String?
    func getWindDirection(from dictionary: [String: Any]) -> String?

    func getPressure(from dictionary: [String: Any]) -> String?
    func getHumidity(from dictionary: [String: Any]) -> Int?
    func getCloudiness(from dictionary: [String: Any]) -> Int?
    func getVisibility(from dictionary: [String: Any]) -> Int?

    func getSunrise(from dictionary: [String: Any]) -> Int?
    func getSunset(from dictionary: [String: Any]) -> Int?
}

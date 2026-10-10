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

    func timeZone(from dictionary: [String: Any]) -> Int?
    func responseTime(from dictionary: [String: Any]) -> Int?

    func weatherDescription(from dictionary: [String: Any]) -> String?
    func weatherIconName(from dictionary: [String: Any]) -> String?

    func temperature(from dictionary: [String: Any]) -> String?
    func temperatureFeelsLike(from dictionary: [String: Any]) -> String?
    func temperatureMinimum(from dictionary: [String: Any]) -> String?
    func temperatureMaximum(from dictionary: [String: Any]) -> String?

    func windSpeed(from dictionary: [String: Any]) -> String?
    func windGusts(from dictionary: [String: Any]) -> String?
    func windDirection(from dictionary: [String: Any]) -> String?

    func pressure(from dictionary: [String: Any]) -> String?
    func humidity(from dictionary: [String: Any]) -> Int?
    func cloudiness(from dictionary: [String: Any]) -> Int?
    func visibility(from dictionary: [String: Any]) -> Int?

    func sunrise(from dictionary: [String: Any]) -> Int?
    func sunset(from dictionary: [String: Any]) -> Int?
}

//
//  ForecastParserProtocol.swift
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

public protocol ForecastParserProtocol {
    func getTimeZone(from dictionary: [String: Any]) -> Int?
    func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]?
}

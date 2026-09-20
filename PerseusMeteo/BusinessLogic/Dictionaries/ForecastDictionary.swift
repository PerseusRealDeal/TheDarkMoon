//
//  ForecastDictionary.swift
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

public class ForecastDictionary: MeteoDataDictionary {

    public var parser: ForecastParserProtocol?

    // MARK: - Properties

    public var lastOne: Int?

    public var timezone: Int? {

        guard let cach = data else { return nil }

        return parser?.getTimeZone(from: cach)
    }

    public var forecastDays: [ForecastDay]? {

        guard let cach = data else { return nil }

        return parser?.getForecastDays(from: cach)
    }

    // MARK: - Reset properties

    public func clear() {
        lastOne = nil
    }
}

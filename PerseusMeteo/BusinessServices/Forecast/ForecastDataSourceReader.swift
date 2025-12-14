//
//  ForecastDataSourceReader.swift
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

public class ForecastDataSourceReader: MeteoDataSourceReader {

    // public var data: [String: Any]?
    public var parser: ForecastParserProtocol?

    // MARK: - Properties

    public var lastOne: Int?

    public var timezone: Int? {

        guard let dict = data else { return nil }

        return parser?.getTimeZone(from: dict)
    }

    public var forecastDays: [ForecastDay]? {

        guard let dict = data else { return nil }

        return parser?.getForecastDays(from: dict)
    }

    // MARK: - Reset properties

    public func clear() {
        lastOne = nil
    }
}

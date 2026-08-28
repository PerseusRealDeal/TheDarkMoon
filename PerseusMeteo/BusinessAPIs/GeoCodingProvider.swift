//
//  GeoCodingProvider.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (20.08.2026.)
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public enum GeoCodingProvider: Int, CaseIterable, CustomStringConvertible, Codable {

    case serviceOpenWeatherMap = 0 // Version 1.0
    case serviceOpenMeteo      = 1 // Version 1

    public var description: String {
        return "\(marketName)"
    }

    public var marketName: String {
        switch self {
        case .serviceOpenWeatherMap:
            return marketNameOpenWeather
        case .serviceOpenMeteo:
            return marketNameOpenMeteo
        }
    }

    public var webLink: String {
        switch self {
        case .serviceOpenWeatherMap:
            return linkGeoCodingOpenWeather
        case .serviceOpenMeteo:
            return linkGeoCodingOpenMeteo
        }
    }
}

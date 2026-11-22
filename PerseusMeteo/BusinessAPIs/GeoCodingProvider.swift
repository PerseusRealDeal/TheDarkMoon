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

    case serviceOpenMeteo      = 0 // Version 1
    case serviceOpenWeatherMap = 1 // Version 1.0

    public var marketName: String {
        switch self {
        case .serviceOpenMeteo:
            return marketNameOpenMeteo
        case .serviceOpenWeatherMap:
            return marketNameOpenWeather
        }
    }

    public var marketNameWebLink: String {
        switch self {
        case .serviceOpenMeteo:
            return linkOpenMeteo
        case .serviceOpenWeatherMap:
            return linkOpenWeather
        }
    }

    public var description: String {
        return "\(marketName)"
    }
}

//
//  MeteoProvider.swift
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

public enum MeteoProvider: Int, CaseIterable, CustomStringConvertible, Codable {

    case serviceOpenMeteo      = 0 // Version 1
    case serviceOpenWeatherMap = 1 // Version 2.5

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

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

// MARK: - Providers list

public enum MeteoProvider: CustomStringConvertible {

    public var description: String {

        switch self {
        case .serviceOpenWeatherMap:
            return "OpenWeather" // Market name.
        }
    }

    case serviceOpenWeatherMap // Version 2.5.
}

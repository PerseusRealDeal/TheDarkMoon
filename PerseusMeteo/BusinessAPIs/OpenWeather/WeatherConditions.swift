//
//  WeatherConditions.swift
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

public struct WeatherConditions: CustomStringConvertible {

    public let code: WeatherCode
    public let icon: String

    init(code: WeatherCode, name: String) {
        self.code = code
        self.icon = name
    }

    public var main: String {
        switch self.icon {
        case "01d", "01n":
            return "Main: clear sky".localizedValue
        case "02d", "02n":
            return "Main: few clouds".localizedValue
        case "03d", "03n":
            return "Main: scattered clouds".localizedValue
        case "04d", "04n":
            return "Main: broken clouds".localizedValue
        case "09d", "09n":
            return "Main: shower rain".localizedValue
        case "10d", "10n":
            return "Main: rain".localizedValue
        case "11d", "11n":
            return "Main: thunderstorm".localizedValue
        case "13d", "13n":
            return "Main: snow".localizedValue
        case "50d", "50n":
            return "Main: mist".localizedValue
        default:
            return MeteoFactsDefaults.conditions
        }
    }

    public var description: String {
        return "\(code)"
    }
}

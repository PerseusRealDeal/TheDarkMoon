//
//  OpenMeteoCode.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (09.10.2026.)
//
//  Copyright © 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public enum OpenMeteoCode: Int {

    case thunderstormHeavyHail         = 99
    case thunderstormSlightHail        = 96
    case thunderstormSlightOrModerate  = 95

    case snowShowersHeavy              = 86
    case snowShowersSlight             = 85
    case rainShowersViolent            = 82
    case rainShowersModerate           = 81
    case rainShowersSlight             = 80

    case snowGrains                    = 77
    case snowFallHeavyIntensity        = 75
    case snowFallModerate              = 73
    case snowFallSlight                = 71

    case freezingRainHeavyIntensity    = 67
    case freezingRainLight             = 66
    case rainHeavyIntensity            = 65
    case rainModerate                  = 63
    case rainSlight                    = 61

    case freezingDrizzleDenseIntensity = 57
    case freezingDrizzleLight          = 56
    case drizzleDenseIntensity         = 55
    case drizzleModerate               = 53
    case drizzleLight                  = 51

    case depositingRimeFog             = 48
    case fog                           = 45

    case overcast                      = 3
    case partlyCloudy                  = 2
    case mainlyClear                   = 1
    case clearSky                      = 0
}

extension OpenMeteoCode: CustomStringConvertible {

    public var code: Int {
        return self.rawValue
    }

    public var description: String {

        switch self {
        case .thunderstormHeavyHail:
            return "Code: thunderstorm".localizedValue
        case .thunderstormSlightHail:
            return "Code: thunderstorm".localizedValue
        case .thunderstormSlightOrModerate:
            return "Code: thunderstorm".localizedValue
        case .snowShowersHeavy:
            return "Code: heavySnow".localizedValue
        case .snowShowersSlight:
            return "Code: heavySnow".localizedValue
        case .rainShowersViolent:
            return "Code: showerRain".localizedValue
        case .rainShowersModerate:
            return "Code: showerRain".localizedValue
        case .rainShowersSlight:
            return "Code: showerRain".localizedValue
        case .snowGrains:
            return "Code: snow".localizedValue
        case .snowFallHeavyIntensity:
            return "Code: heavySnow".localizedValue
        case .snowFallModerate:
            return "Code: heavySnow".localizedValue
        case .snowFallSlight:
            return "Code: lightSnow".localizedValue
        case .freezingRainHeavyIntensity:
            return "Code: freezingRain".localizedValue
        case .freezingRainLight:
            return "Code: freezingRain".localizedValue
        case .rainHeavyIntensity:
            return "Code: heavyIntensityRain".localizedValue
        case .rainModerate:
            return "Code: moderateRain".localizedValue
        case .rainSlight:
            return "Code: lightRain".localizedValue
        case .freezingDrizzleDenseIntensity:
            return "Code: heavyIntensityDrizzle".localizedValue
        case .freezingDrizzleLight:
            return "Code: drizzle".localizedValue
        case .drizzleDenseIntensity:
            return "Code: lightIntensityDrizzle".localizedValue
        case .drizzleModerate:
            return "Code: drizzle".localizedValue
        case .drizzleLight:
            return "Code: drizzle".localizedValue
        case .depositingRimeFog:
            return "Code: fog".localizedValue
        case .fog:
            return "Code: fog".localizedValue
        case .overcast:
            return "Code: overcastClouds_85_100".localizedValue
        case .partlyCloudy:
            return "Code: scatteredClouds_25_50".localizedValue
        case .mainlyClear:
            return "Code: fewClouds_11_25".localizedValue
        case .clearSky:
            return "Code: clearSky".localizedValue
        }
    }
}

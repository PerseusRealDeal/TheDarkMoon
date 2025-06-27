//
//  WeatherCode.swift
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
//  Data from https://openweathermap.org/weather-conditions
//
// swiftlint:disable file_length
//

import Foundation

public enum WeatherCode: Int {

    // Group Default Code

    case defaultCode                  = 99

    // Group 2xx: Thunderstorm

    case thunderstormWithLightRain    = 200
    case thunderstormWithRain         = 201
    case thunderstormWithHeavyRain    = 202
    case lightThunderstorm            = 210
    case thunderstorm                 = 211
    case heavyThunderstorm            = 212
    case raggedThunderstorm           = 221
    case thunderstormWithLightDrizzle = 230
    case thunderstormWithDrizzle      = 231
    case thunderstormWithHeavyDrizzle = 232

    // Group 3xx: Drizzle

    case lightIntensityDrizzle        = 300
    case drizzle                      = 301
    case heavyIntensityDrizzle        = 302
    case lightIntensityDrizzleRain    = 310
    case drizzleRain                  = 311
    case heavyIntensityDrizzleRain    = 312
    case showerRainAndDrizzle         = 313
    case heavyShowerRainAndDrizzle    = 314
    case showerDrizzle                = 321

    // Group 5xx: Rain

    case lightRain                    = 500
    case moderateRain                 = 501
    case heavyIntensityRain           = 502
    case veryHeavyRain                = 503
    case extremeRain                  = 504
    case freezingRain                 = 511
    case lightIntensityShowerRain     = 520
    case showerRain                   = 521
    case heavyIntensityShowerRain     = 522
    case raggedShowerRain             = 531

    // Group 6xx: Snow

    case lightSnow                    = 600
    case snow                         = 601
    case heavySnow                    = 602
    case sleet                        = 611
    case lightShowerSleet             = 612
    case showerSleet                  = 613
    case lightRainAndSnow             = 615
    case rainAndSnow                  = 616
    case lightShowerSnow              = 620
    case showerSnow                   = 621
    case heavyShowerSnow              = 622

    // Group 7xx: Atmosphere

    case mist                         = 701
    case smoke                        = 711
    case haze                         = 721
    case sandDustWhirls               = 731
    case fog                          = 741
    case sand                         = 751
    case dust                         = 761
    case volcanicAsh                  = 762
    case squalls                      = 771
    case tornado                      = 781

    // Group 800: Clear

    case clearSky                     = 800

    // Group 80x: Clouds

    case fewClouds_11_25              = 801
    case scatteredClouds_25_50        = 802
    case brokenClouds_51_84           = 803
    case overcastClouds_85_100        = 804
}

extension WeatherCode: CustomStringConvertible {

    public var code: Int {
        return self.rawValue
    }

    public var description: String {

        switch self {
        case .defaultCode:
            return "Label: Weather Conditions".localizedValue
        case .thunderstormWithLightRain:
            return "Code: thunderstormWithLightRain".localizedValue
        case .thunderstormWithRain:
            return "Code: thunderstormWithRain".localizedValue
        case .thunderstormWithHeavyRain:
            return "Code: thunderstormWithHeavyRain".localizedValue
        case .lightThunderstorm:
            return "Code: lightThunderstorm".localizedValue
        case .thunderstorm:
            return "Code: thunderstorm".localizedValue
        case .heavyThunderstorm:
            return "Code: heavyThunderstorm".localizedValue
        case .raggedThunderstorm:
            return "Code: raggedThunderstorm".localizedValue
        case .thunderstormWithLightDrizzle:
            return "Code: thunderstormWithLightDrizzle".localizedValue
        case .thunderstormWithDrizzle:
            return "Code: thunderstormWithDrizzle".localizedValue
        case .thunderstormWithHeavyDrizzle:
            return "Code: thunderstormWithHeavyDrizzle".localizedValue
        case .lightIntensityDrizzle:
            return "Code: lightIntensityDrizzle".localizedValue
        case .drizzle:
            return "Code: drizzle".localizedValue
        case .heavyIntensityDrizzle:
            return "Code: heavyIntensityDrizzle".localizedValue
        case .lightIntensityDrizzleRain:
            return "Code: lightIntensityDrizzleRain".localizedValue
        case .drizzleRain:
            return "Code: drizzleRain".localizedValue
        case .heavyIntensityDrizzleRain:
            return "Code: heavyIntensityDrizzleRain".localizedValue
        case .showerRainAndDrizzle:
            return "Code: showerRainAndDrizzle".localizedValue
        case .heavyShowerRainAndDrizzle:
            return "Code: heavyShowerRainAndDrizzle".localizedValue
        case .showerDrizzle:
            return "Code: showerDrizzle".localizedValue
        case .lightRain:
            return "Code: lightRain".localizedValue
        case .moderateRain:
            return "Code: moderateRain".localizedValue
        case .heavyIntensityRain:
            return "Code: heavyIntensityRain".localizedValue
        case .veryHeavyRain:
            return "Code: veryHeavyRain".localizedValue
        case .extremeRain:
            return "Code: extremeRain".localizedValue
        case .freezingRain:
            return "Code: freezingRain".localizedValue
        case .lightIntensityShowerRain:
            return "Code: lightIntensityShowerRain".localizedValue
        case .showerRain:
            return "Code: showerRain".localizedValue
        case .heavyIntensityShowerRain:
            return "Code: heavyIntensityShowerRain".localizedValue
        case .raggedShowerRain:
            return "Code: raggedShowerRain".localizedValue
        case .lightSnow:
            return "Code: lightSnow".localizedValue
        case .snow:
            return "Code: snow".localizedValue
        case .heavySnow:
            return "Code: heavySnow".localizedValue
        case .sleet:
            return "Code: sleet".localizedValue
        case .lightShowerSleet:
            return "Code: lightShowerSleet".localizedValue
        case .showerSleet:
            return "Code: showerSleet".localizedValue
        case .lightRainAndSnow:
            return "Code: lightRainAndSnow".localizedValue
        case .rainAndSnow:
            return "Code: rainAndSnow".localizedValue
        case .lightShowerSnow:
            return "Code: lightShowerSnow".localizedValue
        case .showerSnow:
            return "Code: showerSnow".localizedValue
        case .heavyShowerSnow:
            return "Code: heavyShowerSnow".localizedValue
        case .mist:
            return "Code: mist".localizedValue
        case .smoke:
            return "Code: smoke".localizedValue
        case .haze:
            return "Code: haze".localizedValue
        case .sandDustWhirls:
            return "Code: sandDustWhirls".localizedValue
        case .fog:
            return "Code: fog".localizedValue
        case .sand:
            return "Code: sand".localizedValue
        case .dust:
            return "Code: dust".localizedValue
        case .volcanicAsh:
            return "Code: volcanicAsh".localizedValue
        case .squalls:
            return "Code: squalls".localizedValue
        case .tornado:
            return "Code: tornado".localizedValue
        case .clearSky:
            return "Code: clearSky".localizedValue
        case .fewClouds_11_25:
            return "Code: fewClouds_11_25".localizedValue
        case .scatteredClouds_25_50:
            return "Code: scatteredClouds_25_50".localizedValue
        case .brokenClouds_51_84:
            return "Code: brokenClouds_51_84".localizedValue
        case .overcastClouds_85_100:
            return "Code: overcastClouds_85_100".localizedValue
        }
    }
}

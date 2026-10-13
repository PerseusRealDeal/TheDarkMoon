//
//  SFSymbolsNamesMapping.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535.
//
//  Copyright © 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

extension String {

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func symbolName(isLight: Bool = true) -> String {

        var iconName = self

        // MARK: - OpenWeatherMap and SF Symbols

        if self.hasPrefix("OW_") {

            iconName = self.replacingOccurrences(of: "OW_", with: "")

            switch iconName {
            case "01d":
                return isLight ? "sun.max.fill" : "sun.max.dark"
            case "01n":
                return isLight ? "moon.fill" : "moon.dark"
            case "02d":
                return isLight ? "cloud.sun.fill" : "cloud.sun.dark"
            case "02n":
                return isLight ? "cloud.moon.fill" : "cloud.moon.dark"
            case "03d":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "03n":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "04d":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "04n":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "09d":
                return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"
            case "09n":
                return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"
            case "10d":
                return isLight ? "cloud.sun.rain.fill" : "cloud.sun.rain.dark"
            case "10n":
                return isLight ? "cloud.moon.rain.fill" : "cloud.moon.rain.dark"
            case "11d":
                return isLight ? "cloud.sun.bolt.fill" : "cloud.sun.bolt.dark"
            case "11n":
                return isLight ? "cloud.moon.bolt.fill" : "cloud.moon.bolt.dark"
            case "13d":
                return isLight ? "snow" : "snow.dark"
            case "13n":
                return isLight ? "snow" : "snow.dark"
            case "50d":
                return isLight ? "cloud.fog.fill" : "cloud.fog.dark"
            case "50n":
                return isLight ? "cloud.fog.fill" : "cloud.fog.dark"
            default:
                break
            }
        }

        // MARK: - Open-Meteo and SF Symbols

        switch iconName {

        case "99d", "96d":
            return isLight ? "cloud.bolt.rain.fill" : "cloud.bolt.rain.dark"
        case "99n", "96n":
            return isLight ? "cloud.bolt.rain.fill" : "cloud.bolt.rain.dark"

        case "95d":
            return isLight ? "cloud.sun.bolt.fill" : "cloud.sun.bolt.dark"
        case "95n":
            return isLight ? "cloud.moon.bolt.fill" : "cloud.moon.bolt.dark"

        case "86d", "85d":
            return isLight ? "cloud.snow.fill" : "cloud.snow.dark"
        case "86n", "85n":
            return isLight ? "cloud.snow.fill" : "cloud.snow.dark"

        case "82d", "81d", "80d":
            return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"
        case "82n", "81n", "80n":
            return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"

        case "77d", "75d":
            return isLight ? "cloud.snow.fill" : "cloud.snow.dark"
        case "77n", "75n":
            return isLight ? "cloud.snow.fill" : "cloud.snow.dark"

        case "73d", "71d":
            return isLight ? "snow" : "snow.dark"
        case "73n", "71n":
            return isLight ? "snow" : "snow.dark"

        case "67d", "66d":
            return isLight ? "cloud.sleet.fill" : "cloud.sleet.dark"
        case "67n", "66n":
            return isLight ? "cloud.sleet.fill" : "cloud.sleet.dark"

        case "65d":
            return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"
        case "65n":
            return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"

        case "63d":
            return isLight ? "cloud.rain.fill" : "cloud.rain.dark"
        case "63n":
            return isLight ? "cloud.rain.fill" : "cloud.rain.dark"

        case "61d":
            return isLight ? "cloud.sun.rain.fill" : "cloud.sun.rain.dark"
        case "61n":
            return isLight ? "cloud.moon.rain.fill" : "cloud.moon.rain.dark"

        case "57d", "56d":
            return isLight ? "cloud.sleet.fill" : "cloud.sleet.dark"
        case "57n", "56n":
            return isLight ? "cloud.sleet.fill" : "cloud.sleet.dark"

        case "55d", "53d", "51d":
            return isLight ? "cloud.drizzle.fill" : "cloud.drizzle.dark"
        case "55n", "53n", "51n":
            return isLight ? "cloud.drizzle.fill" : "cloud.drizzle.dark"

        case "48d", "45d":
            return isLight ? "cloud.fog.fill" : "cloud.fog.dark"
        case "48n", "45n":
            return isLight ? "cloud.fog.fill" : "cloud.fog.dark"

        case "3d":
            return isLight ? "cloud.drizzle.fill" : "cloud.drizzle.dark"
        case "3n":
            return isLight ? "cloud.drizzle.fill" : "cloud.drizzle.dark"

        case "2d":
            return isLight ? "cloud.sun.fill" : "cloud.sun.dark"
        case "2n":
            return isLight ? "cloud.moon.fill" : "cloud.moon.dark"

        case "0d", "1d":
            return isLight ? "sun.max.fill" : "sun.max.dark"
        case "0n", "1n":
            return isLight ? "moon.fill" : "moon.dark"

        default:
            break
        }

        return iconName
    }
}

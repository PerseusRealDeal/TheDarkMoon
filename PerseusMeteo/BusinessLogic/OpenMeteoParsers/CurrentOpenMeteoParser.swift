//
//  CurrentOpenMeteoParser.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (22.09.2026.)
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

public class CurrentOpenMeteoParser: CurrentParserProtocol {

    // MARK: - Timezone

    public func timeZone(from dictionary: [String: Any]) -> Int? {

        guard
            let timezone = getInstance("timezone", String.self, dictionary),
            let utc_offset_seconds = getInstance("utc_offset_seconds", Int.self, dictionary)
        else {
            return nil
        }

        if timezone == "GMT" {
            if utc_offset_seconds == 0 {
                return TimeZone.current.secondsFromGMT()
            } else {
                // If utc_offset_seconds not equel to 0
                return nil
            }
        }

        // If timezone not equel to GMT
        return nil
    }

    // MARK: - Response time

    public func responseTime(from dictionary: [String: Any]) -> Int? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let currentTime = getInstance("time", String.self, current),
            let iso8601Date = "\(currentTime):00Z".iso8601Date
        else {
            return nil
        }

        return Int(iso8601Date.timeIntervalSince1970)
    }

    // MARK: - Weather description

    public func weatherDescription(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let weather_code = getInstance("weather_code", Int.self, current)
        else {
            return nil
        }

        return OpenMeteoCode(rawValue: weather_code)?.description
    }

    // MARK: - Weather icon name

    public func weatherIconName(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let weather_code = getInstance("weather_code", Int.self, current),
            let is_day = getInstance("is_day", Int.self, current)
        else {
            return nil
        }

        return "\(weather_code)\(is_day == 1 ? "d" : "n")"
    }

    // MARK: - Temperature

    public func temperature(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let temperature = getInstance("temperature_2m", Double.self, current)
        else {
            return nil
        }

        return temperature.description
    }

    // MARK: - Temperature feels like

    public func temperatureFeelsLike(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let temperature = getInstance("apparent_temperature", Double.self, current)
        else {
            return nil
        }

        return temperature.description
    }

    // MARK: - Temperature Minimum

    public func temperatureMinimum(from dictionary: [String: Any]) -> String? {
        return nil
    }

    // MARK: - Temperature Maximum

    public func temperatureMaximum(from dictionary: [String: Any]) -> String? {
        return nil
    }

    // MARK: - Wind speed

    public func windSpeed(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let wind_speed_10m = getInstance("wind_speed_10m", Double.self, current)
        else {
            return nil
        }

        return wind_speed_10m.description
    }

    // MARK: - Wind gusts

    public func windGusts(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let wind_gusts_10m = getInstance("wind_gusts_10m", Double.self, current)
        else {
            return nil
        }

        return wind_gusts_10m.description
    }

    // MARK: - Wind direction

    public func windDirection(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let wind_direction_10m = getInstance("wind_direction_10m", Int.self, current)
        else {
            return nil
        }

        return wind_direction_10m.description
    }

    // MARK: - Pressure

    public func pressure(from dictionary: [String: Any]) -> String? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let pressure_msl = getInstance("pressure_msl", Double.self, current)
        else {
            return nil
        }

        return pressure_msl.description
    }

    // MARK: - Humidity

    public func humidity(from dictionary: [String: Any]) -> Int? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let relative_humidity_2m = getInstance("relative_humidity_2m", Int.self, current)
        else {
            return nil
        }

        return relative_humidity_2m
    }

    // MARK: - Cloudiness

    public func cloudiness(from dictionary: [String: Any]) -> Int? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let cloud_cover = getInstance("cloud_cover", Int.self, current)
        else {
            return nil
        }

        return cloud_cover
    }

    // MARK: - Visibility

    public func visibility(from dictionary: [String: Any]) -> Int? {

        guard
            let current = dictionary["current"] as? [String: Any],
            let visibility = getInstance("visibility", Int.self, current)
        else {
            return nil
        }

        return visibility
    }

    // MARK: - Sunrise

    public func sunrise(from dictionary: [String: Any]) -> Int? {

        guard
            let daily = dictionary["daily"] as? [String: Any],
            let sunset = daily["sunrise"] as? [String],
            let first = sunset.first,
            let iso8601Date = "\(first):00Z".iso8601Date
        else {
            return nil
        }

        return Int(iso8601Date.timeIntervalSince1970)
    }

    // MARK: - Sunset

    public func sunset(from dictionary: [String: Any]) -> Int? {

        guard
            let daily = dictionary["daily"] as? [String: Any],
            let sunset = daily["sunset"] as? [String],
            let first = sunset.first,
            let iso8601Date = "\(first):00Z".iso8601Date
        else {
            return nil
        }

        return Int(iso8601Date.timeIntervalSince1970)
    }
}

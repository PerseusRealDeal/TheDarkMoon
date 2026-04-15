//
//  OpenWeatherWeatherParser.swift
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
// swiftlint:disable file_length
//

/* OpenWeatherMap JSON format API response example

{
  "coord": {
    "lon": 10.99,
    "lat": 44.34
  },
  "weather": [
    {
      "id": 501,
      "main": "Rain",
      "description": "moderate rain",
      "icon": "10d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 298.48,
    "feels_like": 298.74,
    "temp_min": 297.56,
    "temp_max": 300.05,
    "pressure": 1015,
    "humidity": 64,
    "sea_level": 1015,
    "grnd_level": 933
  },
  "visibility": 10000,
  "wind": {
    "speed": 0.62,
    "deg": 349,
    "gust": 1.18
  },
  "rain": {
    "1h": 3.16
  },
  "clouds": {
    "all": 100
  },
  "dt": 1661870592,
  "sys": {
    "type": 2,
    "id": 2075663,
    "country": "IT",
    "sunrise": 1661834187,
    "sunset": 1661882248
  },
  "timezone": 7200,
  "id": 3163858,
  "name": "Zocca",
  "cod": 200
}

*/

import Foundation

func getInstance<T>(_ tag: String,
                    _ type: T.Type,
                    _ dic: [String: Any]) -> T? where T: Any {

    if dic.isEmpty {
        log.message("\(#function) \"\(tag)\", but dictionary is empty", .error)
        return nil
    }

    if let value = dic[tag] {
        if let instance = value as? T {

            // log.message("\(#function) \"\(tag)\" cast to \(T.self)", .notice)

            return instance

        } else {
            log.message("\(#function)\"\(tag)\" can't be cast to \(T.self)", .error)
        }
    } else {
        log.message("\(#function) \"\(tag)\" not found", .notice)
    }

    return nil
}

public class OpenWeatherWeatherParser: WeatherParserProtocol {

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {

        // Timezone

        return getInstance("timezone", Int.self, dictionary)
    }

    public func getLastOne(from dictionary: [String: Any]) -> Int? {

        // Date and Time

        return getInstance("dt", Int.self, dictionary)
    }

    public func getVisibility(from dictionary: [String: Any]) -> Int? {

        // Visibility

        return getInstance("visibility", Int.self, dictionary)
    }

    public func getWeatherDescription(from dictionary: [String: Any]) -> String? {

        if let weather = dictionary["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {

                // Current Weather Conditions

                return getInstance("description", String.self, wFirst)

            } else {
                log.message("[\(type(of: self))].\(#function) weather.first mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) \"weather\" mistaken", .error)
        }

        return nil
    }

    public func getWeatherIconName(from dictionary: [String: Any]) -> String? {

        if let weather = dictionary["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if let id = getInstance("id", Int.self, wFirst),
                   let icon = getInstance("icon", String.self, wFirst) {

                    // Current Weather Conditions Icon name

                    let iconName = representOpenWeatherMapIcon(id, icon)

                    return iconName

                } else {
                    log.message("[\(type(of: self))].\(#function) [id.icon] mistaken", .error)
                }
            } else {
                log.message("[\(type(of: self))].\(#function) weather.first mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) \"weather\" mistaken", .error)
        }

        return nil
    }

    public func getTemperature(from dictionary: [String: Any]) -> String? {

        guard let main = dictionary["main"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"main\" mistaken", .error)
            return nil
        }

        // Temperature

        return getInstance("temp", Double.self, main)?.description
    }

    public func getTemperatureFeelsLike(from dictionary: [String: Any]) -> String? {

        guard let main = dictionary["main"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"main\" mistaken", .error)
            return nil
        }

        // Temperature Feels Like

        return getInstance("feels_like", Double.self, main)?.description
    }

    public func getTemperatureMinimum(from dictionary: [String: Any]) -> String? {

        guard let main = dictionary["main"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"main\" mistaken", .error)
            return nil
        }

        // Temperature Minimum

        return getInstance("temp_min", Double.self, main)?.description
    }

    public func getTemperatureMaximum(from dictionary: [String: Any]) -> String? {

        guard let main = dictionary["main"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"main\" mistaken", .error)
            return nil
        }

        // Temperature Maximum

        return getInstance("temp_max", Double.self, main)?.description
    }

    public func getWindSpeed(from dictionary: [String: Any]) -> String? {

        guard let wind = dictionary["wind"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"wind\" mistaken", .notice)
            return nil
        }

        // Wind Speed

        return getInstance("speed", Double.self, wind)?.description
    }

    public func getWindGusts(from dictionary: [String: Any]) -> String? {

        guard let wind = dictionary["wind"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"wind\" mistaken", .notice)
            return nil
        }

        // Wind Gust

        return getInstance("gust", Double.self, wind)?.description
    }

    public func getWindDirection(from dictionary: [String: Any]) -> String? {

        guard let wind = dictionary["wind"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"wind\" mistaken", .notice)
            return nil
        }

        // Wind Direction

        return getInstance("deg", Int.self, wind)?.description
    }

    public func getPressure(from dictionary: [String: Any]) -> String? {

        guard let main = dictionary["main"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"main\" mistaken", .notice)
            return nil
        }

        // Pressure

        return getInstance("pressure", Int.self, main)?.description
    }

    public func getHumidity(from dictionary: [String: Any]) -> Int? {

        guard let main = dictionary["main"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"main\" mistaken", .notice)
            return nil
        }

        // Humidity

        return getInstance("humidity", Int.self, main)
    }

    public func getCloudiness(from dictionary: [String: Any]) -> Int? {

        guard let clouds = dictionary["clouds"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"clouds\" mistaken", .notice)
            return nil
        }

        // Cloudiness

        return getInstance("all", Int.self, clouds)
    }

    public func getSunrise(from dictionary: [String: Any]) -> Int? {

        guard let sys = dictionary["sys"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"sys\" mistaken", .notice)
            return nil
        }

        // Sunrise

        return getInstance("sunrise", Int.self, sys)
    }

    public func getSunset(from dictionary: [String: Any]) -> Int? {

        guard let sys = dictionary["sys"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) \"sys\" mistaken", .notice)
            return nil
        }

        // Sunset

        return getInstance("sunset", Int.self, sys)
    }

    public func getWeatherConditions(from source: [String: Any]) -> WeatherConditions {

        var value: WeatherConditions?

        if let weather = source["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if
                    let id = getInstance("id", Int.self, wFirst),
                    let icon = getInstance("icon", String.self, wFirst),
                    let code = WeatherCode(rawValue: id) {

                    // WeatherConditions struct

                    value = WeatherConditions(code: code, name: icon)

                } else {
                    log.message("\(#function) [id.icon] mistaken", .error)
                }
            } else {
                log.message("\(#function) weather.first wrong", .error)
            }
        } else {
            log.message("\(#function) \"weather\" mistaken", .error)
        }

        guard let conditions = value else { return MeteoFactsDefaults.weatherConditions }

        return conditions
    }
}

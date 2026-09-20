//
//  CurrentOpenWeatherParser.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

/* OpenWeatherMap API request example

https://api.openweathermap.org/data/2.5/weather
?lat=55.02
&lon=82.92
&appid=###
&lang=ru
&units=imperial

*/

/* OpenWeatherMap API response JSON example

{
  "base" : "stations",
  "id" : 1496747,
  "dt" : 1790432931,
  "main" : {
    "humidity" : 66,
    "feels_like" : 46.090000000000003,
    "temp_min" : 47.890000000000001,
    "temp_max" : 47.890000000000001,
    "temp" : 47.890000000000001,
    "pressure" : 1025,
    "sea_level" : 1025,
    "grnd_level" : 1009
  },
  "coord" : {
    "lon" : 82.920000000000002,
    "lat" : 55.020000000000003
  },
  "wind" : {
    "speed" : 4.4699999999999998,
    "deg" : 300,
    "gust" : 19.010000000000002
  },
  "sys" : {
    "id" : 8958,
    "country" : "RU",
    "sunset" : 1790425151,
    "type" : 1,
    "sunrise" : 1790382024
  },
  "weather" : [
    {
      "id" : 804,
      "main" : "Clouds",
      "icon" : "04n",
      "description" : "пасмурно"
    }
  ],
  "visibility" : 10000,
  "clouds" : {
    "all" : 100
  },
  "timezone" : 25200,
  "cod" : 200,
  "name" : "Новосибирск"
}

*/

import Foundation

public class CurrentOpenWeatherParser: CurrentParserProtocol {

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
                if getInstance("id", Int.self, wFirst) != nil,
                   let icon = getInstance("icon", String.self, wFirst) {

                    // Current Weather Conditions Icon name
                    // return mappedOpenWeatherIcon(id, icon)

                    return "OW_\(icon)"

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

/*

public func mappedOpenWeatherIcon(_ id: Int, _ icon: String) -> String {

    var iconName = ""

    switch icon {
    case "01d":
        iconName = "sun.max"
    case "01n":
        iconName = "moon"
    case "02d":
        iconName = "cloud.sun"
    case "02n":
        iconName = "cloud.moon"
    case "03d", "03n", "04d", "04n":
        iconName = "cloud"
    case "09d", "09n":
        iconName = "cloud.heavyrain"
    case "10d":
        iconName = "cloud.sun.rain"
    case "10n":
        iconName = "cloud.moon.rain"
    case "11d":
        iconName = "cloud.sun.bolt"
    case "11n":
        iconName = "cloud.moon.bolt"
    case "13d", "13n":
        iconName = "snow"
    case "50d", "50n":
        iconName = "cloud.fog"
    default:
        iconName = AppGlobals.statusMenusButtonIconName
    }

    log.message(#function + " \(icon) " + iconName)

    return iconName
}

*/

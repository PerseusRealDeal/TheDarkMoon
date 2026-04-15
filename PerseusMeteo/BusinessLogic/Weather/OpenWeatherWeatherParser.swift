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

public class OpenWeatherWeatherParser: WeatherParserProtocol {

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        // Timezone.

        guard
            let timezone = dictionary["timezone"] as? Int
        else {
            log.message("[\(type(of: self))].\(#function) [timezone] mistaken", .error)
            return nil
        }

        return timezone
    }

    public func getLastOne(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        // Date and Time.

        guard
            let dt = dictionary["dt"] as? Int
        else {
            log.message("[\(type(of: self))].\(#function) [dt] mistaken", .error)
            return nil
        }

        return dt
    }

    public func getWeatherDescription(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let weather = dictionary["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if let description = wFirst["description"] as? String {

                    return description

                } else {
                    let text = "[\(type(of: self))].\(#function) [description] mistaken"
                    log.message(text, .error)
                }
            } else {
                log.message("[\(type(of: self))].\(#function) Weather first mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [weather] mistaken", .error)
        }

        return nil
    }

    public func getWeatherIconName(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let weather = dictionary["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if let id = wFirst["id"] as? Int,
                   let icon = wFirst["icon"] as? String {

                    let iconName = representOpenWeatherMapIcon(id, icon)

                    return iconName

                } else {
                    log.message("[\(type(of: self))].\(#function) [id.icon] mistaken", .error)
                }
            } else {
                log.message("[\(type(of: self))].\(#function) Weather first mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [weather] mistaken", .error)
        }

        return nil
    }

    public func getTemperature(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let main = dictionary["main"] as? [String: Any] {
            if let temp = main["temp"] as? Double {

                return temp.description

            } else {
                log.message("[\(type(of: self))].\(#function) [temp] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [main] mistaken", .error)
        }

        return nil
    }

    public func getTemperatureFeelsLike(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let main = dictionary["main"] as? [String: Any] {
            if let feels_like = main["feels_like"] as? Double {

                return feels_like.description

            } else {
                log.message("[\(type(of: self))].\(#function) [feels_like] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [main] mistaken", .error)
        }

        return nil
    }

    public func getTemperatureMinimum(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let main = dictionary["main"] as? [String: Any] {
            if let temp_min = main["temp_min"] as? Double {

                return temp_min.description

            } else {
                log.message("[\(type(of: self))].\(#function) [temp_min] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [main] mistaken", .error)
        }

        return nil
    }

    public func getTemperatureMaximum(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let main = dictionary["main"] as? [String: Any] {
            if let temp_max = main["temp_max"] as? Double {

                return temp_max.description

            } else {
                log.message("[\(type(of: self))].\(#function) [temp_max] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [main] mistaken", .error)
        }

        return nil
    }

    public func getWindSpeed(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let wind = dictionary["wind"] as? [String: Any] {
            if let speed = wind["speed"] as? Double {

                return speed.description

            } else {
                log.message("[\(type(of: self))].\(#function) [speed] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [wind] mistaken", .error)
        }

        return nil
    }

    public func getWindGusts(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let wind = dictionary["wind"] as? [String: Any] {
            if let gust = wind["gust"] as? Double {

                return gust.description

            } else {
                log.message("[\(type(of: self))].\(#function) \"gust\" nil", .notice)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) \"wind\" nil", .notice)
        }

        return nil
    }

    public func getWindDirection(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let wind = dictionary["wind"] as? [String: Any] {
            if let deg = wind["deg"] as? Int {

                return deg.description

            } else {
                log.message("[\(type(of: self))].\(#function) [deg] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [wind] mistaken", .error)
        }

        return nil
    }

    public func getPressure(from dictionary: [String: Any]) -> String? {

        if dictionary.isEmpty {
            return nil
        }

        if let main = dictionary["main"] as? [String: Any] {
            if let pressure = main["pressure"] as? Int {

                return pressure.description

            } else {
                log.message("[\(type(of: self))].\(#function) [pressure] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [main] mistaken", .error)
        }

        return nil
    }

    public func getHumidity(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        if let main = dictionary["main"] as? [String: Any] {
            if let humidity = main["humidity"] as? Int {

                return humidity

            } else {
                log.message("[\(type(of: self))].\(#function) [humidity] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [main] mistaken", .error)
        }

        return nil
    }

    public func getCloudiness(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        if let clouds = dictionary["clouds"] as? [String: Any] {
            if let all = clouds["all"] as? Int {

                return all

            } else {
                log.message("[\(type(of: self))].\(#function) [all] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [clouds] mistaken", .error)
        }

        return nil
    }

    public func getVisibility(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        if let visibility = dictionary["visibility"] as? Int {

            return visibility

        } else {
            log.message("[\(type(of: self))].\(#function) [visibility] mistaken", .error)
        }

        return nil
    }

    public func getSunrise(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        if let sys = dictionary["sys"] as? [String: Any] {
            if let rise = sys["sunrise"] as? Int {

                return rise

            } else {
                log.message("[\(type(of: self))].\(#function) [sunrise] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [sys] mistaken", .error)
        }

        return nil
    }

    public func getSunset(from dictionary: [String: Any]) -> Int? {

        if dictionary.isEmpty {
            return nil
        }

        if let sys = dictionary["sys"] as? [String: Any] {
            if let sunset = sys["sunset"] as? Int {

                return sunset
            } else {
                log.message("[\(type(of: self))].\(#function) [sunset] mistaken", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [sys] mistaken", .error)
        }

        return nil
    }

    public func getWeatherConditions(from source: [String: Any]) -> WeatherConditions {

        if source.isEmpty {
            return MeteoFactsDefaults.weatherConditions
        }

        var value: WeatherConditions?

        if let weather = source["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if
                    let id = wFirst["id"] as? Int,
                    let icon = wFirst["icon"] as? String,
                    let code = WeatherCode(rawValue: id) {

                    value = WeatherConditions(code: code, name: icon)

                } else {
                    log.message("\(#function) [id / icon] mistaken", .error)
                }
            } else {
                log.message("\(#function) weatherFirst wrong", .error)
            }
        } else {
            log.message("\(#function) [weather] mistaken", .error)
        }

        guard let conditions = value else { return MeteoFactsDefaults.weatherConditions }

        return conditions
    }
}

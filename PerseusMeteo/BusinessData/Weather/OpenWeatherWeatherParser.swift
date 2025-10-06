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

        log.message("[\(type(of: self))].\(#function)")

        // Timezone.

        guard
            let timezone = dictionary["timezone"] as? Int
        else {
            log.message("[\(type(of: self))].\(#function) Timezone wrong.", .error)
            return nil
        }

        return timezone
    }

    public func getLastOne(from dictionary: [String: Any]) -> Int? {

        log.message("[\(type(of: self))].\(#function)")

        // Date and Time.

        guard
            let dt = dictionary["dt"] as? Int
        else {
            log.message("[\(type(of: self))].\(#function) dt wrong.", .error)
            return nil
        }

        return dt
    }

    public func getWeatherDescription(from dictionary: [String: Any]) -> String? {

        log.message("[\(type(of: self))].\(#function)")

        if let weather = dictionary["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if let description = wFirst["description"] as? String {

                    return description

                } else {
                    log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
                }
            } else {
                log.message("[\(type(of: self))].\(#function) Weather first wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Weather wrong.", .error)
        }

        return nil
    }

    public func getWeatherIconName(from dictionary: [String: Any]) -> String? {

        log.message("[\(type(of: self))].\(#function)")

        if let weather = dictionary["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if let id = wFirst["id"] as? Int,
                    let icon = wFirst["icon"] as? String {

                    let iconName = representOpenWeatherMapIcon(id, icon)

                    return iconName

                } else {
                    log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
                }
            } else {
                log.message("[\(type(of: self))].\(#function) Weather first wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Weather wrong.", .error)
        }

        return nil
    }

    public func getTemperature(from dictionary: [String: Any]) -> String? {

        log.message("[\(type(of: self))].\(#function)")

        if let main = dictionary["main"] as? [String: Any] {
            if let temp = main["temp"] as? Double {

                return temp.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Main wrong.", .error)
        }

        return nil
    }

    public func getTemperatureFeelsLike(from dictionary: [String: Any]) -> String? {

        if let main = dictionary["main"] as? [String: Any] {
            if let feels_like = main["feels_like"] as? Double {

                return feels_like.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Main wrong.", .error)
        }

        return nil
    }

    public func getTemperatureMinimum(from dictionary: [String: Any]) -> String? {

        if let main = dictionary["main"] as? [String: Any] {
            if let temp_min = main["temp_min"] as? Double {

                return temp_min.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Main wrong.", .error)
        }

        return nil
    }

    public func getTemperatureMaximum(from dictionary: [String: Any]) -> String? {

        if let main = dictionary["main"] as? [String: Any] {
            if let temp_max = main["temp_max"] as? Double {

                return temp_max.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Main wrong.", .error)
        }

        return nil
    }

    public func getWindSpeed(from dictionary: [String: Any]) -> String? {

        if let wind = dictionary["wind"] as? [String: Any] {
            if let speed = wind["speed"] as? Double {

                return speed.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Wind wrong.", .error)
        }

        return nil
    }

    public func getWindGusts(from dictionary: [String: Any]) -> String? {
        if let wind = dictionary["wind"] as? [String: Any] {
            if let gust = wind["gust"] as? Double {

                return gust.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Wind wrong.", .error)
        }

        return nil
    }

    public func getWindDirection(from dictionary: [String: Any]) -> String? {

        if let wind = dictionary["wind"] as? [String: Any] {
            if let deg = wind["deg"] as? Int {

                return deg.description

            } else {
                log.message("[\(type(of: self))].\(#function) Attribute wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Wind wrong.", .error)
        }

        return nil
    }

    public func getPressure(from dictionary: [String: Any]) -> String? {

        if let main = dictionary["main"] as? [String: Any] {
            if let pressure = main["pressure"] as? Int {

                return pressure.description

            } else {
                log.message("[\(type(of: self))].\(#function) Pressure wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Main wrong.", .error)
        }

        return nil
    }

    public func getHumidity(from dictionary: [String: Any]) -> Int? {

        if let main = dictionary["main"] as? [String: Any] {
            if let humidity = main["humidity"] as? Int {

                return humidity

            } else {
                log.message("[\(type(of: self))].\(#function) Humidity wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Main wrong.", .error)
        }

        return nil
    }

    public func getCloudiness(from dictionary: [String: Any]) -> Int? {

        if let clouds = dictionary["clouds"] as? [String: Any] {
            if let all = clouds["all"] as? Int {

                return all

            } else {
                log.message("[\(type(of: self))].\(#function) [all] wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) [clouds] wrong.", .error)
        }

        return nil
    }

    public func getVisibility(from dictionary: [String: Any]) -> Int? {

        if let visibility = dictionary["visibility"] as? Int {

            return visibility

        } else {
            log.message("[\(type(of: self))].\(#function) Visibility wrong.", .error)
        }

        return nil
    }

    public func getSunrise(from dictionary: [String: Any]) -> Int? {

        if let sys = dictionary["sys"] as? [String: Any] {
            if let rise = sys["sunrise"] as? Int {

                return rise

            } else {
                log.message("[\(type(of: self))].\(#function) Sunrise wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Sys wrong.", .error)
        }

        return nil
    }

    public func getSunset(from dictionary: [String: Any]) -> Int? {

        if let sys = dictionary["sys"] as? [String: Any] {
            if let sunset = sys["sunset"] as? Int {

                return sunset
            } else {
                log.message("[\(type(of: self))].\(#function) Sunset wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) Sys wrong.", .error)
        }

        return nil
    }

    public func getWeatherConditions(from source: [String: Any]) -> WeatherConditions {

        var value: WeatherConditions?

        if let weather = source["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if
                    let id = wFirst["id"] as? Int,
                    let icon = wFirst["icon"] as? String,
                    let code = WeatherCode(rawValue: id) {

                    value = WeatherConditions(code: code, name: "\(icon)@4x")

                } else {
                    log.message("\(#function) [id / icon] wrong.", .error)
                }
            } else {
                log.message("\(#function) Weather first wrong.", .error)
            }
        } else {
            log.message("\(#function) [weather] wrong.", .error)
        }

        guard let conditions = value else { return MeteoFactsDefaults.weatherConditions }

        return conditions
    }
}

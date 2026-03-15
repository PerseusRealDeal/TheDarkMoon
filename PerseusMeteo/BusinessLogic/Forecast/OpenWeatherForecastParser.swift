//
//  OpenWeatherForecastRefresher.swift
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

/* OpenWeatherMap JSON forecast list items sample

{
  "message" : 0,
  "cod" : "200",
  "cnt" : 1,
  "list" : [
    // Forecast hours ...
  ],
  "city" : {
    "sunset" : 1708775436,
    "country" : "RU",
    "id" : 1496747,
    "coord" : {
      "lat" : 55.060000000000002,
      "lon" : 83
    },
    "population" : 1419007,
    "timezone" : 25200,
    "sunrise" : 1708738346,
    "name" : "Novosibirsk"
  }
}

*/

import Foundation

public class OpenWeatherForecastParser: ForecastParserProtocol {

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {

        // log.message("[\(type(of: self))].\(#function)")

        if let city = dictionary["city"] as? [String: Any] {
            if let timezone = city["timezone"] as? Int {

                // log.message("[\(type(of: self))].\(#function): \(timezone)")

                return timezone

            } else {
                log.message("[\(type(of: self))].\(#function) timezone wrong.", .error)
            }
        } else {
            log.message("[\(type(of: self))].\(#function) city wrong.", .error)
        }

        return nil
    }

    public func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]? {

        // log.message("[\(type(of: self))].\(#function)")

        guard
            let list = dictionary["list"] as? [Any],
            let timezone = getTimeZone(from: dictionary)
        else {

            log.message("[\(type(of: self))].\(#function) Wrong list.", .error)

            return nil
        }

        let daysSorted = createForecastDays(from: list, timezone: timezone)
        var forecastDays = [ForecastDay]()

        for item in daysSorted {

            // let addition = "DAY KEY: \(item.key) : count \(item.value.count)"
            // log.message("[\(type(of: self))].\(#function) \(addition)")

            let hours = createForecastHours(from: item.value, timezone)

            forecastDays.append(ForecastDay(date: item.key, hours: hours))
        }

        // log.message("[\(type(of: self))].\(#function): \(forecastDays)")

        return forecastDays
    }

    fileprivate func createForecastDays(from list: [Any], timezone: Int) ->
        [(key: String, value: [[String: Any]?])] {

            let listItems = list.map { $0 as? [String: Any] }

            var days = Dictionary(grouping: listItems, by: { (item) -> String in

                if let item = item, let dt = item["dt"] as? Int {

                    let day = Date(timeIntervalSince1970: TimeInterval(dt))
                    let formatter = DateFormatter()

                    formatter.dateStyle = .medium
                    formatter.timeStyle = .none
                    formatter.dateFormat = "yyyy-MM-dd"
                    formatter.timeZone = TimeZone(secondsFromGMT: timezone)

                    let theDay = formatter.string(from: day)

                    // log.message("[\(type(of: self))].\(#function) dt: \(theDay)")

                    return theDay

                } else {
                    log.message("[\(type(of: self))].\(#function) dt wrong.", .error)
                }

                return "-1"
            })

            days.removeValue(forKey: "-1")

            // log.message("[\(type(of: self))].\(#function) DAYS: \(days.count)")
            // log.message("[\(type(of: self))].\(#function) LIST ITEMS: \(listItems.count)")

            let daysSorted = days.sorted(by: {
                createDate(from: $0.key) < createDate(from: $1.key)
            })

            return daysSorted
    }

    fileprivate func createForecastHours(from source: [[String: Any]?],
                                         _ timezone: Int = 0) -> [ForecastHour] {
        guard source.isEmpty == false else {
            return [ForecastHour]()
        }

        var hours = [ForecastHour]()

        for item in source {
            guard let item = item else {
                continue
            }

            hours.append(ForecastHour(source: item, timezone: timezone, title: "auto"))
        }

        return hours
    }

    fileprivate func createDate(from date: String, format: String = "yyyy-MM-dd") -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let theDay = dateFormatter.date(from: date)!

        return theDay
    }
}

// MARK: Getting Forecast Day Values

public func getForecastDay(from source: [String: Any], timezone: Int) -> String {

    var value = -1

    // Get value.
    if let dt = source["dt"] as? Int {

        value = dt

    } else {
        // log.message("[\(#function) [dt] wrong.", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.forecastDate }

    let theDay = representLastOneCalculationTime(value,
                                                 timezone,
                                                 toBe: AppOptions.timeFormatOption)

    let theDayItems = theDay.day?.split(separator: " ")

    guard let items = theDayItems, items.count > 2 else {
        return MeteoFactsDefaults.forecastDate
    }

    return "\(items[0]) \(items[1])"
}

// MARK: Getting Forecast Hour Values

public func getForecastHourDt(from source: [String: Any], timezone: Int) -> String {

    var value = -1

    // Get value.
    if let dt = source["dt"] as? Int {

        value = dt

    } else {
        // log.message("[\(#function) [dt] wrong.", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.sunrizesunset }

    // Recalculate if needed.
    let represented = representMeteoTime(value,
                                         timezone,
                                         toBe: AppOptions.timeFormatOption)

    return "\(represented ?? MeteoFactsDefaults.sunrizesunset)"
}

public func getForecastHourTemp(from source: [String: Any]) -> String {

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let temp_min = main["temp"] as? Double {

            value = temp_min.description

        } else {
            log.message("[\(#function) [temp] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [main] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourTempMin(from source: [String: Any]) -> String {

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let temp_min = main["temp_min"] as? Double {

            value = temp_min.description

        } else {
            log.message("[\(#function) [temp_min] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [main] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourTempMax(from source: [String: Any]) -> String {

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let temp_max = main["temp_max"] as? Double {

            value = temp_max.description

        } else {
            log.message("[\(#function) [temp_max] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [main] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourTempKinda(from source: [String: Any]) -> String {

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let feels_like = main["feels_like"] as? Double {

            value = feels_like.description

        } else {
            log.message("[\(#function) [feels_like] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [main] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourVisibility(from source: [String: Any]) -> String {

    var value = -1

    // Get value.
    if let visibility = source["visibility"] as? Int {

        value = visibility

    } else {
        log.message("[\(#function) [visibility] wrong.", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.visibility }

    // Recalculate if needed.
    let represented = representDistance(value,
                                        asIs: LengthOption.meter,
                                        toBe: AppOptions.distanceOption)

    return "\(represented) \(AppOptions.distanceOption.unitLocalized)"
}

public func getForecastHourWindSpeed(from source: [String: Any]) -> String {

    var value = ""

    // Get value.
    if let wind = source["wind"] as? [String: Any] {
        if let speed = wind["speed"] as? Double {

            value = speed.description

        } else {
            log.message("[\(#function) [speed] wrong.", .error)
        }
    } else {
        log.message("[\(#function) [wind] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.windSpeed }

    // Recalculate if needed.
    let represented = representWindSpeedGusts(value,
                                              asIs: WindSpeedOption.ms,
                                              toBe: AppOptions.windSpeedOption)

    return "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
}

public func getForecastHourWindDirection(from source: [String: Any]) -> String {

    var value = ""

    if let wind = source["wind"] as? [String: Any] {
        if let deg = wind["deg"] as? Int {

            value = deg.description

        } else {
            log.message("[\(#function) [deg] wrong.", .error)
        }
    } else {
        log.message("[\(#function) [wind] wrong.", .error)
    }

    guard
        value != "",
        let point = try? WindDegree(value)
    else {
        return MeteoFactsDefaults.windDirection
    }

    return "\(Int(point.degree))° : \(point.common.abbreviation.localizedValue)"
}

public func getForecastHourWindGusts(from source: [String: Any]) -> String {

    var value = ""

    if let wind = source["wind"] as? [String: Any] {
        if let gust = wind["gust"] as? Double {

            value = gust.description

        } else {
            log.message("[\(#function) [gust] wrong.", .error)
        }
    } else {
        log.message("[\(#function) [wind] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.windSpeed }

    // Recalculate if needed.
    let represented = representWindSpeedGusts(value,
                                              asIs: WindSpeedOption.ms,
                                              toBe: AppOptions.windSpeedOption)

    return "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
}

public func getForecastHourPressure(from source: [String: Any]) -> String {

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let pressure = main["pressure"] as? Int {

            value = pressure.description

        } else {
            log.message("[\(#function) [pressure] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [main] wrong.", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.pressure }

    // Recalculate if needed.
    let represented = representPressure(value,
                                        asIs: PressureOption.hPa,
                                        toBe: AppOptions.pressureOption)

    return "\(represented) \(AppOptions.pressureOption.unitLocalized)"
}

public func getForecastHourHumidity(from source: [String: Any]) -> String {

    var value = -1

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let humidity = main["humidity"] as? Int {

            value = humidity

        } else {
            log.message("[\(#function) [humidity] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [main] wrong.", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.humidity }

    return "\(value)%"
}

public func getForecastHourCloudiness(from source: [String: Any]) -> String {

    var value = -1

    // Get value.
    if let clouds = source["clouds"] as? [String: Any] {
        if let all = clouds["all"] as? Int {

            value = all

        } else {
            log.message("[\(#function) [all] wrong.", .error)
        }
    } else {
        log.message("[\(#function) [clouds] wrong.", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.cloudiness }

    return "\(value)%"
}

/*

 "rain": {
 "3h": 0.49
 },

or

 "snow":{
 "3h":0.69999999999999996
 },

*/

/*

{
...
   "snow":{
      "3h":0.69999999999999996
   },
   "pop":0.48999999999999999,
...
}

*/

public func getPrecipitation(from source: [String: Any]) -> String {

    var precipitation: (Double, String, Double) = (-1, "", -1)

/*
     1. Get probability of precipitation.

     The values of the parameter vary between 0 and 1,
     where 0 is equal to 0%, 1 is equal to 100%
 */

    if let probability = source["pop"] as? Double {

        precipitation.0 = probability

    } else {
        // log.message("[\(#function) [pop] wrong.", .error)
    }

/*
    2. Get Rain/Snow volume for last 3 hours, mm.

    Only mm as units of measurement are available for this parameter
*/

    if let rain = source["rain"] as? [String: Any] {
        if let mm = rain["3h"] as? Double {

            precipitation.1 = "rain".localizedValue
            precipitation.2 = mm

        } else {
            // log.message("[\(#function) [rain 3h] wrong.", .error)
        }
    } else if let snow = source["snow"] as? [String: Any] {
        if let mm = snow["3h"] as? Double {

            precipitation.1 = "snow".localizedValue
            precipitation.2 = mm

        } else {
            // log.message("[\(#function) [snow 3h] wrong.", .error)
        }
    } else {
        // log.message("[\(#function) [rain], [snow] wrong.", .error)
    }

    // MeteoFactsDefaults.conditions
    guard precipitation.1 != "" else { return "-- / --" }

    // "\(precipitation.0)%, \(precipitation.1), \(precipitation.2) mm"
    // "\(precipitation.1), \(precipitation.2)" + " " + "Unit: mm".localizedValue
    return "\(precipitation.1)"
}

/*
 "weather":[
      {
         "id":600,
         "main":"Snow",
         "icon":"13n",
         "description":"light snow"
      }
   ]
*/
public func getWeatherConditions(from source: [String: Any]) -> WeatherConditions {

    var value: WeatherConditions?

    if let weather = source["weather"] as? [Any] {
        if let wFirst = weather.first as? [String: Any] {
            if
                let id = wFirst["id"] as? Int,
                let icon = wFirst["icon"] as? String,
                let code = WeatherCode(rawValue: id) {

                value = WeatherConditions(code: code, name: icon)

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

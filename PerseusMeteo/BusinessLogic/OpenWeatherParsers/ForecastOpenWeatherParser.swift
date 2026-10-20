//
//  ForecastOpenWeatherParser.swift
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

https://api.openweathermap.org/data/2.5/forecast
?lat=55.02
&lon=82.92
&appid=###
&lang=ru
&cnt=1
&units=imperial

*/

/* OpenWeatherMap API response JSON example

{
  "message": 0,
  "cod": "200",
  "cnt": 40,
  "list": [
    {
      "clouds": {
        "all": 100
      },
      "wind": {
        "speed": 7.58,
        "deg": 307,
        "gust": 18.34
      },
      "dt": 1790434800,
      "dt_txt": "2026-09-26 15:00:00",
      "main": {
        "humidity": 66,
        "feels_like": 44.38,
        "temp_min": 47.25,
        "temp_max": 47.89,
        "temp": 47.89,
        "pressure": 1025,
        "temp_kf": 0.36,
        "dew_point": 37.09,
        "sea_level": 1025,
        "grnd_level": 1009
      },
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "пасмурно"
        }
      ],
      "pop": 0,
      "sys": {
        "pod": "n"
      },
      "visibility": 10000
    }
  ],
  "city": {
    "sunset": 1790425151,
    "country": "RU",
    "id": 1496747,
    "coord": {
      "lat": 55.02,
      "lon": 82.92
    },
    "population": 1419007,
    "timezone": 25200,
    "sunrise": 1790382024,
    "name": "Новосибирск"
  }
}

*/

import Foundation

public class ForecastOpenWeatherParser: ForecastParserProtocol {

    private var count = 0 // For debug purpose

    // MARK: - Contract

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {

        guard let city = dictionary["city"] as? [String: Any] else {
            log.message("[\(type(of: self))].\(#function) [city] mistaken", .error)
            return nil
        }

        return getInstance("timezone", Int.self, city)
    }

    public func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]? {

        count += 1
        log.message("[\(type(of: self))].\(#function) \(count)", .debug, .standard)

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
            let probability = initProbability(hours)
            let day = ForecastDay(date: item.key,
                                  hours: hours,
                                  iconName: initIconName(hours),
                                  temperaturesNightDay: initTemperatures(hours),
                                  probability: initProbability(hours),
                                  precipitation: initPrecipitation(hours, pop: probability)
            )
            forecastDays.append(day)
        }

        // log.message("[\(type(of: self))].\(#function): \(forecastDays)")

        return forecastDays
    }

    // MARK: - Helper methods

    private func createForecastDays(from list: [Any], timezone: Int) ->
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
                    log.message("[\(type(of: self))].\(#function) dt wrong", .error)
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

    private func createForecastHours(from source: [[String: Any]?],
                                     _ timezone: Int = 0) -> [ForecastHour] {
        guard source.isEmpty == false else {
            return [ForecastHour]()
        }

        var hours = [ForecastHour]()

        for item in source {
            guard let item = item else {
                continue
            }

            hours.append(ForecastHour(provider: .serviceOpenWeatherMap,
                                      source: item,
                                      timezone: timezone,
                                      title: "auto"))
        }

        return hours
    }

    private func createDate(from date: String, format: String = "yyyy-MM-dd") -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let theDay = dateFormatter.date(from: date)!

        return theDay
    }
}

// MARK: Getting Forecast Day Values

public func parseForecastDay(from source: [String: Any], timezone: Int) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.forecastDate
    }

    var value = -1

    // Get value.
    if let dt = source["dt"] as? Int {

        value = dt

    } else {
        log.message("[\(#function) [dt] mistaken", .error)
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

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.timeFormat
    }

    var value = -1

    // Get value.
    if let dt = source["dt"] as? Int {

        value = dt

    } else {
        log.message("[\(#function) [dt] mistaken", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.timeFormat }

    // Recalculate if needed.
    let represented = representMeteoTime(value,
                                         timezone,
                                         toBe: AppOptions.timeFormatOption)

    return "\(represented ?? MeteoFactsDefaults.timeFormat)"
}

public func getForecastHourTemp(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.temperature
    }

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let temp_min = main["temp"] as? Double {

            value = temp_min.description

        } else {
            log.message("[\(#function) [temp] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [main] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourTempMin(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.temperature
    }

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let temp_min = main["temp_min"] as? Double {

            value = temp_min.description

        } else {
            log.message("[\(#function) [temp_min] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [main] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourTempMax(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.temperature
    }

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let temp_max = main["temp_max"] as? Double {

            value = temp_max.description

        } else {
            log.message("[\(#function) [temp_max] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [main] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourTempKinda(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.temperature
    }

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let feels_like = main["feels_like"] as? Double {

            value = feels_like.description

        } else {
            log.message("[\(#function) [feels_like] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [main] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.temperature }

    // Recalculate if needed.
    let represented = representTemperature(value,
                                           asIs: TemperatureOption.imperial,
                                           toBe: AppOptions.temperatureOption)

    return "\(represented)\(AppOptions.temperatureOption.unit)"
}

public func getForecastHourVisibility(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.visibility
    }

    var value = -1

    // Get value.
    if let visibility = source["visibility"] as? Int {

        value = visibility

    } else {
        log.message("[\(#function) [visibility] mistaken", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.visibility }

    // Recalculate if needed.
    let represented = representDistance(value,
                                        asIs: LengthOption.meter,
                                        toBe: AppOptions.distanceOption)

    return "\(represented) \(AppOptions.distanceOption.unitLocalized)"
}

public func getForecastHourWindSpeed(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.windSpeed
    }

    var value = ""

    // Get value.
    if let wind = source["wind"] as? [String: Any] {
        if let speed = wind["speed"] as? Double {

            value = speed.description

        } else {
            log.message("[\(#function) [speed] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [wind] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.windSpeed }

    // Recalculate if needed.
    let represented = representWindSpeedGusts(value,
                                              asIs: WindSpeedOption.ms,
                                              toBe: AppOptions.windSpeedOption)

    return "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
}

public func getForecastHourWindDirection(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.windDirection
    }

    var value = ""

    if let wind = source["wind"] as? [String: Any] {
        if let deg = wind["deg"] as? Int {

            value = deg.description

        } else {
            log.message("[\(#function) [deg] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [wind] mistaken", .error)
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

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.windSpeed
    }

    var value = ""

    if let wind = source["wind"] as? [String: Any] {
        if let gust = wind["gust"] as? Double {

            value = gust.description

        } else {
            log.message("[\(#function) [gust] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [wind] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.windSpeed }

    // Recalculate if needed.
    let represented = representWindSpeedGusts(value,
                                              asIs: WindSpeedOption.ms,
                                              toBe: AppOptions.windSpeedOption)

    return "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
}

public func getForecastHourPressure(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.pressure
    }

    var value = ""

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let pressure = main["pressure"] as? Int {

            value = pressure.description

        } else {
            log.message("[\(#function) [pressure] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [main] mistaken", .error)
    }

    guard value != "" else { return MeteoFactsDefaults.pressure }

    // Recalculate if needed.
    let represented = representPressure(value,
                                        asIs: PressureOption.hPa,
                                        toBe: AppOptions.pressureOption)

    return "\(represented) \(AppOptions.pressureOption.unitLocalized)"
}

public func getForecastHourHumidity(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.humidity
    }

    var value = -1

    // Get value.
    if let main = source["main"] as? [String: Any] {
        if let humidity = main["humidity"] as? Int {

            value = humidity

        } else {
            log.message("[\(#function) [humidity] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [main] mistaken", .error)
    }

    guard value != -1 else { return MeteoFactsDefaults.humidity }

    return "\(value)%"
}

public func getForecastHourCloudiness(from source: [String: Any]) -> String {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.cloudiness
    }

    var value = -1

    // Get value.
    if let clouds = source["clouds"] as? [String: Any] {
        if let all = clouds["all"] as? Int {

            value = all

        } else {
            log.message("[\(#function) [all] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [clouds] mistaken", .error)
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

// (Double, String, Double) goes for (pop, rain/snow, 3h).
// If not nil (-1, "", -1) means no values. "-- / --"
public func getPrecipitation(from source: [String: Any]) -> (Double, String, Double)? {

    guard !source.isEmpty else { return nil }

    var precipitation: (Double, String, Double) = (-1, "", -1)

/*
     1. Get probability of precipitation (pop).

     The values of the parameter vary between 0 and 1,
     where 0 is equal to 0%, 1 is equal to 100%
 */

    if let pop = source["pop"] as? Double { // 1. pop

        precipitation.0 = pop // 1. Probability of precipitation between 0 and 1.

    } else {
        log.message("[\(#function) [pop] mistaken", .error)
    }

/*
    2. Get Rain/Snow volume for last 3 hours. Note that only mm as units of measurement.
*/

    if let rain = source["rain"] as? [String: Any] { // 2. Rain?
        if let mm = rain["3h"] as? Double {

            precipitation.1 = "rain".localizedValue
            precipitation.2 = mm.cut(.two) // 3. Rain volume for last 3 hours, mm.

        } else {
            log.message("[\(#function) [rain 3h] mistaken", .error)
        }
    } else if let snow = source["snow"] as? [String: Any] { // Snow probability.
        if let mm = snow["3h"] as? Double {

            precipitation.1 = "snow".localizedValue  // 2. Snow?
            precipitation.2 = mm.cut(.two) // 3. Snow volume for last 3 hours, mm.

        } else {
            log.message("[\(#function) [snow 3h] mistaken", .error)
        }
    } else {
        log.message("[\(#function) [rain], [snow] is empty", .notice)
    }

    return precipitation
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

public func getWeatherConditions(from source: [String: Any]) -> OpenWeatherIconCode {

    if source.isEmpty { // Templated result for empty value.
        return MeteoFactsDefaults.weatherConditions
    }

    var value: OpenWeatherIconCode?

    if let weather = source["weather"] as? [Any] {
        if let wFirst = weather.first as? [String: Any] {
            if
                let id = wFirst["id"] as? Int,
                let icon = wFirst["icon"] as? String,
                let code = OpenWeatherCode(rawValue: id) {

                value = OpenWeatherIconCode(code: code, name: icon)

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

// MARK: - Helper functions

public func initIconName(_ hours: [ForecastHour]) -> String? {

    // Ranks

    let iconRanks: [String: Int] = [
        "01": 9, // clear sky
        "02": 8, // few clouds
        "03": 7, // scattered clouds
        "04": 6, // broken clouds
        "09": 3, // shower rain
        "10": 4, // rain
        "11": 1, // thunderstorm
        "13": 2, // snow
        "50": 5  // mist
    ]

    // Icons

    var icons = [String]()

    hours.forEach {
        if let weather = $0.source["weather"] as? [Any] {
            if let wFirst = weather.first as? [String: Any] {
                if let icon = wFirst["icon"] as? String {
                    icons.append(icon) // String(icon.dropLast())
                }
            }
        }
    }

    // Ranked icons

    var rankedIcons = [String: Int]()

    icons.forEach { item in
        let rank = iconRanks["\(item.dropLast())"]
        rankedIcons["\(item)"] = rank
    }

    // The most relevant icon

    guard let iconName = (rankedIcons.min { $0.value < $1.value })?.key else {
        return nil
    }

    return "OW_\(iconName)"
}

public func initTemperatures(_ hours: [ForecastHour]) -> (Double?, Double?) {

    // Get temperatures.
    var temperaturesDay = [Double]()
    var temperaturesNight = [Double]()

    hours.forEach {

        // Get value.
        if let main = $0.source["main"] as? [String: Any] {
            if let temp = main["temp"] as? Double {

                if let sys = $0.source["sys"] as? [String: Any] {
                    if let pod = sys["pod"] as? String {
                        if pod == "d" {
                            temperaturesDay.append(temp)
                        } else if pod == "n" {
                            temperaturesNight.append(temp)
                        }
                    }
                }

            } else {
                log.message("[\(#function) [temp] wrong.", .error)
            }
        } else {
            // log.message("[\(#function) [main] wrong.", .error)
        }
    }

    return (temperaturesNight.min(), temperaturesDay.max())
}

public func initPrecipitation(_ hours: [ForecastHour], pop: Double? = nil) -> String? {

    var precipitation = [String]()

    hours.forEach {

        let snow = $0.source["snow"] as? [String: Any]
        let rain = $0.source["rain"] as? [String: Any]

        if snow != nil {
            if !precipitation.contains("snow") {
                precipitation.append("snow".localizedValue)
            }
        }

        if rain != nil {
            if !precipitation.contains("rain") {
                precipitation.append("rain".localizedValue)
            }
        }
    }

    var conditions = ""

    if precipitation.contains("rain".localizedValue) {
        conditions.append("rain".localizedValue)
    }

    if precipitation.contains("snow".localizedValue) {
        conditions.append(" " + "snow".localizedValue)
    }

    let popRepresented = representProbabilityOfPrecipitation(pop)

    return conditions.isEmpty ? nil :
        (pop == nil ? conditions : "\(popRepresented)% \(conditions)")
}

public func initProbability(_ hours: [ForecastHour]) -> Double? {
    // "pop":0.48999999999999999

    var pops = [Double]()

    hours.forEach {
        // Get values.
        if let pop = $0.source["pop"] as? Double {
            pops.append(pop)
        }
    }

    return pops.max()
}

private var count = 0 // For debug purpose
public func prepareMeteoGroupForecastHourData(_ forecastHourSource: [String: Any],
                                              _ provider: MeteoProvider) -> MeteoGroupData {

    count += 1
    log.message("\(#function): called \(count)", .debug, .standard)

    // Set titles up

    var meteogroup = MeteoGroupData()

    switch provider {
    case .serviceOpenMeteo:
        meteogroup.setTemplatedValuesUp(provider: .serviceOpenMeteo,
                                        category: .forecast)
    case .serviceOpenWeatherMap:
        meteogroup.setTemplatedValuesUp(provider: .serviceOpenWeatherMap,
                                        category: .forecast)
    }

    // Set values up

    switch provider {
    case .serviceOpenMeteo:
        meteogroup.setOpenMeteoForecastUp(data: forecastHourSource)
    case .serviceOpenWeatherMap:
        meteogroup.setOpenWeatherForecastUp(data: forecastHourSource)
    }

    return meteogroup
}

//
//  ForecastDay.swift
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

import Foundation
import ConsolePerseusLogger

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

public struct ForecastDay {

    public var label: String = "" // For debug purpose
    private let isTemplated: Bool

    // MARK: - Data

    public let date: String // Formate: YYYY-MM-DD, it's uniq calculated value
    public let hours: [ForecastHour]

    private let temperaturesNightDay: (Double?, Double?)

    private let probability: Double?
    private let precipitation: String?

    private let iconName: String?

    // MARK: - Init

    init(date: String, hours: [ForecastHour], templated: Bool = false) {
        self.date = date
        self.hours = hours
        self.isTemplated = templated

        self.iconName = ForecastDay.initIconName(source: hours)
        self.temperaturesNightDay = ForecastDay.initTemperatures(source: hours)
        self.probability = ForecastDay.initProbability(source: hours)
        self.precipitation = ForecastDay.initPrecipitation(source: hours, pop: probability)
    }

    // MARK: - Contract

    public var weatherConditionIconName: String {

        guard let icon = self.iconName else { return MeteoFactsDefaults.weatherIconName }

        return "\(icon)@4x"
    }

    public var weatherConditions: String {
        return isTemplated ? MeteoFactsDefaults.forecastDaysItemWeatherDescription :
            (precipitation == nil ? "clear".localizedValue : precipitation!)
    }

    public var dateDayOfTheWeek: String {

        guard
            let firstHour = hours.first,
            let dt = firstHour.source["dt"] as? Int,
            let theDayOfTheWeek = representLastOneCalculationTime(
                dt,
                firstHour.timezone,
                toBe: AppOptions.timeFormatOption).theDayOfTheWeek,
            let theDayOfTheWeekLocalized = DayOfTheWeek(rawValue: theDayOfTheWeek)?.localized
        else {
            return MeteoFactsDefaults.weekday
        }

        return theDayOfTheWeekLocalized
    }

    public var dateDayMonth: String {

        guard let firstHour = hours.first else { return MeteoFactsDefaults.forecastDate }

        let source = firstHour.source
        let tz = firstHour.timezone

        return getForecastDay(from: source, timezone: tz)
    }

    public var minimumTemperature: String {

        guard let value = temperaturesNightDay.0?.description else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented) \(AppOptions.temperatureOption.unit)"
    }

    public var maximumTemperature: String {

        guard let value = temperaturesNightDay.1?.description else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented) \(AppOptions.temperatureOption.unit)"
    }

    // MARK: - Realization

    private static func initTemperatures(source hours: [ForecastHour]) -> (Double?, Double?) {

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

    private static func initPrecipitation(source hours: [ForecastHour],
                                          pop: Double? = nil) -> String? {

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

    private static func initProbability(source hours: [ForecastHour]) -> Double? {
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

    // MARK: - Initialization OpenWather weather condition icon

    private static func initIconName(source hours: [ForecastHour]) -> String? {

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

        return (rankedIcons.min { $0.value < $1.value })?.key
    }
}

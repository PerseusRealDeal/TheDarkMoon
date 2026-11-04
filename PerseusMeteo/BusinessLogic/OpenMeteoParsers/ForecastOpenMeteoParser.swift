//
//  ForecastOpenMeteoParser.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (26.09.2026.)
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

public class ForecastOpenMeteoParser: ForecastParserProtocol {

    private var count = 0 // For debug purpose

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {

        guard
            let timezone = getInstance("utc_offset_seconds", Int.self, dictionary)
        else {
            return nil
        }

        return timezone
    }

    public func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]? {

        count += 1
        log.message("[\(type(of: self))].\(#function) \(count)", .debug, .standard)

        guard
            let timezone = getTimeZone(from: dictionary),
            let daily = dictionary["daily"] as? [String: Any],
            let dailyTime = daily["time"] as? [Int],
            let hourly = dictionary["hourly"] as? [String: Any],
            let hourlyTime = hourly["time"] as? [Int]
        else {
            log.message("[\(type(of: self))].\(#function) \(count)", .error, .standard)
            return nil
        }

        let hoursInTimeZone = hourlyTime.map { prepareTimeInTimeZone($0, 0) }
        // log.message("\(hoursInTimeZone)", .debug, .standard)

        var forecastDays = [ForecastDay]()

        for day in dailyTime {

            guard let dayIndex = (dailyTime.firstIndex { $0 == day }) else {
                continue
            }

            let dayInTimeZone = prepareTimeInTimeZone(day, timezone, "yyyy-MM-dd")
            // log.message("\(dayInTimeZone)", .debug, .standard)

            let hours = getHours(
                hoursInTimeZone.indices.filter { hoursInTimeZone[$0].contains(dayInTimeZone) },
                hourly,
                timezone
            )

            var day = ForecastDay(date: dayInTimeZone, hours: hours)

            day.iconName = getIconName(dayIndex, daily)
            day.temperaturesNightDay = getTemperatures(dayIndex, daily)
            day.probability = getProbability(dayIndex, daily)
            day.precipitation = getPrecipitation(dayIndex, daily)

            forecastDays.append(day)
        }

        return forecastDays
    }

    // MARK: - Helper methods

    private func prepareTimeInTimeZone(_ time: Int,
                                       _ timeoffset: Int,
                                       _ format: String = "yyyy-MM-dd'T'HH:mm") -> String {

        var day = Date(timeIntervalSince1970: TimeInterval(time))
        day.addTimeInterval(TimeInterval(timeoffset))

        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = format // "yyyy-MM-dd" // "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter.string(from: day)
    }

    private func getHours(_ timeIndices: [Int],
                          _ hours: [String: Any],
                          _ timeoffset: Int) -> [ForecastHour] {

        // log.message("min\(timeIndices.min()!) max\(timeIndices.max()!)", .debug, .standard)

        var forecastHours = [ForecastHour]()

        for index in timeIndices {

            var hour = ForecastHour(provider: .serviceOpenMeteo)

            // Time Field

            if
                let times = hours["time"] as? [Int],
                let time = representMeteoTime(times[index], timeoffset,
                                              toBe: AppOptions.timeFormatOption) {
                hour.time = time
            } else {
                hour.time = MeteoFactsDefaults.timeFormat
            }

            // Rain Snow Field

            if let rain = hours["rain"] as? [Double], rain[index] > 0.0 {
                hour.rainsnow = "rain".localizedValue + " \(rain[index].cut(.two))"
            } else if let snow = hours["snowfall"] as? [Double], snow[index] > 0.0 {
                hour.rainsnow = "snow".localizedValue + " \(snow[index].cut(.two))"
            } else {
                hour.rainsnow = MeteoFactsDefaults.forecastRainSnow
            }

            // Temperature Field temperature_2m

            if let temperatures = hours["temperature_2m"] as? [Double] {

                let value = representTemperature("\(temperatures[index])",
                                                 asIs: TemperatureOption.imperial,
                                                 toBe: AppOptions.temperatureOption)

                hour.temperature = "\(value)\(AppOptions.temperatureOption.unit)"
            } else {
                hour.temperature = MeteoFactsDefaults.temperature
            }

            // Meteo Group Forecast Hour

            // TODO: MeteoGroupForecastHourData
            hour.data = prepareMeteoGroupForecastHourData([:], .serviceOpenMeteo)

            forecastHours.append(hour)
        }

        return forecastHours
    }

    private func getForecastHourTime(_ index: Int, _ hours: [String: Any]) -> String {

        guard
            index < hours.count, index >= 0, !hours.isEmpty,
            let times = hours["time"] as? [Int]
        else {
            return MeteoFactsDefaults.timeFormat
        }

        return representMeteoTime(times[index], 0,
                                  toBe: AppOptions.timeFormatOption)
        ?? MeteoFactsDefaults.timeFormat
    }

    private func getIconName(_ timeIndex: Int,
                             _ days: [String: Any]) -> String {

        guard
            let codes = days["weather_code"] as? [Int],
            codes.count > timeIndex, timeIndex >= 0
        else {
            return MeteoFactsDefaults.weatherIconName
        }

        return "\(codes[timeIndex])"
    }

    private func getTemperatures(_ timeIndex: Int,
                                 _ days: [String: Any]) -> (Double?, Double?) {

        var min: Double?

        if let temperature_2m_min = days["temperature_2m_min"] as? [Double?] {
            min = temperature_2m_min[timeIndex]
        }

        var max: Double?

        if let temperature_2m_max = days["temperature_2m_max"] as? [Double?] {
            max = temperature_2m_max[timeIndex]
        }

        return (min, max)
    }

    private func getProbability(_ timeIndex: Int,
                                _ days: [String: Any]) -> Int? {

        var probability: Int?

        if let probability_max = days["precipitation_probability_max"] as? [Int?] {
            probability = probability_max[timeIndex]
        }

        return probability
    }

    private func getPrecipitation(_ timeIndex: Int,
                                  _ days: [String: Any]) -> String {

        var precipitation = [String]()

        if
            let rain_sum = days["rain_sum"] as? [Double?],
            timeIndex < rain_sum.count, timeIndex >= 0,
            let rain = rain_sum[timeIndex], rain > 0.0 {

            precipitation.append("rain".localizedValue)
        }

        if
            let snowfall_sum = days["snowfall_sum"] as? [Double?],
            timeIndex < snowfall_sum.count, timeIndex >= 0,
            let snowfall = snowfall_sum[timeIndex], snowfall > 0.0 {

            precipitation.append("snow".localizedValue)
        }

        if precipitation.isEmpty {
            return ""
        }

        return precipitation.count == 1 ? "\(precipitation[0])" :
        "\(precipitation[0]) \(precipitation[1])"
    }
}

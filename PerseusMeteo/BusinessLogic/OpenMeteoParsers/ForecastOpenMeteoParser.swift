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
            let timezone = getInstance("timezone", String.self, dictionary)
        else {
            return nil
        }

        if timezone == "GMT" {
            return TimeZone.current.secondsFromGMT()
        }

        // If timezone not equel to GMT
        return nil
    }

    public func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]? {

        count += 1
        log.message("[\(type(of: self))].\(#function) \(count)", .debug, .standard)

        guard
            // let timezone = getTimeZone(from: dictionary),
            let daily = dictionary["daily"] as? [String: Any],
            let dailyTime = daily["time"] as? [String],
            let hourly = dictionary["hourly"] as? [String: Any],
            let hourlyTime = hourly["time"] as? [String]
        else {
            return nil
        }

        var forecastDays = [ForecastDay]()

        for day in dailyTime {

            guard let dayIndex = (dailyTime.firstIndex { $0.contains(day) }) else {
                continue
            }

            let day = ForecastDay(
                date: getDate(day),
                hours: getHours(
                    hourlyTime.indices.filter { hourlyTime[$0].contains(day) }, hourly),
                iconName: getIconName(dayIndex, daily),
                temperaturesNightDay: getTemperatures(dayIndex, daily),
                probability: getProbability(dayIndex, daily),
                precipitation: getPrecipitation(dayIndex, daily)
            )

            forecastDays.append(day)
        }

        return forecastDays
    }

    // MARK: - Helper methods

    private func getDate(_ day: String) -> String {

        if createDate(from: day) != nil {
            return day
        }

        return MeteoFactsDefaults.forecastDate
    }

/*
    private func getDate(_ day: String, _ tz: Int) -> String {

        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)

        if let dayWithTZ = formatter.date(from: day) {
            return formatter.string(from: dayWithTZ)
        }

        return MeteoFactsDefaults.forecastDate
    }
*/

    private func getHours(_ timeIndices: [Int],
                          _ hours: [String: Any]) -> [ForecastHour] {

        var hours = [ForecastHour]()

        // TODO: Parse Open-Meteo forecast hours

        for item in 0...4 {
            hours.append(ForecastHour(title: "\(item)", provider: .serviceOpenMeteo))
        }

        return hours
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

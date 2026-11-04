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
// swiftlint:disable file_length
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

    // TODO: Problem: Called twice, but shouldn't...
    public func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]? {

        count += 1
        log.message("[\(type(of: self))].\(#function) \(count)", .debug, .standard)

        guard
            let timezone = getTimeZone(from: dictionary),
            let daily = dictionary["daily"] as? [String: Any],
            let dailyTime = daily["time"] as? [Int?],
            let hourly = dictionary["hourly"] as? [String: Any],
            let hourlyTime = hourly["time"] as? [Int?]
        else {
            log.message("[\(type(of: self))].\(#function) \(count)", .error, .standard)
            return nil
        }

        // TODO: Problem: What if time item in null?

        let hoursInTimeZone = hourlyTime.map { prepareTimeInTimeZone($0, timezone) }
        // log.message("\(hoursInTimeZone)", .debug, .standard)

        var forecastDays = [ForecastDay]()

        for dayItem in dailyTime {

            guard let theDay = dayItem, let dayIndex = (dailyTime.firstIndex { $0 == theDay })
            else {
                continue
            }

            guard let dayInTimeZone = prepareTimeInTimeZone(dayItem, timezone, "yyyy-MM-dd")
            else {
                continue
            }

            // log.message("\(dayInTimeZone)", .debug, .standard)

            let hoursIndices = hoursInTimeZone.indices.filter {

                if let item = hoursInTimeZone[$0] {
                    // log.message("\(item)", .debug, .standard)
                    return item.hasPrefix(dayInTimeZone)
                }
                return false
            }

            if hoursIndices.isEmpty {
                continue
            }

            // log.message("\(hoursIndices)", .debug, .standard)

            let hours = getHours(hoursIndices, hourly, timezone)

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

    private func prepareTimeInTimeZone(_ time: Int?,
                                       _ timeoffset: Int,
                                       _ format: String = "yyyy-MM-dd'T'HH:mm") -> String? {

        guard let time = time else { return nil }

        var day = Date(timeIntervalSince1970: TimeInterval(time))

        if timeoffset > 0 {
            day.addTimeInterval(TimeInterval(timeoffset))
        }

        let formatter = DateFormatter()

        formatter.locale = Locale(identifier: "en_US_POSIX")
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
                let times = hours["time"] as? [Int?], let time = times[index],
                let timeRepresented = representMeteoTime(time, timeoffset,
                                                         toBe: AppOptions.timeFormatOption) {
                hour.time = timeRepresented
            } else {
                hour.time = MeteoFactsDefaults.timeFormat
            }

            // Rain Snow Field

            if let rains = hours["rain"] as? [Double?],
               let rain = rains[index], rain > 0.0 {
                hour.rainsnow = "rain".localizedValue + " \(rain.cut(.two))"
            } else if let snows = hours["snowfall"] as? [Double?],
                      let snow = snows[index], snow > 0.0 {
                hour.rainsnow = "snow".localizedValue + " \(snow.cut(.two))"
            } else {
                hour.rainsnow = MeteoFactsDefaults.forecastRainSnow
            }

            // Temperature Field temperature_2m

            if let temperatures = hours["temperature_2m"] as? [Double?],
               let temperature = temperatures[index] {

                let temperatureRepresented = representTemperature(
                    temperature.description,
                    asIs: TemperatureOption.imperial,
                    toBe: AppOptions.temperatureOption)

                hour.temperature =
                "\(temperatureRepresented)\(AppOptions.temperatureOption.unit)"
            } else {
                hour.temperature = MeteoFactsDefaults.temperature
            }

            // Weather Description

            if let weather_code = hours["weather_code"] as? [Int?],
               let code = weather_code[index],
               let desc = OpenMeteoCode(rawValue: code) {

                hour.weatherDescription = desc.description.capitalizingFirstLetter()
            } else {
                hour.weatherDescription = MeteoFactsDefaults.weatherDescription
            }

            // Meteo Group Data

            hour.data = prepareOpenMeteoForecastHourData(index, hours)

            forecastHours.append(hour)
        }

        return forecastHours
    }

    private func getForecastHourTime(_ index: Int,
                                     _ hours: [String: Any]) -> String {

        guard
            index < hours.count, index >= 0, !hours.isEmpty,
            let times = hours["time"] as? [Int?], let time = times[index]
        else {
            return MeteoFactsDefaults.timeFormat
        }

        return representMeteoTime(time, 0, toBe: AppOptions.timeFormatOption)
        ?? MeteoFactsDefaults.timeFormat
    }

    private func getIconName(_ timeIndex: Int,
                             _ days: [String: Any]) -> String {

        guard
            let codes = days["weather_code"] as? [Int?],
            codes.count > timeIndex, timeIndex >= 0,
            let code = codes[timeIndex]
        else {
            return MeteoFactsDefaults.weatherIconName
        }

        return "\(code)"
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

private var count = 0 // For debug purpose
public func prepareOpenMeteoForecastHourData(_ index: Int,
                                             _ hours: [String: Any]) -> MeteoGroupData {

    count += 1
    // log.message("\(#function): called \(count)", .debug, .standard)

    // Set titles up

    var meteogroup = MeteoGroupData()

    meteogroup.setTemplatedValuesUp(provider: .serviceOpenMeteo, category: .forecast)

    // Set values up

    // Array 1 apparent_temperature

    if let uv_indices = hours["uv_index"] as? [Double?],
       let uv_index = uv_indices[index] {

        meteogroup.value1 = "\(uv_index)"
    }

    if let apparent_temperatures = hours["apparent_temperature"] as? [Double?],
       let apparent_temperature = apparent_temperatures[index] {

        let represented = representTemperature(apparent_temperature.description,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        meteogroup.value2 = "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    if let visibilities = hours["visibility"] as? [Int?],
       let visibility = visibilities[index] {

        let represented = representDistance(visibility,
                                            asIs: LengthOption.meter,
                                            toBe: AppOptions.distanceOption)

        meteogroup.value3 = "\(represented) \(AppOptions.distanceOption.unitLocalized)"
    }

    // Array 2

    if let wind_speed_10m = hours["wind_speed_10m"] as? [Double?],
       let wind_speed = wind_speed_10m[index] {

        let represented = representWindSpeedGusts(wind_speed.description,
                                                  asIs: WindSpeedOption.ms,
                                                  toBe: AppOptions.windSpeedOption)

        meteogroup.value4 = "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
    }

    if let wind_direction_10m = hours["wind_direction_10m"] as? [Int?],
       let wind_direction = wind_direction_10m[index],
       let point = try? WindDegree(wind_direction.description) {

        let degree = Int(point.degree)
        let abbreviation = point.common.abbreviation.localizedValue

        meteogroup.value5 = "\(degree)° : \(abbreviation)"
    } else {
        meteogroup.value5 = MeteoFactsDefaults.windDirection
    }

    if let wind_gusts_10m = hours["wind_gusts_10m"] as? [Double?],
       let wind_gusts = wind_gusts_10m[index] {

        let represented = representWindSpeedGusts(wind_gusts.description,
                                                  asIs: WindSpeedOption.ms,
                                                  toBe: AppOptions.windSpeedOption)

        meteogroup.value6 = "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
    }

    // Array 3

    if let pressure_msl = hours["pressure_msl"] as? [Double?],
       let pressure = pressure_msl[index] {

        let represented = representPressure(pressure.description,
                                            asIs: PressureOption.hPa,
                                            toBe: AppOptions.pressureOption)

        meteogroup.value7 = "\(represented) \(AppOptions.pressureOption.unitLocalized)"
    }

    if let relative_humidity_2m = hours["relative_humidity_2m"] as? [Int?],
       let humidity = relative_humidity_2m[index] {

        meteogroup.value8 = "\(humidity)%"
    }

    if let cloud_cover = hours["cloud_cover"] as? [Int?],
       let cloud = cloud_cover[index] {

        meteogroup.value9 = "\(cloud)%"
    }

    return meteogroup
}

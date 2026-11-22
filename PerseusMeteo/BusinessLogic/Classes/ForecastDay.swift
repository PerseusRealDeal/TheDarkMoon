//
//  ForecastDay.swift
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

import Foundation

public struct ForecastDay {

    // MARK: - Debug Parameters

    public var title: String = "" // For debug purpose
    private var isTemplated: Bool = false

    // MARK: - Business Data

    public let date: String // YYYY-MM-DD, it's uniq calculated value. Time zone added.
    public let hours: [ForecastHour]

    // MARK: - Private Parameters

    public var iconName: String?
    public var temperaturesNightDay: (Double?, Double?)?

    public var probability: Int?
    public var precipitation: String?

    // MARK: - Calculated Parameters

    public var weatherIconName: String {
        return  self.iconName ?? MeteoFactsDefaults.weatherIconName
    }

    public var weatherConditions: String {

        if isTemplated {
            return MeteoFactsDefaults.forecastDaysItemWeatherDescription
        }

        if precipitation == nil {
            return probability == nil ?
            "clear".localizedValue : "\(probability!)% \("clear".localizedValue)"
        }

        if probability != nil {
            return "\(probability!)% \(precipitation!)"
        }

        return precipitation!
    }

    public var theDayOfTheWeek: String {

        guard
            let theDay = createDate(from: date)?.timeIntervalSince1970,
            let theDayOfWeek = representLastOneCalculationTime(
                Int(theDay),
                TimeZone.current.secondsFromGMT(),
                toBe: AppOptions.timeFormatOption).theDayOfTheWeek,
            let theDayOfTheWeekLocalized = DayOfWeek(rawValue: theDayOfWeek)?.localized
        else {
            return MeteoFactsDefaults.weekday
        }

        return theDayOfTheWeekLocalized
    }

    public var theDayNumberAndtheMonth: String {

        guard let theDay = createDate(from: date)?.timeIntervalSince1970 else {
            return MeteoFactsDefaults.forecastDate
        }

        let theDayFormatted = representLastOneCalculationTime(
            Int(theDay),
            TimeZone.current.secondsFromGMT(),
            toBe: AppOptions.timeFormatOption
        )

        let theDayItems = theDayFormatted.day?.split(separator: " ")

        guard let items = theDayItems, items.count > 2 else {
            return MeteoFactsDefaults.forecastDate
        }

        return "\(items[0]) \(items[1])"
    }

    public var temperatureMin: String {

        guard let value = temperaturesNightDay?.0?.description else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.

        let represented = representTemperature(
            value, asIs: TemperatureOption.imperial, toBe: AppOptions.temperatureOption
        )

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    public var temperatureMax: String {

        guard let value = temperaturesNightDay?.1?.description else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }
    // MARK: - Init

    init(date: String, hours: [ForecastHour], templated: Bool = false) {

        self.date = date
        self.hours = hours
        self.isTemplated = templated
    }
}

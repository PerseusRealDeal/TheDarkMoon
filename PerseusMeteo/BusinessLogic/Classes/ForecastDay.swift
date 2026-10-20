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

    public var label: String = "" // For debug purpose
    private let isTemplated: Bool

    // MARK: - Business Data

    public let date: String // Formate: YYYY-MM-DD, it's uniq calculated value
    public let hours: [ForecastHour]

    // MARK: - Private Parameters

    private let iconName: String?
    private let temperaturesNightDay: (Double?, Double?)

    private let probability: Double?
    private let precipitation: String?

    // MARK: - Calculated Parameters

    public var weatherIconName: String {
        return  self.iconName ?? MeteoFactsDefaults.weatherIconName
    }

    public var weatherConditions: String {
        return isTemplated ? MeteoFactsDefaults.forecastDaysItemWeatherDescription :
            (precipitation == nil ? "clear".localizedValue : precipitation!)
    }

    public var theDayOfTheWeek: String {

        guard
            let firstHour = hours.first,
            let dt = firstHour.source["dt"] as? Int,
            let theDayOfWeek = representLastOneCalculationTime(
                dt,
                firstHour.timezone,
                toBe: AppOptions.timeFormatOption).theDayOfTheWeek,
            let theDayOfTheWeekLocalized = DayOfWeek(rawValue: theDayOfWeek)?.localized
        else {
            return MeteoFactsDefaults.weekday
        }

        return theDayOfTheWeekLocalized
    }

    public var theDayOftheMonth: String {

        guard let firstHour = hours.first else { return MeteoFactsDefaults.forecastDate }

        let source = firstHour.source
        let tz = firstHour.timezone

        return parseForecastDay(from: source, timezone: tz)
    }

    public var temperatureMin: String {

        guard let value = temperaturesNightDay.0?.description else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    public var temperatureMax: String {

        guard let value = temperaturesNightDay.1?.description else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }
    // MARK: - Init

    init(date: String,
         hours: [ForecastHour],
         iconName: String?,
         temperaturesNightDay: (Double?, Double?),
         probability: Double?,
         precipitation: String?,
         templated: Bool = false) {

        self.date = date
        self.hours = hours
        self.isTemplated = templated

        self.iconName = iconName // initIconName(hours)
        self.temperaturesNightDay = temperaturesNightDay // initTemperatures(hours)
        self.probability = probability // initProbability(hours)
        self.precipitation = precipitation // initPrecipitation(hours, pop: probability)
    }
}

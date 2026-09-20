//
//  ForecastReader.swift
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

// Unified meteo values ready to be shown on screen.

public class ForecastReader: MeteoSourceReader {

    public static let shared: ForecastReader = { return ForecastReader() }()

    private init() {
        super.init(category: .forecast)
    }

    // MARK: - Contract

    public func addResponseDateAndTime(dt: Int) {

        guard let meteoDictionary = self.meteoDictionary as? ForecastDictionary
        else { return }

        meteoDictionary.lastOne = dt
    }

    // MARK: - Properties

    public var meteoDataProviderName: String {

        guard
            let providerTitle = meteoProvider
        else {
            return MeteoFactsDefaults.meteoDataProviderName
        }

        return "\(providerTitle)"
    }

    public var lastOne: String { // Last time API request response.

        guard
            let meteoDictionary = self.meteoDictionary as? ForecastDictionary,
            let value = meteoDictionary.lastOne,
            let timezone = meteoDictionary.timezone
        else {
            return MeteoFactsDefaults.lastOne
        }

        let lastOne = representLastOneCalculationTime(value,
                                                      timezone,
                                                      toBe: AppOptions.timeFormatOption)
        let prefix = "Prefix: Last One".localizedValue
        let postfixYear = "Postfix: Year".localizedValue

        let day = lastOne.day == nil ? "" : "\(lastOne.day ?? "")\(postfixYear) "

        return "\(prefix): \(day)\(lastOne.time ?? MeteoFactsDefaults.lastOne)"
    }

    public var forecastDays: [ForecastDay] {

        guard
            let meteoDictionary = self.meteoDictionary as? ForecastDictionary
        else {

            // Return empty array

            return [ForecastDay]()
        }

        if let days = meteoDictionary.forecastDays {

            // Return available days

            return days
        }

        // Return sample templated array

        var days = [ForecastDay]()

        for item in 0...4 {

            var hours = [ForecastHour]()

            for item in 0...4 {
                hours.append(ForecastHour(title: "\(item)"))
            }

            days.append(ForecastDay(date: item.description, hours: hours, templated: true))
        }

        return days
    }
}

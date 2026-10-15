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

    // MARK: - Properties

    public var meteoDataProviderName: String {

        guard
            let providerTitle = meteoProvider
        else {
            return MeteoFactsDefaults.meteoDataProviderName
        }

        return "\(providerTitle)"
    }

    public var responseTime: String { // Last time API request response.

        guard
            let meteoDictionary = self.meteoDictionary as? ForecastDictionary,
            let value = self.responseClientReceivedTime,
            let timezone = meteoDictionary.timezone
        else {
            return MeteoFactsDefaults.responseTimeLabelText
        }

        let lastOne = representLastOneCalculationTime(value,
                                                      timezone,
                                                      toBe: AppOptions.timeFormatOption)
        let prefix = "Prefix: Last One".localizedValue
        let postfixYear = "Postfix: Year".localizedValue

        let day = lastOne.day == nil ? "" : "\(lastOne.day ?? "")\(postfixYear) "

        return "\(prefix): \(day)\(lastOne.time ?? MeteoFactsDefaults.responseTimeLabelText)"
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
        let provider = AppOptions.currentMeteoProviderOption

        for item in 0...4 {

            var hours = [ForecastHour]()

            for item in 0...4 {
                hours.append(ForecastHour(title: "\(item)", provider: provider))
            }

            days.append(ForecastDay(date: item.description, hours: hours, templated: true))
        }

        return days
    }
}

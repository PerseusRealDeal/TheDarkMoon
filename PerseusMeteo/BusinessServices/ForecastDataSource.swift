//
//  ForecastDataSource.swift
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

import Foundation

// MARK: - Weather App values ready for reading, viewing on a screen

public class ForecastDataSource: MeteoDataSource {

    // MARK: - Init

    init() {
        super.init(contant: .forecast)
    }

    // MARK: - Contract

    public func addResponseDateAndTime(dt: Int) {

        guard let reader = self.reader as? ForecastDataSourceReader else { return }

        reader.lastOne = dt
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
            let reader = self.reader as? ForecastDataSourceReader,
            let value = reader.lastOne,
            let timezone = reader.timezone
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
            let reader = self.reader as? ForecastDataSourceReader
        else {

            // Return empty array

            return [ForecastDay]()
        }

        if let days = reader.forecastDays {

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

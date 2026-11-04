//
//  ForecastHour.swift
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

public struct ForecastHour {

    public var title = "-1" // For debug purpose

    // MARK: - Business Data

    public let provider: MeteoProvider

    public var time = MeteoFactsDefaults.timeFormat
    public var temperature = MeteoFactsDefaults.temperature
    public var rainsnow = MeteoFactsDefaults.forecastRainSnow

    public var weatherDescription = MeteoFactsDefaults.weatherDescription
    public var data: MeteoGroupData

    // MARK: - Init

    init(provider: MeteoProvider) {
        self.provider = provider
        self.data = prepareMeteoGroupForecastHourData([:], provider)
    }
}

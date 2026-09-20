//
//  MeteoSourceReader.swift
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

public class MeteoSourceReader: MeteoJsonAsDictionary {

    // MARK: - Internals

    internal let meteoCategory: MeteoDataCategory
    internal var meteoDictionary: MeteoDataDictionary?

    internal var meteoProvider: MeteoProvider? {

        log.message("[\(type(of: self))].\(#function): Property called", .info, .standard)

        return self.jsonPath?()?.1
    }

    // MARK: - Init

    init(category: MeteoDataCategory) {
        self.meteoCategory = category
        super.init()

        renewDictionary()
    }

    // MARK: - Contract

    public func clearData() {
        renewDictionary()
    }

    public func refreshData() {

        // Each time when meteo data changes, this method should be called.
        log.message("[\(type(of: self))].\(#function)", .info, .standard)

        guard
            let meteoDictionary = self.meteoDictionary,
            let jsonSerializedAsDictionary = jsonAsDictionary,
            let provider = meteoProvider
        else {
            renewDictionary()
            return
        }

        // 1. The way to cach json meteo data as dictionary to reduce serialization calls.
        meteoDictionary.data = jsonSerializedAsDictionary

        // 2. The way to set appropriate parser up.
        if
            meteoCategory == .currentWeather,
            let meteoDictionary = meteoDictionary as? CurrentDictionary {

            switch provider {
            case .serviceOpenMeteo:
                meteoDictionary.parser = CurrentOpenMeteoParser()
            case .serviceOpenWeatherMap:
                meteoDictionary.parser = CurrentOpenWeatherParser()
            }
        }

        if
            meteoCategory == .forecast,
            let meteoDictionary = meteoDictionary as? ForecastDictionary {

            switch provider {
            case .serviceOpenMeteo:
                meteoDictionary.parser = ForecastOpenMeteoParser()
            case .serviceOpenWeatherMap:
                meteoDictionary.parser = ForecastOpenWeatherParser()
            }
        }
    }

    // MARK: - Privates

    private func renewDictionary() {
        switch meteoCategory {
        case .currentWeather:
            meteoDictionary = CurrentDictionary()
        case .forecast:
            meteoDictionary = ForecastDictionary()
        }
    }
}

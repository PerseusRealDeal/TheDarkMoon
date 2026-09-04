//
//  MeteoDataSource.swift
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

public class MeteoDataSource: DataDictionarySource {

    internal let meteoCategory: MeteoDataCategory
    internal var reader: MeteoDataSourceReader?

    public var meteoProvider: MeteoProvider? {
        didSet {

            guard
                let reader = self.reader,
                let jsonSerialized = data,
                let provider = meteoProvider
            else {
                return
            }

            reader.data = jsonSerialized // Data caching

            if
                meteoCategory == .currentWeather,
                let reader = reader as? WeatherDataSourceReader {

                switch provider {
                case .serviceOpenMeteo:
                    // TODO: Add Open-Meteo current weather parser
                    reader.parser = nil
                case .serviceOpenWeatherMap:
                    reader.parser = OpenWeatherWeatherParser()
                }
            }

            if
                meteoCategory == .forecast,
                let reader = reader as? ForecastDataSourceReader {

                switch provider {
                case .serviceOpenMeteo:
                    // TODO: Add Open-Meteo forecast parser
                    reader.parser = nil
                case .serviceOpenWeatherMap:
                    reader.parser = OpenWeatherForecastParser()
                }
            }

            log.message("[\(type(of: self))].\(#function)")
        }
    }

    // MARK: - Init

    init(contant: MeteoDataCategory) {
        self.meteoCategory = contant
        super.init()

        resetDataCach()
    }

    public func resetDataCach() {
        switch meteoCategory {
        case .currentWeather:
            reader = WeatherDataSourceReader()
        case .forecast:
            reader = ForecastDataSourceReader()
        }
    }
}

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
import ConsolePerseusLogger

public class MeteoDataSource: DataDictionarySource {

    internal let meteoCategory: MeteoCategory
    internal var reader: MeteoDataSourceReader?

    public var meteoProvider: MeteoProvider? {
        didSet {

            guard
                let reader = self.reader,
                let dict = data,
                let provider = meteoProvider
            else {
                return
            }

            reader.data = dict

            if meteoCategory == .current, let reader = reader as? CurrentDataSourceReader {
                switch provider {
                case .serviceOpenWeatherMap:
                    reader.parser = OpenWeatherCurrentParser()
                }
            }

            if meteoCategory == .forecast, let reader = reader as? ForecastDataSourceReader {
                switch provider {
                case .serviceOpenWeatherMap:
                    reader.parser = OpenWeatherForecastParser()
                }
            }

            log.message("[\(type(of: self))].\(#function)")
        }
    }

    // MARK: - Init

    init(contant: MeteoCategory) {
        self.meteoCategory = contant

        super.init()

        if contant == .current {
            self.reader = CurrentDataSourceReader()
        }

        if contant == .forecast {
            self.reader = ForecastDataSourceReader()
        }

    }
}

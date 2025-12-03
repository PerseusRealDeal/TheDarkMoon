//
//  Protocols.swift
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

// MARK: - Protocols

public protocol CurrentDataSourceReaderProtocol {
    var parser: WeatherParserProtocol? { get set }
}

public protocol WeatherParserProtocol {

    func getTimeZone(from dictionary: [String: Any]) -> Int?
    func getLastOne(from dictionary: [String: Any]) -> Int?

    func getWeatherDescription(from dictionary: [String: Any]) -> String?
    func getWeatherIconName(from dictionary: [String: Any]) -> String?
    func getWeatherConditions(from source: [String: Any]) -> WeatherConditions

    func getTemperature(from dictionary: [String: Any]) -> String?
    func getTemperatureFeelsLike(from dictionary: [String: Any]) -> String?
    func getTemperatureMinimum(from dictionary: [String: Any]) -> String?
    func getTemperatureMaximum(from dictionary: [String: Any]) -> String?

    func getWindSpeed(from dictionary: [String: Any]) -> String?
    func getWindGusts(from dictionary: [String: Any]) -> String?
    func getWindDirection(from dictionary: [String: Any]) -> String?

    func getPressure(from dictionary: [String: Any]) -> String?
    func getHumidity(from dictionary: [String: Any]) -> Int?
    func getCloudiness(from dictionary: [String: Any]) -> Int?
    func getVisibility(from dictionary: [String: Any]) -> Int?

    func getSunrise(from dictionary: [String: Any]) -> Int?
    func getSunset(from dictionary: [String: Any]) -> Int?
}

public protocol ForecastDataSourceReaderProtocol {
    var parser: ForecastParserProtocol? { get set }
}

public protocol ForecastParserProtocol {
    func getTimeZone(from dictionary: [String: Any]) -> Int?
    func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]?
}

public protocol MeteoProviderProtocol {
    var meteoProvider: MeteoProvider { get set }
}

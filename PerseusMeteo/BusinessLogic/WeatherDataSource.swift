//
//  WeatherDataSource.swift
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
// swiftlint:disable file_length
//

import Foundation

// MARK: - Weather App values ready for reading, viewing on a screen

public class WeatherDataSource: MeteoDataSource {

    // MARK: - Init

    init() {
        super.init(contant: .weather)
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
            let reader = self.reader as? WeatherDataSourceReader,
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

    public var weatherIconName: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.weatherIconName
        else {
            return MeteoFactsDefaults.weatherIconName
        }

        return value
    }

    public var weatherDescription: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.weatherDescription
        else {
            return MeteoFactsDefaults.forecastDaysItemWeatherDescription
        }

        return "Prefix: Curren Weather in Brief".localizedValue + ": \(value)"
    }

    public var weatherConditions: WeatherConditions {

        guard let reader = self.reader as? WeatherDataSourceReader
        else {
            return MeteoFactsDefaults.weatherConditions
        }

        return reader.weatherConditions
    }

    public var temperature: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.temperature
        else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    public var temperatureFeelsLike: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.temperatureFeelsLike
        else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    public var temperatureMinimum: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.temperatureMinimum
        else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    public var temperatureMaximum: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.temperatureMaximum
        else {
            return MeteoFactsDefaults.temperature
        }

        // Recalculate if needed.
        let represented = representTemperature(value,
                                               asIs: TemperatureOption.imperial,
                                               toBe: AppOptions.temperatureOption)

        return "\(represented)\(AppOptions.temperatureOption.unit)"
    }

    public var windSpeed: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.windSpeed
        else {
            return MeteoFactsDefaults.windSpeed
        }

        // Recalculate if needed.
        let represented = representWindSpeedGusts(value,
                                                  asIs: WindSpeedOption.ms,
                                                  toBe: AppOptions.windSpeedOption)

        return "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
    }

    public var windGusts: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.windGusts
        else {
            return MeteoFactsDefaults.windSpeed
        }

        // Recalculate if needed.
        let represented = representWindSpeedGusts(value,
                                                  asIs: WindSpeedOption.ms,
                                                  toBe: AppOptions.windSpeedOption)

        return "\(represented) \(AppOptions.windSpeedOption.unitLocalized)"
    }

    public var windDirection: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.windDirection,
            let point = try? WindDegree(value)
        else {
            return MeteoFactsDefaults.windDirection
        }

        return "\(Int(point.degree))° : \(point.common.abbreviation.localizedValue)"
    }

    public var pressure: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.pressure
        else {
            return MeteoFactsDefaults.pressure
        }

        // Recalculate if needed.
        let represented = representPressure(value,
                                            asIs: PressureOption.hPa,
                                            toBe: AppOptions.pressureOption)

        return "\(represented) \(AppOptions.pressureOption.unitLocalized)"
    }

    public var humidity: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.humidity
        else {
            return MeteoFactsDefaults.humidity
        }

        return "\(value)%"
    }

    public var cloudiness: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.cloudiness
        else {
                return MeteoFactsDefaults.cloudiness
        }

        return "\(value)%"
    }

    public var visibility: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.visibility
        else {
            return MeteoFactsDefaults.visibility
        }

        // Recalculate if needed.
        let represented = representDistance(value,
                                            asIs: LengthOption.meter,
                                            toBe: AppOptions.distanceOption)

        return "\(represented) \(AppOptions.distanceOption.unitLocalized)"
    }

    public var sunrise: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.sunrise,
            let timezone = reader.timezone
        else {
            return MeteoFactsDefaults.sunrizesunset
        }

        // Recalculate if needed.
        let represented = representMeteoTime(value,
                                             timezone,
                                             toBe: AppOptions.timeFormatOption)

        return "\(represented ?? MeteoFactsDefaults.sunrizesunset)"
    }

    public var sunset: String {

        guard
            let reader = self.reader as? WeatherDataSourceReader,
            let value = reader.sunset,
            let timezone = reader.timezone
        else {
            return MeteoFactsDefaults.sunrizesunset
        }

        // Recalculate if needed.
        let represented = representMeteoTime(value,
                                             timezone,
                                             toBe: AppOptions.timeFormatOption)

        return "\(represented ?? MeteoFactsDefaults.sunrizesunset)"
    }
}

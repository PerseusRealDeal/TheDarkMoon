//
//  CurrentReader.swift
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
// swiftlint:disable file_length
//

import Foundation

// Unified meteo values ready to be shown on screen.

public class CurrentReader: MeteoSourceReader {

    public static let shared: CurrentReader = { return CurrentReader() }()

    private init() {
        super.init(category: .currentWeather)
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

    public var lastOne: String { // API request response last time.

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
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

    public var weatherIconName: String {

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.weatherIconName
        else {
            return MeteoFactsDefaults.weatherIconName
        }

        log.message(#function + " \(value)")

        return value
    }

    public var weatherDescription: String {

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.weatherDescription
        else {
            return MeteoFactsDefaults.forecastDaysItemWeatherDescription
        }

        return "Prefix: Curren Weather in Brief".localizedValue + ": \(value)"
    }

    public var weatherConditions: WeatherConditions {

        guard let meteoDictionary = self.meteoDictionary as? CurrentDictionary
        else {
            return MeteoFactsDefaults.weatherConditions
        }

        return meteoDictionary.weatherConditions
    }

    public var temperature: String {

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.temperature
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.temperatureFeelsLike
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.temperatureMinimum
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.temperatureMaximum
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.windSpeed
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.windGusts
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.windDirection,
            let point = try? WindDegree(value)
        else {
            return MeteoFactsDefaults.windDirection
        }

        return "\(Int(point.degree))° : \(point.common.abbreviation.localizedValue)"
    }

    public var pressure: String {

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.pressure
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.humidity
        else {
            return MeteoFactsDefaults.humidity
        }

        return "\(value)%"
    }

    public var cloudiness: String {

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.cloudiness
        else {
                return MeteoFactsDefaults.cloudiness
        }

        return "\(value)%"
    }

    public var visibility: String {

        guard
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.visibility
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.sunrise,
            let timezone = meteoDictionary.timezone
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
            let meteoDictionary = self.meteoDictionary as? CurrentDictionary,
            let value = meteoDictionary.sunset,
            let timezone = meteoDictionary.timezone
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

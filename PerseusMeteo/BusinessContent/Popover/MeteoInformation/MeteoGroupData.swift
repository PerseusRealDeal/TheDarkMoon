//
//  MeteoGroupData.swift
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

public struct MeteoGroupData {

    public var title1: String = "-- / --"
    public var title2: String = "-- / --"
    public var title3: String = "-- / --"
    public var title4: String = "-- / --"
    public var title5: String = "-- / --"
    public var title6: String = "-- / --"
    public var title7: String = "-- / --"
    public var title8: String = "-- / --"
    public var title9: String = "-- / --"

    public var value1: String = "Default: N/A".localizedValue
    public var value2: String = "Default: N/A".localizedValue
    public var value3: String = "Default: N/A".localizedValue
    public var value4: String = "Default: N/A".localizedValue
    public var value5: String = "Default: N/A".localizedValue
    public var value6: String = "Default: N/A".localizedValue
    public var value7: String = "Default: N/A".localizedValue
    public var value8: String = "Default: N/A".localizedValue
    public var value9: String = "Default: N/A".localizedValue
}

public extension MeteoGroupData {

    mutating func setTemplatedValuesUp(provider: MeteoProvider, category: MeteoDataCategory) {

        // MARK: - Templated Titles

        // Array 1

        if provider == .serviceOpenMeteo, category == .forecast {
            title1 = "Label: UV Index".localizedValue
        } else {
            title1 = "Prefix: Min".localizedValue + ", " + "Prefix: Max".localizedValue
        }

        title2 = "Prefix: Feels Like".localizedValue
        title3 = "Prefix: Visibility".localizedValue

        // Array 2

        title4 = "Label: Speed".localizedValue
        title5 = "Label: Direction".localizedValue
        title6 = "Label: Gust".localizedValue

        // Array 3

        title7 = "Label: Pressure".localizedValue
        title8 = "Prefix: Humidity".localizedValue
        title9 = "Prefix: Cloudiness".localizedValue

        // MARK: Templated Values

        // Array 1

        if provider == .serviceOpenMeteo, category == .forecast {
            value1 = MeteoFactsDefaults.uvindex
        } else {
            value1 = "\(MeteoFactsDefaults.temperature) : \(MeteoFactsDefaults.temperature)"
        }

        value2 = MeteoFactsDefaults.temperature
        value3 = MeteoFactsDefaults.visibility

        // Array 2

        value4 = MeteoFactsDefaults.windSpeed
        value5 = MeteoFactsDefaults.windDirection
        value6 = MeteoFactsDefaults.windSpeed

        // Array 3

        value7 = MeteoFactsDefaults.pressure
        value8 = MeteoFactsDefaults.humidity
        value9 = MeteoFactsDefaults.cloudiness
    }

    mutating func setOpenWeatherForecastUp(data: [String: Any] = [:]) {

        let tempMin = getForecastHourTempMin(from: data)
        let tempMax = getForecastHourTempMax(from: data)

        let valueMinMax = "\(tempMin) : \(tempMax)"

        // Array 1

        value1 = valueMinMax
        value2 = getForecastHourTempKinda(from: data)
        value3 = getForecastHourVisibility(from: data)

        // Array 2

        value4 = getForecastHourWindSpeed(from: data)
        value5 = getForecastHourWindDirection(from: data)
        value6 = getForecastHourWindGusts(from: data)

        // Array 3

        value7 = getForecastHourPressure(from: data)
        value8 = getForecastHourHumidity(from: data)
        value9 = getForecastHourCloudiness(from: data)
    }

    mutating func setOpenMeteoForecastUp(data: [String: Any] = [:]) {

    }
}

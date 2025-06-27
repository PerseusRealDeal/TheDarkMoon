//
//  MeteoFactsRepresenter.swift
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
//  Special thanks for common convertion weather values formulas goes to Google Inc.
//  https://www.google.com/search?q=temperature+converter
//
// swiftlint:disable file_length
//

import Foundation

// MARK: - Probability of precipitation (pop)

public func representProbabilityOfPrecipitation(_ value: Double?) -> String {

    guard let probability = value else { return "" }

    let calculated = probability * 100

    return Int(calculated.cut(.two)).description
}

// MARK: - Temperature

public func representTemperature(_ value: String,
                                 asIs: TemperatureOption,
                                 toBe: TemperatureOption) -> String {

    guard  let temperature = Double(value) else { return value }

    var calculated = value.description

    // Fahrenheit > Celsius
    if asIs == .imperial, toBe == .metric {

        // (0°F − 32) × 5/9
        let tempRecalculated = Int(((temperature - 32) * 5/9).rounded())

        calculated = tempRecalculated.description
    }

    // Fahrenheit > Kelvin
    if asIs == .imperial, toBe == .standard {

        // (0°F − 32) × 5/9 + 273.15
        let tempRecalculated = (temperature - 32) * 5/9 + 273.15

        calculated = tempRecalculated.cut(.two).description
    }

    return calculated
}

// MARK: - Wind and gust speed

public func representWindSpeedGusts(_ value: String,
                                    asIs: WindSpeedOption,
                                    toBe: WindSpeedOption) -> String {

    guard let speed = Double(value) else { return value }

    var calculated = value.description

    // Meter per second [meter/sec] > Kilometer per hour [km/hour]
    if asIs == .ms, toBe == .kmh {

        // Multiply the speed value by 3.6
        let speedCalculated = (speed * 3.6).cut(.two)

        calculated = speedCalculated.description
    }

    // Meter per second [meter/sec] > Mile per hour [mph]
    if asIs == .ms, toBe == .mph {

        // Multiply the speed value by 2.237
        let speedCalculated = (speed * 2.237).cut(.two)

        calculated = speedCalculated.description
    }

    return calculated
}

// MARK: - Pressure

public func representPressure(_ value: String,
                              asIs: PressureOption,
                              toBe: PressureOption) -> String {

    guard let pressure = Double(value) else { return value }

    var calculated = value

    // Hectopascal [hPa] > Millibar [mbar]
    if asIs == .hPa, toBe == .mb {

        //  1 hPa = 1 mbar

        calculated = value
    }

    // Hectopascal [hPa] > Millibar [mbar]
    if asIs == .hPa, toBe == .mmHg {

        // 1 hPa = 0.75 mmHg
        let pressureRecalculated = Int((pressure * 0.75).rounded())

        calculated = pressureRecalculated.description
    }

    return calculated
}

// MARK: - Distance

public func representDistance(_ value: Int,
                              asIs: LengthOption,
                              toBe: LengthOption) -> String {

    var calculated = value.description

    // Meter [m] > Kilometre [km]
    if asIs == .meter, toBe == .kilometre {

        // distance = value / 1000
        let distance = (Double(value) / 1000).cut(.two)

        calculated = distance.description
    }

    // Meter [m] > Mile [mi]
    if asIs == .meter, toBe == .mile {

        // distance = value / 1609
        let distance = (Double(value) / 1609).cut(.two)

        calculated = distance.description
    }

    return calculated
}

// MARK: - Meteo time

public func representMeteoTime(_ value: Int,
                               _ timezone: Int,
                               toBe: TimeFormatOption) -> String? {

    // Calculate required time format.
    let current = Date.currentTimeFormat
    let required = toBe == .system ? current : toBe == .hour12 ? .hour12 : .hour24

    // Create a date object of the given time and timezone.
    let date = Date(timeIntervalSince1970: TimeInterval(value))
    let dateInTimeZone = date.addingTimeInterval(TimeInterval(timezone))

    let time = dateInTimeZone.timeInFormat(required)

    return time
}

// MARK: - Day and time (always gregorian by UTC)

public let months =
[
    "January", "February", "March", "April", "May", "June",
    "Jule", "August", "September", "October", "November", "December"
]

public func representLastOneCalculationTime(_ value: Int,
                                            _ timezone: Int,
                                            toBe: TimeFormatOption)
    -> (day: String?, time: String?, theDayOfTheWeek: Int?) {

        // Calculate required time format.
        let current = Date.currentTimeFormat
        let required = toBe == .system ? current : toBe == .hour12 ? .hour12 : .hour24

        // Create a date object of the given time and timezone.
        let date = Date(timeIntervalSince1970: TimeInterval(value))

        // Time.

        let dateInTimeZone = date.addingTimeInterval(TimeInterval(timezone))
        let theTime = dateInTimeZone.timeInFormat(required, withSeconds: true)

        // Day.

        guard let timezone = TimeZone(secondsFromGMT: timezone) else { return (nil, nil, nil) }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timezone

        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: date)

        // Parse.

        guard
            let dayNumber = components.day,
            let monthNumber = components.month,
            let yearNumber = components.year,
            let theDayOfTheWeek = components.weekday
        else {
            return (nil, nil, nil)
        }

        // Formate.

        let month = ("Month: " + months[monthNumber-1]).localizedValue
        let theDay = "\(dayNumber) \(month) \(yearNumber)"

        return (theDay, theTime, theDayOfTheWeek)
}

// MARK: - Icon name

public func representOpenWeatherMapIcon(_ id: Int, _ icon: String) -> String {
    return AppGlobals.statusMenusButtonIconName
}

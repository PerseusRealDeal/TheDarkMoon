//
//  OpenMeteoAPI.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (03.09.2026.)
//
//  Copyright © 7535 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public let schemeOpenMeteo = "https://api.open-meteo.com/v1/"
public let attributesOpenMeteo =
"forecast?latitude=%@&longitude=%@&temperature_unit=%@&forecast_days=%@"
public let paramsOpenMeteo =
"&daily=sunrise,sunset,precipitation_probability_max&wind_speed_unit=ms"

public let schemeDirectGeoCodingOpenMeteo = "https://geocoding-api.open-meteo.com/v1/"
public let attributesDirectGeoCodingOpenMeteo = "search?name=%@&count=%@&language=%@&format=%@"

public struct OpenMeteoAPI {

    public let request: MeteoDataCategory

    public let lat: String
    public let lon: String

    public let units: Units = .imperial // Either .metric or .imperial, not .standard (kelvin)
    public let forecastDays: Int

    public init(request: MeteoDataCategory = .currentWeather,
                lat: String = "55.66",
                lon: String = "85.62",
                days: Int = 1) {

        self.request = request
        self.lat = lat
        self.lon = lon
        self.forecastDays = days
    }

    public var urlString: String {

        let args: [String] = [lat, lon, "\(units)", "\(forecastDays)"]
        let attributes = String(format: attributesOpenMeteo, arguments: args)

        let params = paramsOpenMeteo + (request == .forecast ? "&hourly=" : "&current=") + """
weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,temperature_2m,
""" + """
apparent_temperature,visibility,pressure_msl,relative_humidity_2m,cloud_cover,showers,rain,
""" + """
snowfall,precipitation,precipitation_probability,is_day
"""

        return schemeOpenMeteo + attributes + params
    }

    // Returns URL String for direct geo coding city name
    public static func directGeoCoding(city: String,
                                       count: Int = 10,
                                       lang: Lang = .en,
                                       format: Mode = .json) -> String {

        let args: [String] = [city, "\(count)", "\(lang.rawValue)", "\(format.rawValue)"]
        let attributes = String(format: attributesDirectGeoCodingOpenMeteo, arguments: args)

        let urlString = schemeDirectGeoCodingOpenMeteo + attributes

        return urlString
    }
}

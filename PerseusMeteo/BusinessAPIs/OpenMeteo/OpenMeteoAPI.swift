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

public func suggestionsOpenMeteo(json: Data) -> [Location]? {

    log.message("Open-Meteo Suggestions:\n\(json.prettyPrinted ?? "")", .info, .custom)

    // return suggestionsSample()

    var results: [[String: Any]]

    let opts: JSONSerialization.ReadingOptions = [.mutableContainers]

    do {
        let jsonObject = try JSONSerialization.jsonObject(with: json, options: opts)

        if let array = jsonObject as? [String: Any] {
            if let arrayObjects = array["results"] as? [[String: Any]] {

                results = arrayObjects

            } else {
                log.message("There are no suggestions received".localizedValue,
                            .notice, .custom, .enduser)
                return nil
            }
        } else {
            log.message("\(#function) Open-Meteo response can't go as dictionary", .error)
            return nil
        }
    } catch {
        log.message("\(#function) Open-Meteo response can't go as json", .error)
        return nil
    }

    var suggestions = [Location]()

    for item in results {

        guard
            let name = item["name"] as? String,
            let lat = item["latitude"] as? Double,
            let lon = item["longitude"] as? Double
        else {
            continue
        }

        var location = Location()

        location.name = name
        location.latitude = lat
        location.longitude = lon

        if let country = item["country_code"] as? String {
            location.country = country
        }

        if let name = location.name, let admin1 = item["admin1"] as? String {
            location.name = "\(name), \(admin1)"
        }

        suggestions.append(location)
    }

    return suggestions
}

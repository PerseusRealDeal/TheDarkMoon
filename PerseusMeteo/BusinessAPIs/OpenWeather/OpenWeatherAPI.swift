//
//  OpenWeatherAPI.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7535 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public let schemeOpenWeather = "https://api.openweathermap.org/data/2.5/"
public let attributesOpenWeather = "%@?lat=%@&lon=%@&appid=%@"

public let schemeDirectGeoCodingOpenWeather = "http://api.openweathermap.org/geo/1.0/"
public let attributesDirectGeoCodingOpenWeather = "direct?q=%@&limit=%@&appid=%@"

public enum OpenWeatherRequest: String {
    case currentWeather = "weather" // Default.
    case forecast = "forecast"
}

public enum Units: String {
    case standard // Default.
    case metric
    case imperial
}

public struct OpenWeatherAPI {

    public let appid: String
    public let request: OpenWeatherRequest

    public let lat: String
    public let lon: String

    public let units: Units
    public let lang: Lang
    public let mode: Mode

    // A number of timestamps, which will be returned in the API response.
    public var cnt: Int = -1

    public init(appid: String,
                request: OpenWeatherRequest = .currentWeather,
                lat: String = "55.66",
                lon: String = "85.62",
                units: Units = .standard,
                lang: Lang = Lang.byDefault,
                mode: Mode = Mode.json) {

        self.appid = appid
        self.request = request
        self.lat = lat
        self.lon = lon
        self.units = units
        self.lang = lang
        self.mode = mode
    }

    public var urlString: String {

        let args: [String] = [request.rawValue, lat, lon, appid]
        var attributes = String(format: attributesOpenWeather, arguments: args)

        if !lang.rawValue.isEmpty {
            attributes.append("&lang=\(lang.rawValue)")
        }

        if request == .forecast && cnt != -1 {
            attributes.append("&cnt=\(cnt)")
        }

        if mode != .json {
            attributes.append("&mode=\(mode.rawValue)")
        }

        if units != .standard {
            attributes.append("&units=\(units.rawValue)")
        }

        return schemeOpenWeather + attributes
    }

    // Returns URL String for direct geo coding city name
    public static func directGeoCoding(city: String, limit: Int, appid: String) -> String {

        let args: [String] = [city, "\(limit)", appid]
        let attributes = String(format: attributesDirectGeoCodingOpenWeather, arguments: args)

        let urlString = schemeDirectGeoCodingOpenWeather + attributes

        return urlString
    }
}

public func suggestionsOpenWeather(json: Data) -> [Location]? {

    log.message("Suggestions:\n\(json.prettyPrinted ?? "")", .info, .standard)

    // return prepareSuggestionsSample()

    let decoder = JSONDecoder()

    guard
        let loadedObjects = try? decoder.decode([OpenWeatherSuggestion].self, from: json)
    else {
        return nil
    }

    var suggestions = [Location]()

    for item in loadedObjects {
        var location = Location()

        location.name = item.name
        location.localNames = item.local_names
        location.country = item.country
        location.latitude = item.lat
        location.longitude = item.lon
        location.state = item.state

        suggestions.append(location)
    }

    return suggestions
}

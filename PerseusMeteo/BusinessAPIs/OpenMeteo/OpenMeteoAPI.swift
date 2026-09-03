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

public let schemeDirectGeoCodingOpenMeteo = "https://geocoding-api.open-meteo.com/v1/"
public let attributesDirectGeoCodingOpenMeteo = "search?name=%@&count=%@&language=%@&format=%@"

public struct OpenMeteoAPI {

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

    // log.message("Suggestions:\n\(json.prettyPrinted ?? "")", .info, .standard)

    // return prepareSuggestionsSample()

    var results: [[String: Any]]

    let opts: JSONSerialization.ReadingOptions = [.mutableContainers]

    do {
        let jsonObject = try JSONSerialization.jsonObject(with: json, options: opts)

        if let array = jsonObject as? [String: Any] {
            if let arrayObjects = array["results"] as? [[String: Any]] {

                results = arrayObjects

            } else {
                let text = "There are no suggestions received".localizedValue
                log.message(text, .notice, .custom, .enduser)
                return nil
            }
        } else {
            log.message("\(#function) response can't go as dictionary", .error)
            return nil
        }
    } catch {
        log.message("\(#function) response can't go as json", .error)
        return nil
    }

    var suggestions = [Location]()

    for item in results {
        var location = Location()

        if
            let name = item["name"] as? String,
            let lat = item["latitude"] as? Double,
            let lon = item["longitude"] as? Double {

            location.name = name
            location.latitude = lat
            location.longitude = lon

            if let country = item["country_code"] as? String {
                location.country = country
            }

            if let name = location.name, let admin1 = item["admin1"] as? String {
                location.name = "\(name), \(admin1)"
            }
        }

        suggestions.append(location)
    }

    return suggestions
}

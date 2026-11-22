//
//  GeoCodingSuggestions.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

// MARK: - Open-Meteo Suggestions

public func suggestionsOpenMeteo(json: Data, usePrepared: Bool = false) -> [Location]? {

    // log.message("Open-Meteo Suggestions:\n\(json.prettyPrinted ?? "")", .info, .standard)

    guard usePrepared == false else {
        return sampleSuggestions()
    }

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

// MARK: - OpenWeather Suggestions

public func suggestionsOpenWeather(json: Data, usePrepared: Bool = false) -> [Location]? {

    // log.message("OpenWeather Suggestions:\n\(json.prettyPrinted ?? "")", .info, .standard)

    guard usePrepared == false else {
        return sampleSuggestions()
    }

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

// MARK: - Suggestions Prepared Sample

public func sampleSuggestions() -> [Location] {

    var suggestion1 = Location()
    var suggestion2 = Location()
    var suggestion3 = Location()

    var suggestion4 = Location()
    var suggestion5 = Location()
    var suggestion6 = Location()

    var suggestion7 = Location()

    suggestion1.name = "Советская улица, 75, НСК"
    suggestion1.point = GeoPoint(55.0377335373108, 82.91413691298119)
    suggestion1.country = "RU"
    suggestion1.localNames = [
        "en": "Sovetskaya, 75, NSK",
        "ru": "Советская улица, 75, НСК"
    ]

    suggestion2.name = "ГЛПК Прибой, НСК"
    suggestion2.point = GeoPoint(54.83263291679862, 82.91570663265945)
    suggestion2.country = "RU"

    suggestion3.name = "Остров Тань-Вань, НСК"
    suggestion3.point = GeoPoint(54.817322188351405, 83.03674574747961)
    suggestion3.country = "RU"

    suggestion4.name = "Озеро Мраморное, НСК обл."
    suggestion4.point = GeoPoint(54.22810680087118, 81.7071991707937)
    suggestion4.country = "RU"

    suggestion5.name = "Беловский водопад, Белово, НСК обл."
    suggestion5.point = GeoPoint(54.55994697554389, 83.62070984232841)
    suggestion5.country = "RU"

    suggestion6.name = "Бердские скалы, Новоседово, Нск обл."
    suggestion6.point = GeoPoint(54.618033965714915, 83.98273590642789)
    suggestion6.country = "RU"

    suggestion7.name = "Гора Церковка, Белокуриха"
    suggestion7.point = GeoPoint(51.97283289139373, 84.92740741343708)
    suggestion7.country = "RU"

    return [
        suggestion1,
        suggestion2,
        suggestion3,
        suggestion4,
        suggestion5,
        suggestion6,
        suggestion7
    ]
}

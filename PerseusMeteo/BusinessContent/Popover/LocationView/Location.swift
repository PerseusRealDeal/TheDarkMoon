//
//  Location.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (30.09.2025).
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import CoreLocation

public struct Location: CustomStringConvertible, Codable {

    public var description: String {

        if isCurrentLocation {
            return "Current Location".localizedValue
        }

        return localName ?? "No name".localizedValue
    }

    public var name: String?
    public var localName: String? {
        if
            let names = localNames,
            let local = names[globals.languageSwitcher.currentAppLanguage] {
            return local
        }
        return name
    }

    public var point: GeoPoint? {
        get {
            guard let latitude = latitude, let longitude = longitude else {
                return nil
            }

            return GeoPoint(latitude, longitude)
        }
        set {
            guard let change = newValue else {
                latitude = nil
                longitude = nil
                return
            }

            latitude = change.location.point.latitude
            longitude = change.location.point.longitude
        }
    }

    public var zip: String?
    public var country: String?

    public let isCurrentLocation: Bool
    public var isOnDisplay: Bool

    public var latitude: Double?
    public var longitude: Double?

    public var localNames: [String: String]?

    // MARK: - Initializer

    public init(isCurrent: Bool = false, isOnDisplay: Bool = false) {
        self.isCurrentLocation = isCurrent
        self.isOnDisplay = isOnDisplay
    }
}

public enum LocationCardType: String, CustomStringConvertible {

    case suggestion = "suggestion"
    case favorite   = "favorite"
    case current    = "current location"

    public var description: String {
        return self.rawValue
    }
}

public func prepareSuggestionsSample() -> [Location] {

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
        suggestion1, suggestion2, suggestion3, suggestion4, suggestion5, suggestion6,
        suggestion7
    ]
}

public func prepareSuggestions(json: Data) -> [Location]? {

    // let text = "JSON:\n\(json.prettyPrinted ?? "")"
    // log.message("\(#function)\n\(text)")

    // return prepareSuggestionsSample()

    let decoder = JSONDecoder()
    guard
        let loadedObjects = try? decoder.decode([SuggestionOpenWeatherMap].self, from: json),
        loadedObjects.isEmpty != true else {
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

        suggestions.append(location)
    }

    return suggestions
}

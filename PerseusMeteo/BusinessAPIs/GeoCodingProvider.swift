//
//  GeoCodingProvider.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (20.08.2026.)
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public enum GeoCodingProvider: Int, CaseIterable, CustomStringConvertible, Codable {

    case serviceOpenMeteo      = 0 // Version 1
    case serviceOpenWeatherMap = 1 // Version 1.0

    public var marketName: String {
        switch self {
        case .serviceOpenMeteo:
            return marketNameOpenMeteo
        case .serviceOpenWeatherMap:
            return marketNameOpenWeather
        }
    }

    public var marketNameWebLink: String {
        switch self {
        case .serviceOpenMeteo:
            return linkOpenMeteo
        case .serviceOpenWeatherMap:
            return linkOpenWeather
        }
    }

    public var description: String {
        return "\(marketName)"
    }
}

public func suggestionsSample() -> [Location] {

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

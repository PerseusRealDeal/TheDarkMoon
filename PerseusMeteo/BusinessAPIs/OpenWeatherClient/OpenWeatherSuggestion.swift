//
//  OpenWeatherSuggestion.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

public struct OpenWeatherSuggestion: Codable {

    public let name: String
    public let local_names: [String: String]?

    public let country: String?

    public let lat: Double
    public let lon: Double

    public let state: String?
}

//
//  ForecastHour.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public struct ForecastHour {

    public var label: String // For debug purpose

    // MARK: - Business Data

    public let provider: MeteoProvider

    public let source: [String: Any]
    public let timezone: Int

    // MARK: - Init

    init(title: String,
         provider: MeteoProvider,
         source: [String: Any] = [:],
         timezone: Int = 0) {

        self.label = title
        self.provider = provider
        self.source = source
        self.timezone = timezone
    }

    init(provider: MeteoProvider, source: [String: Any], timezone: Int, title: String = "") {
        self.init(title: title, provider: provider, source: source, timezone: timezone)
    }
}

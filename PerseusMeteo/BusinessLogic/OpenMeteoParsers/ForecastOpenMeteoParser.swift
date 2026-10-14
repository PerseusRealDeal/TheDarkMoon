//
//  ForecastOpenMeteoParser.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (26.09.2026.)
//
//  Copyright © 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public class ForecastOpenMeteoParser: ForecastParserProtocol {

    // TODO: Implement Open-Meteo forecast weather parser protocol

    public func getTimeZone(from dictionary: [String: Any]) -> Int? {

        guard
            let timezone = getInstance("timezone", String.self, dictionary)
        else {
            return nil
        }

        if timezone == "GMT" {
            return TimeZone.current.secondsFromGMT()
        }

        // If timezone not equel to GMT
        return nil
    }

    public func getForecastDays(from dictionary: [String: Any]) -> [ForecastDay]? {
        return nil
    }
}

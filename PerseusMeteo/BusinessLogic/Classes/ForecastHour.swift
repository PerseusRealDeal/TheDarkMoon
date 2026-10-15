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

/* OpenWeatherMap JSON forecast hour sample in case if cnt = 1

{
   "clouds":{
      "all":100
   },
   "wind":{
      "speed":10.42,
      "deg":210,
      "gust":21.030000000000001
   },
   "dt":1708884000,
   "snow":{
      "3h":0.69999999999999996
   },
   "dt_txt":"2024-02-25 18:00:00",
   "main":{
      "humidity":96,
      "feels_like":-6.54,
      "temp_min":6.0599999999999996,
      "temp_max":6.0599999999999996,
      "temp":6.0599999999999996,
      "pressure":1040,
      "temp_kf":0,
      "sea_level":1040,
      "grnd_level":1021
   },
   "weather":[
      {
         "id":600,
         "main":"Snow",
         "icon":"13n",
         "description":"light snow"
      }
   ],
   "pop":0.48999999999999999,
   "sys":{
      "pod":"n"
   },
   "visibility":130
}

*/

public var count = 0

public struct ForecastHour {

    public var label: String // For debug purpose

    // MARK: - Data

    public let provider: MeteoProvider

    public let source: [String: Any]
    public let timezone: Int

    private var meteoGroupData = MeteoGroupData()

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

    // MARK: - Contract

    // MARK: - Time of Hour

    public var time: String {
        return getForecastHourDt(from: source, timezone: timezone)
    }

    // MARK: - Temperature

    public var temperature: String {
        return getForecastHourTemp(from: source)
    }

    // MARK: - Incoming Precipitation

    public var precipitation: String {
        if let precipitation = getPrecipitation(from: source), precipitation.1 != "" {
            return precipitation.1 + " \(precipitation.2)"
        } else {
            return "-- / --"
        }
    }

    // MARK: - Weather conditions

    public var weatherConditions: OpenWeatherIconCode {
        return getWeatherConditions(from: source)
    }

    // MARK: - Public calculation requests

    public func prepareMeteoGroupData() -> MeteoGroupData {

        count += 1

        log.message("- GET GROUP COUNT: \(count)", .notice, .standard)

        // Set titles up

        var meteogroup = MeteoGroupData()

        switch provider {
        case .serviceOpenMeteo:
            meteogroup.setTemplatedValuesUp(provider: .serviceOpenMeteo,
                                            category: .forecast)
        case .serviceOpenWeatherMap:
            meteogroup.setTemplatedValuesUp(provider: .serviceOpenWeatherMap,
                                            category: .forecast)
        }

        // Set values up

        switch provider {
        case .serviceOpenMeteo:
            meteogroup.setOpenMeteoForecastUp(data: source)
        case .serviceOpenWeatherMap:
            meteogroup.setOpenWeatherForecastUp(data: source)
        }

        return meteogroup
    }
}

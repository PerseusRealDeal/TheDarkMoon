//
//  OpenMeteoCurrentSample.swift
//  TheDarkMoon
//
//  Created in 7535 (02.10.2026.)
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//

// MARK: - Open-Meteo Current JSON Request

/*

https://api.open-meteo.com/v1/forecast
?latitude=55.02
&longitude=82.92
&temperature_unit=fahrenheit
&forecast_days=1
&daily=sunrise,sunset,precipitation_probability_max
&wind_speed_unit=ms
&current=weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,temperature_2m,
apparent_temperature,visibility,pressure_msl,relative_humidity_2m,cloud_cover,
howers,rain,snowfall,precipitation,precipitation_probability,is_day

*/

// MARK: - Open-Meteo Current JSON Response

let sampleOpenMeteoCurrent = """
{
  "generationtime_ms" : 0.22208690643310547,
  "longitude" : 83.00797,
  "utc_offset_seconds" : 0,
  "elevation" : 129,
  "current_units" : {
    "is_day" : "",
    "wind_direction_10m" : "°",
    "wind_speed_10m" : "m/s",
    "apparent_temperature" : "°F",
    "temperature_2m" : "°F",
    "showers" : "mm",
    "interval" : "seconds",
    "snowfall" : "cm",
    "time" : "iso8601",
    "pressure_msl" : "hPa",
    "relative_humidity_2m" : "%",
    "precipitation" : "mm",
    "weather_code" : "wmo code",
    "wind_gusts_10m" : "m/s",
    "visibility" : "m",
    "cloud_cover" : "%",
    "precipitation_probability" : "%",
    "rain" : "mm"
  },
  "timezone" : "GMT",
  "latitude" : 55.008785000000003,
  "timezone_abbreviation" : "GMT",
  "current" : {
    "is_day" : 1,
    "wind_direction_10m" : 86,
    "wind_speed_10m" : 2.3500000000000001,
    "apparent_temperature" : 41.799999999999997,
    "temperature_2m" : 47,
    "showers" : 0,
    "interval" : 900,
    "snowfall" : 0,
    "time" : "2026-10-02T03:45",
    "pressure_msl" : 1018.5,
    "relative_humidity_2m" : 68,
    "precipitation" : 0,
    "weather_code" : 3,
    "wind_gusts_10m" : 6.4000000000000004,
    "visibility" : 60360,
    "cloud_cover" : 100,
    "precipitation_probability" : 0,
    "rain" : 0
  },
  "daily_units" : {
    "sunset" : "iso8601",
    "precipitation_probability_max" : "%",
    "time" : "iso8601",
    "sunrise" : "iso8601"
  },
  "daily" : {
    "sunset" : [
      "2026-10-02T12:01"
    ],
    "precipitation_probability_max" : [
      13
    ],
    "time" : [
      "2026-10-02"
    ],
    "sunrise" : [
      "2026-10-02T00:31"
    ]
  }
}
"""

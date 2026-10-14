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
&timezone=GMT
&forecast_days=1
&daily=sunrise,sunset,precipitation_probability_max,temperature_2m_min,temperature_2m_max
&wind_speed_unit=ms
&current=weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,temperature_2m,
apparent_temperature,visibility,pressure_msl,relative_humidity_2m,cloud_cover,
howers,rain,snowfall,precipitation,precipitation_probability,is_day

*/

// MARK: - Open-Meteo Current JSON Response

let sampleOpenMeteoCurrent = """
{
  "generationtime_ms" : 1.5184879302978516,
  "longitude" : 83.00797,
  "utc_offset_seconds" : 0,
  "elevation" : 129,
  "current_units" : {
    "rain" : "mm",
    "wind_direction_10m" : "°",
    "wind_speed_10m" : "m/s",
    "apparent_temperature" : "°F",
    "temperature_2m" : "°F",
    "showers" : "mm",
    "interval" : "seconds",
    "snowfall" : "cm",
    "time" : "iso8601",
    "is_day" : "",
    "relative_humidity_2m" : "%",
    "precipitation" : "mm",
    "weather_code" : "wmo code",
    "wind_gusts_10m" : "m/s",
    "visibility" : "m",
    "cloud_cover" : "%",
    "precipitation_probability" : "%",
    "pressure_msl" : "hPa"
  },
  "timezone" : "GMT",
  "latitude" : 55.008785000000003,
  "timezone_abbreviation" : "GMT",
  "current" : {
    "rain" : 0,
    "wind_direction_10m" : 182,
    "wind_speed_10m" : 3.25,
    "apparent_temperature" : 40,
    "temperature_2m" : 46.700000000000003,
    "showers" : 0,
    "interval" : 900,
    "snowfall" : 0,
    "time" : "2026-10-12T07:45",
    "is_day" : 1,
    "relative_humidity_2m" : 60,
    "precipitation" : 0,
    "weather_code" : 3,
    "wind_gusts_10m" : 7.5999999999999996,
    "visibility" : 64620,
    "cloud_cover" : 100,
    "precipitation_probability" : 0,
    "pressure_msl" : 1020.8
  },
  "daily_units" : {
    "temperature_2m_max" : "°F",
    "sunset" : "iso8601",
    "precipitation_probability_max" : "%",
    "temperature_2m_min" : "°F",
    "time" : "iso8601",
    "sunrise" : "iso8601"
  },
  "daily" : {
    "temperature_2m_max" : [
      47.700000000000003
    ],
    "sunset" : [
      "2026-10-12T11:37"
    ],
    "precipitation_probability_max" : [
      76
    ],
    "temperature_2m_min" : [
      33.899999999999999
    ],
    "time" : [
      "2026-10-12"
    ],
    "sunrise" : [
      "2026-10-12T00:50"
    ]
  }
}
"""

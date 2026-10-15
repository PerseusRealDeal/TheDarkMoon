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
 ?latitude=55.02&longitude=82.92&temperature_unit=fahrenheit&timezone=GMT
 &wind_speed_unit=ms&forecast_days=1
 &daily=uv_index_max,moon_phase,moonrise,moonset,sunrise,sunset,precipitation_probability_max,
 temperature_2m_min,temperature_2m_max
 &current=weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,
 temperature_2m,apparent_temperature,visibility,pressure_msl,
 relative_humidity_2m,cloud_cover,showers,rain,snowfall,
 precipitation,precipitation_probability,is_day

 */

// MARK: - Open-Meteo Current JSON Response

let sampleOpenMeteoCurrent = """
{
  "generationtime_ms" : 0.27835369110107422,
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
    "rain" : 0.10000000000000001,
    "wind_direction_10m" : 198,
    "wind_speed_10m" : 6.2000000000000002,
    "apparent_temperature" : 36.200000000000003,
    "temperature_2m" : 44.5,
    "showers" : 0,
    "interval" : 900,
    "snowfall" : 0,
    "time" : "2026-10-20T06:00",
    "is_day" : 1,
    "relative_humidity_2m" : 83,
    "precipitation" : 0.10000000000000001,
    "weather_code" : 51,
    "wind_gusts_10m" : 13.1,
    "visibility" : 5800,
    "cloud_cover" : 100,
    "precipitation_probability" : 98,
    "pressure_msl" : 1005.8
  },
  "daily_units" : {
    "sunset" : "iso8601",
    "precipitation_probability_max" : "%",
    "time" : "iso8601",
    "moonrise" : "iso8601",
    "uv_index_max" : "",
    "sunrise" : "iso8601",
    "temperature_2m_min" : "°F",
    "temperature_2m_max" : "°F",
    "moon_phase" : "fraction",
    "moonset" : "iso8601"
  },
  "daily" : {
    "sunset" : [
      "2026-10-20T11:17"
    ],
    "precipitation_probability_max" : [
      100
    ],
    "time" : [
      "2026-10-20"
    ],
    "moonrise" : [
      "2026-10-20T09:33"
    ],
    "uv_index_max" : [
      0.34999999999999998
    ],
    "sunrise" : [
      "2026-10-20T01:06"
    ],
    "temperature_2m_min" : [
      30.899999999999999
    ],
    "temperature_2m_max" : [
      45.600000000000001
    ],
    "moon_phase" : [
      0.30599999999999999
    ],
    "moonset" : [
      "2026-10-20T18:31"
    ]
  }
}
"""

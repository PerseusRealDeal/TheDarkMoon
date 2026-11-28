//
//  OpenMeteoCurrent.swift
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
?latitude=55.02&longitude=82.92
&temperature_unit=fahrenheit
&forecast_days=1
&wind_speed_unit=ms
&timezone=auto
&timeformat=unixtime
&daily=uv_index_max,moon_phase,moonrise,moonset,sunrise,sunset,weather_code,
 rain_sum,snowfall_sum,precipitation_probability_max,temperature_2m_min,temperature_2m_max
&current=weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,
 temperature_2m,apparent_temperature,visibility,pressure_msl,relative_humidity_2m,
 cloud_cover,showers,rain,snowfall,precipitation,precipitation_probability,uv_index,is_day

 */

// MARK: - Open-Meteo Current JSON Response

let sampleOpenMeteoCurrent = """
{
  "generationtime_ms" : 0.38266181945800781,
  "longitude" : 83.00797,
  "utc_offset_seconds" : 25200,
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
    "time" : "unixtime",
    "uv_index" : "",
    "relative_humidity_2m" : "%",
    "precipitation" : "mm",
    "is_day" : "",
    "weather_code" : "wmo code",
    "wind_gusts_10m" : "m/s",
    "visibility" : "m",
    "cloud_cover" : "%",
    "precipitation_probability" : "%",
    "pressure_msl" : "hPa"
  },
  "timezone" : "Asia/Novosibirsk",
  "latitude" : 55.008785000000003,
  "timezone_abbreviation" : "GMT+7",
  "current" : {
    "rain" : 0,
    "wind_direction_10m" : 311,
    "wind_speed_10m" : 4.3200000000000003,
    "apparent_temperature" : 24.5,
    "temperature_2m" : 32.5,
    "showers" : 0,
    "interval" : 900,
    "snowfall" : 0.14000000000000001,
    "time" : 1795536000,
    "uv_index" : 0,
    "relative_humidity_2m" : 97,
    "precipitation" : 0.20000000000000001,
    "is_day" : 0,
    "weather_code" : 73,
    "wind_gusts_10m" : 8.6999999999999993,
    "visibility" : 2820,
    "cloud_cover" : 100,
    "precipitation_probability" : 100,
    "pressure_msl" : 1007
  },
  "daily_units" : {
    "snowfall_sum" : "cm",
    "rain_sum" : "mm",
    "time" : "unixtime",
    "sunrise" : "unixtime",
    "uv_index_max" : "",
    "sunset" : "unixtime",
    "moon_phase" : "fraction",
    "precipitation_probability_max" : "%",
    "weather_code" : "wmo code",
    "moonset" : "unixtime",
    "temperature_2m_min" : "°F",
    "moonrise" : "unixtime",
    "temperature_2m_max" : "°F"
  },
  "daily" : {
    "snowfall_sum" : [
      4.1299999999999999
    ],
    "rain_sum" : [
      10.199999999999999
    ],
    "time" : [
      1795453200
    ],
    "sunrise" : [
      1795486588
    ],
    "uv_index_max" : [
      0.10000000000000001
    ],
    "sunset" : [
      1795515133
    ],
    "moon_phase" : [
      0.48399999999999999
    ],
    "precipitation_probability_max" : [
      100
    ],
    "weather_code" : [
      85
    ],
    "moonset" : [
      1795486371
    ],
    "temperature_2m_min" : [
      32.399999999999999
    ],
    "moonrise" : [
      1795511526
    ],
    "temperature_2m_max" : [
      39.299999999999997
    ]
  }
}
"""

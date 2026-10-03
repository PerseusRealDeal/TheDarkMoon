//
//  OpenWeatherCurrentSample.swift
//  TheDarkMoon
//
//  Created in 7535 (03.10.2026.)
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//

// MARK: - OpenWeatherMap Current JSON Request

/*

https://api.openweathermap.org/data/2.5/weather
?lat=55.02
&lon=82.92
&appid=###
&lang=ru
&units=imperial

*/

// MARK: - OpenWeatherMap Current JSON Response

let sampleOpenWeatherMapCurrent = """
{
  "base" : "stations",
  "id" : 1496747,
  "dt" : 1790432931,
  "main" : {
    "humidity" : 66,
    "feels_like" : 46.090000000000003,
    "temp_min" : 47.890000000000001,
    "temp_max" : 47.890000000000001,
    "temp" : 47.890000000000001,
    "pressure" : 1025,
    "sea_level" : 1025,
    "grnd_level" : 1009
  },
  "coord" : {
    "lon" : 82.920000000000002,
    "lat" : 55.020000000000003
  },
  "wind" : {
    "speed" : 4.4699999999999998,
    "deg" : 300,
    "gust" : 19.010000000000002
  },
  "sys" : {
    "id" : 8958,
    "country" : "RU",
    "sunset" : 1790425151,
    "type" : 1,
    "sunrise" : 1790382024
  },
  "weather" : [
    {
      "id" : 804,
      "main" : "Clouds",
      "icon" : "04n",
      "description" : "пасмурно"
    }
  ],
  "visibility" : 10000,
  "clouds" : {
    "all" : 100
  },
  "timezone" : 25200,
  "cod" : 200,
  "name" : "Новосибирск"
}
"""

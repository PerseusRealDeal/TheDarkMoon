//
//  OpenWeatherForecastSample.swift
//  TheDarkMoon
//
//  Created in 7535 (03.10.2026.)
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
// swiftlint:disable file_length
//

// MARK: - OpenWeatherMap Forecast JSON Request

/*

https://api.openweathermap.org/data/2.5/forecast
?lat=55.02
&lon=82.92
&appid=###
&lang=ru
&cnt=40
&units=imperial

*/

// MARK: - OpenWeatherMap Forecast JSON Response

let sampleOpenWeatherMapForecast1 = """
{
  "message": 0,
  "cod": "200",
  "cnt": 40,
  "list": [
    {
      "clouds": {
        "all": 100
      },
      "wind": {
        "speed": 7.58,
        "deg": 307,
        "gust": 18.34
      },
      "dt": 1790434800,
      "dt_txt": "2026-09-26 15:00:00",
      "main": {
        "humidity": 66,
        "feels_like": 44.38,
        "temp_min": 47.25,
        "temp_max": 47.89,
        "temp": 47.89,
        "pressure": 1025,
        "temp_kf": 0.36,
        "dew_point": 37.09,
        "sea_level": 1025,
        "grnd_level": 1009
      },
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "пасмурно"
        }
      ],
      "pop": 0,
      "sys": {
        "pod": "n"
      },
      "visibility": 10000
    }
  ],
  "city": {
    "sunset": 1790425151,
    "country": "RU",
    "id": 1496747,
    "coord": {
      "lat": 55.02,
      "lon": 82.92
    },
    "population": 1419007,
    "timezone": 25200,
    "sunrise": 1790382024,
    "name": "Новосибирск"
  }
}
"""

let sampleOpenWeatherMapForecast40 = """
{
  "message" : 0,
  "cod" : "200",
  "cnt" : 40,
  "list" : [
    {
      "clouds" : {
        "all" : 37
      },
      "wind" : {
        "speed" : 13.85,
        "deg" : 214,
        "gust" : 17.780000000000001
      },
      "dt" : 1791007200,
      "dt_txt" : "2026-10-03 06:00:00",
      "main" : {
        "humidity" : 62,
        "feels_like" : 55.200000000000003,
        "temp_min" : 56.890000000000001,
        "temp_max" : 59.359999999999999,
        "temp" : 56.890000000000001,
        "pressure" : 1020,
        "temp_kf" : -1.3700000000000001,
        "dew_point" : 44.020000000000003,
        "sea_level" : 1020,
        "grnd_level" : 1004
      },
      "weather" : [
        {
          "id" : 802,
          "main" : "Clouds",
          "icon" : "03d",
          "description" : "переменная облачность"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 56
      },
      "wind" : {
        "speed" : 12.48,
        "deg" : 243,
        "gust" : 19.530000000000001
      },
      "dt" : 1791018000,
      "dt_txt" : "2026-10-03 09:00:00",
      "main" : {
        "humidity" : 54,
        "feels_like" : 57.060000000000002,
        "temp_min" : 58.93,
        "temp_max" : 63.009999999999998,
        "temp" : 58.93,
        "pressure" : 1020,
        "temp_kf" : -2.27,
        "dew_point" : 42.329999999999998,
        "sea_level" : 1020,
        "grnd_level" : 1005
      },
      "weather" : [
        {
          "id" : 803,
          "main" : "Clouds",
          "icon" : "04d",
          "description" : "облачно с прояснениями"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 77
      },
      "wind" : {
        "speed" : 4.9699999999999998,
        "deg" : 228,
        "gust" : 5.0300000000000002
      },
      "dt" : 1791028800,
      "dt_txt" : "2026-10-03 12:00:00",
      "main" : {
        "humidity" : 56,
        "feels_like" : 54.460000000000001,
        "temp_min" : 56.280000000000001,
        "temp_max" : 56.479999999999997,
        "temp" : 56.479999999999997,
        "pressure" : 1021,
        "temp_kf" : 0.11,
        "dew_point" : 41,
        "sea_level" : 1021,
        "grnd_level" : 1005
      },
      "weather" : [
        {
          "id" : 803,
          "main" : "Clouds",
          "icon" : "04d",
          "description" : "облачно с прояснениями"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 2.6600000000000001,
        "deg" : 133,
        "gust" : 2.6400000000000001
      },
      "dt" : 1791039600,
      "dt_txt" : "2026-10-03 15:00:00",
      "main" : {
        "humidity" : 58,
        "feels_like" : 51.210000000000001,
        "temp_min" : 53.439999999999998,
        "temp_max" : 53.439999999999998,
        "temp" : 53.439999999999998,
        "pressure" : 1021,
        "temp_kf" : 0,
        "dew_point" : 38.93,
        "sea_level" : 1021,
        "grnd_level" : 1005
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 5.6799999999999997,
        "deg" : 132,
        "gust" : 6.1299999999999999
      },
      "dt" : 1791050400,
      "dt_txt" : "2026-10-03 18:00:00",
      "main" : {
        "humidity" : 59,
        "feels_like" : 50.159999999999997,
        "temp_min" : 52.450000000000003,
        "temp_max" : 52.450000000000003,
        "temp" : 52.450000000000003,
        "pressure" : 1021,
        "temp_kf" : 0,
        "dew_point" : 38.640000000000001,
        "sea_level" : 1021,
        "grnd_level" : 1005
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 6.5099999999999998,
        "deg" : 125,
        "gust" : 9.6600000000000001
      },
      "dt" : 1791061200,
      "dt_txt" : "2026-10-03 21:00:00",
      "main" : {
        "humidity" : 63,
        "feels_like" : 47.259999999999998,
        "temp_min" : 49.869999999999997,
        "temp_max" : 49.869999999999997,
        "temp" : 49.869999999999997,
        "pressure" : 1020,
        "temp_kf" : 0,
        "dew_point" : 37.539999999999999,
        "sea_level" : 1020,
        "grnd_level" : 1004
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 6.5099999999999998,
        "deg" : 149,
        "gust" : 10.74
      },
      "dt" : 1791072000,
      "dt_txt" : "2026-10-04 00:00:00",
      "main" : {
        "humidity" : 62,
        "feels_like" : 45.640000000000001,
        "temp_min" : 48.520000000000003,
        "temp_max" : 48.520000000000003,
        "temp" : 48.520000000000003,
        "pressure" : 1019,
        "temp_kf" : 0,
        "dew_point" : 35.939999999999998,
        "sea_level" : 1019,
        "grnd_level" : 1003
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 10.710000000000001,
        "deg" : 156,
        "gust" : 22.030000000000001
      },
      "dt" : 1791082800,
      "dt_txt" : "2026-10-04 03:00:00",
      "main" : {
        "humidity" : 60,
        "feels_like" : 52.590000000000003,
        "temp_min" : 54.609999999999999,
        "temp_max" : 54.609999999999999,
        "temp" : 54.609999999999999,
        "pressure" : 1018,
        "temp_kf" : 0,
        "dew_point" : 40.75,
        "sea_level" : 1018,
        "grnd_level" : 1002
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04d",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 13.69,
        "deg" : 177,
        "gust" : 27.219999999999999
      },
      "dt" : 1791093600,
      "dt_txt" : "2026-10-04 06:00:00",
      "main" : {
        "humidity" : 45,
        "feels_like" : 58.869999999999997,
        "temp_min" : 60.960000000000001,
        "temp_max" : 60.960000000000001,
        "temp" : 60.960000000000001,
        "pressure" : 1017,
        "temp_kf" : 0,
        "dew_point" : 39.469999999999999,
        "sea_level" : 1017,
        "grnd_level" : 1001
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04d",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 9.7300000000000004,
        "deg" : 140,
        "gust" : 21.59
      },
      "dt" : 1791104400,
      "dt_txt" : "2026-10-04 09:00:00",
      "main" : {
        "humidity" : 43,
        "feels_like" : 59.969999999999999,
        "temp_min" : 62.039999999999999,
        "temp_max" : 62.039999999999999,
        "temp" : 62.039999999999999,
        "pressure" : 1015,
        "temp_kf" : 0,
        "dew_point" : 39.560000000000002,
        "sea_level" : 1015,
        "grnd_level" : 1000
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04d",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 13,
        "deg" : 138,
        "gust" : 29.370000000000001
      },
      "dt" : 1791115200,
      "dt_txt" : "2026-10-04 12:00:00",
      "main" : {
        "humidity" : 49,
        "feels_like" : 57.25,
        "temp_min" : 59.32,
        "temp_max" : 59.32,
        "temp" : 59.32,
        "pressure" : 1013,
        "temp_kf" : 0,
        "dew_point" : 39.969999999999999,
        "sea_level" : 1013,
        "grnd_level" : 998
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 12.68,
        "deg" : 144,
        "gust" : 27.579999999999998
      },
      "dt" : 1791126000,
      "dt_txt" : "2026-10-04 15:00:00",
      "main" : {
        "humidity" : 46,
        "feels_like" : 57.609999999999999,
        "temp_min" : 59.770000000000003,
        "temp_max" : 59.770000000000003,
        "temp" : 59.770000000000003,
        "pressure" : 1011,
        "temp_kf" : 0,
        "dew_point" : 39,
        "sea_level" : 1011,
        "grnd_level" : 995
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 13.779999999999999,
        "deg" : 160,
        "gust" : 31.850000000000001
      },
      "dt" : 1791136800,
      "dt_txt" : "2026-10-04 18:00:00",
      "main" : {
        "humidity" : 43,
        "feels_like" : 57.18,
        "temp_min" : 59.5,
        "temp_max" : 59.5,
        "temp" : 59.5,
        "pressure" : 1008,
        "temp_kf" : 0,
        "dew_point" : 37.359999999999999,
        "sea_level" : 1008,
        "grnd_level" : 993
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 11.59,
        "deg" : 156,
        "gust" : 28.609999999999999
      },
      "dt" : 1791147600,
      "rain" : {
        "3h" : 1.1799999999999999
      },
      "dt_txt" : "2026-10-04 21:00:00",
      "main" : {
        "humidity" : 79,
        "feels_like" : 53.530000000000001,
        "temp_min" : 54.640000000000001,
        "temp_max" : 54.640000000000001,
        "temp" : 54.640000000000001,
        "pressure" : 1006,
        "temp_kf" : 0,
        "dew_point" : 48.109999999999999,
        "sea_level" : 1006,
        "grnd_level" : 990
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.85999999999999999,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 13.09,
        "deg" : 168,
        "gust" : 28.66
      },
      "dt" : 1791158400,
      "rain" : {
        "3h" : 0.31
      },
      "dt_txt" : "2026-10-05 00:00:00",
      "main" : {
        "humidity" : 75,
        "feels_like" : 53.869999999999997,
        "temp_min" : 55.130000000000003,
        "temp_max" : 55.130000000000003,
        "temp" : 55.130000000000003,
        "pressure" : 1004,
        "temp_kf" : 0,
        "dew_point" : 47.460000000000001,
        "sea_level" : 1004,
        "grnd_level" : 988
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.81999999999999995,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 15.93,
        "deg" : 269,
        "gust" : 28.16
      },
      "dt" : 1791169200,
      "rain" : {
        "3h" : 0.53000000000000003
      },
      "dt_txt" : "2026-10-05 03:00:00",
      "main" : {
        "humidity" : 84,
        "feels_like" : 42.549999999999997,
        "temp_min" : 48.539999999999999,
        "temp_max" : 48.539999999999999,
        "temp" : 48.539999999999999,
        "pressure" : 1007,
        "temp_kf" : 0,
        "dew_point" : 43.950000000000003,
        "sea_level" : 1007,
        "grnd_level" : 991
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.72999999999999998,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 18.25,
        "deg" : 253,
        "gust" : 30.670000000000002
      },
      "dt" : 1791180000,
      "rain" : {
        "3h" : 0.32000000000000001
      },
      "dt_txt" : "2026-10-05 06:00:00",
      "main" : {
        "humidity" : 62,
        "feels_like" : 42.890000000000001,
        "temp_min" : 49.189999999999998,
        "temp_max" : 49.189999999999998,
        "temp" : 49.189999999999998,
        "pressure" : 1011,
        "temp_kf" : 0,
        "dew_point" : 36.789999999999999,
        "sea_level" : 1011,
        "grnd_level" : 996
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.68999999999999995,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 99
      },
      "wind" : {
        "speed" : 19.219999999999999,
        "deg" : 228,
        "gust" : 28.829999999999998
      },
      "dt" : 1791190800,
      "rain" : {
        "3h" : 0.26000000000000001
      },
      "dt_txt" : "2026-10-05 09:00:00",
      "main" : {
        "humidity" : 57,
        "feels_like" : 47.640000000000001,
        "temp_min" : 50.229999999999997,
        "temp_max" : 50.229999999999997,
        "temp" : 50.229999999999997,
        "pressure" : 1014,
        "temp_kf" : 0,
        "dew_point" : 35.600000000000001,
        "sea_level" : 1014,
        "grnd_level" : 998
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.27000000000000002,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 65
      },
      "wind" : {
        "speed" : 9.6400000000000006,
        "deg" : 231,
        "gust" : 20.829999999999998
      },
      "dt" : 1791201600,
      "rain" : {
        "3h" : 0.20000000000000001
      },
      "dt_txt" : "2026-10-05 12:00:00",
      "main" : {
        "humidity" : 42,
        "feels_like" : 42.149999999999999,
        "temp_min" : 46.759999999999998,
        "temp_max" : 46.759999999999998,
        "temp" : 46.759999999999998,
        "pressure" : 1016,
        "temp_kf" : 0,
        "dew_point" : 24.620000000000001,
        "sea_level" : 1016,
        "grnd_level" : 1000
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.20000000000000001,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 21
      },
      "wind" : {
        "speed" : 10.51,
        "deg" : 176,
        "gust" : 23.02
      },
      "dt" : 1791212400,
      "dt_txt" : "2026-10-05 15:00:00",
      "main" : {
        "humidity" : 53,
        "feels_like" : 39.869999999999997,
        "temp_min" : 45.18,
        "temp_max" : 45.18,
        "temp" : 45.18,
        "pressure" : 1015,
        "temp_kf" : 0,
        "dew_point" : 28.850000000000001,
        "sea_level" : 1015,
        "grnd_level" : 999
      },
      "weather" : [
        {
          "id" : 801,
          "main" : "Clouds",
          "icon" : "02n",
          "description" : "небольшая облачность"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 58
      },
      "wind" : {
        "speed" : 17.219999999999999,
        "deg" : 194,
        "gust" : 30.620000000000001
      },
      "dt" : 1791223200,
      "dt_txt" : "2026-10-05 18:00:00",
      "main" : {
        "humidity" : 52,
        "feels_like" : 40.950000000000003,
        "temp_min" : 47.530000000000001,
        "temp_max" : 47.530000000000001,
        "temp" : 47.530000000000001,
        "pressure" : 1014,
        "temp_kf" : 0,
        "dew_point" : 30.719999999999999,
        "sea_level" : 1014,
        "grnd_level" : 998
      },
      "weather" : [
        {
          "id" : 803,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "облачно с прояснениями"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 11.029999999999999,
        "deg" : 203,
        "gust" : 23.09
      },
      "dt" : 1791234000,
      "rain" : {
        "3h" : 0.11
      },
      "dt_txt" : "2026-10-05 21:00:00",
      "main" : {
        "humidity" : 66,
        "feels_like" : 39.670000000000002,
        "temp_min" : 45.159999999999997,
        "temp_max" : 45.159999999999997,
        "temp" : 45.159999999999997,
        "pressure" : 1013,
        "temp_kf" : 0,
        "dew_point" : 34.340000000000003,
        "sea_level" : 1013,
        "grnd_level" : 997
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.23999999999999999,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 15.5,
        "deg" : 200,
        "gust" : 26.690000000000001
      },
      "dt" : 1791244800,
      "rain" : {
        "3h" : 0.29999999999999999
      },
      "dt_txt" : "2026-10-06 00:00:00",
      "main" : {
        "humidity" : 66,
        "feels_like" : 37.439999999999998,
        "temp_min" : 44.469999999999999,
        "temp_max" : 44.469999999999999,
        "temp" : 44.469999999999999,
        "pressure" : 1013,
        "temp_kf" : 0,
        "dew_point" : 33.850000000000001,
        "sea_level" : 1013,
        "grnd_level" : 997
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.27000000000000002,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 19.059999999999999,
        "deg" : 194,
        "gust" : 30.530000000000001
      },
      "dt" : 1791255600,
      "rain" : {
        "3h" : 0.22
      },
      "dt_txt" : "2026-10-06 03:00:00",
      "main" : {
        "humidity" : 64,
        "feels_like" : 38.710000000000001,
        "temp_min" : 46.130000000000003,
        "temp_max" : 46.130000000000003,
        "temp" : 46.130000000000003,
        "pressure" : 1012,
        "temp_kf" : 0,
        "dew_point" : 34.57,
        "sea_level" : 1012,
        "grnd_level" : 996
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.20000000000000001,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 22.48,
        "deg" : 207,
        "gust" : 35.700000000000003
      },
      "dt" : 1791266400,
      "rain" : {
        "3h" : 0.56000000000000005
      },
      "dt_txt" : "2026-10-06 06:00:00",
      "main" : {
        "humidity" : 61,
        "feels_like" : 38.909999999999997,
        "temp_min" : 46.799999999999997,
        "temp_max" : 46.799999999999997,
        "temp" : 46.799999999999997,
        "pressure" : 1011,
        "temp_kf" : 0,
        "dew_point" : 34.270000000000003,
        "sea_level" : 1011,
        "grnd_level" : 995
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.46999999999999997,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 21.23,
        "deg" : 206,
        "gust" : 37.649999999999999
      },
      "dt" : 1791277200,
      "rain" : {
        "3h" : 0.42999999999999999
      },
      "dt_txt" : "2026-10-06 09:00:00",
      "main" : {
        "humidity" : 66,
        "feels_like" : 37.890000000000001,
        "temp_min" : 45.840000000000003,
        "temp_max" : 45.840000000000003,
        "temp" : 45.840000000000003,
        "pressure" : 1010,
        "temp_kf" : 0,
        "dew_point" : 35.200000000000003,
        "sea_level" : 1010,
        "grnd_level" : 994
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.68999999999999995,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 16.690000000000001,
        "deg" : 224,
        "gust" : 27.850000000000001
      },
      "dt" : 1791288000,
      "rain" : {
        "3h" : 1.3100000000000001
      },
      "dt_txt" : "2026-10-06 12:00:00",
      "main" : {
        "humidity" : 87,
        "feels_like" : 32.609999999999999,
        "temp_min" : 40.979999999999997,
        "temp_max" : 40.979999999999997,
        "temp" : 40.979999999999997,
        "pressure" : 1011,
        "temp_kf" : 0,
        "dew_point" : 37.310000000000002,
        "sea_level" : 1011,
        "grnd_level" : 995
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.87,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 12.73,
        "deg" : 207,
        "gust" : 20.780000000000001
      },
      "dt" : 1791298800,
      "rain" : {
        "3h" : 0.60999999999999999
      },
      "dt_txt" : "2026-10-06 15:00:00",
      "main" : {
        "humidity" : 82,
        "feels_like" : 33.729999999999997,
        "temp_min" : 40.909999999999997,
        "temp_max" : 40.909999999999997,
        "temp" : 40.909999999999997,
        "pressure" : 1010,
        "temp_kf" : 0,
        "dew_point" : 35.729999999999997,
        "sea_level" : 1010,
        "grnd_level" : 994
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.76000000000000001,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 9.4000000000000004,
        "deg" : 230,
        "gust" : 15.050000000000001
      },
      "dt" : 1791309600,
      "rain" : {
        "3h" : 1.1899999999999999
      },
      "dt_txt" : "2026-10-06 18:00:00",
      "main" : {
        "humidity" : 87,
        "feels_like" : 32.32,
        "temp_min" : 38.710000000000001,
        "temp_max" : 38.710000000000001,
        "temp" : 38.710000000000001,
        "pressure" : 1010,
        "temp_kf" : 0,
        "dew_point" : 34.899999999999999,
        "sea_level" : 1010,
        "grnd_level" : 994
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.93999999999999995,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 9.3499999999999996,
        "deg" : 232,
        "gust" : 18.699999999999999
      },
      "dt" : 1791320400,
      "snow" : {
        "3h" : 0.45000000000000001
      },
      "dt_txt" : "2026-10-06 21:00:00",
      "main" : {
        "humidity" : 96,
        "feels_like" : 29.48,
        "temp_min" : 36.390000000000001,
        "temp_max" : 36.390000000000001,
        "temp" : 36.390000000000001,
        "pressure" : 1010,
        "temp_kf" : 0,
        "dew_point" : 35.350000000000001,
        "sea_level" : 1010,
        "grnd_level" : 994
      },
      "weather" : [
        {
          "id" : 600,
          "main" : "Snow",
          "icon" : "13n",
          "description" : "небольшой снег"
        }
      ],
      "pop" : 0.85999999999999999,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 95
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 14.609999999999999,
        "deg" : 244,
        "gust" : 22.100000000000001
      },
      "dt" : 1791331200,
      "snow" : {
        "3h" : 0.19
      },
      "dt_txt" : "2026-10-07 00:00:00",
      "main" : {
        "humidity" : 76,
        "feels_like" : 28.620000000000001,
        "temp_min" : 37.380000000000003,
        "temp_max" : 37.380000000000003,
        "temp" : 37.380000000000003,
        "pressure" : 1011,
        "temp_kf" : 0,
        "dew_point" : 30.379999999999999,
        "sea_level" : 1011,
        "grnd_level" : 995
      },
      "weather" : [
        {
          "id" : 600,
          "main" : "Snow",
          "icon" : "13n",
          "description" : "небольшой снег"
        }
      ],
      "pop" : 0.75,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 12.210000000000001,
        "deg" : 237,
        "gust" : 23.510000000000002
      },
      "dt" : 1791342000,
      "snow" : {
        "3h" : 0.17000000000000001
      },
      "dt_txt" : "2026-10-07 03:00:00",
      "main" : {
        "humidity" : 95,
        "feels_like" : 28.039999999999999,
        "temp_min" : 36.25,
        "temp_max" : 36.25,
        "temp" : 36.25,
        "pressure" : 1013,
        "temp_kf" : 0,
        "dew_point" : 34.990000000000002,
        "sea_level" : 1013,
        "grnd_level" : 997
      },
      "weather" : [
        {
          "id" : 600,
          "main" : "Snow",
          "icon" : "13d",
          "description" : "небольшой снег"
        }
      ],
      "pop" : 0.40000000000000002,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 101
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 15.970000000000001,
        "deg" : 244,
        "gust" : 24.23
      },
      "dt" : 1791352800,
      "rain" : {
        "3h" : 0.28999999999999998
      },
      "dt_txt" : "2026-10-07 06:00:00",
      "main" : {
        "humidity" : 75,
        "feels_like" : 30.850000000000001,
        "temp_min" : 39.450000000000003,
        "temp_max" : 39.450000000000003,
        "temp" : 39.450000000000003,
        "pressure" : 1015,
        "temp_kf" : 0,
        "dew_point" : 32.340000000000003,
        "sea_level" : 1015,
        "grnd_level" : 999
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.54000000000000004,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 17.219999999999999,
        "deg" : 240,
        "gust" : 29.420000000000002
      },
      "dt" : 1791363600,
      "rain" : {
        "3h" : 0.87
      },
      "dt_txt" : "2026-10-07 09:00:00",
      "main" : {
        "humidity" : 93,
        "feels_like" : 28.129999999999999,
        "temp_min" : 37.630000000000003,
        "temp_max" : 37.630000000000003,
        "temp" : 37.630000000000003,
        "pressure" : 1017,
        "temp_kf" : 0,
        "dew_point" : 35.740000000000002,
        "sea_level" : 1017,
        "grnd_level" : 1000
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10d",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.83999999999999997,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 1460
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 15.369999999999999,
        "deg" : 247,
        "gust" : 25.59
      },
      "dt" : 1791374400,
      "rain" : {
        "3h" : 0.39000000000000001
      },
      "dt_txt" : "2026-10-07 12:00:00",
      "main" : {
        "humidity" : 82,
        "feels_like" : 30.809999999999999,
        "temp_min" : 39.289999999999999,
        "temp_max" : 39.289999999999999,
        "temp" : 39.289999999999999,
        "pressure" : 1019,
        "temp_kf" : 0,
        "dew_point" : 34.289999999999999,
        "sea_level" : 1019,
        "grnd_level" : 1003
      },
      "weather" : [
        {
          "id" : 500,
          "main" : "Rain",
          "icon" : "10n",
          "description" : "небольшой дождь"
        }
      ],
      "pop" : 0.81999999999999995,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 99
      },
      "wind" : {
        "speed" : 13.31,
        "deg" : 247,
        "gust" : 27.309999999999999
      },
      "dt" : 1791385200,
      "dt_txt" : "2026-10-07 15:00:00",
      "main" : {
        "humidity" : 78,
        "feels_like" : 30.09,
        "temp_min" : 38.189999999999998,
        "temp_max" : 38.189999999999998,
        "temp" : 38.189999999999998,
        "pressure" : 1020,
        "temp_kf" : 0,
        "dew_point" : 31.949999999999999,
        "sea_level" : 1020,
        "grnd_level" : 1004
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0.16,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 94
      },
      "wind" : {
        "speed" : 9.9800000000000004,
        "deg" : 231,
        "gust" : 24.399999999999999
      },
      "dt" : 1791396000,
      "dt_txt" : "2026-10-07 18:00:00",
      "main" : {
        "humidity" : 78,
        "feels_like" : 29.699999999999999,
        "temp_min" : 36.810000000000002,
        "temp_max" : 36.810000000000002,
        "temp" : 36.810000000000002,
        "pressure" : 1021,
        "temp_kf" : 0,
        "dew_point" : 30.719999999999999,
        "sea_level" : 1021,
        "grnd_level" : 1004
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0.040000000000000001,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 7.4299999999999997,
        "deg" : 216,
        "gust" : 19.690000000000001
      },
      "dt" : 1791406800,
      "dt_txt" : "2026-10-07 21:00:00",
      "main" : {
        "humidity" : 70,
        "feels_like" : 32.850000000000001,
        "temp_min" : 38.299999999999997,
        "temp_max" : 38.299999999999997,
        "temp" : 38.299999999999997,
        "pressure" : 1020,
        "temp_kf" : 0,
        "dew_point" : 29.300000000000001,
        "sea_level" : 1020,
        "grnd_level" : 1004
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 99
      },
      "wind" : {
        "speed" : 10.33,
        "deg" : 198,
        "gust" : 22.699999999999999
      },
      "dt" : 1791417600,
      "dt_txt" : "2026-10-08 00:00:00",
      "main" : {
        "humidity" : 78,
        "feels_like" : 28.539999999999999,
        "temp_min" : 36.009999999999998,
        "temp_max" : 36.009999999999998,
        "temp" : 36.009999999999998,
        "pressure" : 1020,
        "temp_kf" : 0,
        "dew_point" : 29.710000000000001,
        "sea_level" : 1020,
        "grnd_level" : 1003
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04n",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "n"
      },
      "visibility" : 10000
    },
    {
      "clouds" : {
        "all" : 100
      },
      "wind" : {
        "speed" : 12.84,
        "deg" : 188,
        "gust" : 23.469999999999999
      },
      "dt" : 1791428400,
      "dt_txt" : "2026-10-08 03:00:00",
      "main" : {
        "humidity" : 74,
        "feels_like" : 31.620000000000001,
        "temp_min" : 39.270000000000003,
        "temp_max" : 39.270000000000003,
        "temp" : 39.270000000000003,
        "pressure" : 1018,
        "temp_kf" : 0,
        "dew_point" : 31.530000000000001,
        "sea_level" : 1018,
        "grnd_level" : 1001
      },
      "weather" : [
        {
          "id" : 804,
          "main" : "Clouds",
          "icon" : "04d",
          "description" : "пасмурно"
        }
      ],
      "pop" : 0,
      "sys" : {
        "pod" : "d"
      },
      "visibility" : 10000
    }
  ],
  "city" : {
    "sunset" : 1791028872,
    "country" : "RU",
    "id" : 1496747,
    "coord" : {
      "lat" : 55.020000000000003,
      "lon" : 82.920000000000002
    },
    "population" : 1419007,
    "timezone" : 25200,
    "sunrise" : 1790987614,
    "name" : "Новосибирск"
  }
}
"""

The App's Name: Snowman
==

Contents
==

* [Idea History](#Idea-History)
    * [Outs of Expectations](#Out-of-Expectations)
* [Meteo Terms mapping](#Meteo-Terms-mapping)
* [Integrations](#Integrations)
    * [OpenWeather API](#OpenWeather-API)
    * [Open-Meteo API](#Open-Meteo-API)
* [GUI Sketches](#GUI-Sketches)
* [Business Tasks](#Business-Tasks)
    * [Current Location](#Current-Location)
    * [Current Weather](#Current-Weather)
    * [Forecast](#Forecast)
    * [Geocoding](#Geocoding)
* [Options](#Options)
* [Special Features](#Special-Features)
    * [Favorites](#Favorites)
* [Data Mappings](#Data-Mappings)
    * [OpenWeather Icons](#OpenWeather-Icons)
    * [Open-Meteo Icons](#Open-Meteo-Icons)

Idea History
==

- Date in format YYYY-MMM-DD, in this file meets Gregorian calendar only.

| Ver     | Release     | Type         | Top feature                                                 | Link |
| ------- | ----------- | :----------: | ----------------------------------------------------------- | ---- |
| v0.6+   | 2026-NNN-NN | Developer RC | Open-Meteo API: Current & Weather Forecast. Geocoding.      | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.6.0) |
| v0.5.2+ | 2026-Apr-07 | Developer RC | Retry logic for current, forecast and suggestions calls.    | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.5.2) |
| v0.5+   | 2025-Dec-29 | Developer RC | Multiline Status Menus.                                     | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.5.0) |
| v0.4+   | 2025-Nov-13 | Developer RC | OpenWeather API: Direct geocoding. Location search by name. | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.4)   |
| v0.3+   | 2025-Jun-27 | Developer RC | OpenWeather API: Forecast for Current Location.             | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.3)   |
| v0.2+   | 2024-Feb-01 | Developer RC | OpenWeather API: Current Weather for Current Location.      | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.2)   |
| v0.1+   | 2023-Apr-05 | Template RC  | Initial point of development process.                       | [View](https://github.com/PerseusRealDeal/TheDarkMoon/releases/tag/0.1)   |

Outs of Expectations
--

> Details that took out of expectations:

| Ver     | Action   | Detail                 | Link |
| ------- | -------- | ---------------------- | ---- |
| v0.2+   | Rejected | 00-3: Starts on login. | [Issue #7](https://github.com/PerseusRealDeal/TheDarkMoon/issues/7) |

Meteo Terms mapping
==

| Term in App   | OpenWeather     | Open-Meteo                |
| ------------- | --------------- | ------------------------- |
| Temperature   | Temperature     | Temperature (2 m)         |
| Kinda         | Feels Like      | Apparent Temperature      |
| L             | Temperature Min | Minimum Temperature (2 m) |
| H             | Temperature Max | Maximum Temperature (2 m) |
| Wind          | Wind Speed      | Wind Speed (10 m)         |
| Direction     | Wind Direction  | Wind Direction (10m)      |
| Gusts         | Wind Gusts      | Wind Gusts (10m)          |
| Pressure      | Pressure        | Sea Level Pressure        |
| Humidity      | Humidity        | Relative Humidity (2 m)   |
| Cloudiness    | Cloudiness      | Cloud Cover Total         |
| Sunrise       | Sunrise         | Sunrise                   |
| Sunset        | Sunset          | Sunset                    |
| Rain          | Rain            | Rain, Showers             |
| Snow          | Snow            | Snow, Snowfall            |
| Precipitation | Rain, Snow      | Rain + Showers + Snow     |
| Probability   | None            | Precipitation Probability |

Integrations
==

OpenWeather API
--

| Task            | API product |
| --------------- | ----------- |
| Current weather | https://openweathermap.org/current           |
| Forecast        | https://openweathermap.org/forecast5         |
| Geocoding       | https://openweathermap.org/api/geocoding-api |

> `Current Weather OpenWeather API Request:`

```
https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

```

> `Weather Forecast OpenWeather API Request:`

```
https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}

```

> `Direct Geocoding OpenWeather API Request:` coordinates by location name

```
http://api.openweathermap.org/geo/1.0/direct?q={Location name}&limit=5&appid={API key}

```

Open-Meteo API
--

| Task                       | API product |
| -------------------------- | ----------- |
| Current & Weather Forecast | https://open-meteo.com/en/docs               |
| Geocoding                  | https://open-meteo.com/en/docs/geocoding-api |

> `Current Weather Open-Meteo API Request:`

```
https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m

```

> `Weather Forecast Open-Meteo API Request:`

```
https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&hourly=temperature_2m&forecast_days=5

```

> `Direct Geocoding Open-Meteo API Request:` coordinates by location name

```
https://geocoding-api.open-meteo.com/v1/search?name={Location name}&count=10&language=en&format=json

```

GUI Sketches
==

| ID     | Description |
| ------ | ----------- |
| GUI-1  | The app should look like it presented in the picture below. </br> ![Image](https://github.com/perseusrealdeal/thedarkmoon/assets/50202963/b8c4b185-41cf-4c7c-be2f-8cb31c6958fb) |
| GUI-2  | The app should run as a Status Menus app (the Menu Bar one).   |
| GUI-3  | For preferences (options) a typical window should be employed. |
| REST-1 | No Icon in Dock.                                               |
| REST-2 | No Main menu.                                                  |

Business Tasks
==

Current Location
--

- Apple location API should be employed for geo coordinates determining.
- Geo coordinates determining should be manual, by end-user click.
- The app should rely on [PerseusGeoKit](https://github.com/PerseusRealDeal/PerseusGeoKit) capabilities for Current Location for instance `Location Access status`, etc.

Current Weather
--

- The app should show the last current weather API respose time.
- Current Weather API respose should be saved in app for reducing requests needed if an option changes.

| Show in App            | OpenWeather API Respose        | Open-Meteo API Response          |
| ---------------------- | ------------------------------ | -------------------------------- |
| Weather Icon           | Weather icon id                | None                             |
| Weather Description    | Weather condition codes        | WMO code                         |
| Sunrise                | UTC                            | GMT                              |
| Sunset                 | UTC                            | GMT                              |
| Temperature            | Imperial: Fahrenheit           | Imperial: Fahrenheit             |
| Temperature Low        | Imperial: Fahrenheit           | Imperial: Fahrenheit             |
| Temperature High       | Imperial: Fahrenheit           | Imperial: Fahrenheit             |
| Temperature Feels Like | Imperial: Fahrenheit           | Imperial: Fahrenheit             |
| Visibility             | meter                          | meter                            |
| Wind Speed             | meter/sec                      | meter/sec                        |
| Wind Direction         | degrees° (meteorological)      | degrees° (meteorological)        |
| Wind Gust              | meter/sec                      | meter/sec                        |
| Pressure               | sea level, hPa                 | sea level, hPa                   |
| Humidity               | %                              | %                                |
| Cloudiness             | %                              | %                                |
| Rain                   | Rain Precipitation, mm/h       | Rain, Showers, mm/h              |
| Snow                   | Snow Precipitation, mm/h       | Snow, Snowfall, cm/h             |
| Precipitation          | Calculated (Rain + Snow), mm/h | Precipitation, mm/h              |
| Probability            | Calculated (Precipitation), %  | Precipitation Probability Max, % |

> [!NOTE]
> `OpenWeather Current Weather request prepared:`
> https://api.openweathermap.org/data/2.5/weather?lat=##.##&lon=##.##&units=imperial&lang=##&appid=###

> [!NOTE]
> `Open-Meteo Current Weather request prepared:`
> https://api.open-meteo.com/v1/forecast?latitude=##.##&longitude=##.##&daily=sunrise,sunset,precipitation_probability_max&current={PARAMS}&temperature_unit=fahrenheit&wind_speed_unit=ms&forecast_days=1

`Open-Meteo Current PARAMS:` weather_code, wind_speed_10m, wind_direction_10m, wind_gusts_10m, temperature_2m, apparent_temperature, visibility, pressure_msl, relative_humidity_2m, cloud_cover, showers, rain, snowfall, precipitation, precipitation_probability, is_day

Forecast
--

- The app should show the last weather forecast API respose time.
- Weather Forecast API respose should be saved in app for reducing requests needed if an option changes.

> [!NOTE]
> OpenWeather API Respose: 5 day / 3 hour forecast data [concept](https://openweathermap.org/api/forecast5?collection=current_forecast#concept)

| Show in App            | OpenWeather API Respose          | Open-Meteo API Response                     |
| ---------------------- | -------------------------------- | ------------------------------------------- |
| Weather Icon           | Weather icon id                  | None                                        |
| Weather Description    | Weather condition codes          | WMO code                                    |
| Sunrise                | UTC                              | GMT                                         |
| Sunset                 | UTC                              | GMT                                         |
| Temperature            | Imperial: Fahrenheit             | Imperial: Fahrenheit                        |
| Temperature Low        | Imperial: Fahrenheit             | Imperial: Fahrenheit                        |
| Temperature High       | Imperial: Fahrenheit             | Imperial: Fahrenheit                        |
| Temperature Feels Like | Imperial: Fahrenheit             | Imperial: Fahrenheit                        |
| Visibility             | meter                            | meter                                       |
| Wind Speed             | meter/sec                        | meter/sec                                   |
| Wind Direction         | degrees° (meteorological)        | degrees° (meteorological)                   |
| Wind Gust              | meter/sec                        | meter/sec                                   |
| Pressure               | sea level, hPa                   | sea level, hPa                              |
| Humidity               | %                                | %                                           |
| Cloudiness             | %                                | %                                           |
| Rain                   | Hourly: Rain Precipitation, mm/h | Hourly: Rain, Showers, mm/h                 |
| Snow                   | Hourly: Snow Precipitation, mm/h | Hourly: Snow, Snowfall, cm/h                |
| Precipitation          | Calculated (Rain + Snow), mm/h   | Hourly: Precipitation, mm/h                 |
| Probability            | Calculated (Precipitation), %    | Daily and Hourly: Precipitation Probability |

> [!NOTE]
> `OpenWeather Weather Forecast request prepared:`
> https://api.openweathermap.org/data/2.5/forecast?lat=##.##&lon=##.##&cnt=40&units=imperial&lang=##&appid=###

> [!NOTE]
> `Open-Meteo Weather Forecast request prepared:`
> https://api.open-meteo.com/v1/forecast?latitude=##.##&longitude=##.##&daily=sunrise,sunse,precipitation_probability_maxt&hourly={PARAMS}&temperature_unit=fahrenheit&wind_speed_unit=ms&forecast_days=16

`Open-Meteo Forecast PARAMS:` weather_code, wind_speed_10m, wind_direction_10m, wind_gusts_10m, temperature_2m, apparent_temperature, visibility, pressure_msl, relative_humidity_2m, cloud_cover, showers, rain, snowfall, precipitation, precipitation_probability, is_day

Geocoding
--

- Geocoding API should be applied for searching locations by name.
- Geocoding request should be sent by end-user click.
- Geocoding request should be sent automatically as an option.
- Geocoding API respose (suggestion) should be saved in app for reducing requests needed if an option changes.

Options
==

- OpenWeather API Key should be saved as a secret with Apple KeyChain technology.

| Option                            | Units                                     | Default                     |
| --------------------------------- | ----------------------------------------- | --------------------------- |
| `Dark Mode`                       | Light, Dark, System                       | System                      |
| `Language`                        | English, Russian, System                  | System, En if not in Units  |
| `Time`                            | 24-hour, 12-hour, System                  | System                      |
| Temperature                       | Kelvin, Celsius, Fahrenheit               | Fahrenheit                  |
| Wind Speed                        | meter/sec, km/hour, miles per hour        | miles per hour              |
| Pressure                          | hPa, mmHg, mb                             | mb                          |
| Visibility                        | Kilometre, Mile                           | Mile                        |
| Precipitation                     | mm/h, cm/h                                | mm/h                        |
| `Current Weather in Status Menus` | true, false                               | false                       |
| Current Weather `Update period`   | per 12 hours, per 3 hours, per hour, none | none                        |
| Status Menus `multiline mode`     | true, false                               | false                       |
| Status Menus second line          | Weather quick list                        | Wind                        |
| Status Menus Tool tip             | Weather quick list, Weather quick list    | Direction, Gust             |
| OpenWeather `API Key`             | Text                                      | Empty, key value if exsists |

> [!NOTE]
> `Weather quick list:` Feels like, Direction, Gust, Wind, Visibility, Pressure, Humidity, Cloudiness.

> [!IMPORTANT]
> `Precipitation:` For the water equivalent in millimeter, divide by 7. E.g. 7 cm snow = 10 mm precipitation water equivalent

Special Features
==

Favorites
--

- The list of favorite places should have "Current Location" item as the first item that can't be removed.

Data Mappings
==

- The app should rely on Apple weather icons to represent weather condition.
- If Dark Mode in Light, Apple icons should have postfix .fill, "sun.max.fill" for instance.

OpenWeather Icons
--

> [!NOTE]
> OpenWeather API: [weather conditions](https://openweathermap.org/api/weather-conditions)

| OpenWeather Icon | Description      | Apple Icon Day  | Apple Icon Night |
| ---------------- | ---------------- | --------------- | ---------------- |
| 01d or 01n       | Clear sky        | sun.max         | moon             |
| 02d or 02n       | Few clouds       | cloud.sun       | cloud.moon       |
| 03d or 03n       | Scattered clouds | cloud           | cloud            |
| 04d or 04n       | Broken clouds    | cloud           | cloud            |
| 09d or 09n       | Shower rain      | cloud.heavyrain | cloud.heavyrain  |
| 10d or 10n       | Rain             | cloud.sun.rain  | cloud.moon.rain  |
| 11d or 11n       | Thunderstorm     | cloud.sun.bolt  | cloud.moon.bolt  |
| 13d or 13n       | Snow             | snow            | snow             |
| 50d or 50n       | Mist             | cloud.fog       | cloud.fog        |

Open-Meteo Icons
--

> [!NOTE]
> Open-Meteo API: [WMO Weather interpretation codes](https://open-meteo.com/en/docs) at the end of page.

| Open-Meteo Code | WMO Description                   | Apple Icon Day  | Apple Icon Night |
| --------------- | --------------------------------- | --------------- | ---------------- |
| 99              | Thunderstorm: heavy hail          | cloud.bolt.rain | cloud.bolt.rain  |
| 96              | Thunderstorm: slight hail         | cloud.bolt.rain | cloud.bolt.rain  |
| 95              | Thunderstorm: slight or moderate  | cloud.sun.bolt  | cloud.moon.bolt  |
| 86              | Snow showers: heavy               | cloud.sleet     | cloud.sleet      |
| 85              | Snow showers: slight              | cloud.sleet     | cloud.sleet      |
| 82              | Rain showers: violent             | cloud.heavyrain | cloud.heavyrain  |
| 81              | Rain showers: moderate            | cloud.heavyrain | cloud.heavyrain  |
| 80              | Rain showers: slight              | cloud.heavyrain | cloud.heavyrain  |
| 77              | Snow grains                       | cloud.snow      | cloud.snow       |
| 75              | Snow fall: heavy intensity        | cloud.snow      | cloud.snow       |
| 73              | Snow fall: moderate               | cloud.snow      | cloud.snow       |
| 71              | Snow fall: slight                 | cloud.snow      | cloud.snow       |
| 67              | Freezing Rain: heavy intensity    | cloud.sleet     | cloud.sleet      |
| 66              | Freezing Rain: light              | cloud.sleet     | cloud.sleet      |
| 65              | Rain: heavy intensity             | cloud.heavyrain | cloud.heavyrain  |
| 63              | Rain: moderate                    | cloud.heavyrain | cloud.heavyrain  |
| 61              | Rain: slight                      | cloud.rain      | cloud.moon.rain  |
| 57              | Freezing Drizzle: dense intensity | cloud.sleet     | cloud.sleet      |
| 56              | Freezing Drizzle: light           | cloud.sleet     | cloud.sleet      |
| 55              | Drizzle: dense intensity          | cloud.drizzle   | cloud.drizzle    |
| 53              | Drizzle: moderate                 | cloud.drizzle   | cloud.drizzle    |
| 51              | Drizzle: light                    | cloud.drizzle   | cloud.drizzle    |
| 48              | Depositing rime fog               | cloud.fog       | cloud.fog        |
| 45              | Fog                               | cloud.fog       | cloud.fog        |
| 3               | Overcast                          | cloud           | cloud            |
| 2               | Partly cloudy                     | cloud.sun       | cloud.moon       |
| 1               | Mainly clear                      | cloud.sun       | cloud.moon       |
| 0               | Clear sky                         | sun.max         | moon             |

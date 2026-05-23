The App's Name: Snowman
==

Contents
==

* [Idea History](#Idea-History)
    * [Outs of Expectations](#Out-of-Expectations)
* [Integrations](#Integrations)
    * [Open-Meteo API](#Open-Meteo-API)
    * [OpenWeather API](#OpenWeather-API)
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

Integrations
==

Open-Meteo API
--

| Task                       | API product |
| -------------------------- | ----------- |
| Current & Weather Forecast | https://open-meteo.com/en/docs               |
| Geocoding                  | https://open-meteo.com/en/docs/geocoding-api |

OpenWeather API
--

| Task            | API product |
| --------------- | ----------- |
| Current weather | https://openweathermap.org/current           |
| Forecast        | https://openweathermap.org/forecast5         |
| Geocoding       | https://openweathermap.org/api/geocoding-api |

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

| Parameter              | Saved in App               | OpenWeather API Respose  | Open-Meteo API Response |
| ---------------------- | -------------------------- | ------------------------ | ----------------------- |
| Weather Icon           | Weather icon id            | Weather icon id          ||
| Weather Description    | Weather condition codes    | Weather condition codes  ||
| Sunrise                | UTC                        | UTC                      ||
| Sunset                 | UTC                        | UTC                      ||
| Temperature            | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Temperature Low        | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Temperature High       | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Temperature Feels Like | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Visibility             | meter                      | meter                    ||
| Wind Speed             | meter/sec                  | meter/sec                ||
| Wind Direction         | degrees (meteorological)   | degrees (meteorological) ||
| Wind Gust              | meter/sec                  | meter/sec                ||
| Pressure               | sea level, hPa             | sea level, hPa           ||
| Humidity               | %                          | %                        || 
| Cloudiness             | %                          | %                        ||

> OpenWeather API: current weather request with minimum parameters sample

```

https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

```

> Open-Meteo API: forecast request with minimum parameters sample

```

```


Forecast
--

- The app should show the last weather forecast API respose time.

> [!NOTE]
> OpenWeather API Respose: 5 day / 3 hour forecast data [concept](https://openweathermap.org/api/forecast5?collection=current_forecast#concept)

| Parameter              | Saved in App               | OpenWeather API Respose  | Open-Meteo API Response |
| ---------------------- | -------------------------- | ------------------------ | ----------------------- |
| Weather Icon           | Weather icon id            | Weather icon id          ||
| Weather Description    | Weather condition codes    | Weather condition codes  ||
| Sunrise                | UTC                        | UTC                      ||
| Sunset                 | UTC                        | UTC                      ||
| Temperature            | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Temperature Low        | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Temperature High       | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Temperature Feels Like | Imperial: Fahrenheit       | Imperial: Fahrenheit     ||
| Visibility             | meter                      | meter                    ||
| Wind Speed             | meter/sec                  | meter/sec                ||
| Wind Direction         | degrees (meteorological)   | degrees (meteorological) ||
| Wind Gust              | meter/sec                  | meter/sec                ||
| Pressure               | sea level, hPa             | sea level, hPa           ||
| Humidity               | %                          | %                        || 
| Cloudiness             | %                          | %                        ||

> OpenWeather API: forecast request with minimum parameters sample

```

https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}

```

> Open-Meteo API: forecast request with minimum parameters sample

```

```

Geocoding
--

- Geocoding API should be applied for searching locations by name.
- Geocoding request should be sent by end-user click.
- Geocoding request should be sent automatically as an option.

Options
==

| Option                            | Units                                     | Default                     |
| --------------------------------- | ----------------------------------------- | --------------------------- |
| `Dark Mode`                       | Light, Dark, System                       | System                      |
| `Language`                        | English, Russian, System                  | System, En if not in Units  |
| `Time`                            | 24-hour, 12-hour, System                  | System                      |
| Temperature                       | Kelvin, Celsius, Fahrenheit               | Fahrenheit                  |
| Wind Speed                        | meter/sec, km/hour, miles per hour        | miles per hour              |
| Pressure                          | hPa, mmHg, mb                             | mb                          |
| Visibility                        | Kilometre, Mile                           | Mile                        |
| `Current Weather in Status Menus` | true, false                               | false                       |
| Current Weather `Update period`   | per 12 hours, per 3 hours, per hour, none | none                        |
| Status Menus `multiline mode`     | true, false                               | false                       |
| Status Menus second line          | Weather quick list                        | Wind                        |
| Status Menus Tool tip             | Weather quick list, Weather quick list    | Direction, Gust             |
| OpenWeather `API Key`             | Text                                      | Empty, key value if exsists |

> [!NOTE]
> `Weather quick list:` Feels like, Direction, Gust, Wind, Visibility, Pressure, Humidity, Cloudiness.

- OpenWeather API Key should be saved as a secret with Apple KeyChain technology.

Special Features
==

Favorites
--

- The list of favorite places should have "Current Location" item as the first item that can't be removed.

Data Mappings
==

- OpenWeather API: [weather conditions](https://openweathermap.org/api/weather-conditions)

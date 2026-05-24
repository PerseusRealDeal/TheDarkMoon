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

| Show in App            | OpenWeather API Respose  | Open-Meteo API Response |
| ---------------------- | ------------------------ | ----------------------- |
| Weather Icon           | Weather icon id          ||
| Weather Description    | Weather condition codes  ||
| Sunrise                | UTC                      ||
| Sunset                 | UTC                      ||
| Temperature            | Imperial: Fahrenheit     ||
| Temperature Low        | Imperial: Fahrenheit     ||
| Temperature High       | Imperial: Fahrenheit     ||
| Temperature Feels Like | Imperial: Fahrenheit     ||
| Visibility             | meter                    ||
| Wind Speed             | meter/sec                ||
| Wind Direction         | degrees (meteorological) ||
| Wind Gust              | meter/sec                ||
| Pressure               | sea level, hPa           ||
| Humidity               | %                        || 
| Cloudiness             | %                        ||

Forecast
--

- The app should show the last weather forecast API respose time.
- Weather Forecast API respose should be saved in app for reducing requests needed if an option changes.

> [!NOTE]
> OpenWeather API Respose: 5 day / 3 hour forecast data [concept](https://openweathermap.org/api/forecast5?collection=current_forecast#concept)

| Show in App            | OpenWeather API Respose  | Open-Meteo API Response |
| ---------------------- | ------------------------ | ----------------------- |
| Weather Icon           | Weather icon id          ||
| Weather Description    | Weather condition codes  ||
| Sunrise                | UTC                      ||
| Sunset                 | UTC                      ||
| Temperature            | Imperial: Fahrenheit     ||
| Temperature Low        | Imperial: Fahrenheit     ||
| Temperature High       | Imperial: Fahrenheit     ||
| Temperature Feels Like | Imperial: Fahrenheit     ||
| Visibility             | meter                    ||
| Wind Speed             | meter/sec                ||
| Wind Direction         | degrees (meteorological) ||
| Wind Gust              | meter/sec                ||
| Pressure               | sea level, hPa           ||
| Humidity               | %                        || 
| Cloudiness             | %                        ||

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
| `Current Weather in Status Menus` | true, false                               | false                       |
| Current Weather `Update period`   | per 12 hours, per 3 hours, per hour, none | none                        |
| Status Menus `multiline mode`     | true, false                               | false                       |
| Status Menus second line          | Weather quick list                        | Wind                        |
| Status Menus Tool tip             | Weather quick list, Weather quick list    | Direction, Gust             |
| OpenWeather `API Key`             | Text                                      | Empty, key value if exsists |

> [!NOTE]
> `Weather quick list:` Feels like, Direction, Gust, Wind, Visibility, Pressure, Humidity, Cloudiness.

Special Features
==

Favorites
--

- The list of favorite places should have "Current Location" item as the first item that can't be removed.

Data Mappings
==

- OpenWeather API: [weather conditions](https://openweathermap.org/api/weather-conditions)
- Open-Meteo API: [WMO Weather interpretation codes](https://open-meteo.com/en/docs) at the end of page

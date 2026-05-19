The App's Name: Snowman
==

Contents
==

* [Idea History](#Idea-History)
    * [Outs of Expectations](#Out-of-Expectations)
* [Integrations](#Integrations)
    * [Open-Meteo API](#Open-Meteo-API)
    * [OpenWeather API](#OpenWeather-API)
* [Functional Requirements](#Functional-Requirements)
    * [GUI Sketches](#GUI-Sketches)
    * [User Stories](#User-Stories)
* [Business Tasks](#Business-Tasks)
    * [Current Location](#Current-Location)
    * [Current Weather](#Current-Weather)
    * [Forecast](#Forecast)
    * [Geocoding](#Geocoding)
* [Special Features](#Special-Features)
    * [Favorites](#Favorites)
* [Options](#Options)
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

Functional Requirements
==

GUI Sketches
--

| ID     | Description |
| ------ | ----------- |
| GUI-1  | The app should look like it presented in the picture below. </br> ![Image](https://github.com/perseusrealdeal/thedarkmoon/assets/50202963/b8c4b185-41cf-4c7c-be2f-8cb31c6958fb) |
| GUI-2  | The app should run as a Status Menus app (the Menu Bar one).   |
| GUI-3  | For preferences (options) a typical window should be employed. |
| REST-1 | No Icon in Dock.                                               |
| REST-2 | No Main menu.                                                  |

User Stories
--

| ID   | Description |
| ---- | ----------- |
| US-1 | As Mikhail, I want to be aware of the current weather condition (popover), so I can feel more in selfcare.            |
| US-2 | As Mikhail, I want to be able to call weather condition again (manually), so I can be sure about the current weather. |
| US-3 | As Mikhail, I want to be able to adjust the app preferences, so I can feel more comfortable in the app usage.         |
| US-4 | As Mikhail, I want to be able to quit the app, so I can feel more comfortable in the app usage.                       |
| US-5 | As Mikhail, I want to be aware of the forecast, so I can feel more in selfcare.                                       |
| US-6 | As Mikhail, I want to use the name of a location with requesting weather data (direct geocoding.)                     |
| US-7 | As Mikhail, I want to enjoy list of favorite places (CRUD operations.)                                                |
| US-8 | As Mikhail, I want to be aware of the current weather condition (StatusMenusButton), so I can feel more in selfcare.  |

Business Tasks
==

Current Location
--

- The app should produce an opportunity to restrict sending the Apple location manager's geo coordinates to the weather data provider's server, Geocoding API instead as an alternative for.

Current Weather
--

Forecast
--

Geocoding
--

Special Features
==

Favorites
--

- The list of favorite places should have "Current Location" item as the first item that can't be removed.

Options
==

- Dark Mode switching.

Data Mappings
==


--- 
> END of FILE
---

> # Operations

| ID   | Description                                                   | Must have  | In Use                         | Result | Rules  |
| ---- | ------------------------------------------------------------- | ---------- | ------------------------------ | ------ | ------ |
| OP-1 | Call current weather with OpenWeather API (Popover)           | API key    | DATA-2, OO-2                   | DATA-1 | RULE-1 |
| OP-2 | Ask for current location                                      | Permission |                                | DATA-2 | -      |
| OP-3 | Call 5 day / 3 hour forecast with OpenWeather API             | API key    | DATA-2, OO-2                   | DATA-1 | RULE-1 |
| OP-4 | Direct geocoding with OpenWeather API                         | API key    | OO-2                           |        |        |
| OP-5 | CRUD Favorites                                                |            |                                |        |        |
| OP-6 | Call current weather with OpenWeather API (StatusMenusButton) | API key    | DATA-2, OO-2, OO-4, OO-5, OO-6 | DATA-1 | RULE-1 |

> # Rules

| ID     | Description                                        |
| ------ | -------------------------------------------------- |
| RULE-1 | Generally accepted temperature converting formulas |

> # Data Models

> ## Business matter attributes

| ID     | Name             | Details                                                 | Defaults            |
| ------ | ---------------- | ------------------------------------------------------- | ------------------- |
| DATA-1 | Temperature      | Standard: Kelvin, Metric: Celsius, Imperial: Fahrenheit | Apply: Fahrenheit\* |
| DATA-2 | Current location | Couple: (latitude, longitude)                           | -                   |

> ## Other Options

| ID       | Name                     | Details                                                                      | Defaults          |
| -------- | ------------------------ | ---------------------------------------------------------------------------- | ----------------- |
| OO-1     | Dark Mode                | Auto, On, Off                                                                | Apply: Auto       |
| OO-2     | OpenWeather API key      | User Input                                                                   | -                 |
| OO-3\*\* | Starts on login          | True, False                                                                  | Apply: True       |
| 00-4     | Status Menus View        | singleLine, two                                                              | singleLine        |
| 00-5     | Status Menus Second Line | feelsLike, Direction, Gust, Wind, Visibility, Pressure, Humidity, Cloudiness | Wind              |
| 00-6     | Status Menus ToolTip     | feelsLike, Direction, Gust, Wind, Visibility, Pressure, Humidity, Cloudiness | (Direction, Gust) |

> \* changed

> \*\* rejected

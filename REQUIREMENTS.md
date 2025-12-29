> # The App's Name: Snowman

> # Idea history

<table>
    <tr>
        <th>Versions</th>
        <th>Product</th>
        <th>Short description</th>
    </tr>
    <tr>
        <td>0.5+</td>
        <td>Developer release (candidate).</td>
        <td>StatusMenusButton view options.</td>
    </tr>
    <tr>
        <td>0.4+</td>
        <td>Developer release (candidate).</td>
        <td>Current weather (StatusMenusButton).</td>
    </tr>
    <tr>
        <td>0.4+</td>
        <td>Developer release (candidate).</td>
        <td>City search by name (direct geocoding).</td>
    </tr>
    <tr>
        <td>0.4+</td>
        <td>Developer release (candidate).</td>
        <td>Favorites (collection of places).</td>
    </tr>
    <tr>
        <td>0.3+</td>
        <td>Developer release (candidate).</td>
        <td>Forecast.(*)(**)</td>
    </tr>
    <tr>
        <td>0.2+</td>
        <td>Developer release (candidate).</td>
        <td>Current weather (Popover).</td>
    </tr>
    <tr>
        <td></td>
        <td>* Change</td>
        <td>DATA-1: Default Temperature changed from Celsius to Fahrenheit.</td>
    </tr>
    <tr>
        <td></td>
        <td>** Reject</td>
        <td>00-3: Starts on login had been canceled.</td>
    </tr>
</table>

> # Business Tasks:

| ID   | Description                 | Operations                          | API product                                  |
| ---- | --------------------------- | ----------------------------------- | -------------------------------------------- |
| BT-1 | Fetching current weather    | OP-1, OP-2, OP-4, OP-5, OP-6 REST-3 | https://openweathermap.org/current           |
| BT-2 | Fetching forecast           | OP-2, OP-3, OP-4, OP-5, REST-3      | https://openweathermap.org/forecast5         |
| BT-3 | City search by name         | OP-4                                | https://openweathermap.org/api/geocoding-api |
| BT-4 | Favorites                   | REST-4                              |                                              |

> # Sketches (GUI requirements)

<table>
    <tr>
        <th>ID</th>
        <th>Description</th>
    </tr>
    <tr>
        <td nowrap>GUI-1</td>
        <td>The app should look like it presented in the picture below.</td>
    </tr>
    <tr>
        <td></td>
        <td><img src="https://github.com/perseusrealdeal/macOS.Weather/assets/50202963/b8c4b185-41cf-4c7c-be2f-8cb31c6958fb" width="400" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/></td>
    </tr>
    <tr>
        <td nowrap>GUI-2</td>
        <td>The app should run as a Status Menus app (the Menu Bar one).</td>
    </tr>
    <tr>
        <td nowrap>GUI-3</td>
        <td>A typical window should be employed for preferences.</td>
    </tr>
    <tr>
        <td nowrap>REST-1</td>
        <td>The app should have no Icon in Dock.</td>
    </tr>
    <tr>
        <td nowrap>REST-2</td>
        <td>The app should have no Main menu.</td>
    </tr>
    <tr>
        <td nowrap>REST-3</td>
        <td>The app should produce an opportunity to restrict sending geo coordinates from location manager to weather data provider's server.</td>
    </tr>
    <tr>
        <td nowrap>REST-4</td>
        <td>The list of favorite places should have "current location" item as the first item and can't be removed, but coordinates can be actualized.</td>
    </tr>
</table>

> # User Stories

<table>
    <tr>
        <th>ID</th>
        <th>Description</th>
    </tr>
    <tr>
        <td nowrap>US-1</td>
        <td>As Mikhail, I want to be aware of the current weather condition (popover), so I can feel more in selfcare.</td>
    </tr>
    <tr>
        <td nowrap>US-2</td>
        <td>As Mikhail, I want to be able to call weather condition again (manually), so I can be sure about the current weather.</td>
    </tr>
    <tr>
        <td nowrap>US-3</td>
        <td>As Mikhail, I want to be able to adjust the app preferences, so I can feel more comfortable in the app usage.</td>
    </tr>
    <tr>
        <td nowrap>US-4</td>
        <td>As Mikhail, I want to be able to quit the app, so I can feel more comfortable in the app usage.</td>
    </tr>
    <tr>
        <td nowrap>US-5</td>
        <td>As Mikhail, I want to be aware of the forecast, so I can feel more in selfcare.</td>
    </tr>
    <tr>
        <td nowrap>US-6</td>
        <td>As Mikhail, I want to use the name of a location with requesting weather data (direct geocoding.)</td>
    </tr>
    <tr>
        <td nowrap>US-7</td>
        <td>As Mikhail, I want to enjoy list of favorite places (CRUD operations.)</td>
    </tr>
    <tr>
        <td nowrap>US-8</td>
        <td>As Mikhail, I want to be aware of the current weather condition (StatusMenusButton), so I can feel more in selfcare.</td>
    </tr>
<!--
    <tr>
        <td nowrap>US-N</td>
        <td>As Mikhail, I want to see my current geographical coordinates converted into the name of the nearby location by request weather data (reverse geocoding.)</td>
    </tr>
-->
</table>

> # Features (specials)

| ID  | Description | Data |
| --- | ----------- | ---- |
| F-1 | Dark Mode   | OO-1 |

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

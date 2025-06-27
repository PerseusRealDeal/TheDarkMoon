> # The App's Name: Snowman

> # Idea history

<table>
    <tr>
        <th>Related to versions</th>
        <th>Short description</th>
    </tr>
    <tr>
        <td>0.3</td>
        <td>Developer release (candidate) with minimum functionality (forecast).</td>
    </tr>
    <tr>
        <td>Reject, Change</td>
        <td>—</td>
    </tr>
    <tr>
        <td>0.2+</td>
        <td>Developer release (candidate) with minimum functionality (current weather).</td>
    </tr>
    <tr>
        <td>* Change</td>
        <td>DATA-1: Temperature default changed from Celsius to Fahrenheit.</td>
    </tr>
    <tr>
        <td>** Reject</td>
        <td>00-3: Starts on login had been canceled.</td>
    </tr>
</table>

> # Business Tasks:

| ID   | Description                 | Operations | API product                          |
| ---- | --------------------------- | ---------- | ------------------------------------ |
| BT-1 | Fetching current weather    | OP-1, OP-2 | https://openweathermap.org/current   |
| BT-2 | Fetching forecast           | OP-2, OP-3 | https://openweathermap.org/forecast5 |

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
</table>

> # User Stories

<table>
    <tr>
        <th>ID</th>
        <th>Description</th>
    </tr>
    <tr>
        <td nowrap>US-1</td>
        <td>As Mikhail, I want to be aware of the current weather condition, so I can feel more in selfcare.</td>
    </tr>
    <tr>
        <td nowrap>US-2</td>
        <td>As Mikhail, I want to be able to call weather condition again, so I can be sure about the current weather.</td>
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
</table>

> # Features (specials)

| ID  | Description | Data |
| --- | ----------- | ---- |
| F-1 | Dark Mode   | OO-1 |

> # Operations

| ID   | Description                                       | Must have  | In Use               | Result | Rules  |
| ---- | ------------------------------------------------- | ---------- | -------------------- | ------ | ------ |
| OP-1 | Call current weather with OpenWeather API         | API key    | DATA-2, OO-2         | DATA-1 | RULE-1 |
| OP-2 | Ask for current location                          | Permission |                      | DATA-2 | -      |
| OP-3 | Call 5 day / 3 hour forecast with OpenWeather API | API key    | DATA-2, OO-2         | DATA-1 | RULE-1 |

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

| ID       | Name                | Details          | Defaults    |
| -------- | ------------------- | ---------------- | ----------- |
| OO-1     | Dark Mode           | Auto, On, Off    | Apply: Auto |
| OO-2     | OpenWeather API key | User Input       | -           |
| OO-3\*\* | Starts on login     | True, False      | Apply: True |

> \* changed

> \*\* rejected

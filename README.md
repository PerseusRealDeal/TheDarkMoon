<div align="right">

[`A3 Environment`](/APPROBATION.md) • [`CHANGELOG`](/CHANGELOG.md) • [`The Clear BSD License`](/LICENSE)

[![Platforms](https://img.shields.io/badge/Platform-macOS%2010.13+-orange.svg)](https://en.wikipedia.org/wiki/MacOS_version_history)
[![Xcode](https://img.shields.io/badge/Xcode-14.2+-red.svg)](https://en.wikipedia.org/wiki/Xcode)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)](https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html)
[![SDK](https://img.shields.io/badge/SDK-UIKit%20-blueviolet.svg)](https://developer.apple.com/documentation/uikit)

</div>

<div align="center">

![Image](https://github.com/user-attachments/assets/75e9c8a3-2a98-41f2-b0fa-8a45c1db3fa2)

Snowman
==

__The Status Menus Weather App__

[![Actions Status](https://github.com/perseusrealdeal/TheDarkMoon/actions/workflows/main.yml/badge.svg)](https://github.com/perseusrealdeal/TheDarkMoon/actions)
[![Style](https://github.com/perseusrealdeal/TheDarkMoon/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/perseusrealdeal/TheDarkMoon/actions/workflows/swiftlint.yml)
[![Version](https://img.shields.io/badge/Version-0.6.0-green.svg)](/CHANGELOG.md)

[![ConsolePerseusLogger](http://img.shields.io/:ConsolePerseusLogger-1.7.1-green.svg)](https://github.com/perseusrealdeal/ConsolePerseusLogger.git)
[![PerseusDarkMode](http://img.shields.io/:PerseusDarkMode-2.2.0-green.svg)](https://github.com/perseusrealdeal/PerseusDarkMode.git)
[![PerseusGeoKit](http://img.shields.io/:PerseusGeoKit-1.2.1-green.svg)](https://github.com/perseusrealdeal/PerseusGeoKit.git)

</div>

Meteo source switching
--

<table>
  <tr>
    <td>
        <a href="https://open-meteo.com">
            <img src="https://github.com/user-attachments/assets/9f0b74d4-53ee-4fa8-8972-d1cd0c5de5f2" width="80" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/><br>Open-Meteo
        </a>
    </td>
    <td>
        <a href="https://open-meteo.com/en/docs">API: Current & Weather Forecast</a> • <a href="https://open-meteo.com/en/docs/geocoding-api">Geocoding</a><br><br><a href="https://open-meteo.com/en/terms">Terms and Privacy</a> • <a href="https://open-meteo.com/en/licence">License</a>
    </td>
  </tr>
  <tr>
    <td>
        <a href="https://openweathermap.org">
            <img src="https://github.com/user-attachments/assets/b87acbc5-0bb4-4d9e-aa53-65356ae23e77" width="80" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/><br>OpenWeather
        </a>
    </td>
    <td>
        <a href="https://openweathermap.org/current?collection=current_forecast">API: Current & Weather 5 Day / 3 Hour Forecast</a> • <a href="https://openweathermap.org/api/geocoding-api?collection=other">Geocoding</a> • <a href="https://openweathermap.org/appid">Individual API key</a><br><br><a href="https://openweather.co.uk/api/files/file/Openweather_website_terms_and_conditions_of_use.pdf">Terms</a> • <a href="https://openweather.co.uk/privacy-policy">Privacy</a> • <a href="https://openweathermap.org/guide#licensing">License</a>
    </td>
  </tr>
</table>

Contents
==

* [Announcement](#Announcement)
    * [Our terms](#Our-terms)
    * [The why](#The-why)
    * [Preview material](#Preview-material)
    * [Top features](#Top-features)
* [The requirements](#The-requirements)
* [The unity and part-whole structure](#The-unity-and-part-whole-structure)
    * [Project directory tree](#Project-directory-tree)
    * [First-party software](#First-party-software)
    * [Third-party software](#Third-party-software)
    * [Gifts](#Gifts)
    * [Account points](#Account-points)
* [License](#License)
    * [Other required licenses details](#Other-required-licenses-details)
* [Credits](#Credits)
* [Contributing](#Contributing)
* [Acknowledgements](#Acknowledgements)
* [Author](#Author)
    * [Contact](#Contact)

Announcement
==

> This is the great home-made macOS app project to accomplish `weather forecast` task.

Our Terms
--

| Acronym | Stands for                                                                                                |
| :-----: | --------------------------------------------------------------------------------------------------------- |
| CPL     | [Console_Perseus_Logger](https://github.com/perseusrealdeal/ConsolePerseusLogger.git)                     |
| PDM     | [Perseus_Dark_Mode](https://github.com/perseusrealdeal/PerseusDarkMode.git)                               |
| PGK     | [Perseus_Geo_Kit](https://github.com/perseusrealdeal/PerseusGeoKit.git)                                   |
| A3      | [Apple_Apps_Approbation](https://docs.google.com/document/d/1K2jOeIknKRRpTEEIPKhxO2H_1eBTof5uTXxyOm5g6nQ) |
| T3      | [The_Technological_Tree](https://github.com/perseusrealdeal/TheTechnologicalTree)                         |
| P2P     | Person_to_Person                                                                                          |

The why
--

> The why of this app cannot, and need not, be put into words.

Preview material
--

<!--

TODO: refresh GUI screens

-->

<div align="center">

<table>
  <tr>
    <th>Main Screen (Popover)</th>
  </tr>
  <tr>
    <td>
        <img src="https://github.com/user-attachments/assets/7eef35cb-b8ee-4223-bd23-bf5916b9d65b" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/>
    </td>
  </tr>
</table>

<table>
  <tr>
    <th>Options Screen</th>
  </tr>
  <tr>
    <td>
        <img src="https://github.com/user-attachments/assets/3c3e4617-ee40-4270-b0f7-a94b989e3ad0" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/>
    </td>
  </tr>
</table>

<!--
> [!IMPORTANT]
> `Unidentified developer case:` 

TODO: past the link to the video

> The video above recordered with `QuickTime Player` and than converted with [``](). 
TODO: past the link to the tool
-->

</div>

Top features
--

- `Current weather` for Current Location and specific location name
- `Forecast` for Current Location and specific location name
- `Geocoding` for searching location by location name with auto suggesting, optionally
- `Current Location` determining, latitude and longitude via [PGK](https://github.com/perseusrealdeal/PerseusGeoKit.git)

---

- `Temperature (Low, High, Kinda):` Kelvin, Celsius, Fahrenheit
- `Visibility:` Kilometre, Mile
- `Wind (Speed, Direction, Gust):` meter/sec, km/hour, miles per hour
- `Pressure:` hPa, mmHg, mb
- `Humidity:` %
- `Cloudiness:` %
- `Sunrise:` local time
- `Sunset:` local time

---

- `Favorites list:` Collecting locations, add and remove items
- `Multilanguage:` English and Russian
- `Dark Mode:` Light, Dark, System (auto) via [PDM](https://github.com/perseusrealdeal/PerseusDarkMode.git)
- `Multi time format:` 24-hour and 12-hour
- `Auto Current Weather update:` per 12 hours, per 3 hours, per hour, none

---

- `Multiline:` Additional string line for Status Menus item, macOS 11 (Big Sur)+ 
- `ToolTip:` Showing extra meteo parameters for Status Menus item
- `Keychain:` Keeping OpenWeather API key saved as a secret
- `Logging:` Collecting log messages, special screen with [CPL](https://github.com/perseusrealdeal/ConsolePerseusLogger.git) managing options

The requirements
==

> [!NOTE]
> The current app project is represented in source code only, it's a developer edition.

`To build:`

- [macOS Monterey 12.7.6+](https://apps.apple.com/by/app/macos-monterey/id1576738294)
- [Xcode 14.2+](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_14.2/Xcode_14.2.xip)

`Specifications:`

- [Functional specification](/REQUIREMENTS.md)
- Translations [EN](/PerseusMeteo/Configuration/Translations/Translation_en.plist), [RU](/PerseusMeteo/Configuration/Translations/Translation_ru.plist)

The unity and part-whole structure
==

Project directory tree
--

[![GitHubTree](https://img.shields.io/badge/GitHubTree-TheDarkMoon-blue)](https://githubtree.mgks.dev/repo/perseusrealdeal/thedarkmoon/main/?ref=badge)

```bash

.
├── LICENSE
├── main.yml
├── swiftlint.yml
├── .gitignore
├── .swiftlint.yml
├── PerseusMeteo
│   ├── TheCrownOfStars
│   │   ├── TheLoggerStar.swift
│   │   ├── TheGeoStar.swift
│   │   └── TheDarknessStar.swift
│   ├── main.swift
│   ├── AppGlobals.swift
│   ├── AppOptions.swift
│   ├── AppDelegate.swift
│   ├── Configuration
│   │   ├── MVPPattern
│   │   │   ├── MVPPresenter.swift
│   │   │   └── MVPViewDelegate.swift
│   │   ├── Translations
│   │   │   ├── Translation_en.plist
│   │   │   └── Translation_ru.plist
│   │   ├── Localization
│   │   │   ├── InfoPlist.strings
│   │   │   └── Localizable.strings
│   │   ├── UIComponents
│   │   │   └── ...
│   │   ├── Assets.xcassets
│   │   ├── Info.plist
│   │   ├── PerseusMeteo.entitlements
│   │   ├── AppLinks.swift
│   │   ├── Extensions.swift
│   │   └── CPLConfig.json
│   ├── FirstPartyCode
│   │   └── ...
│   ├── BusinessContent
│   │   └── ...
│   ├── BusinessLogic
│   │   └── ...
│   └── BusinessAPIs
│       └── ...
├── SnowmanTests
│   ├── Info.plist
│   ├── TestPlan.xctestplan
│   ├── TestingAppDelegate.swift
│   ├── ...
│   └── Helpers
│       ├── LocalizedInfoPlistGift.swift
│       ├── LocalizedExpectationGift.swift
│       └── PerseusLogger.swift
├── README.md
├── CHANGELOG.md
├── APPROBATION.md
└── REQUIREMENTS.md

```

First-party software
--

| Type     | License                            | Name                                                                                                      |
| -------- | :--------------------------------: | --------------------------------------------------------------------------------------------------------- |
| Package  | MIT                                | [ConsolePerseusLogger v1.7.1](https://github.com/perseusrealdeal/ConsolePerseusLogger/releases/tag/1.7.1) |
| Class    | MIT                                | [PerseusLogger](https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5)                 |
| Package  | MIT                                | [PerseusDarkMode v2.2.0](https://github.com/perseusrealdeal/PerseusDarkMode/releases/tag/2.2.0)           |
| Package  | MIT                                | [PerseusGeoKit v1.2.1](https://github.com/perseusrealdeal/PerseusGeoKit/releases/tag/1.2.1)               |
| Class    | MIT                                | [PerseusCompassDirection](https://gist.github.com/perseusrealdeal/3b053b2390d704f561ec52c6477b5cf2)       |
| Variable | MIT                                | [PerseusTimeFormat](https://gist.github.com/perseusrealdeal/7aa89d78d9b1c220cc06682be8908a97)             |
| Class    | MIT                                | [MessageLabel](https://gist.github.com/PerseusRealDeal/dbfed6e01ed80be084983738ba713654)                  |
| Class    | [Unlicense](https://unlicense.org) | [WebLabel](/PerseusMeteo/FirstPartyCode/WebLabel.swift)                                                   |
| Class    | [Unlicense](https://unlicense.org) | [PerseusNetworkClient](/PerseusMeteo/FirstPartyCode/PerseusNetworkClient.swift)                           |

Third-party software
--

| Type          | License                            | Name                                                                                  |
| ------------- | :--------------------------------: | ------------------------------------------------------------------------------------- |
| Code Style    | MIT                                | [SwiftLint v0.57.0 Monterey+](https://github.com/realm/SwiftLint/releases/tag/0.57.0) |
| GitHub Action | [Unlicense](https://unlicense.org) | [mxcl/xcodebuild@v3](https://github.com/mxcl/xcodebuild)                              |
| GitHub Action | MIT                                | [cirruslabs/swiftlint-action@v1](https://github.com/cirruslabs/swiftlint-action/)     |
| Tree View     | MIT                                | [GitHubTree Viewer](https://github.com/mgks/GitHubTree)                               |

Gifts
--

- [CurrentSystemLanguageGift.swift](https://gist.github.com/perseusrealdeal/98b082b136d574dd1b5aa760036dac8b)
- [JsonDataDictionaryGift.swift](https://gist.github.com/perseusrealdeal/918c25633122e64d51f363f00059f6f8)
- [JsonDataPrettyPrintedGift.swift](https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca)
- [LocalizedInfoPlistGift.swift](/SnowmanTests/GiftsAndHelpers/LocalizedInfoPlistGift.swift)
- [LocalizedExpectationGift.swift](/SnowmanTests/GiftsAndHelpers/LocalizedExpectationGift.swift)

Account points 
--

- Explicit start point [main.swift](/PerseusMeteo/main.swift)
- Explicit app delegate [TestingAppDelegate.swift](/SnowmanTests/TestingAppDelegate.swift)
- Explicit app globals [AppGlobals.swift](/PerseusMeteo/AppGlobals.swift)
- Explicit app options [AppOptions.swift](/PerseusMeteo/AppOptions.swift)
- Architectural points: 
    - MVP applied. Based on [Gist](https://gist.github.com/PerseusRealDeal/5301e90881732f0cd0040e2083a78a3d)
    - Coordinator. Top business logic wrapped up in [ContentCoordinator.swift](/PerseusMeteo/BusinessContent/ContentCoordinator.swift)
- Localization based on Localizable.strings approach
- [Test Plan](/SnowmanTests/TestPlan.xctestplan) configured for EN and RU
- [Changelog](/CHANGELOG.md)
- [A3 environment specification](/APPROBATION.md)
- [Software requirements specification](/REQUIREMENTS.md)
- [GitHub CI build & test](/.github/workflows/main.yml)
- [GitHub CI SwiftLint](/.github/workflows/swiftlint.yml)
- [SwiftLint Rules](/.swiftlint.yml)
- [Git Config](/.gitignore)
- SwiftLint shell script as a build phase (SwiftLint preinstallation required)

License
==

__The Clear BSD License__, see [LICENSE](/LICENSE) for details.

Copyright `© 7531 - 7534 Mikhail A. Zhigulin of Novosibirsk`<br/>
Copyright `© 7531 - 7534 PerseusRealDeal`

- The year starts from the creation of the world according to a Slavic calendar.
- September, the 1st of Slavic year. For instance, "Sep 01, 2025" is the beginning of 7534.

Other required licenses details
--

`© 2025 The SwiftLint Contributors` for SwiftLint.<br/>
`© GitHub` for GitHub Action cirruslabs/swiftlint-action@v1.</br>
`© 2025 Ghazi (mgks.dev)` for GitHubTree Viewer.

`Attribution to Open-Meteo:` [format recommendation](https://open-meteo.com/en/licence#:~:text=Weather%20data%20by%20Open-Meteo%2Ecom)<br/>
`Attribution to OpenWeather:` [format recommendation](https://openweathermap.org/full-price#:~:text=Weather%20data%20%C2%A9%20OpenWeather)

Credits
==

<table>
  <tr>
      <td>Balance and Control</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Source Code</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Documentation</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Approbation</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Artwork</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>English</td>
      <td>Mikhail Zhigulin</td>
  </tr>
  <tr>
      <td>Russian</td>
      <td>Mikhail Zhigulin</td>
  </tr>
</table>

> [!NOTE]
> The Apple weather icons are used to indicate different weather conditions, like fog or haze.

> [!IMPORTANT]
> The Open-Meteo `logo` taken from [`https://open-meteo.com/favicon.ico`](https://open-meteo.com/favicon.ico).</br>
> The OpenWeather `logo` taken from [`https://github.com/openweathermap`](https://github.com/openweathermap).</br>
> The weather conditions icons for legacy macOS taken from [`sf-symbols-online`](https://github.com/andrewtavis/sf-symbols-online).

- Artwork tool: [GIMP](https://www.gimp.org/) / [2.10.36](https://download.gimp.org/gimp/v2.10/osx/) for macOS 10.12 Sierra or newer
- Language support: [Reverso](https://www.reverso.net/) 
- Git clients: [SmartGit](https://syntevo.com/) and [GitHub Desktop](https://github.com/apps/desktop)

Contributing
==

> [!NOTE]
> The product is constructed in `P2P` relationship paradigm that means the only one single and the same face in the product team during all development process stages.

But, `translations and bug reports are welcome`, create an issue and give details.

If you'd like `to see the app in your native language` consider [translation for EN](/PerseusMeteo/Configuration/Translations/Translation_en.plist) as a template, then prepare your translation in the same way and create an issue, EN and RU already done.

Acknowledgements
==

Along the dev process of the releases v0.2..0.3 there're several things were also taken into the account, actual even for current version also.

<table>
  <thead>
    <tr>
      <th>Thanks to</th>
      <th>For</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Google, Inc.</td>
      <td><a href="https://www.google.com/search?q=temperature+converter">Convertion formulas</a></td>
    </tr>
    <tr>
      <td>Lorenzo Boaro</td>
      <td><a href="https://www.kodeco.com/9240-keychain-services-api-tutorial-for-passwords-in-swift">The Keychain API tutorial</a></td>
    </tr>
    <tr>
      <td>Gabriel Theodoropoulos</td>
      <td><a href="https://www.appcoda.com/macos-status-bar-apps/">The macos-status-bar-apps tutorial</a></td>
    </tr>
    <tr>
      <td>Bill Waggoner</td>
      <td><a href="https://github.com/ctgreybeard/SwiftCustomControl">Swift-custom-control sample</a></td>
    </tr>
  </tbody>
</table>

Author
==

<div align="center">

`© Mikhail A. Zhigulin of Novosibirsk`

</div>

Contact
--

<div align="center">

[E-mail](mailto:mzhigulin@gmail.com) • [Telegram](https://t.me/velociraptor1985) • [GitHub](https://github.com/perseusrealdeal)

</div>

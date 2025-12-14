# Snowman — Weather Status Menus app — Xcode 14.2+

[![Actions Status](https://github.com/perseusrealdeal/TheDarkMoon/actions/workflows/main.yml/badge.svg)](https://github.com/perseusrealdeal/TheDarkMoon/actions)
[![Style](https://github.com/perseusrealdeal/TheDarkMoon/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/perseusrealdeal/TheDarkMoon/actions/workflows/swiftlint.yml)
[![Version](https://img.shields.io/badge/Version-0.4.3-green.svg)](/CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/Platform-macOS%2010.13+-orange.svg)](https://en.wikipedia.org/wiki/MacOS_version_history)
[![Xcode](https://img.shields.io/badge/Xcode-14.2+-red.svg)](https://en.wikipedia.org/wiki/Xcode)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)](https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html)
[![SDK](https://img.shields.io/badge/SDK-UIKit%20-blueviolet.svg)](https://developer.apple.com/documentation/uikit)
[![License](http://img.shields.io/:License-Clear_BSD-blue.svg)](/LICENSE)

> This is the great home-made macOS weather app project. The app runs in the Status Menus (top-right).

> `1:` Request current weather.</br>
> `2:` Request `5 Day / 3 Hour` forecast.

> [`OpenWeather Agent`](https://github.com/perseusrealdeal/OpenWeatherAgent) in use to fetch weather data. [`Individual API key`](https://openweathermap.org/appid) is required.

> For details: [`Approbation and A3 Environment`](/APPROBATION.md) / [`CHANGELOG`](/CHANGELOG.md)

## Dependencies

> The Crown of Stars:

[![ConsolePerseusLogger](http://img.shields.io/:ConsolePerseusLogger-1.7.0-green.svg)](https://github.com/perseusrealdeal/ConsolePerseusLogger.git)
[![PerseusDarkMode](http://img.shields.io/:PerseusDarkMode-2.1.1-green.svg)](https://github.com/perseusrealdeal/PerseusDarkMode.git)
[![PerseusGeoKit](http://img.shields.io/:PerseusGeoKit-1.1.2-green.svg)](https://github.com/perseusrealdeal/PerseusGeoKit.git)
[![OpenWeatherAgent](http://img.shields.io/:OpenWeatherAgent-0.3.5-green.svg)](https://github.com/perseusrealdeal/OpenWeatherAgent)

# Contents

* [The Why](#The-Why)
* [Build requirements](#Build-requirements)
* [Software requirements](#Software-requirements)
* [Gifts](#Gifts)
* [First-party software](#First-party-software)
* [Third-party software](#Third-party-software)
* [Points taken into account](#Points-taken-into-account)
* [License](#License)
    * [Other required licenses details](#Other-required-licenses-details)
* [Credits](#Credits)
* [Author](#Author)

# The Why

> The Why of this app cannot, and need not, be put into words.

<table>
  <tr>
    <th>The Dark Moon in English</th>
    <th>The Dark Moon in Russian</th>
  </tr>
  <tr>
    <td>
        <img src="https://github.com/user-attachments/assets/cc7925f0-5f69-41fa-bc14-09f4d1b65919" width="350" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/>
    </td>
    <td>
        <img src="https://github.com/user-attachments/assets/3dbeb9d3-8641-40a0-87de-e71bb944e52f" width="350" style="max-width: 100%; display: block; margin-left: auto; margin-right: auto;"/>
    </td>
  </tr>
</table>

# Build requirements

- [macOS Monterey 12.7.6+](https://apps.apple.com/by/app/macos-monterey/id1576738294) / [Xcode 14.2+](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_14.2/Xcode_14.2.xip)

> [!NOTE]
> The current app project is represented in source code only, it's a developer edition.

# Software requirements

- [Functional specification](/REQUIREMENTS.md)
- Translations [EN](/PerseusMeteo/Configuration/Translations/Translation_en.plist), [RU](/PerseusMeteo/Configuration/Translations/Translation_ru.plist)

# First-party software

## MIT

| Type     | Name                                                                                                                                                                  | License |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| Package  | [ConsolePerseusLogger](https://github.com/perseusrealdeal/ConsolePerseusLogger) / [1.7.0](https://github.com/perseusrealdeal/ConsolePerseusLogger/releases/tag/1.7.0) | MIT     |
| Class    | [PerseusLogger](https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5)                                                                             | MIT     |
| Package  | [PerseusDarkMode](https://github.com/perseusrealdeal/PerseusDarkMode) / [2.1.1](https://github.com/perseusrealdeal/PerseusDarkMode/releases/tag/2.1.1)                | MIT     |
| Package  | [PerseusGeoKit](https://github.com/perseusrealdeal/PerseusGeoKit) / [1.1.2](https://github.com/perseusrealdeal/PerseusGeoKit/releases/tag/1.1.2)                      | MIT     |
| Class    | [PerseusCompassDirection](https://gist.github.com/perseusrealdeal/3b053b2390d704f561ec52c6477b5cf2)                                                                   | MIT     |
| Variable | [PerseusTimeFormat](https://gist.github.com/perseusrealdeal/7aa89d78d9b1c220cc06682be8908a97)                                                                         | MIT     |
| Package  | [OpenWeatherAgent](https://github.com/perseusrealdeal/OpenWeatherAgent) / [0.3.5](https://github.com/perseusrealdeal/OpenWeatherAgent/releases/tag/0.3.5)             | MIT     |
| Class    | [MessageLabel](https://gist.github.com/PerseusRealDeal/dbfed6e01ed80be084983738ba713654)                                                                              | MIT     |

## Unlicense

| Type     | Name                                                                                                                              | License                            |
| -------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| Variable | [CurrentSystemLanguageGift.swift](https://gist.github.com/perseusrealdeal/98b082b136d574dd1b5aa760036dac8b)                       | [Unlicense](https://unlicense.org) |
| Class    | [JsonDataDictionaryGift.swift](https://gist.github.com/perseusrealdeal/918c25633122e64d51f363f00059f6f8)                          | [Unlicense](https://unlicense.org) |
| Variable | [JsonDataPrettyPrintedGift.swift](https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca)                       | [Unlicense](https://unlicense.org) |
| Variable | [LocalizedInfoPlistGift.swift](/SnowmanTests/GiftsAndHelpers/LocalizedInfoPlistGift.swift)                                        | [Unlicense](https://unlicense.org) |
| Variable | [LocalizedExpectationGift.swift](/SnomanTests/GiftsAndHelpers/LocalizedExpectationGift.swift)                                     | [Unlicense](https://unlicense.org) |

# Third-party software

| Type   | Name                                                                                                                              | License                            |
| ------ | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| Style  | [SwiftLint](https://github.com/realm/SwiftLint) / [v0.57.0 for Monterey+](https://github.com/realm/SwiftLint/releases/tag/0.57.0) | MIT                                |
| Action | [mxcl/xcodebuild@v3](https://github.com/mxcl/xcodebuild)                                                                          | [Unlicense](https://unlicense.org) |
| Action | [cirruslabs/swiftlint-action@v1](https://github.com/cirruslabs/swiftlint-action/)                                                 | MIT                                |

# Points taken into account

- Explicit start point placed in [main.swift](/PerseusMeteo/main.swift)
- Explicit app delegate [TestingAppDelegate.swift](/SnowmanTests/TestingAppDelegate.swift) with test bundle
- Explicit app globals placed in [AppGlobals.swift](/PerseusMeteo/Configuration/AppGlobals.swift)
- Localization based on Localizable.strings approach
- [Test Plan](/SnowmanTests/TestPlan.xctestplan) configured for EN and RU as well
- [Changelog](/CHANGELOG.md)
- [A3 Environment Specification Template](/APPROBATION.md)
- [Software Requirements](/REQUIREMENTS.md)
- [GitHub CI build & test](/main.yml)
- [GitHub CI SwiftLint](/swiftlint.yml)
- [SwiftLint Rules](/.swiftlint.yml)
- [Git Config](/.gitignore)
- SwiftLint shell script as a build phase (SwiftLint preinstallation required)
- Architectural points. MVP applied. Based on [Gist](https://gist.github.com/PerseusRealDeal/5301e90881732f0cd0040e2083a78a3d).

# License

`License:` The Clear BSD License

Copyright © 7531 - 7534 Mikhail A. Zhigulin of Novosibirsk<br/>
Copyright © 7531 - 7534 PerseusRealDeal

- The year starts from the creation of the world according to a Slavic calendar.
- September, the 1st of Slavic year. It means that "Sep 01, 2025" is the beginning of 7534.

[LICENSE](/LICENSE) for details.

## Other required licenses details

© Mikhail A. Zhigulin of Novosibirsk **for** ConsolePerseusLogger, PerseusDarkMode, PerseusGeoKit, OpenWeatherAgent</br>
© PerseusRealDeal **for** ConsolePerseusLogger, PerseusDarkMode, PerseusGeoKit, OpenWeatherAgent</br>
© 2025 The SwiftLint Contributors **for** SwiftLint</br>
© GitHub **for** GitHub Action cirruslabs/swiftlint-action@v1</br>

# Credits

<table>
<tr>
    <td>Balance and Control</td>
    <td>kept by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Source Code</td>
    <td>written by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Documentation</td>
    <td>prepared by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Product Approbation</td>
    <td>tested by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Artwork</td>
    <td>expressed by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Russian Translation</td>
    <td>prepared by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>English Translation</td>
    <td>prepared by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
</table>

> [!IMPORTANT]
> The `OpenWeather` icons taken from `https://openweathermap.org` to represent weather condition that also available online by OpenWeatherMap API request.

- Artwork tool: [GIMP](https://www.gimp.org/) / [2.10.36](https://download.gimp.org/gimp/v2.10/osx/) for macOS 10.12 Sierra or newer
- Language support: [Reverso](https://www.reverso.net/) 
- Git clients: [SmartGit](https://syntevo.com/) and [GitHub Desktop](https://github.com/apps/desktop)

# Author

> © Mikhail A. Zhigulin of Novosibirsk

# Contributing Translations

Localizations in other languages are very welcome from the app version 1.0.0<br/>
Please consider [translation for EN](/PerseusMeteo/Configuration/Translations/Translation_en.plist) as a template.

# Acknowledgements

> During the dev process of the releases v0.2..0.3 there're several things were also taken into the account.

***Thanks Google Inc.*** for [convertion formulas](https://www.google.com/search?q=temperature+converter) easy seachable in public.</br>
Convertion formulas applied in [MeteoFactsRepresenter.swift](/PerseusMeteo/BusinessData/MeteoFactsRepresenter.swift)

***Thanks Lorenzo Boaro*** for [the Keychain API tutorial](https://www.kodeco.com/9240-keychain-services-api-tutorial-for-passwords-in-swift).<br/>
Keychain API applied in [PerseusDataDefender.swift](/PerseusMeteo/FirstPartyCode/PerseusDataDefender/PerseusDataDefender.swift)

***Thanks Gabriel Theodoropoulos*** for [the macos-status-bar-apps tutorial](https://www.appcoda.com/macos-status-bar-apps/).<br/>
[StatusMenusButtonPresenter.swift](/PerseusMeteo/BusinessLogic/StatusMenusButtonPresenter.swift)

***Thanks Bill Waggoner*** for the SwiftCustomControl [sample](https://github.com/ctgreybeard/SwiftCustomControl).<br/>
Constrainting custom control's content view approach has been applied in a such components like [WeatherView.swift](/PerseusMeteo/BusinessContent/Popover/WeatherView.swift)


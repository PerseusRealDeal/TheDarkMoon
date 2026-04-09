# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

- Given a version number MAJOR.MINOR.PATCH, where MAJOR in 0 means developer edition.
- Date in format YYYY-MM-DD, in this file meets Gregorian calendar only.

## [0.5.4] - [2026-??-??], The Dark Moon

### Added

- Additional preview material.

## [0.5.3] - [2026-04-09], The Dark Moon

### Added

- Minor UI fixes for legacy macOS systems.

## [0.5.2] - [2026-04-07], The Dark Moon

### Added

- Autoscroll as an option to Logger screen.
- Manual meteo data request cancellation.
- Retry logic for current, forecast and suggestions calls.

### Fixed

- Log message about current location.

### Reconstructed

- OpenWeather Free Client API Agent to PerseusNetworkClient.

## [0.5.1] - [2026-03-25], The Dark Moon

### Added

- (Auto) Scroll to bottom in Logger screen.

### Restructured

- Location details view.
- The project tree.

### Updated

- CPL dependecy to v1.7.2.
- PGK dependecy to v1.2.1.
- PDM dependecy to v2.2.0.

## [0.5.0] - [2025-12-29], The Dark Moon

### Added

- Multiline Status Menus, but from macOS Big Sur (11) only.
- ToolTip with extra meteo parameters for Status Menus.

### Fixed

- Reset to defaults option, language.

### Other

- Minor changes and fixes.

## [0.4.4] - [2025-12-17], The Dark Moon

### Updated

- README, easy readable on mobile devices.

### Added

- Forecast items auto selecting by default.

### Fixed

- Provider name web label, forecast view.

## [0.4.3] - [2025-12-14], The Dark Moon

### Reorganized

- Main screen.
- Project structure.

### Fixed

- Dark Mode appearance for High Sierra.

### Added

- Localization for Redirect Alert used with PGK.
- WebLabel to represent web link to provider meteo source.
- Coordinator to work in accord with MVP architectural points.

### Moved

- Top business logic to Coordinator. 

### Updated

- Selfie screen.
- Logger screen.
- PGK dependency to v1.1.2.

### Other

- Minor changes and fixes.

## [0.4.2] - [2025-11-30], The Dark Moon

### Fixed

- Infinite recursion in log viewer (issue [#45](https://github.com/PerseusRealDeal/TheDarkMoon/issues/45).)

### Added

- Logger window.
- Architectural points. MVP. Based on [Gist](https://gist.github.com/PerseusRealDeal/5301e90881732f0cd0040e2083a78a3d).

## Updated

- Selfie window.
- Dependencies.

## [0.4.1] - [2025-11-17], The Dark Moon

### Fixed

- Weather auto fetching.

### Added

- End-user message highlighting.
- Minor changes.

## [0.4] - [2025-11-13], The Dark Moon

### Added

- Current Weather (StatuaMenusButton).
- Message Label for extra short message showing, end-user notifications.
- City search by name, direct geocoding.
- The list of favorite places, favorites.
- Log viewer as a part of About screen.
- [APPROBATION](/APPROBATION.md) report.

### Reorginized

- The crown of stars: major first-party dependencies in use as standalone.

## [0.3] - [2025-06-27], The Dark Moon

### Added

- Forecast.
- Minor changes.

### Fixed

- Incorrect Location Access Status display in Popover Screen (#30).

### Changed

- Default Xcode Project Version from 10 to 14.

### Updated

- Dependencies: CPL, PDM, PGK, OpenWeatherAgent. 

## [0.2] - [2024-02-01], Current Weather

### Added

- Screen: Popover.
- View: for Current Location.
- View: for Current Weather.
- Screen: Options.
- Option: Dark Mode.
- Option: Localization (EN and RU).
- Option: Time Format (24/12).
- Option: OpenWeather API Key.
- Option: Temperature.
- Option: Wind Speed.
- Option: Pressure (Barometer).
- Option: Distance (Visibility).
- Screen: About.
- Image: App Icon (logo).

### Security

- To keep OpenWeather API key in safe Perseus Data Defender based on Keychain API used (#6).

### Changed

- The project for running as a Status Menus app (#3).

## [0.1] - 2023-04-05, Developer Beginning Release

### Added

- Initial point of development process of [The Technological Tree](https://github.com/perseusrealdeal/TheTechnologicalTree).

//
//  TranslationTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

import XCTest
@testable import Snowman

// swiftlint:disable:next type_body_length
class TranslationTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    // MARK: - Greeting

    func test_translation_common() {

        // assert

        XCTAssertEqual("Have a great time".localizedExpectation,
                       "Have a great time".localizedValue)

        XCTAssertEqual("Greetings".localizedExpectation,
                       "Greetings".localizedValue)
    }

    // MARK: - Popover Screen

    func test_translation_of_PopoverScreen() {

        // assert

        XCTAssertEqual("Button: Call Weather".localizedExpectation,
                       "Button: Call Weather".localizedValue)

        XCTAssertEqual("Button: Call Forecast".localizedExpectation,
                       "Button: Call Forecast".localizedValue)

        XCTAssertEqual("Label: Made with Love".localizedExpectation,
                       "Label: Made with Love".localizedValue)

        XCTAssertEqual("Tab: Current Weather".localizedExpectation,
                       "Tab: Current Weather".localizedValue)

        XCTAssertEqual("Tab: Forecast".localizedExpectation,
                       "Tab: Forecast".localizedValue)

        XCTAssertEqual("Button: Quit".localizedExpectation,
                       "Button: Quit".localizedValue)

        XCTAssertEqual("Button: About".localizedExpectation,
                       "Button: About".localizedValue)

        XCTAssertEqual("Button: Options".localizedExpectation,
                       "Button: Options".localizedValue)

        XCTAssertEqual("Button: Hide".localizedExpectation,
                       "Button: Hide".localizedValue)

        XCTAssertEqual("Default: N/A".localizedExpectation,
                       "Default: N/A".localizedValue)

        XCTAssertEqual("P2P".localizedExpectation,
                       "P2P".localizedValue)

        XCTAssertEqual("P2P stands for Person to Person".localizedExpectation,
                       "P2P stands for Person to Person".localizedValue)

        XCTAssertEqual("API key is either rejected or empty".localizedExpectation,
                       "API key is either rejected or empty".localizedValue)
    }

    // MARK: - End-User Messages

    func test_translation_of_end_user_messages() {

        // assert

        XCTAssertEqual("Coordinates update is required".localizedExpectation,
                       "Coordinates update is required".localizedValue)

        XCTAssertEqual("Location card is switched".localizedExpectation,
                       "Location card is switched".localizedValue)

        XCTAssertEqual("Location card is cleared".localizedExpectation,
                       "Location card is cleared".localizedValue)

        XCTAssertEqual("Item removed from favorites".localizedExpectation,
                       "Item removed from favorites".localizedValue)

        XCTAssertEqual("Item added to favorites".localizedExpectation,
                       "Item added to favorites".localizedValue)

        XCTAssertEqual("Location Name should be typed".localizedExpectation,
                       "Location Name should be typed".localizedValue)

        XCTAssertEqual("Auto requesting suggestions is on!".localizedExpectation,
                       "Auto requesting suggestions is on!".localizedValue)

        XCTAssertEqual("Current Location should be selected".localizedExpectation,
                       "Current Location should be selected".localizedValue)

        XCTAssertEqual("Current neither to add nor to remove!".localizedExpectation,
                       "Current neither to add nor to remove!".localizedValue)
    }

    // MARK: - LocationView

    func test_translation_of_PopoverScreen_LocationView() {

        // assert

        XCTAssertEqual("Label: Permission".localizedExpectation,
                       "Label: Permission".localizedValue)

        XCTAssertEqual("GeoAccess: .notDetermined".localizedExpectation,
                       "GeoAccess: .notDetermined".localizedValue)

        XCTAssertEqual("GeoAccess: .deniedForAllAndRestricted".localizedExpectation,
                       "GeoAccess: .deniedForAllAndRestricted".localizedValue)

        XCTAssertEqual("GeoAccess: .restricted".localizedExpectation,
                       "GeoAccess: .restricted".localizedValue)

        XCTAssertEqual("GeoAccess: .deniedForAllApps".localizedExpectation,
                       "GeoAccess: .deniedForAllApps".localizedValue)

        XCTAssertEqual("GeoAccess: .deniedForTheApp".localizedExpectation,
                       "GeoAccess: .deniedForTheApp".localizedValue)

        XCTAssertEqual("GeoAccess: .allowed".localizedExpectation,
                       "GeoAccess: .allowed".localizedValue)

        XCTAssertEqual("GeoAccess: .notAllowed".localizedExpectation,
                       "GeoAccess: .notAllowed".localizedValue)

        XCTAssertEqual("Geo Couple".localizedExpectation,
                       "Geo Couple".localizedValue)

        XCTAssertEqual("Button: Update Geo Access".localizedExpectation,
                       "Button: Update Geo Access".localizedValue)

        XCTAssertEqual("Button: Refresh Current Location".localizedExpectation,
                       "Button: Refresh Current Location".localizedValue)

        XCTAssertEqual("Button: Request Suggestions".localizedExpectation,
                       "Button: Request Suggestions".localizedValue)

        XCTAssertEqual("Current Location".localizedExpectation,
                       "Current Location".localizedValue)

        XCTAssertEqual("Auto".localizedExpectation,
                       "Auto".localizedValue)
    }

    // MARK: - WeatherView

    func test_translation_of_PopoverScreen_WeatherView() {

        // assert

        XCTAssertEqual("Label: Meteo Data Provider".localizedExpectation,
                       "Label: Meteo Data Provider".localizedValue)

        XCTAssertEqual("Label: Weather Conditions".localizedExpectation,
                       "Label: Weather Conditions".localizedValue)

        XCTAssertEqual("Prefix: Curren Weather in Brief".localizedExpectation,
                       "Prefix: Curren Weather in Brief".localizedValue)

        XCTAssertEqual("Prefix: Feels Like".localizedExpectation,
                       "Prefix: Feels Like".localizedValue)

        XCTAssertEqual("Prefix: Min".localizedExpectation,
                       "Prefix: Min".localizedValue)

        XCTAssertEqual("Prefix: Max".localizedExpectation,
                       "Prefix: Max".localizedValue)

        XCTAssertEqual("Prefix: Humidity".localizedExpectation,
                       "Prefix: Humidity".localizedValue)

        XCTAssertEqual("Prefix: Visibility".localizedExpectation,
                       "Prefix: Visibility".localizedValue)

        XCTAssertEqual("Prefix: Cloudiness".localizedExpectation,
                       "Prefix: Cloudiness".localizedValue)

        XCTAssertEqual("Unit: Meter".localizedExpectation,
                       "Unit: Meter".localizedValue)

        XCTAssertEqual("Unit: Kilometre".localizedExpectation,
                       "Unit: Kilometre".localizedValue)

        XCTAssertEqual("Unit: Mile".localizedExpectation,
                       "Unit: Mile".localizedValue)

        XCTAssertEqual("Unit: Foot".localizedExpectation,
                       "Unit: Foot".localizedValue)

        XCTAssertEqual("Label: Speed".localizedExpectation,
                       "Label: Speed".localizedValue)

        XCTAssertEqual("Label: Direction".localizedExpectation,
                       "Label: Direction".localizedValue)

        XCTAssertEqual("Label: Gust".localizedExpectation,
                       "Label: Gust".localizedValue)

        XCTAssertEqual("Unit: m/s".localizedExpectation,
                       "Unit: m/s".localizedValue)

        XCTAssertEqual("Unit: km/h".localizedExpectation,
                       "Unit: km/h".localizedValue)

        XCTAssertEqual("Unit: mph".localizedExpectation,
                       "Unit: mph".localizedValue)

        XCTAssertEqual("Label: Pressure".localizedExpectation,
                       "Label: Pressure".localizedValue)

        XCTAssertEqual("Unit: hPa".localizedExpectation,
                       "Unit: hPa".localizedValue)

        XCTAssertEqual("Unit: mmHg".localizedExpectation,
                       "Unit: mmHg".localizedValue)

        XCTAssertEqual("Unit: mb".localizedExpectation,
                       "Unit: mb".localizedValue)

        XCTAssertEqual("Label: Sunrise".localizedExpectation,
                       "Label: Sunrise".localizedValue)

        XCTAssertEqual("Label: Sunset".localizedExpectation,
                       "Label: Sunset".localizedValue)

        XCTAssertEqual("AM".localizedExpectation,
                       "AM".localizedValue)

        XCTAssertEqual("PM".localizedExpectation,
                       "PM".localizedValue)

        XCTAssertEqual("Postfix: Year".localizedExpectation,
                       "Postfix: Year".localizedValue)

        XCTAssertEqual("Prefix: Last One".localizedExpectation,
                       "Prefix: Last One".localizedValue)
    }

    func test_translation_of_redirect_alert() {

        // assert

        XCTAssertEqual("Redirect Alert: title".localizedExpectation,
                       "Redirect Alert: title".localizedValue)

        XCTAssertEqual("Redirect Alert: message".localizedExpectation,
                       "Redirect Alert: message".localizedValue)

        XCTAssertEqual("Redirect Alert: cancel".localizedExpectation,
                       "Redirect Alert: cancel".localizedValue)

        XCTAssertEqual("Redirect Alert: function".localizedExpectation,
                       "Redirect Alert: function".localizedValue)
    }
    // MARK: - ForecastView

    func test_translation_of_PopoverScreen_ForecastView() {

        // assert "Label: DayItem Weather Conditions"

        XCTAssertEqual("Label: DayItem Weather Conditions".localizedExpectation,
                       "Label: DayItem Weather Conditions".localizedValue)
        XCTAssertEqual("Label: Weekday short".localizedExpectation,
                       "Label: Weekday short".localizedValue)
        XCTAssertEqual("Label: Forecast Date".localizedExpectation,
                       "Label: Forecast Date".localizedValue)

        XCTAssertEqual("rain".localizedExpectation,
                       "rain".localizedValue)
        XCTAssertEqual("snow".localizedExpectation,
                       "snow".localizedValue)
        XCTAssertEqual("clear".localizedExpectation,
                       "clear".localizedValue)
    }

    // MARK: - Options Screen

    func test_translation_of_OptionsScreen() {

        // assert

        XCTAssertEqual("Title: Options Screen".localizedExpectation,
                       "Title: Options Screen".localizedValue)

        XCTAssertEqual("Section: App Options".localizedExpectation,
                       "Section: App Options".localizedValue)

        XCTAssertEqual("Section: Meteo Options".localizedExpectation,
                       "Section: Meteo Options".localizedValue)

        XCTAssertEqual("Option: Language".localizedExpectation,
                       "Option: Language".localizedValue)

        XCTAssertEqual("Option: OpenWeather Key".localizedExpectation,
                       "Option: OpenWeather Key".localizedValue)

        XCTAssertEqual("Option: Time Format".localizedExpectation,
                       "Option: Time Format".localizedValue)

        XCTAssertEqual("Section: Meteo Options".localizedExpectation,
                       "Section: Meteo Options".localizedValue)

        XCTAssertEqual("Option: Temperature".localizedExpectation,
                       "Option: Temperature".localizedValue)

        XCTAssertEqual("Option: Wind Speed".localizedExpectation,
                       "Option: Wind Speed".localizedValue)

        XCTAssertEqual("Option: Pressure".localizedExpectation,
                       "Option: Pressure".localizedValue)

        XCTAssertEqual("Option: Distance".localizedExpectation,
                       "Option: Distance".localizedValue)

        XCTAssertEqual("Unit: Light".localizedExpectation,
                       "Unit: Light".localizedValue)

        XCTAssertEqual("Unit: Dark".localizedExpectation,
                       "Unit: Dark".localizedValue)

        XCTAssertEqual("Unit: System".localizedExpectation,
                       "Unit: System".localizedValue)

        XCTAssertEqual("Unit: English".localizedExpectation,
                       "Unit: English".localizedValue)

        XCTAssertEqual("Unit: Russian".localizedExpectation,
                       "Unit: Russian".localizedValue)

        XCTAssertEqual("Unit: 24-hour".localizedExpectation,
                       "Unit: 24-hour".localizedValue)

        XCTAssertEqual("Unit: 12-hour".localizedExpectation,
                       "Unit: 12-hour".localizedValue)

        XCTAssertEqual("Unit: Kelvin".localizedExpectation,
                       "Unit: Kelvin".localizedValue)

        XCTAssertEqual("Unit: Celsius".localizedExpectation,
                       "Unit: Celsius".localizedValue)

        XCTAssertEqual("Unit: Fahrenheit".localizedExpectation,
                       "Unit: Fahrenheit".localizedValue)

        XCTAssertEqual("Unit: m/s long".localizedExpectation,
                       "Unit: m/s long".localizedValue)

        XCTAssertEqual("Unit: km/h long".localizedExpectation,
                       "Unit: km/h long".localizedValue)

        XCTAssertEqual("Unit: mph long".localizedExpectation,
                       "Unit: mph long".localizedValue)

        XCTAssertEqual("Unit: Kilometre long".localizedExpectation,
                       "Unit: Kilometre long".localizedValue)

        XCTAssertEqual("Unit: Mile long".localizedExpectation,
                       "Unit: Mile long".localizedValue)

        XCTAssertEqual("Button: Close".localizedExpectation,
                       "Button: Close".localizedValue)

        XCTAssertEqual("Button: Reset to Defaults".localizedExpectation,
                       "Button: Reset to Defaults".localizedValue)
    }

    func test_translation_of_OptionsScreen_SpecialOptions() {

        // assert

        XCTAssertEqual("Section: Special Options".localizedExpectation,
                       "Section: Special Options".localizedValue)

        XCTAssertEqual("OpenWeather: Lock".localizedExpectation,
                       "OpenWeather: Lock".localizedValue)

        XCTAssertEqual("OpenWeather: Unlock".localizedExpectation,
                       "OpenWeather: Unlock".localizedValue)

        XCTAssertEqual("OpenWeather: Hidden".localizedExpectation,
                       "OpenWeather: Hidden".localizedValue)

        XCTAssertEqual("OpenWeather: Editable".localizedExpectation,
                       "OpenWeather: Editable".localizedValue)

        XCTAssertEqual("Option: StatusMenus".localizedExpectation,
                       "Option: StatusMenus".localizedValue)

        XCTAssertEqual("Button: CheckBox StatusMenus".localizedExpectation,
                       "Button: CheckBox StatusMenus".localizedValue)

        XCTAssertEqual("Option: StatusMenus Update".localizedExpectation,
                       "Option: StatusMenus Update".localizedValue)

        XCTAssertEqual("StatusMenus: per 12 hours".localizedExpectation,
                       "StatusMenus: per 12 hours".localizedValue)

        XCTAssertEqual("StatusMenus: per 3 hours".localizedExpectation,
                       "StatusMenus: per 3 hours".localizedValue)

        XCTAssertEqual("StatusMenus: per hour".localizedExpectation,
                       "StatusMenus: per hour".localizedValue)

        XCTAssertEqual("StatusMenus: none".localizedExpectation,
                       "StatusMenus: none".localizedValue)
    }

    // MARK: - Compass Directions

    func test_translation_of_Compass_Directions() {

        // assert

        XCTAssertEqual("Compass: N".localizedExpectation, "Compass: N".localizedValue)
        XCTAssertEqual("Compass: NNE".localizedExpectation, "Compass: NNE".localizedValue)
        XCTAssertEqual("Compass: NE".localizedExpectation, "Compass: NE".localizedValue)
        XCTAssertEqual("Compass: ENE".localizedExpectation, "Compass: ENE".localizedValue)
        XCTAssertEqual("Compass: E".localizedExpectation, "Compass: E".localizedValue)
        XCTAssertEqual("Compass: ESE".localizedExpectation, "Compass: ESE".localizedValue)
        XCTAssertEqual("Compass: SE".localizedExpectation, "Compass: SE".localizedValue)
        XCTAssertEqual("Compass: SSE".localizedExpectation, "Compass: SSE".localizedValue)
        XCTAssertEqual("Compass: S".localizedExpectation, "Compass: S".localizedValue)
        XCTAssertEqual("Compass: SSW".localizedExpectation, "Compass: SSW".localizedValue)
        XCTAssertEqual("Compass: SW".localizedExpectation, "Compass: SW".localizedValue)
        XCTAssertEqual("Compass: WSW".localizedExpectation, "Compass: WSW".localizedValue)
        XCTAssertEqual("Compass: W".localizedExpectation, "Compass: W".localizedValue)
        XCTAssertEqual("Compass: WNW".localizedExpectation, "Compass: WNW".localizedValue)
        XCTAssertEqual("Compass: NW".localizedExpectation, "Compass: NW".localizedValue)
        XCTAssertEqual("Compass: NNW".localizedExpectation, "Compass: NNW".localizedValue)
    }

    // MARK: - Months

    func test_translation_of_Compass_Months() {

        // assert

        XCTAssertEqual("Month: December".localizedExpectation,
                       "Month: December".localizedValue)
        XCTAssertEqual("Month: January".localizedExpectation,
                       "Month: January".localizedValue)
        XCTAssertEqual("Month: February".localizedExpectation,
                       "Month: February".localizedValue)
        XCTAssertEqual("Month: March".localizedExpectation,
                       "Month: March".localizedValue)
        XCTAssertEqual("Month: April".localizedExpectation,
                       "Month: April".localizedValue)
        XCTAssertEqual("Month: May".localizedExpectation,
                       "Month: May".localizedValue)
        XCTAssertEqual("Month: June".localizedExpectation,
                       "Month: June".localizedValue)
        XCTAssertEqual("Month: Jule".localizedExpectation,
                       "Month: Jule".localizedValue)
        XCTAssertEqual("Month: August".localizedExpectation,
                       "Month: August".localizedValue)
        XCTAssertEqual("Month: September".localizedExpectation,
                       "Month: September".localizedValue)
        XCTAssertEqual("Month: October".localizedExpectation,
                       "Month: October".localizedValue)
        XCTAssertEqual("Month: November".localizedExpectation,
                       "Month: November".localizedValue)
    }

    // MARK: - Days

    func test_translation_of_the_day_of_the_week() {

        // assert

        XCTAssertEqual("Day: Sun".localizedExpectation,
                       "Day: Sun".localizedValue)
        XCTAssertEqual("Day: Mon".localizedExpectation,
                       "Day: Mon".localizedValue)
        XCTAssertEqual("Day: Tue".localizedExpectation,
                       "Day: Tue".localizedValue)
        XCTAssertEqual("Day: Wed".localizedExpectation,
                       "Day: Wed".localizedValue)
        XCTAssertEqual("Day: Thu".localizedExpectation,
                       "Day: Thu".localizedValue)
        XCTAssertEqual("Day: Fri".localizedExpectation,
                       "Day: Fri".localizedValue)
        XCTAssertEqual("Day: Sat".localizedExpectation,
                       "Day: Sat".localizedValue)
    }

    // MARK: - About Screen

    func test_translation_of_AboutScreen() {

        // assert

        XCTAssertEqual("Title: The Dark Moon".localizedExpectation,
                       "Title: The Dark Moon".localizedValue)
        XCTAssertEqual("Button: The App Source Code".localizedExpectation,
                       "Button: The App Source Code".localizedValue)
        XCTAssertEqual("Button: The Technological Tree".localizedExpectation,
                       "Button: The Technological Tree".localizedValue)
        XCTAssertEqual("Label: The App Version".localizedExpectation,
                       "Label: The App Version".localizedValue)
        XCTAssertEqual("Label: Copyright Notice".localizedExpectation,
                       "Label: Copyright Notice".localizedValue)
        XCTAssertEqual("Label: Copyright Details".localizedExpectation,
                       "Label: Copyright Details".localizedValue)
        XCTAssertEqual("Label: Credits".localizedExpectation,
                       "Label: Credits".localizedValue)
        XCTAssertEqual("Label: Balancing and Control".localizedExpectation,
                       "Label: Balancing and Control".localizedValue)
        XCTAssertEqual("Label: Writing".localizedExpectation,
                       "Label: Writing".localizedValue)
        XCTAssertEqual("Label: Documenting".localizedExpectation,
                       "Label: Documenting".localizedValue)
        XCTAssertEqual("Label: Artworking".localizedExpectation,
                       "Label: Artworking".localizedValue)
        XCTAssertEqual("Label: EN Expectation".localizedExpectation,
                       "Label: EN Expectation".localizedValue)
        XCTAssertEqual("Label: RU Expectation".localizedExpectation,
                       "Label: RU Expectation".localizedValue)
        XCTAssertEqual("Label: Author".localizedExpectation,
                       "Label: Author".localizedValue)
        XCTAssertEqual("Button: License".localizedExpectation,
                       "Button: License".localizedValue)
        XCTAssertEqual("Button: Terms & Conditions".localizedExpectation,
                       "Button: Terms & Conditions".localizedValue)
        XCTAssertEqual("Tab: Essentials".localizedExpectation,
                       "Tab: Essentials".localizedValue)
        XCTAssertEqual("Tab: Log".localizedExpectation,
                       "Tab: Log".localizedValue)
    }

    // MARK: - Weather-conditions descriptions

// swiftlint:disable:next function_body_length
    func test_translation_weather_conditions_descriptions() {

        // assert

        XCTAssertEqual("Main: clear sky".localizedExpectation,
                       "Main: clear sky".localizedValue)
        XCTAssertEqual("Main: few clouds".localizedExpectation,
                       "Main: few clouds".localizedValue)
        XCTAssertEqual("Main: scattered clouds".localizedExpectation,
                       "Main: scattered clouds".localizedValue)
        XCTAssertEqual("Main: broken clouds".localizedExpectation,
                       "Main: broken clouds".localizedValue)
        XCTAssertEqual("Main: shower rain".localizedExpectation,
                       "Main: shower rain".localizedValue)
        XCTAssertEqual("Main: rain".localizedExpectation,
                       "Main: rain".localizedValue)
        XCTAssertEqual("Main: thunderstorm".localizedExpectation,
                       "Main: thunderstorm".localizedValue)
        XCTAssertEqual("Main: snow".localizedExpectation,
                       "Main: snow".localizedValue)
        XCTAssertEqual("Main: mist".localizedExpectation,
                       "Main: mist".localizedValue)

        XCTAssertEqual("Code: thunderstormWithLightRain".localizedExpectation,
                       "Code: thunderstormWithLightRain".localizedValue)
        XCTAssertEqual("Code: thunderstormWithRain".localizedExpectation,
                       "Code: thunderstormWithRain".localizedValue)
        XCTAssertEqual("Code: thunderstormWithHeavyRain".localizedExpectation,
                       "Code: thunderstormWithHeavyRain".localizedValue)
        XCTAssertEqual("Code: lightThunderstorm".localizedExpectation,
                       "Code: lightThunderstorm".localizedValue)
        XCTAssertEqual("Code: thunderstorm".localizedExpectation,
                       "Code: thunderstorm".localizedValue)
        XCTAssertEqual("Code: heavyThunderstorm".localizedExpectation,
                       "Code: heavyThunderstorm".localizedValue)
        XCTAssertEqual("Code: raggedThunderstorm".localizedExpectation,
                       "Code: raggedThunderstorm".localizedValue)
        XCTAssertEqual("Code: thunderstormWithLightDrizzle".localizedExpectation,
                       "Code: thunderstormWithLightDrizzle".localizedValue)
        XCTAssertEqual("Code: thunderstormWithDrizzle".localizedExpectation,
                       "Code: thunderstormWithDrizzle".localizedValue)
        XCTAssertEqual("Code: thunderstormWithHeavyDrizzle".localizedExpectation,
                       "Code: thunderstormWithHeavyDrizzle".localizedValue)

        XCTAssertEqual("Code: lightIntensityDrizzle".localizedExpectation,
                       "Code: lightIntensityDrizzle".localizedValue)
        XCTAssertEqual("Code: drizzle".localizedExpectation,
                       "Code: drizzle".localizedValue)
        XCTAssertEqual("Code: heavyIntensityDrizzle".localizedExpectation,
                       "Code: heavyIntensityDrizzle".localizedValue)
        XCTAssertEqual("Code: lightIntensityDrizzleRain".localizedExpectation,
                       "Code: lightIntensityDrizzleRain".localizedValue)
        XCTAssertEqual("Code: drizzleRain".localizedExpectation,
                       "Code: drizzleRain".localizedValue)
        XCTAssertEqual("Code: heavyIntensityDrizzleRain".localizedExpectation,
                       "Code: heavyIntensityDrizzleRain".localizedValue)
        XCTAssertEqual("Code: showerRainAndDrizzle".localizedExpectation,
                       "Code: showerRainAndDrizzle".localizedValue)
        XCTAssertEqual("Code: heavyShowerRainAndDrizzle".localizedExpectation,
                       "Code: heavyShowerRainAndDrizzle".localizedValue)
        XCTAssertEqual("Code: showerDrizzle".localizedExpectation,
                       "Code: showerDrizzle".localizedValue)
        XCTAssertEqual("Code: lightRain".localizedExpectation,
                       "Code: lightRain".localizedValue)

        XCTAssertEqual("Code: moderateRain".localizedExpectation,
                       "Code: moderateRain".localizedValue)
        XCTAssertEqual("Code: heavyIntensityRain".localizedExpectation,
                       "Code: heavyIntensityRain".localizedValue)
        XCTAssertEqual("Code: veryHeavyRain".localizedExpectation,
                       "Code: veryHeavyRain".localizedValue)
        XCTAssertEqual("Code: extremeRain".localizedExpectation,
                       "Code: extremeRain".localizedValue)
        XCTAssertEqual("Code: freezingRain".localizedExpectation,
                       "Code: freezingRain".localizedValue)
        XCTAssertEqual("Code: lightIntensityShowerRain".localizedExpectation,
                       "Code: lightIntensityShowerRain".localizedValue)
        XCTAssertEqual("Code: showerRain".localizedExpectation,
                       "Code: showerRain".localizedValue)
        XCTAssertEqual("Code: heavyIntensityShowerRain".localizedExpectation,
                       "Code: heavyIntensityShowerRain".localizedValue)
        XCTAssertEqual("Code: raggedShowerRain".localizedExpectation,
                       "Code: raggedShowerRain".localizedValue)
        XCTAssertEqual("Code: lightSnow".localizedExpectation,
                       "Code: lightSnow".localizedValue)

        XCTAssertEqual("Code: snow".localizedExpectation,
                       "Code: snow".localizedValue)
        XCTAssertEqual("Code: heavySnow".localizedExpectation,
                       "Code: heavySnow".localizedValue)
        XCTAssertEqual("Code: sleet".localizedExpectation,
                       "Code: sleet".localizedValue)
        XCTAssertEqual("Code: lightShowerSleet".localizedExpectation,
                       "Code: lightShowerSleet".localizedValue)
        XCTAssertEqual("Code: showerSleet".localizedExpectation,
                       "Code: showerSleet".localizedValue)
        XCTAssertEqual("Code: lightRainAndSnow".localizedExpectation,
                       "Code: lightRainAndSnow".localizedValue)
        XCTAssertEqual("Code: rainAndSnow".localizedExpectation,
                       "Code: rainAndSnow".localizedValue)
        XCTAssertEqual("Code: lightShowerSnow".localizedExpectation,
                       "Code: lightShowerSnow".localizedValue)
        XCTAssertEqual("Code: showerSnow".localizedExpectation,
                       "Code: showerSnow".localizedValue)
        XCTAssertEqual("Code: heavyShowerSnow".localizedExpectation,
                       "Code: heavyShowerSnow".localizedValue)

        XCTAssertEqual("Code: mist".localizedExpectation,
                       "Code: mist".localizedValue)
        XCTAssertEqual("Code: smoke".localizedExpectation,
                       "Code: smoke".localizedValue)
        XCTAssertEqual("Code: haze".localizedExpectation,
                       "Code: haze".localizedValue)
        XCTAssertEqual("Code: sandDustWhirls".localizedExpectation,
                       "Code: sandDustWhirls".localizedValue)
        XCTAssertEqual("Code: fog".localizedExpectation,
                       "Code: fog".localizedValue)
        XCTAssertEqual("Code: sand".localizedExpectation,
                       "Code: sand".localizedValue)
        XCTAssertEqual("Code: dust".localizedExpectation,
                       "Code: dust".localizedValue)
        XCTAssertEqual("Code: volcanicAsh".localizedExpectation,
                       "Code: volcanicAsh".localizedValue)
        XCTAssertEqual("Code: squalls".localizedExpectation,
                       "Code: squalls".localizedValue)
        XCTAssertEqual("Code: tornado".localizedExpectation,
                       "Code: tornado".localizedValue)
        XCTAssertEqual("Code: clearSky".localizedExpectation,
                       "Code: clearSky".localizedValue)
        XCTAssertEqual("Code: fewClouds_11_25".localizedExpectation,
                       "Code: fewClouds_11_25".localizedValue)
        XCTAssertEqual("Code: scatteredClouds_25_50".localizedExpectation,
                       "Code: scatteredClouds_25_50".localizedValue)
        XCTAssertEqual("Code: brokenClouds_51_84".localizedExpectation,
                       "Code: brokenClouds_51_84".localizedValue)
        XCTAssertEqual("Code: overcastClouds_85_100".localizedExpectation,
                       "Code: overcastClouds_85_100".localizedValue)
    }
}

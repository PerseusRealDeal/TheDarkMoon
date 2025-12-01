//
//  PopoverLocalizationTests.swift
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

import XCTest
@testable import Snowman

class PopoverScreenLocalizationTests: XCTestCase {

    private var sut: PopoverViewController!

    override func setUp() {
        super.setUp()

        sut = PopoverViewController.storyboardInstance()
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_Localization_of_Popover() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertEqual(sut.buttonQuit.title,
                       "Button: Quit".localizedValue)

        XCTAssertEqual(sut.buttonFetchMeteoFacts.title,
                       "Button: Call Weather".localizedValue)

        XCTAssertEqual(sut.labelMadeWithLove.stringValue,
                       "Label: Made with Love".localizedValue)

        XCTAssertEqual(sut.tabCurrentWeather.label,
                       "Tab: Current Weather".localizedValue)

        XCTAssertEqual(sut.tabForecast.label,
                       "Tab: Forecast".localizedValue)

        XCTAssertEqual(sut.buttonAbout.title,
                       "Button: About".localizedValue)

        XCTAssertEqual(sut.buttonOptions.title,
                       "Button: Options".localizedValue)

        XCTAssertEqual(sut.buttonLogger.title,
                       "Button: Logger".localizedValue)

        XCTAssertEqual(sut.buttonHideAppScreens.title,
                       "Button: Hide".localizedValue)
    }

    func test_Localization_of_LocationView() {

        // arrange

        sut.loadView()

        // assert
/*
        XCTAssertEqual(sut.viewLocation.labelGeoCoordinates.stringValue,
                       "Geo Couple".localizedValue)
 */
        XCTAssertEqual(sut.viewLocation.labelPermissionStatus.stringValue,
                       "Label: Permission".localizedValue + ": " +
                       GeoAgent.currentStatus.localizedKey.localizedValue)
    }

    func test_Localization_of_WeatherView() {

        // arrange

        sut.loadView()

        // assert

        let title = "Label: Meteo Data Provider".localizedValue
        let nick = globals.sourceWeather.meteoDataProviderName

        XCTAssertEqual(sut.viewWeather.labelMeteoProvider.stringValue,
                       "\(title) \(nick)")

        let inFact = sut.viewWeather.labelWeatherConditionsDescriptionValue.stringValue
        XCTAssertEqual(inFact, "Label: Weather Conditions".localizedValue)

        XCTAssertEqual(sut.viewWeather.labelSunriseTitle.stringValue,
                       "Label: Sunrise".localizedValue)

        XCTAssertEqual(sut.viewWeather.labelSunsetTitle.stringValue,
                       "Label: Sunset".localizedValue)

    }

    func test_Localization_of_WeatherView_MeteoGroupView() {

        // arrange

        sut.loadView()

        // assert

        let minmaxtitle = "Prefix: Min".localizedValue + ", " + "Prefix: Max".localizedValue
        let minmaxvalue =
            "\(MeteoFactsDefaults.temperature)" + " : " + "\(MeteoFactsDefaults.temperature)"

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title1.stringValue, minmaxtitle)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value1.stringValue, minmaxvalue)

        let fltitle = "Prefix: Feels Like".localizedValue
        let flvalue = MeteoFactsDefaults.temperature

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title2.stringValue, fltitle)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value2.stringValue, flvalue)

        let vistitle = "Prefix: Visibility".localizedValue
        let visvalue = MeteoFactsDefaults.visibility

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title3.stringValue, vistitle)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value3.stringValue, visvalue)

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title4.stringValue,
                       "Label: Speed".localizedValue)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title5.stringValue,
                       "Label: Direction".localizedValue)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title6.stringValue,
                       "Label: Gust".localizedValue)

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value4.stringValue,
                       MeteoFactsDefaults.windSpeed)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value5.stringValue,
                       MeteoFactsDefaults.windDirection)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value6.stringValue,
                       MeteoFactsDefaults.windSpeed)

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title7.stringValue,
                       "Label: Pressure".localizedValue)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value7.stringValue,
                       MeteoFactsDefaults.pressure)

        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.title8.stringValue,
                       "Prefix: Humidity".localizedValue)
        XCTAssertEqual(sut.viewWeather.viewMeteoGroup.value8.stringValue,
                       MeteoFactsDefaults.humidity)

        // TODO: - Add cloudiness test
    }

    func test_Localization_of_ForecastView_MeteoGroupView() {

        // arrange

        sut.loadView()

        // assert

    }

    func test_Localization_of_ForecastView() {

        // arrange

        sut.loadView()

        // assert

        let title = "Label: Meteo Data Provider".localizedValue
        let nick = globals.sourceForecast.meteoDataProviderName

        XCTAssertEqual(sut.viewForecast.labelMeteoProvider.stringValue, "\(title) \(nick)")
    }
}

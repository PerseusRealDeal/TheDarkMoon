//
//  PopoverConnectionsTests.swift
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

class PopoverConnectionsTests: XCTestCase {

    private var sut: PopoverViewController!

    override func setUp() {
        super.setUp()

        sut = PopoverViewController.storyboardInstance()
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_ConnectionsNotNil_Popover() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.buttonQuit)

        XCTAssertNotNil(sut.viewLocation)
        XCTAssertNotNil(sut.viewWeather)
        XCTAssertNotNil(sut.viewForecast)

        XCTAssertNotNil(sut.buttonFetchMeteoFacts)
        XCTAssertNotNil(sut.labelMadeWithLove)

        XCTAssertNotNil(sut.viewTabs)
        XCTAssertNotNil(sut.tabCurrentWeather)
        XCTAssertNotNil(sut.tabForecast)

        XCTAssertNotNil(sut.buttonAbout)
        XCTAssertNotNil(sut.buttonOptions)
        XCTAssertNotNil(sut.buttonHideAppScreens)
    }

    func test_ConnectionsNotNil_LocationView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewLocation.viewContent)

        XCTAssertNotNil(sut.viewLocation.labelGeoCoordinates)
        XCTAssertNotNil(sut.viewLocation.labelPermissionStatus)

        XCTAssertNotNil(sut.viewLocation.buttonUpdateCurrentLocation)
    }

    func test_ConnectionsNotNil_WeatherView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewWeather.viewContent)

        XCTAssertNotNil(sut.viewWeather.labelMeteoProvider)

        XCTAssertNotNil(sut.viewWeather.indicator)

        XCTAssertNotNil(sut.viewWeather.viewWeatherConditionsIcon)
        XCTAssertNotNil(sut.viewWeather.labelTemperatureValue)
        XCTAssertNotNil(sut.viewWeather.labelWeatherConditionsDescriptionValue)

        XCTAssertNotNil(sut.viewWeather.labelSunriseTitle)
        XCTAssertNotNil(sut.viewWeather.labelSunriseValue)
        XCTAssertNotNil(sut.viewWeather.labelSunsetTitle)
        XCTAssertNotNil(sut.viewWeather.labelSunsetValue)
    }

    func test_ConnectionsNotNil_ForecastView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewForecast.labelMeteoProvider)

        XCTAssertNotNil(sut.viewForecast.indicator)
    }

    func test_ConnectionsNotNil_MeteoGroupView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title1)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title2)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title3)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title4)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title5)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title5)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title6)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title7)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.title9)

        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value1)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value2)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value3)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value4)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value5)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value6)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value7)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value8)
        XCTAssertNotNil(sut.viewWeather.viewMeteoGroup.value9)

        // assert

        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title1)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title2)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title3)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title4)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title5)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title5)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title6)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title7)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.title9)

        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value1)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value2)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value3)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value4)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value5)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value6)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value7)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value8)
        XCTAssertNotNil(sut.viewForecast.viewMeteoGroup.value9)
    }
}

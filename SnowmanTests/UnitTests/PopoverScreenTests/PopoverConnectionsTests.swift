//
//  PopoverConnectionsTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 PerseusRealDeal
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
        XCTAssertNotNil(sut.viewCurrentWeather)
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

        XCTAssertNotNil(sut.viewLocation.labelLocationNameValue)
        XCTAssertNotNil(sut.viewLocation.labelGeoCoupleDataValue)

        XCTAssertNotNil(sut.viewLocation.labelPermissionTitle)
        XCTAssertNotNil(sut.viewLocation.labelPermissionValue)

        XCTAssertNotNil(sut.viewLocation.buttonRefresh)
    }

    func test_ConnectionsNotNil_WeatherView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewCurrentWeather.viewContent)

        XCTAssertNotNil(sut.viewCurrentWeather.labelMeteoProviderTitle)
        XCTAssertNotNil(sut.viewCurrentWeather.labelMeteoProviderValue)

        XCTAssertNotNil(sut.viewCurrentWeather.indicator)

        XCTAssertNotNil(sut.viewCurrentWeather.viewWeatherConditionsIcon)
        XCTAssertNotNil(sut.viewCurrentWeather.labelTemperatureValue)
        XCTAssertNotNil(sut.viewCurrentWeather.labelWeatherConditionsDescriptionValue)

        XCTAssertNotNil(sut.viewCurrentWeather.labelSunriseTitle)
        XCTAssertNotNil(sut.viewCurrentWeather.labelSunriseValue)
        XCTAssertNotNil(sut.viewCurrentWeather.labelSunsetTitle)
        XCTAssertNotNil(sut.viewCurrentWeather.labelSunsetValue)
    }

    func test_ConnectionsNotNil_ForecastView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewForecast.labelMeteoProviderTitle)
        XCTAssertNotNil(sut.viewForecast.labelMeteoProviderValue)

        XCTAssertNotNil(sut.viewForecast.indicator)
    }

    func test_ConnectionsNotNil_MeteoGroupView() {

        // arrange

        sut.loadView()

        // assert

        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title1)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title2)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title3)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title4)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title5)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title5)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title6)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title7)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.title9)

        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value1)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value2)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value3)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value4)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value5)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value6)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value7)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value8)
        XCTAssertNotNil(sut.viewCurrentWeather.viewMeteoGroup.value9)

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

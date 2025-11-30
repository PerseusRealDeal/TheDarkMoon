//
//  OptionsLocalizationTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//
//  Before start unit tests, make sure that previous app's installation is removed.
//

import XCTest
@testable import Snowman

class OptionsLocalizationTests: XCTestCase {

    private var windowController: OptionsWindowController!
    private var sut: OptionsViewController!

    override func setUp() {
        super.setUp()

        windowController = OptionsWindowController.storyboardInstance()
        sut = windowController.contentViewController as? OptionsViewController
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_Localization_of_OptionsScreen() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        let title = "Title: Options Screen".localizedValue
        XCTAssertEqual(sut.view.window?.title, "Product Name".localizedValue + " — " + title)

        let theAppOptions = "Section: App Options".localizedValue
        XCTAssertEqual(sut.boxAppOptions.title, theAppOptions + ":")

        XCTAssertEqual(sut.labelDarkMode.stringValue, "Option: Dark Mode".localizedValue)
        XCTAssertEqual(sut.labelLanguage.stringValue, "Option: Language".localizedValue)
        XCTAssertEqual(sut.labelTimeFormat.stringValue, "Option: Time Format".localizedValue)

        let meteoOptions = "Section: Meteo Options".localizedValue
        XCTAssertEqual(sut.boxWeatherOptions.title, meteoOptions + ":")

        XCTAssertEqual(sut.labelTemperature.stringValue, "Option: Temperature".localizedValue)
        XCTAssertEqual(sut.labelWindSpeed.stringValue, "Option: Wind Speed".localizedValue)
        XCTAssertEqual(sut.labelPressure.stringValue, "Option: Pressure".localizedValue)
        XCTAssertEqual(sut.labelDistance.stringValue, "Option: Distance".localizedValue)

        XCTAssertEqual(sut.labelPressure.stringValue, "Option: Pressure".localizedValue)
        XCTAssertEqual(sut.labelDistance.stringValue, "Option: Distance".localizedValue)

        let specialOptions = "Section: Special Options".localizedValue
        XCTAssertEqual(sut.boxSpecialOptions.title, specialOptions + ":")

        let labelKey = "Option: OpenWeather Key".localizedValue
        XCTAssertEqual(sut.labelOpenWeatherKey.stringValue, labelKey)
        let labelStatusMenus = "Option: StatusMenus".localizedValue
        XCTAssertEqual(sut.labelStatusMenus.stringValue, labelStatusMenus)
        let labelStatusMenusUpdate = "Option: StatusMenus Update".localizedValue + ":"
        XCTAssertEqual(sut.labelStatusMenusUpdate.stringValue, labelStatusMenusUpdate)

        let checkBoxStatusMenus = "Button: CheckBox StatusMenus".localizedValue
        XCTAssertEqual(sut.checkBoxStatusMenus.title, checkBoxStatusMenus)

        XCTAssertEqual(sut.buttonClose.title, "Button: Close".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlOpenWeatherKey() {

        // arrange

        sut.loadView()
        sut.controlOpenWeatherKey.isEditable = false

        sut.localize()

        // assert

        XCTAssertEqual(sut.controlOpenWeatherKey.placeholderString,
                       "OpenWeather: Hidden".localizedValue)
        XCTAssertEqual(sut.controlUnlockButton.title, "OpenWeather: Unlock".localizedValue)

        sut.controlOpenWeatherKey.isEditable = true
        sut.localize()

        XCTAssertEqual(sut.controlOpenWeatherKey.placeholderString,
                       "OpenWeather: Editable".localizedValue)
        XCTAssertEqual(sut.controlUnlockButton.title, "OpenWeather: Lock".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlDarkMode() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlDarkMode.label(forSegment: 0), "Unit: Light".localizedValue)
        XCTAssertEqual(sut.controlDarkMode.label(forSegment: 1), "Unit: Dark".localizedValue)
        XCTAssertEqual(sut.controlDarkMode.label(forSegment: 2), "Unit: System".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlLanguage() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlLanguage.label(forSegment: 2),
                       "Unit: System".localizedValue)
        XCTAssertEqual(sut.controlLanguage.label(forSegment: 1),
                       "Unit: Russian".localizedValue)
        XCTAssertEqual(sut.controlLanguage.label(forSegment: 0),
                       "Unit: English".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlTimeFormat() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlTimeFormat.label(forSegment: 0),
                       "Unit: 24-hour".localizedValue)
        XCTAssertEqual(sut.controlTimeFormat.label(forSegment: 1),
                       "Unit: 12-hour".localizedValue)
        XCTAssertEqual(sut.controlTimeFormat.label(forSegment: 2),
                       "Unit: System".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlTemperature() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlTemperature.label(forSegment: 0),
                       "Unit: Kelvin".localizedValue + " K")
        XCTAssertEqual(sut.controlTemperature.label(forSegment: 1),
                       "Unit: Celsius".localizedValue + " °C")
        XCTAssertEqual(sut.controlTemperature.label(forSegment: 2),
                       "Unit: Fahrenheit".localizedValue + " °F")
    }

    func test_Localization_of_OptionsScreen_controlWindSpeed() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlWindSpeed.label(forSegment: 0),
                       "Unit: m/s long".localizedValue)
        XCTAssertEqual(sut.controlWindSpeed.label(forSegment: 1),
                       "Unit: km/h long".localizedValue)
        XCTAssertEqual(sut.controlWindSpeed.label(forSegment: 2),
                       "Unit: mph long".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlPressure() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlPressure.label(forSegment: 0), "Unit: hPa".localizedValue)
        XCTAssertEqual(sut.controlPressure.label(forSegment: 1), "Unit: mmHg".localizedValue)
        XCTAssertEqual(sut.controlPressure.label(forSegment: 2), "Unit: mb".localizedValue)
    }

    func test_Localization_of_OptionsScreen_controlDistance() {

        // arrange

        sut.loadView()
        sut.localize()

        // assert

        XCTAssertEqual(sut.controlDistance.label(forSegment: 0),
                       "Unit: Kilometre long".localizedValue)
        XCTAssertEqual(sut.controlDistance.label(forSegment: 1),
                       "Unit: Mile long".localizedValue)
    }
}

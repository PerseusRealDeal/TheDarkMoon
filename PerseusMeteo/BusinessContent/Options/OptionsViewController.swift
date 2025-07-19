//
//  OptionsViewController.swift, OptionsWindowController.storyboard
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7532 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

import Cocoa

class OptionsViewController: NSViewController, NSTextFieldDelegate {

    // MARK: - Outlets

    @IBOutlet private(set) weak var controlAppOptionsSection: NSBox!
    @IBOutlet private(set) weak var controlWeatherOptionsSection: NSBox!
    @IBOutlet private(set) weak var controlCloseButton: NSButton!

    @IBOutlet private(set) weak var labelDarkMode: NSTextField!
    @IBOutlet private(set) weak var labelLanguage: NSTextField!
    @IBOutlet private(set) weak var labelTimeFormat: NSTextField!
    @IBOutlet private(set) weak var labelOpenWeatherKey: NSTextField!

    @IBOutlet private(set) weak var controlDarkMode: NSSegmentedControl!
    @IBOutlet private(set) weak var controlLanguage: NSSegmentedControl!
    @IBOutlet private(set) weak var controlTimeFormat: NSSegmentedControl!
    @IBOutlet private(set) weak var controlOpenWeatherKey: NSTextField!
    @IBOutlet private(set) weak var controlUnlockButton: NSButton!

    @IBOutlet private(set) weak var labelTemperature: NSTextField!
    @IBOutlet private(set) weak var labelWindSpeed: NSTextField!
    @IBOutlet private(set) weak var labelPressure: NSTextField!
    @IBOutlet private(set) weak var labelDistance: NSTextField!

    @IBOutlet private(set) weak var controlTemperature: NSSegmentedControl!
    @IBOutlet private(set) weak var controlWindSpeed: NSSegmentedControl!
    @IBOutlet private(set) weak var controlPressure: NSSegmentedControl!
    @IBOutlet private(set) weak var controlDistance: NSSegmentedControl!

    // MARK: - Actions

    @IBAction func controlDarkModeDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlDarkMode.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            DarkModeAgent.force(.off)
        case 1:
            DarkModeAgent.force(.on)
        case 2:
            DarkModeAgent.force(.auto)
        default:
            break
        }
    }

    @IBAction func controlLanguageDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlLanguage.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            AppOptions.languageOption = .en
        case 1:
            AppOptions.languageOption = .ru
        case 2:
            AppOptions.languageOption = .system
        default:
            break
        }

        globals.languageSwitcher.switchLanguageIfNeeded(AppOptions.languageOption)
    }

    @IBAction func controlTimeFormatDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlTimeFormat.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            AppOptions.timeFormatOption = .hour24
        case 1:
            AppOptions.timeFormatOption = .hour12
        case 2:
            AppOptions.timeFormatOption = .system
        default:
            break
        }

        let nc = AppGlobals.notificationCenter
        nc.post(Notification.init(name: .meteoDataOptionsDidChanged))
    }

    @IBAction func controlUnlockButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function) - \(controlUnlockButton.stringValue)")

        if self.controlOpenWeatherKey.isEditable {
            lockOpenWeatherKeyHole()
        } else {
            let secret = AppOptions.OpenWeatherAPIOption
            if let secret = secret {
                unlockOpenWeatherKeyHole(stringValue: secret)
            }
        }
    }

    @IBAction func controlTemperatureDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlTemperature.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            AppOptions.temperatureOption = .standard
        case 1:
            AppOptions.temperatureOption = .metric
        case 2:
            AppOptions.temperatureOption = .imperial
        default:
            break
        }

        let nc = AppGlobals.notificationCenter
        nc.post(Notification.init(name: .meteoDataOptionsDidChanged))
    }

    @IBAction func controlWindSpeedDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlWindSpeed.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            AppOptions.windSpeedOption = .ms
        case 1:
            AppOptions.windSpeedOption = .kmh
        case 2:
            AppOptions.windSpeedOption = .mph
        default:
            break
        }

        let nc = AppGlobals.notificationCenter
        nc.post(Notification.init(name: .meteoDataOptionsDidChanged))
    }

    @IBAction func controlPressureDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlPressure.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            AppOptions.pressureOption = .hPa
        case 1:
            AppOptions.pressureOption = .mmHg
        case 2:
            AppOptions.pressureOption = .mb
        default:
            break
        }

        let nc = AppGlobals.notificationCenter
        nc.post(Notification.init(name: .meteoDataOptionsDidChanged))
    }

    @IBAction func controlDistanceDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlDistance.selectedSegment)")

        switch sender.selectedSegment {
        case 0:
            AppOptions.distanceOption = .kilometre
        case 1:
            AppOptions.distanceOption = .mile
        default:
            break
        }

        let nc = AppGlobals.notificationCenter
        nc.post(Notification.init(name: .meteoDataOptionsDidChanged))
    }

    @IBAction func closeOptionsWindow(_ sender: NSButton) {
        statusMenusButtonPresenter.screenOptions.close()
    }

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        log.message("[\(type(of: self))].\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        log.message("[\(type(of: self))].\(#function)")

        // Setup content options.

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        if #unavailable(macOS 10.14) { // For HighSierra only.
            controlAppOptionsSection.isTransparent = true
            controlWeatherOptionsSection.isTransparent = true
        }

        controlOpenWeatherKey.delegate = self

        lockOpenWeatherKeyHole()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        log.message("[\(type(of: self))].\(#function)")

        updateControlDarkMode()
        updateControlLanguage()
        updateControlTimeFormat()

        updateControlTemperature()
        updateControlWindSpeed()
        updateControlPressure()
        updateControlDistance()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        log.message("[\(type(of: self))].\(#function)")

        lockOpenWeatherKeyHole()
    }

    // MARK: - Events

    func controlTextDidChange(_ obj: Notification) {
        log.message("[\(type(of: self))].\(#function)")

        guard let tf = obj.object as? NSTextField else { return }

        var text = tf.stringValue
        let limit = OPEN_WEATHER_API_KEY_TEXT_LIMIT

        log.message("[\(type(of: self))].\(#function) count: \(text.count)")

        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            text.removeSubrange(index..<text.endIndex)

            tf.stringValue = text
        }

        AppOptions.OpenWeatherAPIOption = tf.stringValue
        if let secret = AppOptions.OpenWeatherAPIOption {
            controlOpenWeatherKey.stringValue = secret
        } else {
            lockOpenWeatherKeyHole()
        }
    }

    // MARK: - Realization

    private func updateControlDarkMode() {
        log.message("[\(type(of: self))].\(#function) \(DarkModeAgent.DarkModeUserChoice)")

        switch DarkModeAgent.DarkModeUserChoice {
        case .auto:
            controlDarkMode.selectedSegment = 2
        case .on:
            controlDarkMode.selectedSegment = 1
        case .off:
            controlDarkMode.selectedSegment = 0
        }
    }

    private func updateControlLanguage() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.languageOption)")

        switch AppOptions.languageOption {
        case .system:
            controlLanguage.selectedSegment = 2
        case .ru:
            controlLanguage.selectedSegment = 1
        case .en:
            controlLanguage.selectedSegment = 0
        }
    }

    private func lockOpenWeatherKeyHole() {
        controlOpenWeatherKey.isEditable = false

        controlOpenWeatherKey.stringValue = ""
        controlOpenWeatherKey.placeholderString = "OpenWeather: Hidden".localizedValue

        controlUnlockButton.title = "OpenWeather: Unlock".localizedValue
    }

    private func unlockOpenWeatherKeyHole(stringValue: String = "") {
        controlOpenWeatherKey.isEditable = true

        if stringValue.isEmpty {
            controlOpenWeatherKey.stringValue = ""
            controlOpenWeatherKey.placeholderString = "OpenWeather: Editable".localizedValue
        } else {
            controlOpenWeatherKey.stringValue = stringValue
        }

        controlUnlockButton.title = "OpenWeather: Lock".localizedValue
    }

    private func updateControlTemperature() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.temperatureOption)")

        switch AppOptions.temperatureOption {
        case .imperial:
            controlTemperature.selectedSegment = 2
        case .metric:
            controlTemperature.selectedSegment = 1
        case .standard:
            controlTemperature.selectedSegment = 0
        }
    }

    private func updateControlWindSpeed() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.windSpeedOption)")

        switch AppOptions.windSpeedOption {
        case .mph:
            controlWindSpeed.selectedSegment = 2
        case .kmh:
            controlWindSpeed.selectedSegment = 1
        case .ms:
            controlWindSpeed.selectedSegment = 0
        }
    }

    private func updateControlPressure() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.pressureOption)")

        switch AppOptions.pressureOption {
        case .mb:
            controlPressure.selectedSegment = 2
        case .mmHg:
            controlPressure.selectedSegment = 1
        case .hPa:
            controlPressure.selectedSegment = 0
        }
    }

    private func updateControlTimeFormat() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.timeFormatOption)")

        switch AppOptions.timeFormatOption {
        case .system:
            controlTimeFormat.selectedSegment = 2
        case .hour12:
            controlTimeFormat.selectedSegment = 1
        case .hour24:
            controlTimeFormat.selectedSegment = 0
        }
    }

    private func updateControlDistance() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.distanceOption)")

        switch AppOptions.distanceOption {
        case .mile:
            controlDistance.selectedSegment = 1
        case .kilometre:
            controlDistance.selectedSegment = 0
        default:
            controlDistance.isEnabled = false
        }
    }
}

// MARK: - Extensions

extension OptionsViewController {

    // MARK: - Localization

    public func localize() {
        log.message("[\(type(of: self))].\(#function)")

        self.view.window?.title = self.windowTitleLocalized

        controlAppOptionsSection.title = "Section: App Options".localizedValue + ":"

        labelDarkMode.stringValue = "Option: Dark Mode".localizedValue
        labelLanguage.stringValue = "Option: Language".localizedValue
        labelOpenWeatherKey.stringValue = "Option: OpenWeather Key".localizedValue
        labelTimeFormat.stringValue = "Option: Time Format".localizedValue

        controlWeatherOptionsSection.title = "Section: Meteo Options".localizedValue + ":"

        labelTemperature.stringValue = "Option: Temperature".localizedValue
        labelWindSpeed.stringValue = "Option: Wind Speed".localizedValue
        labelPressure.stringValue = "Option: Pressure".localizedValue
        labelDistance.stringValue = "Option: Distance".localizedValue

        controlOpenWeatherKey.placeholderString = controlOpenWeatherKey.isEditable ?
            "OpenWeather: Editable".localizedValue :
            "OpenWeather: Hidden".localizedValue

        controlUnlockButton.title = controlOpenWeatherKey.isEditable ?
            "OpenWeather: Lock".localizedValue :
            "OpenWeather: Unlock".localizedValue

        controlDarkMode.setLabel("Unit: Light".localizedValue, forSegment: 0)
        controlDarkMode.setLabel("Unit: Dark".localizedValue, forSegment: 1)
        controlDarkMode.setLabel("Unit: System".localizedValue, forSegment: 2)

        controlLanguage.setLabel("Unit: System".localizedValue, forSegment: 2)
        controlLanguage.setLabel("Unit: Russian".localizedValue, forSegment: 1)
        controlLanguage.setLabel("Unit: English".localizedValue, forSegment: 0)

        controlTimeFormat.setLabel("Unit: 24-hour".localizedValue, forSegment: 0)
        controlTimeFormat.setLabel("Unit: 12-hour".localizedValue, forSegment: 1)
        controlTimeFormat.setLabel("Unit: System".localizedValue, forSegment: 2)

        controlTemperature.setLabel("Unit: Kelvin".localizedValue + " K", forSegment: 0)
        controlTemperature.setLabel("Unit: Celsius".localizedValue + " °C", forSegment: 1)
        controlTemperature.setLabel("Unit: Fahrenheit".localizedValue + " °F", forSegment: 2)

        controlWindSpeed.setLabel("Unit: m/s long".localizedValue, forSegment: 0)
        controlWindSpeed.setLabel("Unit: km/h long".localizedValue, forSegment: 1)
        controlWindSpeed.setLabel("Unit: mph long".localizedValue, forSegment: 2)

        controlPressure.setLabel("Unit: hPa".localizedValue, forSegment: 0)
        controlPressure.setLabel("Unit: mmHg".localizedValue, forSegment: 1)
        controlPressure.setLabel("Unit: mb".localizedValue, forSegment: 2)

        controlDistance.setLabel("Unit: Kilometre long".localizedValue, forSegment: 0)
        controlDistance.setLabel("Unit: Mile long".localizedValue, forSegment: 1)

        controlCloseButton.title = "Button: Close".localizedValue
    }

    private var windowTitleLocalized: String {
        return "Product Name".localizedValue + " — " + "Title: Options Screen".localizedValue
    }
}

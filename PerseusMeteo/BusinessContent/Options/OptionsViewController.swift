//
//  OptionsViewController.swift, OptionsWindowController.storyboard
//  PerseusMeteo
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
// swiftlint:disable file_length
//

import Cocoa

class OptionsViewController: NSViewController, NSTextFieldDelegate {

    // MARK: - Presenter

    var presenter: OptionsViewPresenter?

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        log.message("[\(type(of: self))].\(#function)")

        // Setup content options.

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        log.message("[\(type(of: self))].\(#function)")

        presenter?.viewDidAppear()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()

        log.message("[\(type(of: self))].\(#function)")

        presenter?.viewWillDisappear()
    }

    // MARK: - Outlets

    @IBOutlet private(set) weak var boxAppOptions: NSBox!
    @IBOutlet private(set) weak var boxWeatherOptions: NSBox!
    @IBOutlet private(set) weak var boxSpecialOptions: NSBox!

    @IBOutlet private(set) weak var buttonClose: NSButton!
    @IBOutlet private(set) weak var buttonResetAllSettings: NSButton!

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

    @IBOutlet private(set) weak var labelCurrentWeatherStatusMenus: NSTextField!
    @IBOutlet private(set) weak var labelStatusMenusUpdate: NSTextField!
    @IBOutlet private(set) weak var checkBoxCurrentWeatherStatusMenus: NSButton!
    @IBOutlet private(set) weak var comboBoxStatusMenusUpdatePeriod: NSComboBox!

    @IBOutlet private(set) weak var labelStatusMenus: NSTextField!
    @IBOutlet private(set) weak var labelSecondLine: NSTextField!
    @IBOutlet private(set) weak var labelToolTip: NSTextField!

    @IBOutlet private(set) weak var buttonInfo: NSButton!
    @IBOutlet private(set) weak var checkBoxTwoLines: NSButton!
    @IBOutlet private(set) weak var comboBoxSecondLine: NSComboBox!
    @IBOutlet private(set) weak var comboBoxToolTipLeft: NSComboBox!
    @IBOutlet private(set) weak var comboBoxToolTipRight: NSComboBox!

    // MARK: - Actions

    @IBAction func closeOptionsWindow(_ sender: NSButton) {
        Coordinator.shared.screenOptions.close()
    }

    @IBAction func resetAllSettingsTapped(_ sender: NSButton) {
        presenter?.resetToDefaults()
    }

    @IBAction func controlDarkModeDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlDarkMode.selectedSegment)")
        presenter?.forceDarkMode(sender.selectedSegment)
    }

    @IBAction func controlLanguageDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlLanguage.selectedSegment)")
        presenter?.forceLanguage(sender.selectedSegment)
    }

    @IBAction func controlTimeFormatDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlTimeFormat.selectedSegment)")
        presenter?.forceTimeFormat(sender.selectedSegment)
    }

    @IBAction func controlTemperatureDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlTemperature.selectedSegment)")
        presenter?.forceTemperatureUnit(sender.selectedSegment)
    }

    @IBAction func controlWindSpeedDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlWindSpeed.selectedSegment)")
        presenter?.forceWindSpeedUnit(sender.selectedSegment)
    }

    @IBAction func controlPressureDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlPressure.selectedSegment)")
        presenter?.forcePressureUnit(sender.selectedSegment)
    }

    @IBAction func controlDistanceDidChanged(_ sender: NSSegmentedControl) {
        log.message("[\(type(of: self))].\(#function) - \(controlDistance.selectedSegment)")
        presenter?.forceDistanceUnit(sender.selectedSegment)
    }

    @IBAction func checkBoxStatusMenusDidChanged(_ sender: NSButton) {
        let state = checkBoxCurrentWeatherStatusMenus.state
        log.message("[\(type(of: self))].\(#function) - \(state)")

        let isEnabled = sender.state == .on ? true : false

        presenter?.forceStatusMenus(isEnabled)
        comboBoxStatusMenusUpdatePeriod.isEnabled = isEnabled
    }

    @IBAction func comboBoxStatusMenusUpdatePeriodDidChanged(_ sender: NSComboBox) {
        let index = comboBoxStatusMenusUpdatePeriod.indexOfSelectedItem
        log.message("[\(type(of: self))].\(#function) - \(index)")

        presenter?.forceStatusMenusUpdatePeriod(sender.indexOfSelectedItem)
    }

    @IBAction func checkBoxTwoLinesDidChanged(_ sender: NSButton) {
        let state = checkBoxTwoLines.state
        log.message("[\(type(of: self))].\(#function) - \(state)")

        let isEnabled = sender.state == .on ? true : false
        presenter?.forceStatusMenusTwoLines(isEnabled)
    }

    @IBAction func comboBoxSecondLineDidChanged(_ sender: NSComboBox) {
        let index = comboBoxStatusMenusUpdatePeriod.indexOfSelectedItem
        log.message("[\(type(of: self))].\(#function) - \(index)")

        presenter?.forceStatusMenusSecondLine(sender.indexOfSelectedItem)
    }

    @IBAction func comboBoxToolTipLeftDidChanged(_ sender: NSComboBox) {
        let index = comboBoxStatusMenusUpdatePeriod.indexOfSelectedItem
        log.message("[\(type(of: self))].\(#function) - \(index)")

        presenter?.forceStatusMenusToolTipLeft(sender.indexOfSelectedItem)
    }

    @IBAction func comboBoxToolTipRightDidChanged(_ sender: NSComboBox) {
        let index = comboBoxStatusMenusUpdatePeriod.indexOfSelectedItem
        log.message("[\(type(of: self))].\(#function) - \(index)")

        presenter?.forceStatusMenusToolTipRight(sender.indexOfSelectedItem)
    }

    // MARK: - OpenWeatherKey Input

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
}

// MARK: - MVP View

extension OptionsViewController: OptionsViewDelegate {

    // MARK: - OptionsViewDelegate

    func onViewWillDisappear() {
        lockOpenWeatherKeyHole()
    }

    func onViewDidAppear() {
        refreshUI()
    }

    func refreshStatusMenusOptions() {
        udpateComboBoxStatusMenusUpdatePeriod()
        updateStatusMenusViewOptions()
    }

    // MARK: - MVPViewDelegate

    func setupUI() {

        log.message("[\(type(of: self))].\(#function)")

        controlOpenWeatherKey.delegate = self

        if isHighSierra {

            boxAppOptions.isTransparent = true
            boxWeatherOptions.isTransparent = true
            boxSpecialOptions.isTransparent = true

        }

        if isLegacy == false {
            buttonInfo.isHidden = true
        }

        lockOpenWeatherKeyHole()
    }

    func makeUp() {

        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        // view.layer?.backgroundColor = NSColor.perseusBlue.cgColor

        if isHighSierra {
            view.window?.appearance = DarkModeAgent.DarkModeUserChoice == .on ?
            DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE
        }
    }

    func localize() {

        log.message("[\(type(of: self))].\(#function)")

        self.view.window?.title = self.windowTitleLocalized

        boxAppOptions.title = "Section: App Options".localizedValue + ":"

        labelDarkMode.stringValue = "Option: Dark Mode".localizedValue
        labelLanguage.stringValue = "Option: Language".localizedValue
        labelTimeFormat.stringValue = "Option: Time Format".localizedValue

        boxWeatherOptions.title = "Section: Meteo Options".localizedValue + ":"

        labelTemperature.stringValue = "Option: Temperature".localizedValue
        labelWindSpeed.stringValue = "Option: Wind Speed".localizedValue
        labelPressure.stringValue = "Option: Pressure".localizedValue
        labelDistance.stringValue = "Option: Distance".localizedValue

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

        boxSpecialOptions.title = "Section: Special Options".localizedValue + ":"

        labelOpenWeatherKey.stringValue = "Option: OpenWeather Key".localizedValue

        controlOpenWeatherKey.placeholderString = controlOpenWeatherKey.isEditable ?
            "OpenWeather: Editable".localizedValue :
            "OpenWeather: Hidden".localizedValue

        controlUnlockButton.title = controlOpenWeatherKey.isEditable ?
            "OpenWeather: Lock".localizedValue :
            "OpenWeather: Unlock".localizedValue

        labelCurrentWeatherStatusMenus.stringValue =
        "Option: CurrentWeatherStatusMenus".localizedValue

        let weatherStatusMenusUpdate = "Option: StatusMenus Update".localizedValue + ":"
        labelStatusMenusUpdate.stringValue = weatherStatusMenusUpdate
        checkBoxCurrentWeatherStatusMenus.title = "Button: CheckBox StatusMenus".localizedValue

        udpateComboBoxStatusMenusUpdatePeriod()

        labelStatusMenus.stringValue = "Option: StatusMenusView".localizedValue
        checkBoxTwoLines.title = "Button: CheckBox TwoLines".localizedValue
        labelSecondLine.stringValue = "Option: SecondLine".localizedValue + ":"
        labelToolTip.stringValue = "Option: ToolTip".localizedValue + ":"

        updateStatusMenusViewOptions()
        buttonInfo.toolTip = "Button: TwoLines Info".localizedValue

        buttonClose.title = "Button: Close".localizedValue
        buttonResetAllSettings.title = "Button: Reset to Defaults".localizedValue
    }

    private var windowTitleLocalized: String {
        return "Product Name".localizedValue + " — " + "Title: Options Screen".localizedValue
    }
}

// MARK: - Updates

extension OptionsViewController {

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

    private func udpateCheckBoxCurrentWeatherStatusMenus() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.statusMenusOption)")
        checkBoxCurrentWeatherStatusMenus.state = AppOptions.statusMenusOption ? .on : .off
    }

    private func udpateComboBoxStatusMenusUpdatePeriod() {
        log.message("[\(type(of: self))].\(#function)")
        comboBoxStatusMenusUpdatePeriod.removeAllItems()

        for item in StatusMenusUpdatePeriodOption.allCases {
            comboBoxStatusMenusUpdatePeriod.addItem(withObjectValue: "\(item)".localizedValue)
        }

        let selectedIndex = AppOptions.statusMenusPeriodOption.rawValue

        comboBoxStatusMenusUpdatePeriod.selectItem(at: selectedIndex)
        comboBoxStatusMenusUpdatePeriod.isEnabled = AppOptions.statusMenusOption
    }

    private func updateStatusMenusViewOptions() {
        log.message("[\(type(of: self))].\(#function)")
        let options = AppOptions.statusMenusViewOptions

        if isLegacy { // Legacy OS doesn't support multiline status menus items.
            checkBoxTwoLines.isEnabled = false
            comboBoxSecondLine.isEnabled = false
        }

        checkBoxTwoLines.state = options.twoLines ? .on : .off

        comboBoxSecondLine.removeAllItems()
        comboBoxToolTipLeft.removeAllItems()
        comboBoxToolTipRight.removeAllItems()

        for item in MeteoParameter.allCases {
            comboBoxSecondLine.addItem(withObjectValue: "\(item)".localizedValue)
            comboBoxToolTipLeft.addItem(withObjectValue: "\(item)".localizedValue)
            comboBoxToolTipRight.addItem(withObjectValue: "\(item)".localizedValue)
        }

        comboBoxSecondLine.selectItem(at: options.secondLine.rawValue)
        comboBoxToolTipLeft.selectItem(at: options.toolTipLeft.rawValue)
        comboBoxToolTipRight.selectItem(at: options.toolTipRight.rawValue)
    }

    private func refreshUI() {

        log.message("[\(type(of: self))].\(#function)")

        updateControlDarkMode()
        updateControlLanguage()
        updateControlTimeFormat()

        updateControlTemperature()
        updateControlWindSpeed()
        updateControlPressure()
        updateControlDistance()

        udpateCheckBoxCurrentWeatherStatusMenus()
        udpateComboBoxStatusMenusUpdatePeriod()
        updateStatusMenusViewOptions()
    }
}

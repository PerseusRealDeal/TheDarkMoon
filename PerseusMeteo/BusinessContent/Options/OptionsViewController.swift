//
//  OptionsViewController.swift, OptionsWindowController.storyboard
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
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
    @IBOutlet private(set) weak var textFieldOpenWeatherKey: NSTextField!
    @IBOutlet private(set) weak var buttonUnlockOpenWeatherKey: NSButton!

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

    @IBOutlet private(set) weak var labelCurrentProvider: NSTextField!
    @IBOutlet private(set) weak var labelForMeteoData: NSTextField!
    @IBOutlet private(set) weak var labelForGeoData: NSTextField!

    @IBOutlet private(set) weak var comboBoxForMeteoProviders: NSComboBox!
    @IBOutlet private(set) weak var comboBoxForGeoProviders: NSComboBox!

    @IBOutlet private(set) weak var labelProxy: NSTextField!
    @IBOutlet private(set) weak var labelProxyCredentials: NSTextField!
    @IBOutlet private(set) weak var checkBoxProxy: NSButton!
    @IBOutlet private(set) weak var buttonRefreshProxyConnectionStatus: NSButton!
    @IBOutlet private(set) weak var textFieldProxy: NSTextField!
    @IBOutlet private(set) weak var buttonUnlockProxyCredentials: NSButton!

    // MARK: - Actions

    @IBAction func checkBoxProxy(_ sender: NSButton) {

        let isOn = sender.state == .on ? true : false

        log.message("[\(type(of: self))].\(#function): \(isOn)", .debug, .standard)

        if isOn {
            if let credentials = AppOptions.proxyCredentials, !credentials.isEmpty {
                let config = PerseusProxyCredentials(credentials)

                AppOptions.proxyOption = true
                labelProxyCredentials.stringValue = "\(config.server):\(config.port)"

                presenter?.forceProxy(config) // Turn on proxy

                // TODO: Send end-user message?
                return
            }
        }

        checkBoxProxy.state = .off

        AppOptions.proxyOption = false
        labelProxyCredentials.stringValue = ""

        presenter?.forceProxy() // Turn off proxy

        // TODO: Send end-user message?
    }

    @IBAction func buttonRefreshProxyConnectionStatusTapped(_ sender: NSButton) {

        let isOn = AppOptions.proxyOption

        if isOn {
            if let credentials = AppOptions.proxyCredentials, !credentials.isEmpty {
                let config = PerseusProxyCredentials(credentials)
                AppOptions.proxyOption = true
                presenter?.forceProxy(config) // Turn on proxy
                labelProxyCredentials.stringValue = "\(config.server):\(config.port)"
                return
            } else {
                checkBoxProxy.state = .off // Ignore
                AppOptions.proxyOption = false
                labelProxyCredentials.stringValue = ""
                // TODO: Send end-user message?
                return
            }
        }

        AppOptions.proxyOption = false
        presenter?.forceProxy() // Turn off proxy
    }

    @IBAction func buttonUnlockProxyCredentialsTapped(_ sender: NSButton) {

        if self.textFieldProxy.isEditable {
            lockProxyTextField()
        } else {

            let secret = AppOptions.proxyCredentials

            if let secret = secret {
                unlockProxyTextField(stringValue: secret)
            }
        }
    }

    @IBAction func buttonUnlockOpenWeatherKeyTapped(_ sender: NSButton) {

        if self.textFieldOpenWeatherKey.isEditable {
            lockOpenWeatherKeyHole()
        } else {
            let secret = AppOptions.keyOpenWeatherAPIOption
            if let secret = secret {
                unlockOpenWeatherKeyHole(stringValue: secret)
            }
        }
    }

    @IBAction func closeOptionsWindow(_ sender: NSButton) {
        ContentCoordinator.shared.screenOptions.close()
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

    @IBAction func comboBoxForMeteoProvidersDidChanged(_ sender: NSComboBox) {
        let index = comboBoxForMeteoProviders.indexOfSelectedItem
        log.message("[\(type(of: self))].\(#function) - \(index)")

        presenter?.forceMeteoDataProviderSelected(sender.indexOfSelectedItem)
    }

    @IBAction func comboBoxForGeoProvidersDidChanged(_ sender: NSComboBox) {
        let index = comboBoxForGeoProviders.indexOfSelectedItem
        log.message("[\(type(of: self))].\(#function) - \(index)")

        presenter?.forceGeoDataProviderSelected(sender.indexOfSelectedItem)
    }

    // MARK: - NSTextFieldDelegate: Proxy and OpenWeatherKey

    func controlTextDidChange(_ obj: Notification) {

        log.message("[\(type(of: self))].\(#function)", .debug, .standard)

        guard
            let tf = obj.object as? NSTextField,
            let id = tf.identifier?.rawValue
        else { return }

        switch id {
        case "textFieldProxy":
            textFieldProxyDidChange(tf)
        case "textFieldOpenWeatherKey":
            textFieldOpenWeatherKeyDidChange(tf)
        default:
            return
        }
    }

    // MARK: Proxy Credentials Hole

    private func textFieldProxyDidChange(_ tf: NSTextField) {

        log.message("[\(type(of: self))].\(#function)", .debug, .standard)

        var text = tf.stringValue
        let limit = PROXY_CREDENTIALS_TEXT_LIMIT

        log.message("[\(type(of: self))].\(#function) count: \(text.count)", .debug, .standard)

        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            text.removeSubrange(index..<text.endIndex)

            tf.stringValue = text
        }

        AppOptions.proxyCredentials = tf.stringValue

        if let secret = AppOptions.proxyCredentials {
            textFieldProxy.stringValue = secret
        } else {
            lockProxyTextField()
        }
    }

    private func lockProxyTextField() {
        textFieldProxy.isEditable = false

        textFieldProxy.stringValue = ""
        textFieldProxy.placeholderString = "IP:Port:Login:Password".localizedValue

        buttonUnlockProxyCredentials.title = "Button: Unlock".localizedValue
    }

    private func unlockProxyTextField(stringValue: String = "") {
        textFieldProxy.isEditable = true

        if stringValue.isEmpty {
            textFieldProxy.stringValue = ""
            textFieldProxy.placeholderString = "IP:Port:Login:Password".localizedValue
        } else {
            textFieldProxy.stringValue = stringValue
        }

        buttonUnlockProxyCredentials.title = "Button: Lock".localizedValue
    }

    // MARK: - OpenWeather Key Hole

    private func textFieldOpenWeatherKeyDidChange(_ tf: NSTextField) {

        log.message("[\(type(of: self))].\(#function)", .debug, .standard)

        var text = tf.stringValue
        let limit = OPEN_WEATHER_API_KEY_TEXT_LIMIT

        log.message("[\(type(of: self))].\(#function) count: \(text.count)")

        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            text.removeSubrange(index..<text.endIndex)

            tf.stringValue = text
        }

        AppOptions.keyOpenWeatherAPIOption = tf.stringValue
        if let secret = AppOptions.keyOpenWeatherAPIOption {
            textFieldOpenWeatherKey.stringValue = secret
        } else {
            lockOpenWeatherKeyHole()
        }
    }

    private func lockOpenWeatherKeyHole() {
        textFieldOpenWeatherKey.isEditable = false

        textFieldOpenWeatherKey.stringValue = ""
        textFieldOpenWeatherKey.placeholderString = "OpenWeather: Hidden".localizedValue

        buttonUnlockOpenWeatherKey.title = "Button: Unlock".localizedValue
    }

    private func unlockOpenWeatherKeyHole(stringValue: String = "") {
        textFieldOpenWeatherKey.isEditable = true

        if stringValue.isEmpty {
            textFieldOpenWeatherKey.stringValue = ""
            textFieldOpenWeatherKey.placeholderString = "OpenWeather: Editable".localizedValue
        } else {
            textFieldOpenWeatherKey.stringValue = stringValue
        }

        buttonUnlockOpenWeatherKey.title = "Button: Lock".localizedValue
    }
}

// MARK: - MVP View

extension OptionsViewController: OptionsViewDelegate {

    // MARK: - OptionsViewDelegate

    func onViewWillDisappear() {
        lockOpenWeatherKeyHole()
        lockProxyTextField()
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

        textFieldOpenWeatherKey.delegate = self
        textFieldProxy.delegate = self

        if isHighSierra {

            boxAppOptions.isTransparent = true
            boxWeatherOptions.isTransparent = true
            boxSpecialOptions.isTransparent = true

        }

        if isLegacy == false {
            buttonInfo.isHidden = true
        }

        lockOpenWeatherKeyHole()
        lockProxyTextField()
    }

    func makeUp() {

        log.message("[\(type(of: self))].\(#function) DarkMode: \(DarkMode.style)")

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

        textFieldOpenWeatherKey.placeholderString = textFieldOpenWeatherKey.isEditable ?
        "OpenWeather: Editable".localizedValue : "OpenWeather: Hidden".localizedValue

        buttonUnlockOpenWeatherKey.title = textFieldOpenWeatherKey.isEditable ?
        "Button: Lock".localizedValue : "Button: Unlock".localizedValue

        buttonUnlockProxyCredentials.title = textFieldProxy.isEditable ?
        "Button: Lock".localizedValue : "Button: Unlock".localizedValue

        labelCurrentWeatherStatusMenus.stringValue =
        "Option: CurrentWeatherStatusMenus".localizedValue

        let weatherStatusMenusUpdate = "Option: StatusMenus Update".localizedValue + ":"
        labelStatusMenusUpdate.stringValue = weatherStatusMenusUpdate
        checkBoxCurrentWeatherStatusMenus.title = "Button: CheckBox StatusMenus".localizedValue

        labelProxy.stringValue = "Label: Proxy".localizedValue
        checkBoxProxy.title = ""

        udpateComboBoxStatusMenusUpdatePeriod()

        labelStatusMenus.stringValue = "Option: StatusMenusView".localizedValue
        checkBoxTwoLines.title = "Button: CheckBox TwoLines".localizedValue
        labelSecondLine.stringValue = "Option: SecondLine".localizedValue + ":"
        labelToolTip.stringValue = "Option: ToolTip".localizedValue + ":"

        updateStatusMenusViewOptions()
        buttonInfo.toolTip = "Button: TwoLines Info".localizedValue

        buttonClose.title = "Button: Close".localizedValue
        buttonResetAllSettings.title = "Button: Reset to Defaults".localizedValue

        labelCurrentProvider.stringValue = "Option: Current Provider".localizedValue
        labelForMeteoData.stringValue = "Option: For Meteo Data".localizedValue + ":"
        labelForGeoData.stringValue = "Option: For Geo Data".localizedValue + ":"

        udpateComboBoxForMeteoData()
        udpateComboBoxForGeoData()
    }

    private var windowTitleLocalized: String {
        let name = "Product Name".localizedValue
        let title = "Title: Options Screen".localizedValue
        let version = AppGlobals.theAppVersionLocalized
        return name + " — " + title + ". " + version
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

    private func udpateCheckBoxProxy() {
        log.message("[\(type(of: self))].\(#function) \(AppOptions.proxyOption)")
        checkBoxProxy.state = AppOptions.proxyOption ? .on : .off
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

    private func udpateComboBoxForMeteoData() {
        log.message("[\(type(of: self))].\(#function)")
        comboBoxForMeteoProviders.removeAllItems()

        let selectedIndex = AppOptions.currentMeteoProviderOption.rawValue

        for item in MeteoProvider.allCases {
            comboBoxForMeteoProviders.addItem(withObjectValue: "\(item.marketName)")
        }

        comboBoxForMeteoProviders.selectItem(at: selectedIndex)
    }

    private func udpateComboBoxForGeoData() {
        log.message("[\(type(of: self))].\(#function)")
        comboBoxForGeoProviders.removeAllItems()

        let selectedIndex = AppOptions.currentGeoProviderOption.rawValue

        for item in GeoCodingProvider.allCases {
            comboBoxForGeoProviders.addItem(withObjectValue: "\(item.marketName)")
        }

        comboBoxForGeoProviders.selectItem(at: selectedIndex)
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
        udpateCheckBoxProxy()

        udpateComboBoxStatusMenusUpdatePeriod()
        updateStatusMenusViewOptions()

        udpateComboBoxForMeteoData()
        udpateComboBoxForGeoData()
    }
}

//
//  PopoverViewController.swift, PopoverViewController.storyboard
//  PerseusMeteo
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
//  Special thanks for the macos-status-bar-apps tutorial goes to Gabriel Theodoropoulos.
//  https://www.appcoda.com/macos-status-bar-apps/
//
//  Special thanks for the SwiftCustomControl sample goes to Bill Waggoner.
//  https://github.com/ctgreybeard/SwiftCustomControl
//
// swiftlint:disable file_length
//

import Cocoa

public class PopoverViewController: NSViewController, NSTabViewDelegate {

    // MARK: - Internals

    private let tabCurrentWeatherID = "CurrentWeather"
    private let tabForecastID = "Forecast"

    // MARK: - Storyboard Instance

    public class func storyboardInstance() -> PopoverViewController {
        log.message("[\(type(of: self))].\(#function)")

        let sb = NSStoryboard(name: String(describing: self), bundle: nil)

        guard let screen = sb.instantiateInitialController() as? PopoverViewController else {
            let text = "[\(type(of: self))].\(#function)"
            log.message(text, .error)
            fatalError(text)
        }

        // Do default setup; don't set any parameter causing loadWindow up, breaks unit tests.

        return screen
    }

    // MARK: - Outlets

    @IBOutlet private(set) weak var buttonQuit: NSButton!
    @IBOutlet private(set) weak var labelGreeting: NSTextField!

    @IBOutlet private(set) weak var viewLocation: LocationView!
    @IBOutlet private(set) weak var viewCurrentWeather: WeatherView!
    @IBOutlet private(set) weak var viewForecast: ForecastView!

    @IBOutlet private(set) weak var buttonFetchMeteoFacts: NSButton!
    @IBOutlet private(set) weak var labelMadeWithLove: NSTextField!

    @IBOutlet private(set) weak var viewTabs: NSTabView!
    @IBOutlet private(set) weak var tabCurrentWeather: NSTabViewItem!
    @IBOutlet private(set) weak var tabForecast: NSTabViewItem!

    @IBOutlet private(set) weak var buttonAbout: NSButton!
    @IBOutlet private(set) weak var buttonOptions: NSButton!
    @IBOutlet private(set) weak var buttonHideAppScreens: NSButton!

    // MARK: - Actions

    @IBAction func quitButtonTapped(_ sender: NSButton) {
        // AppOptions.removeAll()
        AppGlobals.quitTheApp()
    }

    @IBAction func fetchMeteoFactsButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function)")
        if
            let tabSelected = viewTabs.selectedTabViewItem,
            let tabId = tabSelected.identifier as? String {

            if tabId == tabCurrentWeatherID {
                statusMenusButtonPresenter.callCurrentWeather(sender)
            } else if tabId == tabForecastID {
                statusMenusButtonPresenter.callForecast(sender)
            }
        }
    }

    @IBAction func aboutButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function)")
        statusMenusButtonPresenter.screenAbout.showWindow(sender)
    }

    @IBAction func optionsButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function)")
        statusMenusButtonPresenter.screenOptions.showWindow(sender)
    }

    @IBAction func hideAppScreensButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function)")

        guard let popover = statusMenusButtonPresenter.popover else { return }

        statusMenusButtonPresenter.screenAbout.close()
        statusMenusButtonPresenter.screenOptions.close()

        popover.performClose(sender)
    }

    public func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        log.message("[\(type(of: self))].\(#function)")
        actualizeCallingSection()
    }

    // MARK: - Initialization

    public override func awakeFromNib() {
        super.awakeFromNib()
        log.message("[\(type(of: self))].\(#function)")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        log.message("[\(type(of: self))].\(#function)")

        // Setup content size.

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        // Tabs event delegate.

        tabCurrentWeather.identifier = tabCurrentWeatherID
        tabForecast.identifier = tabForecastID

        viewTabs.delegate = self

        // Connect to Dark Mode

        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))

        // Localization, option changed event.

        let nc = AppGlobals.notificationCenter

        nc.addObserver(self, selector: #selector(localize),
                       name: NSNotification.Name.languageSwitchedManuallyNotification,
                       object: nil)

        // Meteo data, view options changed event.

        nc.addObserver(self, selector: #selector(reloadData),
                       name: NSNotification.Name.meteoDataOptionsDidChanged,
                       object: nil)

        // Appearance.

        makeUp()
        localize()

        // Forecast items selected by default.

        viewForecast.selectTheFirstForecastDay()

        // Locks hours collection scrolling, it's an issue
        // viewForecast.selectTheFirstForecastHour()
    }

    // MARK: - Contract

    @objc public func reloadData() {
        guard let weather = self.viewCurrentWeather, let forecast = self.viewForecast else {
            return
        }

        weather.reloadData()
        forecast.reloadData(saveSelection: true)

        self.actualizeCallingSection()
    }

    public func reloadCurrentWeatherData() {
        guard let weather = self.viewCurrentWeather else {
            return
        }

        weather.reloadData()
        self.actualizeCallingSection()
    }

    public func reloadForecastData() {
        guard let forecast = self.viewForecast else {
            return
        }

        forecast.reloadData(saveSelection: false)
        self.actualizeCallingSection()

        self.viewForecast.selectTheFirstForecastDay()
        self.viewForecast.selectTheFirstForecastHour()
    }

    public func startAnimationProgressIndicator(_ section: MeteoCategory,
                                                _ sender: Any? = nil) {
        switch section {
        case .current:
            viewCurrentWeather.progressIndicator = true
        case .forecast:
            viewForecast.progressIndicator = true
        }
    }

    public func stopAnimationProgressIndicator(_ section: MeteoCategory,
                                               _ sender: Any? = nil) {
        switch section {
        case .current:
            viewCurrentWeather.progressIndicator = false
        case .forecast:
            viewForecast.progressIndicator = false
        }
    }

    @objc private func makeUp() {
        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        // Subviews.

        viewLocation?.makeup()
        viewCurrentWeather?.makeup()
        viewForecast?.makeup()
    }
}

// MARK: - LOCALIZATION

extension PopoverViewController: Localizable {

    @objc func localize() {
        log.message("[\(type(of: self))].\(#function)")

        // Subviews.

        viewLocation?.localize()
        viewCurrentWeather?.localize()
        viewForecast?.localize()

        // Buttons and labels.

        buttonQuit.title = "Button: Quit".localizedValue
        labelGreeting.stringValue = "DeveloperRelease".localizedValue

        actualizeCallingSection()

        tabCurrentWeather.label = "Tab: Current Weather".localizedValue
        tabForecast.label = "Tab: Forecast".localizedValue

        buttonAbout.title = "Button: About".localizedValue
        buttonOptions.title = "Button: Options".localizedValue

        buttonHideAppScreens.title = "Button: Hide".localizedValue
    }

    private func actualizeCallingSection() {
        if
            let tabSelected = viewTabs.selectedTabViewItem,
            let tabId = tabSelected.identifier as? String {

            if tabId == tabCurrentWeatherID {
                buttonFetchMeteoFacts.title = "Button: Call Weather".localizedValue
                labelMadeWithLove.stringValue = globals.sourceCurrentWeather.lastOne
            } else if tabId == tabForecastID {
                buttonFetchMeteoFacts.title = "Button: Call Forecast".localizedValue
                labelMadeWithLove.stringValue = globals.sourceForecast.lastOne
            }
        }
    }
}

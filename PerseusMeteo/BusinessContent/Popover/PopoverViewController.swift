//
//  PopoverViewController.swift, PopoverViewController.storyboard
//  PerseusMeteo
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
//  Special thanks for the macos-status-bar-apps tutorial goes to Gabriel Theodoropoulos.
//  https://www.appcoda.com/macos-status-bar-apps/
//
//  Special thanks for the SwiftCustomControl sample goes to Bill Waggoner.
//  https://github.com/ctgreybeard/SwiftCustomControl
//
// swiftlint:disable file_length
//

import Cocoa

typealias Level = PerseusLogger.Level

public class PopoverViewController: NSViewController, NSTabViewDelegate {

    deinit {
        statusMenusPresenter.deinitTimer()
    }

    // MARK: - Internals

    private let tabCurrentWeatherID = "CurrentWeather"
    private let tabForecastID = "Forecast"

    private var updateStatusMenusItemTimer: Timer?

    // MARK: - Storyboard Instance

    public class func storyboardInstance() -> PopoverViewController {

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
    @IBOutlet private(set) weak var labelGreeting: MessageLabel!

    @IBOutlet private(set) weak var viewLocation: LocationView!
    @IBOutlet private(set) weak var viewWeather: WeatherView!
    @IBOutlet private(set) weak var viewForecast: ForecastView!

    @IBOutlet private(set) weak var buttonFetchMeteoFacts: NSButton!
    @IBOutlet private(set) weak var labelMadeWithLove: NSTextField!

    @IBOutlet private(set) weak var viewTabs: NSTabView!
    @IBOutlet private(set) weak var tabCurrentWeather: NSTabViewItem!
    @IBOutlet private(set) weak var tabForecast: NSTabViewItem!

    @IBOutlet private(set) weak var buttonAbout: NSButton!
    @IBOutlet private(set) weak var buttonOptions: NSButton!
    @IBOutlet private(set) weak var buttonLogger: NSButton!

    @IBOutlet private(set) weak var buttonHideAppScreens: NSButton!

    // MARK: - Actions

    @IBAction func quitButtonTapped(_ sender: NSButton) {
        // AppOptions.removeAll()
        AppGlobals.quitTheApp()
    }

    @IBAction func fetchMeteoFactsButtonTapped(_ sender: NSButton) {
        if viewLocation.locationCard == .current, AppGlobals.currentLocation == nil {
            let text = "Coordinates update is required".localizedValue
            log.message(text, .notice, .custom, .enduser)
            return
        }

        if
            let tabSelected = viewTabs.selectedTabViewItem,
            let tabId = tabSelected.identifier as? String {

            if tabId == tabCurrentWeatherID {
                if AppOptions.statusMenusPeriodOption == .none {
                    statusMenusPresenter.callWeather()
                } else {
                    statusMenusPresenter.startUpdateTimerIfNeeded()
                }
            } else if tabId == tabForecastID {
                statusMenusPresenter.callForecast()
            }
        }
    }

    @IBAction func aboutButtonTapped(_ sender: NSButton) {
        statusMenusPresenter.screenSelfie.showWindow(sender)
    }

    @IBAction func optionsButtonTapped(_ sender: NSButton) {
        statusMenusPresenter.screenOptions.showWindow(sender)
    }

    @IBAction func buttonLoggerTapped(_ sender: Any) {
        statusMenusPresenter.screenLogger.showWindow(sender)
    }

    @IBAction func hideAppScreensButtonTapped(_ sender: NSButton) {

        guard let popover = statusMenusPresenter.popover else { return }

        statusMenusPresenter.screenSelfie.close()
        statusMenusPresenter.screenOptions.close()

        popover.performClose(sender)
    }

    public func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        actualizeCallingSection()
    }

    // MARK: - Initialization

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Setup content size

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        // End-user messages

        report.messageDelegate = labelGreeting

        // Tabs event delegate

        tabCurrentWeather.identifier = tabCurrentWeatherID
        tabForecast.identifier = tabForecastID

        viewTabs.delegate = self

        // Dark Mode event

        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))

        // Localization event

        let nc = AppGlobals.notificationCenter

        nc.addObserver(self, selector: #selector(localize),
                       name: NSNotification.Name.languageSwitchedManuallyNotification,
                       object: nil)

        // Meteo data event

        nc.addObserver(self, selector: #selector(reloadData),
                       name: NSNotification.Name.meteoDataOptionsNotification,
                       object: nil)

        // Suggestion selected event

        nc.addObserver(self, selector: #selector(suggestionSelected(_:)),
                       name: NSNotification.Name.suggestionNotification,
                       object: nil)

        // Fovorite selected event

        nc.addObserver(self, selector: #selector(favoriteSelected(_:)),
                       name: NSNotification.Name.favoriteNotification,
                       object: nil)

        // Bookmark button tapped event (to add or remove fovorite item)

        nc.addObserver(self, selector: #selector(bookmarkTapped),
                       name: NSNotification.Name.bookmarkNotification,
                       object: nil)

        // Hide suggestions view event mark

        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) {
            SuggestionsView.shouldProcessVisisbility = true
            return $0
        }

        // Forecast items selected by default

        viewForecast.selectTheFirstForecastDay()

        // TODO: ISSUE - Locks hours collection scrolling
        // viewForecast.selectTheFirstForecastHour()

        // Appearance

        makeUp()
        localize()
    }

    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        hideSuggestionsViewIfNeeded()
    }

    public override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        hideSuggestionsViewIfNeeded()
    }

    private func hideSuggestionsViewIfNeeded() {

        guard SuggestionsView.shouldProcessVisisbility else { return }
        guard self.viewLocation.viewSuggestions.alphaValue > 0.0 else { return }

        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5

                self.viewLocation.viewSuggestions.animator().alphaValue = 0.0
            }, completionHandler: {
                self.viewLocation.constraintViewSuggestionsHeight?.constant = 0
                SuggestionsView.shouldProcessVisisbility = false
            })
        }
    }

    // MARK: - Contract

    @objc public func reloadData() {
        guard let weather = self.viewWeather, let forecast = self.viewForecast else {
            return
        }

        statusMenusPresenter.reloadData()

        weather.reloadData()
        forecast.reloadData(saveSelection: true)

        self.actualizeCallingSection()
    }

    public func reloadWeatherData() {
        guard let weather = self.viewWeather else {
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
        case .weather:
            viewWeather?.progressIndicator = true
        case .forecast:
            viewForecast?.progressIndicator = true
        }
    }

    public func stopAnimationProgressIndicator(_ section: MeteoCategory,
                                               _ sender: Any? = nil) {
        switch section {
        case .weather:
            viewWeather?.progressIndicator = false
        case .forecast:
            viewForecast?.progressIndicator = false
        }
    }

    @objc private func makeUp() {
        // log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        viewLocation?.makeup()
        viewWeather?.makeup()
        viewForecast?.makeup()
    }

    @objc func suggestionSelected(_ notification: Notification) {

        SuggestionsView.shouldProcessVisisbility = true
        hideSuggestionsViewIfNeeded()

        let key = Notification.Name.suggestionNotification.rawValue

        guard let location = notification.userInfo?[key] as? Location else { return }

        AppGlobals.currentLocation = nil
        AppGlobals.suggestion = location

        AppGlobals.weather = nil
        AppGlobals.forecast = nil

        viewLocation?.locationCard = .suggestion

        viewLocation?.reloadData()
        viewWeather?.reloadData()
        viewForecast?.reloadData()

        statusMenusPresenter.reloadData()

        actualizeCallingSection()
    }

    @objc func favoriteSelected(_ notification: Notification) {
        guard
            let selectedIndex = notification.userInfo?["index"] as? Int,
            let currentIndex = AppOptions.favoriteLocationsOption.firstIndex(
                where: { $0.isOnDisplay }),
            selectedIndex < AppOptions.favoriteLocationsOption.count
        else { return }

        var userMessage = ""

        if selectedIndex != currentIndex { // Change flag isOnDisplay
            AppOptions.favoriteLocationsOption[currentIndex].isOnDisplay = false
            AppOptions.favoriteLocationsOption[selectedIndex].isOnDisplay = true
            userMessage = "Location card is switched".localizedValue
        } else {
            userMessage = "Location card is cleared".localizedValue
        }

        viewLocation?.locationCard = AppOptions.favoriteLocationsOption.first(where: {
            $0.isOnDisplay && $0.isCurrentLocation }) != nil ? .current : .favorite

        AppGlobals.currentLocation = nil
        AppGlobals.suggestion = nil

        AppGlobals.weather = nil
        AppGlobals.forecast = nil

        viewLocation?.reloadData()
        viewWeather?.reloadData()
        viewForecast?.reloadData()

        statusMenusPresenter.reloadData()

        actualizeCallingSection()

        statusMenusPresenter.startUpdateTimerIfNeeded()

        log.message(userMessage, .notice, .custom, .enduser)
    }

    @objc func bookmarkTapped() {

        log.message("[\(type(of: self))].\(#function)")

        // Add item to favorites

        if viewLocation?.locationCard == .suggestion {

            let limit = AppGlobals.favoritesLimit
            let itemsCount = AppOptions.favoriteLocationsOption.count

            if itemsCount == limit {
                let text = "Favorites are limited".localizedValue
                log.message(text, .notice, .custom, .enduser)
                return
            }

            if var suggestion = AppGlobals.suggestion,
               let favoriteIndex = AppOptions.favoriteLocationsOption.firstIndex(
                where: { $0.isOnDisplay }) {

                AppOptions.favoriteLocationsOption[favoriteIndex].isOnDisplay = false
                suggestion.isOnDisplay = true

                AppOptions.favoriteLocationsOption.append(suggestion)
                AppGlobals.suggestion = nil

                viewLocation?.locationCard = .favorite
                viewLocation?.reloadData()

                let text = "Item added to favorites".localizedValue
                log.message(text, .notice, .custom, .enduser)
            }

            return
        }

        // Remove item from favorites

        if viewLocation?.locationCard == .current {
            let text = "Current neither to add nor to remove!".localizedValue
            log.message(text, .notice, .custom, .enduser)
            return
        }

        if viewLocation?.locationCard == .favorite {

            if let removedOneIndex = AppOptions.favoriteLocationsOption.firstIndex(
                where: { $0.isOnDisplay && $0.isCurrentLocation == false }) {

                AppOptions.favoriteLocationsOption.remove(at: removedOneIndex)
                AppOptions.favoriteLocationsOption[0].isOnDisplay = true

                viewLocation?.locationCard = .current
            } else {
                return
            }

            AppGlobals.currentLocation = nil
            AppGlobals.suggestion = nil

            AppGlobals.weather = nil
            AppGlobals.forecast = nil

            viewLocation?.reloadData()
            viewWeather?.reloadData()
            viewForecast?.reloadData()

            actualizeCallingSection()

            let text = "Item removed from favorites".localizedValue
            log.message(text, .notice, .custom, .enduser)

            return
        }
    }
}

// MARK: - LOCALIZATION

extension PopoverViewController: Localizable {

    @objc func localize() {

        // Subviews

        viewLocation?.localize()
        viewWeather?.localize()
        viewForecast?.localize()

        // Buttons and labels

        buttonQuit.title = "Button: Quit".localizedValue
        labelGreeting.message = "DeveloperRelease".localizedValue

        actualizeCallingSection()

        tabCurrentWeather.label = "Tab: Current Weather".localizedValue
        tabForecast.label = "Tab: Forecast".localizedValue

        buttonAbout.title = "Button: About".localizedValue
        buttonOptions.title = "Button: Options".localizedValue
        buttonLogger.title = "Button: Logger".localizedValue

        buttonHideAppScreens.title = "Button: Hide".localizedValue
    }

    private func actualizeCallingSection() {
        if
            let tabSelected = viewTabs.selectedTabViewItem,
            let tabId = tabSelected.identifier as? String {

            if tabId == tabCurrentWeatherID {
                buttonFetchMeteoFacts.title = "Button: Call Weather".localizedValue
                labelMadeWithLove.stringValue = globals.sourceWeather.lastOne
            } else if tabId == tabForecastID {
                buttonFetchMeteoFacts.title = "Button: Call Forecast".localizedValue
                labelMadeWithLove.stringValue = globals.sourceForecast.lastOne
            }
        }
    }
}

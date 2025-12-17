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

extension PopoverViewController {

    public class func storyboardInstance() -> PopoverViewController {

        let sb = NSStoryboard(name: String(describing: self), bundle: nil)

        guard let vc = sb.instantiateInitialController() as? PopoverViewController else {
            let text = "[\(type(of: self))].\(#function)"
            log.message(text, .fault)
            fatalError(text)
        }

        vc.presenter = PopoverViewPresenter(view: vc)
        vc.presenter?.viewDidLoad()

        // Do default setup; don't set any parameter causing loadWindow up, breaks unit tests.

        return vc
    }
}

public class PopoverViewController: NSViewController {

    deinit {
        Coordinator.deinitTimer()
    }

    // MARK: - Presenter

    var presenter: PopoverViewPresenter?

    // MARK: - Internals

    private var updateStatusMenusItemTimer: Timer?

    // MARK: - Outlets

    @IBOutlet private(set) weak var buttonQuit: NSButton!

    @IBOutlet private(set) weak var labelGreeting: MessageLabel!
    @IBOutlet private(set) weak var labelMeteoProviderWebLink: WebLabel!

    @IBOutlet private(set) weak var viewLocation: LocationView!

    @IBOutlet private(set) weak var controlCallRequest: NSSegmentedControl!
    @IBOutlet private(set) weak var buttonFetchMeteoFacts: NSButton!

    @IBOutlet private(set) weak var viewWeather: WeatherView!
    @IBOutlet private(set) weak var viewForecast: ForecastView!

    @IBOutlet private(set) weak var labelMadeWithLove: NSTextField!

    @IBOutlet private(set) weak var buttonAbout: NSButton!
    @IBOutlet private(set) weak var buttonOptions: NSButton!
    @IBOutlet private(set) weak var buttonLogger: NSButton!

    @IBOutlet private(set) weak var buttonHideAppScreens: NSButton!

    // MARK: - Actions

    @IBAction func quitButtonTapped(_ sender: NSButton) {
        presenter?.performQuit()
    }

    @IBAction func fetchMeteoFactsButtonTapped(_ sender: NSButton) {
        if viewLocation.locationCard == .current, AppGlobals.currentLocation == nil {
            let text = "Coordinates update is required".localizedValue
            log.message(text, .notice, .custom, .enduser)
            return
        }

        if controlCallRequest.selectedSegment == 0 {
            presenter?.performFetchMeteo(info: .currentWeather)
        } else {
            presenter?.performFetchMeteo(info: .forecast)
        }

    }

    @IBAction func aboutButtonTapped(_ sender: NSButton) {
        Coordinator.shared.screenSelfie.showWindow(sender)
    }

    @IBAction func optionsButtonTapped(_ sender: NSButton) {
        Coordinator.shared.screenOptions.showWindow(sender)
    }

    @IBAction func buttonLoggerTapped(_ sender: Any) {
        Coordinator.shared.screenLogger.showWindow(sender)
    }

    @IBAction func hideAppScreensButtonTapped(_ sender: NSButton) {

        guard let popover = Coordinator.shared.statusMenus.popover else { return }

        Coordinator.shared.screenSelfie.close()
        Coordinator.shared.screenOptions.close()

        popover.performClose(sender)
    }

    @IBAction func controlCallRequestDidChanged(_ sender: NSSegmentedControl) {

        refreshCallInformation()

        if sender.selectedSegment == 0 {
            // Show current weather view
            /*
            DispatchQueue.main.async {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.3

                    self.viewWeather.animator().alphaValue = 1.0
                    self.viewForecast.animator().alphaValue = 0.0

                }, completionHandler: nil)
            }*/
            self.viewWeather.alphaValue = 1.0
            self.viewForecast.alphaValue = 0.0
        } else {
            // Show forecast view
            /*
            DispatchQueue.main.async {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.3

                    self.viewWeather.animator().alphaValue = 0.0
                    self.viewForecast.animator().alphaValue = 1.0

                }, completionHandler: nil)
            }*/
            self.viewWeather.alphaValue = 0.0
            self.viewForecast.alphaValue = 1.0
        }
    }

    // MARK: - Initialization

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

        viewLocation.showControls()
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

        Coordinator.shared.statusMenus.reloadData()

        weather.reloadData()
        forecast.reloadData(saveSelection: true)

        self.refreshCallInformation()
    }

    public func reloadWeatherData() {
        guard let weather = self.viewWeather else {
            return
        }

        weather.reloadData()
        self.refreshCallInformation()
    }

    public func reloadForecastData() {
        guard let forecast = self.viewForecast else {
            return
        }

        forecast.reloadData(saveSelection: false)

        self.viewForecast?.selectTheFirstForecastDay()
        self.viewForecast?.selectTheFirstForecastHour()

        self.refreshCallInformation()
    }

    public func startAnimationProgressIndicator(_ section: MeteoCategory,
                                                _ sender: Any? = nil) {
        switch section {
        case .weather:
            viewWeather?.startProgressIndicator = true
        case .forecast:
            viewForecast?.startProgressIndicator = true
        }
    }

    public func stopAnimationProgressIndicator(_ section: MeteoCategory,
                                               _ sender: Any? = nil) {
        switch section {
        case .weather:
            viewWeather?.startProgressIndicator = false
        case .forecast:
            viewForecast?.startProgressIndicator = false
        }
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
        viewForecast?.selectTheFirstForecastDay()
        viewForecast?.selectTheFirstForecastHour()

        Coordinator.shared.statusMenus.reloadData()

        refreshCallInformation()
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
        viewForecast?.selectTheFirstForecastDay()
        viewForecast?.selectTheFirstForecastHour()

        Coordinator.shared.statusMenus.reloadData()

        refreshCallInformation()

        Coordinator.startUpdateTimerIfNeeded()

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
            viewForecast?.selectTheFirstForecastDay()
            viewForecast?.selectTheFirstForecastHour()

            refreshCallInformation()

            let text = "Item removed from favorites".localizedValue
            log.message(text, .notice, .custom, .enduser)

            return
        }
    }
}

extension PopoverViewController: PopoverViewDelegate {

    // MARK: - PopoverViewDelegate

    // MARK: - MVPViewDelegate

    func setupUI() {

        log.message("[\(type(of: self))].\(#function)")

        // Setup content size

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        // End-user messages

        report.messageDelegate = labelGreeting

        // Meteo data event

        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(reloadData),
            name: NSNotification.Name.meteoDataOptionsNotification,
            object: nil
        )

        // Suggestion selected event

        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(suggestionSelected(_:)),
            name: NSNotification.Name.suggestionNotification,
            object: nil
        )

        // Fovorite selected event

        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(favoriteSelected(_:)),
            name: NSNotification.Name.favoriteNotification,
            object: nil
        )

        // Bookmark button tapped event (to add or remove fovorite item)

        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(bookmarkTapped),
            name: NSNotification.Name.bookmarkNotification,
            object: nil
        )

        // Hide suggestions view event mark

        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) {
            SuggestionsView.shouldProcessVisisbility = true
            return $0
        }

        // Current weather and forecast

        controlCallRequest.selectedSegment = 0

        viewWeather.alphaValue = 1.0
        viewWeather.isHidden = false

        viewForecast.alphaValue = 0.0
        viewForecast.isHidden = false

        // Select forecast items

        viewForecast.setupUI()

        viewForecast.selectTheFirstForecastDay()
        viewForecast.selectTheFirstForecastHour()
    }

    func makeUp() {

        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        if isHighSierra {
            view.window?.appearance = DarkModeAgent.DarkModeUserChoice == .on ?
            DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE
        }

        viewLocation?.makeup()

        viewWeather?.makeup()
        viewForecast?.makeup()
    }

    func localize() {

        log.message("[\(type(of: self))].\(#function)")

        // Subviews

        viewLocation?.localize()

        viewWeather?.localize()
        viewForecast?.localize()

        // Buttons and labels

        buttonQuit.title = "Button: Quit".localizedValue
        labelGreeting.message = "DeveloperRelease".localizedValue

        refreshCallInformation()

        controlCallRequest.setLabel("Tab: Current Weather".localizedValue, forSegment: 0)
        controlCallRequest.setLabel("Tab: Forecast".localizedValue, forSegment: 1)

        buttonAbout.title = "Button: About".localizedValue
        buttonOptions.title = "Button: Options".localizedValue
        buttonLogger.title = "Button: Logger".localizedValue

        buttonHideAppScreens.title = "Button: Hide".localizedValue
    }

    private func refreshCallInformation() {

        var provider = ""

        if controlCallRequest.selectedSegment == 0 {
            if AppGlobals.weather == nil {
                provider = AppGlobals.meteoProviderName
            } else {
                provider = globals.sourceWeather.meteoDataProviderName
            }
        } else {
            if AppGlobals.forecast == nil {
                provider = AppGlobals.meteoProviderName
            } else {
                provider = globals.sourceForecast.meteoDataProviderName
            }
        }

        let toolTip = "Label: Meteo Data Provider".localizedValue
        let toolTipLink = provider == AppGlobals.meteoProviderName ?
        linkAuthor : linkOpenWeather

        labelMeteoProviderWebLink.weblink = "\(toolTip): \(toolTipLink)"
        labelMeteoProviderWebLink.text = provider

        if controlCallRequest.selectedSegment == 0 {
            buttonFetchMeteoFacts.title = "Button: Call Weather".localizedValue
            labelMadeWithLove.stringValue = globals.sourceWeather.lastOne
        } else {
            buttonFetchMeteoFacts.title = "Button: Call Forecast".localizedValue
            labelMadeWithLove.stringValue = globals.sourceForecast.lastOne
        }
    }
}

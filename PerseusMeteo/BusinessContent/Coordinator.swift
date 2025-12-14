//
//  Coordinator.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (02.12.2025.)
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

class Coordinator {

    // MARK: - Internals

    private var meteoClientManager: MeteoClientManager?
    private var updateTimer: Timer?

    // MARK: - Screens

    lazy var screenPopover = { () -> PopoverViewController in
        return PopoverViewController.storyboardInstance()
    }()

    lazy var screenOptions = { () -> OptionsWindowController in
        return OptionsWindowController.storyboardInstance()
    }()

    lazy var screenSelfie = { () -> SelfieWindowController in
        return SelfieWindowController.storyboardInstance()
    }()

    lazy var screenLogger = { () -> LoggerWindowController in
        return LoggerWindowController.storyboardInstance()
    }()

    // MARK: - Components

    let statusMenus: StatusMenusPresenter

    // MARK: - Singletone

    static let shared = Coordinator()

    // MARK: - Initialization

    init() {

        log.message("[\(type(of: self))].\(#function)")

        statusMenus = StatusMenusPresenter()

        // Meteo data fetcher
        meteoClientManager = MeteoClientManager(presenter: statusMenus)

        // Observe StatusMenusItem events
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(Coordinator.shared.updateCurrentWeatherByTimer),
            name: NSNotification.Name.updateCurrentWeatherByTimerCommand,
            object: nil
        )
    }

    // MARK: - Contract

    static func start() {

        log.message("[\(type(of: self))].\(#function)")

        // The statements before the app's delegate called put here

        shared.statusMenus.reloadData()
    }

    static func callWeather() {
        shared.meteoClientManager?.fetchWeather()
    }

    static func callForecast() {
        shared.meteoClientManager?.fetchForecast()
    }

    static func fetchSuggestions(_ search: String) {
        shared.meteoClientManager?.fetchSuggestions(search)
    }

    static func startUpdateTimerIfNeeded() {
        shared.updateCurrentWeatherByTimer()
    }

    static func deinitTimer() {
        shared.updateTimer?.invalidate()
    }

    @objc private func updateCurrentWeatherByTimer() {

        let main = Coordinator.shared

        main.updateTimer?.invalidate()
        main.statusMenus.reloadData()

        guard
            AppOptions.statusMenusOption,
            AppOptions.statusMenusPeriodOption != .none
        else {
            return
        }

        main.updateTimer = Timer.scheduledTimer(
            withTimeInterval: AppOptions.statusMenusPeriodOption.timeInterval,
            repeats: true) { _ in
                main.meteoClientManager?.fetchWeather()
                log.message("[\(type(of: self))].\(#function) The timer fired!")
            }

        main.meteoClientManager?.fetchWeather()
    }
}

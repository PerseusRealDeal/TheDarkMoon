//
//  StatusMenusPresenter.swift
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
// swiftlint:disable file_length
//

import AppKit

public class StatusMenusPresenter {

    // MARK: - Internals

    private var meteoClientManager: MeteoClientManager?
    private var customStatusMenusItemContent: CustomStatusButtonView?
    private var updateTimer: Timer?

    private let dataSource = globals.sourceWeather
    private let theDarknessTrigger = DarkModeObserver()

    // MARK: - Popover for Status Menus Item

    public var statusItem: NSStatusItem?

    public var popover: NSPopover? {
        didSet {
            popover?.behavior = .transient
        }
    }

    // MARK: - Screens

    public lazy var screenPopover = { () -> PopoverViewController in
        return PopoverViewController.storyboardInstance()
    }()

    public lazy var screenOptions = { () -> OptionsWindowController in
        return OptionsWindowController.storyboardInstance()
    }()

    public lazy var screenAbout = { () -> AboutWindowController in
        return AboutWindowController.storyboardInstance()
    }()

    // MARK: - Initialization

    init() {

        // Localization
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(localize),
            name: NSNotification.Name.languageSwitchedManuallyNotification,
            object: nil
        )

        // Dark Mode
        theDarknessTrigger.action = { _ in self.makeUp() }

        // StatusMenus popover
        popover = NSPopover()

        // StatusMenus item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // StatusMenusItem button
        guard let button = statusItem?.button else {
            return
        }

        button.target = self
        button.action = #selector(buttonStatusItemTapped)

        // Custom StatusMenusItem view
        let newFrame = CGRect(x: 0, y: 0, width: calcWidth(), height: button.frame.height)

        button.frame = newFrame
        customStatusMenusItemContent = CustomStatusButtonView(frame: newFrame)

        if let content = customStatusMenusItemContent {
            // content.titleOneFontSize = 10
            content.titleTwoFontSize = 9
            button.addSubview(content)
        }

        // Refresh for StatusMenusItem
        refresh()

        // Update task for StatusMenusItem
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(updateStatusMenusItemTask),
            name: NSNotification.Name.updateStatusMenusItemNotification,
            object: nil
        )

        // Meteo data fetcher
        meteoClientManager = MeteoClientManager(presenter: self)
    }

    // MARK: - Contract

    public func callWeather() {
        meteoClientManager?.fetchWeather()
    }

    public func callForecast() {
        meteoClientManager?.fetchForecast()
    }

    public func fetchSuggestions(_ search: String) {
        meteoClientManager?.fetchSuggestions(search)
    }

    public func reloadData() {
        refresh()
    }

    public func startUpdateTimerIfNeeded() {
        updateStatusMenusItemTask()
    }

    public func deinitTimer() {
        updateTimer?.invalidate()
    }

    // MARK: - Internal Service

    @objc internal func buttonStatusItemTapped() {

        guard let popover = popover, let button = statusItem?.button else {
            return
        }

        if popover.isShown {
            popover.performClose(button)
            screenAbout.close()
            screenOptions.close()
        } else {
            popover.contentViewController = screenPopover
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    @objc private func updateStatusMenusItemTask() {

        reset()
        updateTimer?.invalidate()

        guard AppOptions.statusMenusOption else {
            return
        }

        let period = AppOptions.statusMenusPeriodOption.timeInterval

        updateTimer = Timer.scheduledTimer(withTimeInterval: period, repeats: true) { _ in
            self.meteoClientManager?.fetchWeather()
            log.message("The timer fired!")
        }

        meteoClientManager?.fetchWeather()
    }

    @objc private func makeUp() {
        statusMenusPresenter.popover?.appearance = DarkModeAgent.shared.style == .light ?
        LIGHT_APPEARANCE_DEFAULT_IN_USE : DARK_APPEARANCE_DEFAULT_IN_USE
    }

    @objc private func localize() {
        reset()
    }

    private func refresh() {

        if let button = statusItem?.button {
            let newFrame = CGRect(x: 0, y: 0, width: calcWidth(), height: button.frame.height)
            button.frame = newFrame
            customStatusMenusItemContent?.frame = newFrame
        }

        reset()
    }

    private func calcWidth() -> CGFloat {
        return 77.0
    }

    private func reset() {

        guard AppOptions.statusMenusOption else {
            customStatusMenusItemContent?.image = NSImage(
                named: AppGlobals.statusMenusButtonIconName
            )
            customStatusMenusItemContent?.titleOne = "P2P".localizedValue
            customStatusMenusItemContent?.titleTwo = "Product Name".localizedValue

            statusItem?.button?.toolTip = "P2P stands for Person to Person".localizedValue
            return
        }

        customStatusMenusItemContent?.image = NSImage(named: dataSource.weatherConditions.icon)

        customStatusMenusItemContent?.titleOne = dataSource.temperature
        customStatusMenusItemContent?.titleTwo = dataSource.windSpeed

        statusItem?.button?.toolTip = "\(dataSource.windDirection) \(dataSource.windGusts)"
    }
}

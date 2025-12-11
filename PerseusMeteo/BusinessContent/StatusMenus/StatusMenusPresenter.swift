//
//  StatusMenusPresenter.swift
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

import AppKit

public class StatusMenusPresenter {

    // MARK: - Internals

    private var meteoClientManager: MeteoClientManager?
    private var customStatusMenusItemContent: CustomStatusButtonView?
    private var updateTimer: Timer?

    private let dataSource = globals.sourceWeather

    private var buttonWidth: CGFloat {
        return 78.0
    }

    // MARK: - Popover for Status Menus Item

    public var statusItem: NSStatusItem?

    public var popover: NSPopover? {
        didSet {
            popover?.behavior = .transient
        }
    }

    // MARK: - Initialization

    init() {

        // Meteo data fetcher
        meteoClientManager = MeteoClientManager(presenter: self)

        // Observe localization events
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(localize),
            name: NSNotification.Name.languageSwitchedManuallyNotification,
            object: nil
        )

        // Observe StatusMenusItem events
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(updateStatusMenusItemTask),
            name: NSNotification.Name.updateStatusMenusItemNotification,
            object: nil
        )

        // StatusMenus popover
        popover = NSPopover()

        // StatusMenus item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // StatusMenusItem button
        guard let button = statusItem?.button else {
            log.message("[\(type(of: self))].\(#function) statusItem?.button is nil", .error)
            return
        }

        button.target = self
        button.action = #selector(buttonStatusItemTapped)

        if legacy == false {

            // Custom StatusMenusItem view
            let newFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: button.frame.height)

            button.frame = newFrame
            customStatusMenusItemContent = CustomStatusButtonView(frame: newFrame)

            if let content = customStatusMenusItemContent {
                content.titleOneFontSize = 10
                content.titleTwoFontSize = 9

                button.addSubview(content)
            }
        }

        // Dark Mode
        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))

        refresh()
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
        log.message("[\(type(of: self))].\(#function)")
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
            Coordinator.shared.screenSelfie.close()
            Coordinator.shared.screenOptions.close()
        } else {
            popover.contentViewController = Coordinator.shared.screenPopover
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    @objc private func updateStatusMenusItemTask() {

        log.message("[\(type(of: self))].\(#function)")

        reset()
        updateTimer?.invalidate()

        guard AppOptions.statusMenusOption, AppOptions.statusMenusPeriodOption != .none else {
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
        log.message("[\(type(of: self))].\(#function)")

        Coordinator.shared.statusMenus.popover?.appearance =
        DarkModeAgent.shared.style == .light ? LIGHT_APPEARANCE_DEFAULT_IN_USE :
        DARK_APPEARANCE_DEFAULT_IN_USE
    }

    @objc private func localize() {
        reset()
    }

    private func refresh() {
        log.message("[\(type(of: self))].\(#function)")

        if legacy == false {
            if let button = statusItem?.button {
                let newFrame = CGRect(x: 0, y: 0,
                                      width: buttonWidth,
                                      height: button.frame.height)

                button.frame = newFrame
                customStatusMenusItemContent?.frame = newFrame
            }
        }

        reset()
    }

    private func reset() {
        log.message("[\(type(of: self))].\(#function)")

        if AppOptions.statusMenusOption == false {
            if legacy {
                statusItem?.button?.imagePosition = .imageLeading
                statusItem?.button?.image = NSImage(
                    named: AppGlobals.statusMenusButtonIconName
                )

                statusItem?.button?.title = "Product Name".localizedValue
            } else {
                customStatusMenusItemContent?.image = NSImage(
                    named: AppGlobals.statusMenusButtonIconName
                )
                customStatusMenusItemContent?.titleOne = "P2P".localizedValue
                customStatusMenusItemContent?.titleTwo = "Product Name".localizedValue
            }

            statusItem?.button?.toolTip = "P2P stands for Person to Person".localizedValue
            return
        }

        let image = NSImage(named: dataSource.weatherConditions.icon)
        let temperature = dataSource.temperature

        if legacy {
            statusItem?.button?.imagePosition = .imageLeading
            statusItem?.button?.image = image
            statusItem?.button?.title = temperature
        } else {
            customStatusMenusItemContent?.image = image
            customStatusMenusItemContent?.titleOne = temperature
            customStatusMenusItemContent?.titleTwo = dataSource.windSpeed
        }

        statusItem?.button?.toolTip = "\(dataSource.windDirection), \(dataSource.windGusts)"
    }
}

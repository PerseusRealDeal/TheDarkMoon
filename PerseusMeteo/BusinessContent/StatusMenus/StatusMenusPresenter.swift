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

    private var customStatusMenusItemContent: CustomStatusButtonView?
    private let dataSource = globals.sourceWeather

    private var buttonWidth: CGFloat {
        return 78.0
    }

    private var titleTwo: String {
        return dataSource.windSpeed
    }

    private var toolTip: String {
        return "\(dataSource.windDirection), \(dataSource.windGusts)"
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

        // Observe localization events
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(localize),
            name: NSNotification.Name.languageSwitchedManuallyNotification,
            object: nil
        )

        // Observe options change events
        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(refresh),
            name: NSNotification.Name.meteoDataOptionsNotification,
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

        refresh()

        // Dark Mode
        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))
    }

    // MARK: - Contract

    public func reloadData() {
        log.message("[\(type(of: self))].\(#function)")
        refresh()
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

    @objc private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")

        Coordinator.shared.statusMenus.popover?.appearance =
        DarkModeAgent.shared.style == .light ? LIGHT_APPEARANCE_DEFAULT_IN_USE :
        DARK_APPEARANCE_DEFAULT_IN_USE
    }

    @objc private func localize() {
        log.message("[\(type(of: self))].\(#function)")
        reset()
    }

    @objc private func refresh() {
        log.message("[\(type(of: self))].\(#function)")

        reConfigureViewStructureIfNeeded()
        reset()
    }

    private func reset() {
        log.message("[\(type(of: self))].\(#function)")

        if AppOptions.statusMenusOption == false {
            if isLegacy || AppOptions.statusMenusViewOptions.twoLines == false {
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

        if isLegacy || AppOptions.statusMenusViewOptions.twoLines == false {
            statusItem?.button?.imagePosition = .imageLeading
            statusItem?.button?.image = image
            statusItem?.button?.title = temperature
        } else {
            customStatusMenusItemContent?.image = image
            customStatusMenusItemContent?.titleOne = temperature

            customStatusMenusItemContent?.titleTwo = self.titleTwo
        }

        statusItem?.button?.toolTip = self.toolTip
    }

    private func reConfigureViewStructureIfNeeded() {

        self.customStatusMenusItemContent?.removeFromSuperview()
        self.customStatusMenusItemContent = nil

        self.statusItem?.button?.image = nil
        self.statusItem?.button?.title = ""

        if // Add custom view for two line view structure
            isLegacy == false, AppOptions.statusMenusViewOptions.twoLines,
            let button = statusItem?.button {

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
    }
}

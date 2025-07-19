//
//  StatusMenusButtonPresenter.swift
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

import AppKit

public class StatusMenusButtonPresenter {

    // MARK: - Internals

    private var meteoClientManager: MeteoClientManager?
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

        // Setup the meteo client.

        meteoClientManager = MeteoClientManager(presenter: self)

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
        log.message("[\(type(of: self))].\(#function)")

        // Setup status menus button and popover.

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem?.button?.imagePosition = .imageLeft
        statusItem?.button?.image = NSImage(named: AppGlobals.statusMenusButtonIconName)
        statusItem?.button?.title = AppGlobals.statusMenusButtonTitle

        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(buttonStatusItemTapped)

        popover = NSPopover()

        // Connect to Dark Mode explicitly
        theDarknessTrigger.action = { _ in self.makeUp() }
    }

    @objc internal func buttonStatusItemTapped() {
        log.message("[\(type(of: self))].\(#function)")

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

    public func callCurrentWeather(_ sender: Any?) {
        log.message("[\(type(of: self))].\(#function)")
        meteoClientManager?.fetchCurrent(sender)
    }

    public func callForecast(_ sender: Any?) {
        log.message("[\(type(of: self))].\(#function)")
        meteoClientManager?.fetchForecast(sender)
    }

    @objc private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")
        statusMenusButtonPresenter.popover?.appearance = DarkModeAgent.shared.style == .light ?
        LIGHT_APPEARANCE_DEFAULT_IN_USE : DARK_APPEARANCE_DEFAULT_IN_USE
    }
}

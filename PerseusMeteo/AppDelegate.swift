//
//  AppDelegate.swift
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

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        log.message("[\(type(of: self))].\(#function)")

        GeoCoordinator.reloadGeoComponents()

        LanguageSwitcher.switchLanguageIfNeeded(AppOptions.languageOption)
        Coordinator.startUpdateTimerIfNeeded()

        // Observe system sleep events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(systemWillSleep),
            name: NSWorkspace.willSleepNotification,
            object: nil
        )

        // Observe system wake events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(systemDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )

        DarkModeAgent.force(DarkModeUserChoice)

        log.message("Started with business matter purpose...", .info)
    }

    @objc func systemWillSleep(_ notification: Notification) {
        log.message("[\(type(of: self))].\(#function) System is about to sleep.", .info)
        Coordinator.deinitTimer()
    }

    @objc func systemDidWake(_ notification: Notification) {
        log.message("[\(type(of: self))].\(#function) System has woken up.", .info)
        Coordinator.startUpdateTimerIfNeeded()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Unregister observers when the application terminates
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}

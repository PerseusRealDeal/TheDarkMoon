//
//  AppDelegate.swift
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7532 PerseusRealDeal
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

        DarkModeAgent.force(DarkModeUserChoice)
        GeoCoordinator.reloadGeoComponents()

        globals.languageSwitcher.switchLanguageIfNeeded(AppOptions.languageOption)

        log.message("> Ready with business matter purpose...", .info)
    }
}

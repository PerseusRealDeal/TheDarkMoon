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

class Coordinator {

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

    // MARK: - Singletone

    static let shared = Coordinator()

    // MARK: - Contract

    static func start() {

    }
}

//
//  MVPPresenter.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532 (19.11.2025).
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

// MARK: - Common MVP Business Logic (delegated)

class MVPPresenter {

    let darkModeObserver = DarkModeObserver()
    weak var view: MVPViewDelegate? // Weak reference to prevent retain cycles

    init(view: MVPViewDelegate) {
        self.view = view

        darkModeObserver.action = { _ in self.view?.makeUp() }

        AppGlobals.notificationCenter.addObserver(
            self,
            selector: #selector(self.localize),
            name: NSNotification.Name.languageSwitchedManuallyNotification,
            object: nil
        )
    }

    @objc private func localize() {
        view?.localize()
    }
}

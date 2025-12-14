//
//  PopoverViewPresenter.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (03.12.2025.)
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

// MARK: - PopoverView Communication

protocol PopoverViewDelegate: MVPViewDelegate { }

// MARK: - PopoverView Business Logic

class PopoverViewPresenter: MVPPresenter {

    // MARK: - Initialization

    init(view: PopoverViewDelegate) {
        super.init(view: view)
    }

    // MARK: - Life Circle

    func viewDidLoad() {

        log.message("[\(type(of: self))].\(#function)")

        view?.setupUI()

        view?.makeUp()
        view?.localize()
    }

    // MARK: - Business Contract

    func performQuit() {
        // AppOptions.removeAll()
        AppGlobals.quitTheApp()
    }

    func performFetchMeteo(info: OpenWeatherRequest) {

        log.message("[\(type(of: self))].\(#function)")

        switch info {
        case .currentWeather:
            if AppOptions.statusMenusPeriodOption == .none {
                Coordinator.callWeather()
            } else {
                Coordinator.startUpdateTimerIfNeeded()
            }
        case .forecast:
            Coordinator.callForecast()
        }
    }
}

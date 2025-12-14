//
//  OptionsViewPresenter.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532 (20.11.2025).
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

// MARK: - OptionsWindow Communication

protocol OptionsViewDelegate: MVPViewDelegate {

    func onViewDidAppear()
    func onViewWillDisappear()

    func refreshStatusMenusUpdatePeriod()
}

// MARK: - OptionsWindow Business Logic

class OptionsViewPresenter: MVPPresenter {

    // MARK: - Initialization

    init(view: OptionsViewDelegate) {
        super.init(view: view)
    }

    // MARK: - Life Circle

    func viewDidLoad() {

        log.message("[\(type(of: self))].\(#function)")

        guard let view = view as? OptionsViewDelegate else { return }

        view.setupUI()

        view.makeUp()
        view.localize()
    }

    func viewDidAppear() {

        log.message("[\(type(of: self))].\(#function)")

        guard let view = view as? OptionsViewDelegate else { return }

        view.onViewDidAppear()
    }

    func viewWillDisappear() {

        log.message("[\(type(of: self))].\(#function)")

        guard let view = view as? OptionsViewDelegate else { return }

        view.onViewWillDisappear()
    }

    // MARK: - Business Contract

    func forceDarkMode(_ selected: Int) {
        switch selected {
        case 0:
            DarkModeAgent.force(.off)
        case 1:
            DarkModeAgent.force(.on)
        case 2:
            DarkModeAgent.force(.auto)
        default:
            break
        }
    }

    func forceLanguage(_ selected: Int) {
        switch selected {
        case 0:
            AppOptions.languageOption = .en
        case 1:
            AppOptions.languageOption = .ru
        case 2:
            AppOptions.languageOption = .system
        default:
            return
        }

        LanguageSwitcher.switchLanguageIfNeeded(AppOptions.languageOption)
    }

    func forceTimeFormat(_ selected: Int) {
        switch selected {
        case 0:
            AppOptions.timeFormatOption = .hour24
        case 1:
            AppOptions.timeFormatOption = .hour12
        case 2:
            AppOptions.timeFormatOption = .system
        default:
            return
        }

        AppGlobals.notificationCenter.post(
            Notification.init(name: .meteoDataOptionsNotification)
        )
    }

    func forceTemperatureUnit(_ selected: Int) {
        switch selected {
        case 0:
            AppOptions.temperatureOption = .standard
        case 1:
            AppOptions.temperatureOption = .metric
        case 2:
            AppOptions.temperatureOption = .imperial
        default:
            return
        }

        AppGlobals.notificationCenter.post(
            Notification.init(name: .meteoDataOptionsNotification)
        )
    }

    func forceWindSpeedUnit(_ selected: Int) {
        switch selected {
        case 0:
            AppOptions.windSpeedOption = .ms
        case 1:
            AppOptions.windSpeedOption = .kmh
        case 2:
            AppOptions.windSpeedOption = .mph
        default:
            return
        }

        AppGlobals.notificationCenter.post(
            Notification.init(name: .meteoDataOptionsNotification)
        )
    }

    func forcePressureUnit(_ selected: Int) {
        switch selected {
        case 0:
            AppOptions.pressureOption = .hPa
        case 1:
            AppOptions.pressureOption = .mmHg
        case 2:
            AppOptions.pressureOption = .mb
        default:
            return
        }

        AppGlobals.notificationCenter.post(
            Notification.init(name: .meteoDataOptionsNotification)
        )
    }

    func forceDistanceUnit(_ selected: Int) {

        switch selected {
        case 0:
            AppOptions.distanceOption = .kilometre
        case 1:
            AppOptions.distanceOption = .mile
        default:
            return
        }

        AppGlobals.notificationCenter.post(
            Notification.init(name: .meteoDataOptionsNotification)
        )
    }

    func forceStatusMenus(_ turned: Bool) {
        AppOptions.statusMenusOption = turned
        AppGlobals.notificationCenter.post(
            Notification.init(name: .updateCurrentWeatherByTimerCommand)
        )
    }

    func forceStatusMenusUpdatePeriod(_ index: Int) {
        guard
            let period = StatusMenusUpdatePeriodOption(rawValue: index)
        else {
            (view as? OptionsViewDelegate)?.refreshStatusMenusUpdatePeriod()
            return
        }

        AppOptions.statusMenusPeriodOption = period
        AppGlobals.notificationCenter.post(
            Notification.init(name: .updateCurrentWeatherByTimerCommand)
        )
    }

    func resetToDefaults() {

        let ud = AppGlobals.userDefaults

        ud.removeObject(forKey: DARK_MODE_SETTINGS_KEY)
        ud.removeObject(forKey: LANGUAGE_OPTION_KEY)
        ud.removeObject(forKey: TEMPERATURE_OPTION_KEY)
        ud.removeObject(forKey: WINDSPEED_OPTION_KEY)
        ud.removeObject(forKey: PRESSURE_OPTION_KEY)
        ud.removeObject(forKey: TIME_OPTION_KEY)
        ud.removeObject(forKey: DISTANCE_OPTION_KEY)
        ud.removeObject(forKey: SUGGESTIONS_REQUEST_OPTION_KEY)
        ud.removeObject(forKey: STATUSMENUS_OPTION_KEY)
        ud.removeObject(forKey: STATUSMENUS_PERIOD_OPTION_KEY)

        ud.removeObject(forKey: DARK_MODE_USER_CHOICE_KEY)
        DarkModeAgent.force(DARK_MODE_USER_CHOICE_DEFAULT)

        (view as? OptionsViewDelegate)?.onViewDidAppear()

        let nc = AppGlobals.notificationCenter

        nc.post(Notification.init(name: .updateCurrentWeatherByTimerCommand))
        nc.post(Notification.init(name: .meteoDataOptionsNotification))
    }

    // MARK: - Realization

}

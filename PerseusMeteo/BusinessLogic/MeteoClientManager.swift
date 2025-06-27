//
//  MeteoClientManager.swift
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

import Foundation

import OpenWeatherAgent
import ConsolePerseusLogger

public class MeteoClientManager {

    private var theAppPresenter: StatusMenusButtonPresenter?

    private var isReadyToCall = false
    private var isReadyToCallForecast = false

    private var serviceCurrentOpenWeatherMap = OpenWeatherClient()
    private var serviceForecastOpenWeatherMap = OpenWeatherClient()

    init(presenter: StatusMenusButtonPresenter) {

        theAppPresenter = presenter

        setupCallerLogic(for: serviceCurrentOpenWeatherMap,
                         and: serviceForecastOpenWeatherMap)
    }

    private func setupCallerLogic(for current: OpenWeatherClient,
                                  and forecast: OpenWeatherClient) {

        log.message("[\(type(of: self))].\(#function)")

        // Decide what to do with data given.

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        current.onDataGiven = { response in

            DispatchQueue.main.async {
                presenter.screenPopover.stopAnimationProgressIndicator(.current)
            }

            var meteoData: Data?

            switch response {
            case .success(let data):
                meteoData = data

            case .failure(let error):
                switch error {
                case .failedRequest(let message):
                    log.message(message, .error)

                default:
                    log.message("[\(type(of: self))].\(#function) \(error)", .error)
                }
            }

            self.serviceCurrentOpenWeatherMapHandler(meteoData ?? Data())
        }

        forecast.onDataGiven = { response in

            DispatchQueue.main.async {
                presenter.screenPopover.stopAnimationProgressIndicator(.forecast)
            }

            var meteoData: Data?

            switch response {
            case .success(let data):
                meteoData = data

            case .failure(let error):
                switch error {
                case .failedRequest(let message):
                    log.message(message, .error)

                default:
                    log.message("[\(type(of: self))].\(#function) \(error)", .error)
                }
            }

            self.serviceForecastOpenWeatherMapHandler(meteoData ?? Data())
        }

        isReadyToCall = true
        isReadyToCallForecast = true
    }

    public func fetchCurrent(_ sender: Any?) {

        guard isReadyToCall else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .error)
            return
        }

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function) presenter is nil.", .error)
            return
        }

        guard let location = AppGlobals.currentLocation else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        isReadyToCall = false

        let lat = location.latitude.cut(.two).description
        let lon = location.longitude.cut(.two).description

        let lang = globals.languageSwitcher.currentAppLanguage

        let key = AppGlobals.appKeyOpenWeather.isEmpty ?
            AppOptions.OpenWeatherAPIOption ?? "" : AppGlobals.appKeyOpenWeather

        let callDetails = OpenWeatherRequestData(appid: key,
                                                 format: .currentWeather,
                                                 lat: lat,
                                                 lon: lon,
                                                 units: .imperial,
                                                 lang: .init(rawValue: lang),
                                                 mode: .json)

        log.message(callDetails.urlString)

        do {
            presenter.screenPopover.startAnimationProgressIndicator(.current)

            try serviceCurrentOpenWeatherMap.call(with: callDetails)

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            presenter.screenPopover.stopAnimationProgressIndicator(.current)

            isReadyToCall = true
        }
    }

    public func fetchForecast(_ sender: Any?) {

        guard isReadyToCallForecast else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .error)
            return
        }

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function) presenter is nil.", .error)
            return
        }

        guard let location = AppGlobals.currentLocation else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        isReadyToCallForecast = false

        let lat = location.latitude.cut(.two).description
        let lon = location.longitude.cut(.two).description

        let lang = globals.languageSwitcher.currentAppLanguage

        let key = AppGlobals.appKeyOpenWeather.isEmpty ?
            AppOptions.OpenWeatherAPIOption ?? "" : AppGlobals.appKeyOpenWeather

        var callDetails = OpenWeatherRequestData(appid: key,
                                                 format: .forecast,
                                                 lat: lat,
                                                 lon: lon,
                                                 units: .imperial,
                                                 lang: .init(rawValue: lang),
                                                 mode: .json)
        callDetails.cnt = 40

        log.message(callDetails.urlString)

        do {
            presenter.screenPopover.startAnimationProgressIndicator(.forecast)

            try serviceForecastOpenWeatherMap.call(with: callDetails)

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            presenter.screenPopover.stopAnimationProgressIndicator(.forecast)

            isReadyToCall = true
        }
    }

    // MARK: - Event handlers

    private func serviceCurrentOpenWeatherMapHandler(_ data: Data) {

        log.message("[\(type(of: self))].\(#function)")

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        // TODO: - Make no matter what order of the two following instraction below

        // Here, but for now it's matter >

        AppGlobals.weather = data
        globals.sourceCurrentWeather.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            presenter.screenPopover.stopAnimationProgressIndicator(.current)
            presenter.screenPopover.reloadCurrentWeatherData()

            self.isReadyToCall = true
        }
    }

    private func serviceForecastOpenWeatherMapHandler(_ data: Data) {

        log.message("[\(type(of: self))].\(#function)")

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        // And here, but for now it's matter >

        AppGlobals.forecast = data
        globals.sourceForecast.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            presenter.screenPopover.stopAnimationProgressIndicator(.forecast)
            presenter.screenPopover.reloadForecastData()

            self.isReadyToCallForecast = true
        }
    }
}

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

public class MeteoClientManager {

    private var theAppPresenter: StatusMenusPresenter?

    private var isReadyToCall = false
    private var isReadyToCallForecast = false

    private var serviceWeatherOpenWeatherMap = OpenWeatherClient()
    private var serviceForecastOpenWeatherMap = OpenWeatherClient()

    init(presenter: StatusMenusPresenter) {

        theAppPresenter = presenter

        setupCallerLogic(for: serviceWeatherOpenWeatherMap,
                         and: serviceForecastOpenWeatherMap)
    }

    private func setupCallerLogic(for current: OpenWeatherClient,
                                  and forecast: OpenWeatherClient) {

        // Decide what to do with data given.

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        current.onDataGiven = { response in

            DispatchQueue.main.async {
                presenter.screenPopover.stopAnimationProgressIndicator(.weather)
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

            self.serviceWeatherOpenWeatherMapHandler(meteoData ?? Data())
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

    public func fetchWeather() {

        guard isReadyToCall else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .error)
            return
        }

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function) presenter is nil.", .error)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        isReadyToCall = false

        let lat = point.latitude.cut(.two).description
        let lon = point.longitude.cut(.two).description

        let lang = globals.languageSwitcher.currentAppLanguage

        let key = AppGlobals.appKeyOpenWeather.isEmpty ?
            AppOptions.OpenWeatherAPIOption ?? "" : AppGlobals.appKeyOpenWeather

        let callDetails = OpenWeatherRequestData(appid: key,
                                                 lat: lat,
                                                 lon: lon,
                                                 units: .imperial,
                                                 lang: .init(rawValue: lang),
                                                 mode: .json)

        // log.message(callDetails.urlString)

        do {
            presenter.screenPopover.startAnimationProgressIndicator(.weather)

            try serviceWeatherOpenWeatherMap.call(with: callDetails)

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            presenter.screenPopover.stopAnimationProgressIndicator(.weather)

            isReadyToCall = true
        }
    }

    public func fetchForecast() {

        guard isReadyToCallForecast else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .error)
            return
        }

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function) presenter is nil.", .error)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        isReadyToCallForecast = false

        let lat = point.latitude.cut(.two).description
        let lon = point.longitude.cut(.two).description

        let lang = globals.languageSwitcher.currentAppLanguage

        let key = AppGlobals.appKeyOpenWeather.isEmpty ?
            AppOptions.OpenWeatherAPIOption ?? "" : AppGlobals.appKeyOpenWeather

        var callDetails = OpenWeatherRequestData(appid: key,
                                                 request: .forecast,
                                                 lat: lat,
                                                 lon: lon,
                                                 units: .imperial,
                                                 lang: .init(rawValue: lang),
                                                 mode: .json)
        callDetails.cnt = 40

        // log.message(callDetails.urlString)

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

    private func serviceWeatherOpenWeatherMapHandler(_ data: Data) {

        guard let presenter = theAppPresenter else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        // TODO: - Make no matter what order of the two following instraction below

        // Here, but for now it's matter >

        AppGlobals.weather = data

        globals.sourceWeather.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            presenter.screenPopover.stopAnimationProgressIndicator(.weather)
            presenter.screenPopover.reloadWeatherData()
            presenter.reloadData()

            self.isReadyToCall = true
        }
    }

    private func serviceForecastOpenWeatherMapHandler(_ data: Data) {

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

    private func getLocationPoint() -> GeoPoint? {

        var locationCardType: LocationCardType?

        if let type = theAppPresenter?.screenPopover.viewLocation?.locationCard {
            locationCardType = type
        } else {
            locationCardType = AppOptions.favoriteLocationsOption.first(where: {
                $0.isOnDisplay && $0.isCurrentLocation }) != nil ? .current : .favorite
        }

        guard let locationCard = locationCardType else { return nil }

        var point: GeoPoint?

        switch locationCard {
        case .suggestion:
            point = AppGlobals.suggestion?.point
        case .favorite:
            point = AppOptions.favoriteLocationsOption.first(where: { $0.isOnDisplay })?.point
        case .current:
            point = AppGlobals.currentLocation
        }

        return point
    }
}

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

import Cocoa

public class MeteoClientManager {

    private let presenter: StatusMenusPresenter

    private var isReadyToCall = false
    private var isReadyToCallForecast = false
    private var isReadyToGetSuggestions = false

    private let serviceWeatherOpenWeatherMap: OpenWeatherClient
    private let serviceForecastOpenWeatherMap: OpenWeatherClient
    private let serviceSuggestionsOpenWeatherMap: OpenWeatherClient

    init(presenter: StatusMenusPresenter) {

        log.message("[\(type(of: self))].\(#function)", .info)

        self.presenter = presenter

        serviceWeatherOpenWeatherMap = OpenWeatherClient()
        serviceForecastOpenWeatherMap = OpenWeatherClient()
        serviceSuggestionsOpenWeatherMap = OpenWeatherClient()

        configureCurrentClient()
        configureForecastClient()
        configureSuggestionsClient()

        isReadyToCall = true
        isReadyToCallForecast = true
        isReadyToGetSuggestions = true
    }

    private func configureCurrentClient() {
        serviceWeatherOpenWeatherMap.onDataGiven = { response in

            DispatchQueue.main.async {
                self.presenter.screenPopover.stopAnimationProgressIndicator(.weather)
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
    }

    private func configureForecastClient() {
        serviceForecastOpenWeatherMap.onDataGiven = { response in

            DispatchQueue.main.async {
                self.presenter.screenPopover.stopAnimationProgressIndicator(.forecast)
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
    }

    private func configureSuggestionsClient() {
        serviceSuggestionsOpenWeatherMap.onDataGiven = { response in

            DispatchQueue.main.async {

                // stopAnimationIndicator
                self.presenter.screenPopover.viewLocation.indicatorCircular?.isHidden = true
                self.presenter.screenPopover.viewLocation.indicatorCircular?.stopAnimation(nil)

                var suggestions: Data?

                switch response {
                case .success(let data):
                    suggestions = data

                case .failure(let error):
                    switch error {
                    case .failedRequest(let message):
                        log.message(message, .error)

                    default:
                        log.message("[\(type(of: self))].\(#function) \(error)", .error)
                    }
                }

                self.serviceSuggestionsOpenWeatherMapHandler(suggestions ?? Data())
            }
        }
    }

    public func fetchWeather() {

        guard isReadyToCall else {

            // TODO: Implement a timeout logic to cancel previous request

            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .error)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        let keyLoaded = AppOptions.OpenWeatherAPIOption ?? ""
        let key = keyLoaded.isEmpty ? AppGlobals.appKeyOpenWeather : keyLoaded

        guard key.isEmpty == false else {
            let message = "API key either rejected or empty".localizedValue
            log.message("[\(type(of: self))].\(#function) \(message)", .error)
            log.message(message, .notice, .custom)
            return
        }

        isReadyToCall = false

        let lat = point.latitude.cut(.two).description
        let lon = point.longitude.cut(.two).description

        let lang = globals.languageSwitcher.currentAppLanguage
        let callDetails = OpenWeatherRequestData(appid: key,
                                                 lat: lat,
                                                 lon: lon,
                                                 units: .imperial,
                                                 lang: .init(rawValue: lang),
                                                 mode: .json)

        log.message(callDetails.urlString)

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

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        let keyLoaded = AppOptions.OpenWeatherAPIOption ?? ""
        let key = keyLoaded.isEmpty ? AppGlobals.appKeyOpenWeather : keyLoaded

        guard key.isEmpty == false else {
            let message = "API key either rejected or empty".localizedValue
            log.message("[\(type(of: self))].\(#function) \(message)", .error)
            log.message(message, .notice, .custom)
            return
        }

        isReadyToCallForecast = false

        let lat = point.latitude.cut(.two).description
        let lon = point.longitude.cut(.two).description

        let lang = globals.languageSwitcher.currentAppLanguage
        var callDetails = OpenWeatherRequestData(appid: key,
                                                 request: .forecast,
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

    public func fetchSuggestions(_ search: String) {

        guard
            self.isReadyToGetSuggestions,
            search.isEmpty == false,
            let viewLocation = presenter.screenPopover.viewLocation
        else { return }

        guard AppGlobals.useSuggestionsSample == false
        else {
            viewLocation.indicatorCircular.isHidden = true
            viewLocation.indicatorCircular.stopAnimation(nil)
            serviceWeatherOpenWeatherMapHandler(Data())
            return
        }

        let keyLoaded = AppOptions.OpenWeatherAPIOption ?? ""
        let key = keyLoaded.isEmpty ? AppGlobals.appKeyOpenWeather : keyLoaded

        guard key.isEmpty == false
        else {
            let message = "API key either rejected or empty".localizedValue
            log.message("[\(type(of: self))].\(#function) \(message)", .error)
            log.message(message, .notice, .custom)
            return
        }

        self.isReadyToGetSuggestions = false

        let name = search
        let limit = 5

        let urlString = prepareDirectURLString(cityName: name, limit: limit, appid: key)
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        var preparedURL: URL?

        if let url = URL(string: urlString) {
            preparedURL = url
        } else if let encodedString = encoded, let urlEncoded = URL(string: encodedString) {
            preparedURL = urlEncoded
        }

        guard let requestURL = preparedURL
        else {

            // WRONG: URL cann't be created at all
            log.message("[\(type(of: self))].\(#function) no URL prepared", .error)

            // stopAnimationIndicator
            viewLocation.indicatorCircular.isHidden = true
            viewLocation.indicatorCircular.stopAnimation(nil)

            self.isReadyToGetSuggestions = true

            return
        }

        // startAnimationIndicator
        viewLocation.indicatorCircular.isHidden = false
        viewLocation.indicatorCircular.startAnimation(nil)

        // request
        serviceSuggestionsOpenWeatherMap.requestData(url: requestURL)
    }

    // MARK: - Event handlers

    private func serviceWeatherOpenWeatherMapHandler(_ data: Data) {

        // TODO: - Make no matter what order of the two following instraction below

        // Here, but for now it's matter >

        AppGlobals.weather = data

        globals.sourceWeather.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            self.presenter.screenPopover.stopAnimationProgressIndicator(.weather)
            self.presenter.screenPopover.reloadWeatherData()
            self.presenter.reloadData()

            self.isReadyToCall = true
        }
    }

    private func serviceForecastOpenWeatherMapHandler(_ data: Data) {

        // And here, but for now it's matter >

        AppGlobals.forecast = data
        globals.sourceForecast.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            self.presenter.screenPopover.stopAnimationProgressIndicator(.forecast)
            self.presenter.screenPopover.reloadForecastData()

            self.isReadyToCallForecast = true
        }
    }

    private func serviceSuggestionsOpenWeatherMapHandler(_ data: Data) {

        DispatchQueue.main.async {

            guard data.isEmpty == false
            else {
                return
            }

            var suggestions: [Location]?

            if AppGlobals.useSuggestionsSample {
                suggestions = prepareSuggestionsSample()
            } else {
                suggestions = prepareSuggestions(json: data)
            }

            guard
                let suggestions = suggestions,
                let viewLocation = self.presenter.screenPopover.viewLocation
            else {
                return
            }

            viewLocation.viewSuggestions.suggestionsArray = suggestions

            viewLocation.constraintViewSuggestionsHeight?.constant =
            viewLocation.viewSuggestions.heightCalculated

            viewLocation.collectionSuggestions?.reloadData()

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5

                viewLocation.viewSuggestions.animator().alphaValue = 1.0
            }, completionHandler: nil)

            self.isReadyToGetSuggestions = true
        }
    }

    private func getLocationPoint() -> GeoPoint? {

        var locationCardType: LocationCardType?

        if let type = presenter.screenPopover.viewLocation?.locationCard {
            locationCardType = type
        } else {
            locationCardType = AppOptions.favoriteLocationsOption.first(where: {
                $0.isOnDisplay && $0.isCurrentLocation }) != nil ? .current : .favorite
        }

        guard let locationCard = locationCardType
        else {
            return nil
        }

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

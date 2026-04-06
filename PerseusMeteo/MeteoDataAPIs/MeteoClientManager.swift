//
//  MeteoClientManager.swift
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2025" is the beginning of 7534.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

import Cocoa

extension PerseusNetworkClientError {

    public var endUserMessageLocalized: String {
        switch self {
        case .invalidUrl:
            return "Incorrect URL".localizedValue
        case .cancelled:
            return "Cancelled call".localizedValue
        case .notConnectedToInternet:
            return "The Internet connection offline".localizedValue
        case .timedOut:
            return "Timed out call".localizedValue
        case .statusCode404:
            return "Status 404, not found".localizedValue
        case .nilOrEmptyRequestedData:
            return "Empty data".localizedValue
        case .failedResponseStatusCode:
            return "Failed Response StatusCode".localizedValue
        case .failedResponse(let text):
            return text
        }
    }
}

public class MeteoClientManager {

    private let presenter: StatusMenusPresenter

    private let timeoutIntervalMeteoData = 10.0 // 10 sec.
    private let timeoutIntervalSuggestions = 5.0 // 5 sec.

    private let requestAttemptsForMeteo = 3 // For both current and forecast.
    private let requestAttemtsForSuggestions = 2

    private var retriesCountCurrent = 0
    private var retriesCountForecast = 0

    private var retriesCountSuggestions = 0
    private var retrySearchSuggestions = ""

    private var isReadyToCall = false
    private var isReadyToCallForecast = false
    private var isReadyToGetSuggestions = false

    private let serviceCurrentWeather = PerseusNetworkClient(URLSession.shared, "Current")
    private let serviceForecast = PerseusNetworkClient(URLSession.shared, "Forecast")
    private let serviceSuggestions = PerseusNetworkClient(URLSession.shared, "Suggestions")

    init(presenter: StatusMenusPresenter) {

        log.message("[\(type(of: self))].\(#function)", .notice)

        self.presenter = presenter

        serviceCurrentWeather.responseHandler = handleCurrent
        serviceForecast.responseHandler = handleForecast
        serviceSuggestions.responseHandler = handleSuggestions

        isReadyToCall = true
        isReadyToCallForecast = true
        isReadyToGetSuggestions = true
    }

    public func canellWeatherCall() {
        serviceCurrentWeather.cancell()
        // retriesCountCurrent = 0
    }

    public func cancellForecastCall() {
        serviceForecast.cancell()
        // retriesCountForecast = 0
    }

    public func cancellSuggestionsRquest() {
        serviceSuggestions.cancell()
        // retriesCountSuggestions = 0
    }

    public func fetchWeather() {

        guard isReadyToCall else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .notice)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil")
            return
        }

        // let keyLoaded = AppOptions.OpenWeatherAPIOption ?? ""
        // let key = keyLoaded.isEmpty ? AppGlobals.appKeyOpenWeather : keyLoaded

        let keySaved = AppGlobals.appKeyOpenWeather
        let key = keySaved.isEmpty ? AppOptions.OpenWeatherAPIOption ?? "" : keySaved

        guard key.isEmpty == false else {
            let message = "API key is either rejected or empty".localizedValue
            log.message("[\(type(of: self))].\(#function) \(message)", .error)
            log.message(message, .notice, .custom, .enduser)
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

        log.message(callDetails.urlString.replacingOccurrences(of: key, with: "###"), .notice)

        do {
            Coordinator.shared.screenPopover.startAnimationProgressIndicator(.weather)

            try serviceCurrentWeather.call(
                urlString: callDetails.urlString,
                timeout: timeoutIntervalMeteoData
            )

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)

            isReadyToCall = true
        }
    }

    public func fetchForecast() {

        guard isReadyToCallForecast else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCallForecast)", .notice)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .error)
            return
        }

        // let keyLoaded = AppOptions.OpenWeatherAPIOption ?? ""
        // let key = keyLoaded.isEmpty ? AppGlobals.appKeyOpenWeather : keyLoaded

        let keySaved = AppGlobals.appKeyOpenWeather
        let key = keySaved.isEmpty ? AppOptions.OpenWeatherAPIOption ?? "" : keySaved

        guard key.isEmpty == false else {
            let message = "API key is either rejected or empty".localizedValue
            log.message("[\(type(of: self))].\(#function) \(message)", .error)
            log.message(message, .notice, .custom, .enduser)
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

        log.message(callDetails.urlString.replacingOccurrences(of: key, with: "###"), .notice)

        do {
            Coordinator.shared.screenPopover.startAnimationProgressIndicator(.forecast)

            try serviceForecast.call(
                urlString: callDetails.urlString,
                timeout: timeoutIntervalMeteoData
            )

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)

            isReadyToCallForecast = true
        }
    }

    public func fetchSuggestions(_ search: String) {

        guard
            self.isReadyToGetSuggestions,
            search.isEmpty == false,
            let viewLocation = Coordinator.shared.screenPopover.viewLocation
        else { return }

        guard AppGlobals.useSuggestionsSample == false
        else {
            viewLocation.indicatorCircular.isHidden = true
            viewLocation.indicatorCircular.stopAnimation(nil)
            refreshCurrent(Data()) // TODO: Is it correct refresh?
            return
        }

        // let keyLoaded = AppOptions.OpenWeatherAPIOption ?? ""
        // let key = keyLoaded.isEmpty ? AppGlobals.appKeyOpenWeather : keyLoaded

        let keySaved = AppGlobals.appKeyOpenWeather
        let key = keySaved.isEmpty ? AppOptions.OpenWeatherAPIOption ?? "" : keySaved

        guard key.isEmpty == false
        else {
            let message = "API key is either rejected or empty".localizedValue
            log.message("[\(type(of: self))].\(#function) \(message)", .error)
            log.message(message, .notice, .custom, .enduser)
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

        log.message(urlString.replacingOccurrences(of: key, with: "###"), .notice)

        retrySearchSuggestions = search
        serviceSuggestions.requestData(url: requestURL, timeoutIntervalSuggestions)
    }
}

extension MeteoClientManager {

    private func handleCurrent(response: Result<Data, PerseusNetworkClientError>) {

        DispatchQueue.main.async {
            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)
        }

        var meteoData: Data?
        var errorResponse: PerseusNetworkClientError?

        self.isReadyToCall = true

        switch response {
        case .success(let data):
            meteoData = data
        case .failure(let error):
            errorResponse = error
        }

        if let error = errorResponse {

            log.message("\(error.endUserMessageLocalized)", .notice, .custom, .enduser)

            if error == .timedOut {
                if retriesCountCurrent < requestAttemptsForMeteo {

                    // Retry call current weather

                    retriesCountCurrent += 1

                    let text = "The Current Weather call retry attempt \(retriesCountCurrent)"
                    log.message(text, .info)

                    DispatchQueue.main.async {
                        self.fetchWeather()
                    }
                } else {
                    retriesCountCurrent = 0
                }

                return
            }

            retriesCountCurrent = 0

            return
        }

        guard let data = meteoData else {
            let text = "[\(type(of: self))].\(#function)"
            log.message(text + " meteoData should not be nil", .fault)
            return
        }

        refreshCurrent(data)
    }

    private func refreshCurrent(_ data: Data) {

        // TODO: - Make no matter what order for the next two statements

        AppGlobals.weather = data

        globals.sourceWeather.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)
            Coordinator.shared.screenPopover.reloadWeatherData()

            self.presenter.reloadData()
            self.isReadyToCall = true
        }
    }

    private func handleForecast(response: Result<Data, PerseusNetworkClientError>) {

        DispatchQueue.main.async {
            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)
        }

        var meteoData: Data?
        var errorResponse: PerseusNetworkClientError?

        self.isReadyToCallForecast = true

        switch response {
        case .success(let data):
            meteoData = data
        case .failure(let error):
            errorResponse = error
        }

        if let error = errorResponse {

            log.message("\(error.endUserMessageLocalized)", .notice, .custom, .enduser)

            if error == .timedOut {
                if retriesCountForecast < requestAttemptsForMeteo {

                    // Retry call forecast

                    retriesCountForecast += 1

                    let text = "The Forecast call retry attempt"
                    log.message(text + ": \(self.retriesCountSuggestions)", .info)

                    DispatchQueue.main.async {
                        self.fetchForecast()
                    }
                } else {
                    retriesCountForecast = 0
                }

                return
            }

            retriesCountForecast = 0

            return
        }

        guard let data = meteoData else {
            let text = "[\(type(of: self))].\(#function)"
            log.message(text + " meteoData should not be nil", .fault)
            return
        }

        refreshForecast(data)
    }

    private func refreshForecast(_ data: Data) {

        AppGlobals.forecast = data
        globals.sourceForecast.meteoProvider = .serviceOpenWeatherMap

        DispatchQueue.main.async {

            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)
            Coordinator.shared.screenPopover.reloadForecastData()

            self.isReadyToCallForecast = true
        }
    }

    private func handleSuggestions(response: Result<Data, PerseusNetworkClientError>) {
        DispatchQueue.main.async {

            // stopAnimationIndicator

            let indicator = Coordinator.shared.screenPopover.viewLocation.indicatorCircular

            indicator?.isHidden = true
            indicator?.stopAnimation(nil)

            self.isReadyToGetSuggestions = true

            var suggestions: Data?
            var errorResponse: PerseusNetworkClientError?

            switch response {
            case .success(let data):
                suggestions = data
            case .failure(let error):
                errorResponse = error
            }

            if let error = errorResponse {

                log.message("\(error.endUserMessageLocalized)", .notice, .custom, .enduser)

                if error == .timedOut {
                    if self.retriesCountSuggestions < self.requestAttemtsForSuggestions {

                        // Retry call suggestions

                        self.retriesCountSuggestions += 1

                        let text = "The Suggestions call retry attempt"
                        log.message(text + ": \(self.retriesCountSuggestions)", .info)

                        DispatchQueue.main.async {
                            self.fetchSuggestions(self.retrySearchSuggestions)
                        }
                    } else {
                        self.retrySearchSuggestions = ""
                        self.retriesCountSuggestions = 0
                    }

                    return
                }

                self.retrySearchSuggestions = ""
                self.retriesCountSuggestions = 0

                return
            }

            guard let data = suggestions else {
                let text = "[\(type(of: self))].\(#function)"
                log.message(text + " meteoData should not be nil", .fault)
                return
            }

            self.refreshSuggestions(data)
        }
    }

    private func refreshSuggestions(_ data: Data) {

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
                let viewLocation = Coordinator.shared.screenPopover.viewLocation
            else {
                return
            }

            viewLocation.viewSuggestions.suggestionsArray = suggestions

            viewLocation.constraintViewSuggestionsHeight?.constant =
            viewLocation.viewSuggestions.heightCalculated

            viewLocation.collectionSuggestions?.reloadData()
            viewLocation.hideControlsIfLegacy()

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5

                viewLocation.viewSuggestions.animator().alphaValue = 1.0
            }, completionHandler: nil)

            self.isReadyToGetSuggestions = true
        }
    }

    private func getLocationPoint() -> GeoPoint? {

        var locationCardType: LocationCardType?

        if let type = Coordinator.shared.screenPopover.viewLocation?.locationCard {
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

//
//  MeteoClientManager.swift
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

import Cocoa

public class MeteoClientManager {

    private let statusMenusPresenter: StatusMenusPresenter

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

    private let serviceCurrentWeather =
    PerseusNetworkClient(URLSession.shared, "Current")
    private let serviceForecast =
    PerseusNetworkClient(URLSession.shared, "Forecast")

    private let serviceOpenMeteoSuggestions =
    PerseusNetworkClient(URLSession.shared, "OpenMeteoSuggestions")
    private let serviceOpenWeatherSuggestions =
    PerseusNetworkClient(URLSession.shared, "OpenWeatherSuggestions")

    init(presenter: StatusMenusPresenter) {

        log.message("[\(type(of: self))].\(#function)", .notice)

        self.statusMenusPresenter = presenter

        serviceCurrentWeather.responseHandler = handleCurrent
        serviceForecast.responseHandler = handleForecast

        serviceOpenMeteoSuggestions.responseHandler = handleOpenMeteoSuggestions
        serviceOpenWeatherSuggestions.responseHandler = handleOpenWeatherSuggestions

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

    public func cancellSuggestionsRequest() {

        log.message("[\(type(of: self))].\(#function)")

        serviceOpenMeteoSuggestions.cancell()
        serviceOpenWeatherSuggestions.cancell()

        self.retrySearchSuggestions = ""
        self.retriesCountSuggestions = 0

        self.isReadyToGetSuggestions = true

        // stopAnimationIndicator

        let viewLocation = ContentCoordinator.shared.screenPopover.viewLocation

        viewLocation?.indicatorCircular.isHidden = true
        viewLocation?.indicatorCircular.stopAnimation(nil)
    }

    public func fetchWeather() {

        guard isReadyToCall else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .notice)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil", .notice)
            return
        }

        // let keyLoaded = AppOptions.keyOpenWeatherAPIOption ?? ""
        // let key = keyLoaded.isEmpty ? AppGlobals.keyOpenWeatherAPI : keyLoaded

        let keySaved = AppGlobals.keyOpenWeatherAPI
        let key = keySaved.isEmpty ? AppOptions.keyOpenWeatherAPIOption ?? "" : keySaved

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
        let callDetails = OpenWeatherAPI(appid: key,
                                         lat: lat,
                                         lon: lon,
                                         units: .imperial,
                                         lang: .init(rawValue: lang),
                                         mode: .json)

        log.message(callDetails.urlString.replacingOccurrences(of: key, with: "###"), .notice)

        do {
            ContentCoordinator.shared.screenPopover.startAnimationProgressIndicator(.weather)

            try serviceCurrentWeather.call(
                urlString: callDetails.urlString,
                timeout: timeoutIntervalMeteoData
            )

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            ContentCoordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)

            isReadyToCall = true
        }
    }

    public func fetchForecast() {

        guard isReadyToCallForecast else {
            log.message("[\(type(of: self))].\(#function) \(isReadyToCallForecast)", .notice)
            return
        }

        guard let point = getLocationPoint() else {
            log.message("[\(type(of: self))].\(#function) location is nil.", .notice)
            return
        }

        // let keyLoaded = AppOptions.keyOpenWeatherAPIOption ?? ""
        // let key = keyLoaded.isEmpty ? AppGlobals.keyOpenWeatherAPI : keyLoaded

        let keySaved = AppGlobals.keyOpenWeatherAPI
        let key = keySaved.isEmpty ? AppOptions.keyOpenWeatherAPIOption ?? "" : keySaved

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
        var callDetails = OpenWeatherAPI(appid: key,
                                         request: .forecast,
                                         lat: lat,
                                         lon: lon,
                                         units: .imperial,
                                         lang: .init(rawValue: lang),
                                         mode: .json)
        callDetails.cnt = 40

        log.message(callDetails.urlString.replacingOccurrences(of: key, with: "###"), .notice)

        do {
            ContentCoordinator.shared.screenPopover.startAnimationProgressIndicator(.forecast)

            try serviceForecast.call(
                urlString: callDetails.urlString,
                timeout: timeoutIntervalMeteoData
            )

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            ContentCoordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)

            isReadyToCallForecast = true
        }
    }

    public func fetchOpenMeteoSuggestions(_ search: String) {

        log.message("[\(type(of: self))].\(#function) \(search)")

        guard
            self.isReadyToGetSuggestions,
            search.isEmpty == false,
            let viewLocation = ContentCoordinator.shared.screenPopover.viewLocation
        else {
            return
        }

        guard AppGlobals.useSuggestionsSample == false
        else {
            viewLocation.indicatorCircular.isHidden = true
            viewLocation.indicatorCircular.stopAnimation(nil)
            refreshOpenMeteoSuggestions(Data())
            return
        }

        self.isReadyToGetSuggestions = false

        let name = search
        let limit = 5

        let lang = Lang(rawValue: globals.languageSwitcher.currentAppLanguage)

        let urlString = OpenMeteoAPI.directGeoCoding(city: name, count: limit, lang: lang)
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

        retrySearchSuggestions = search
        serviceOpenMeteoSuggestions.requestData(url: requestURL, timeoutIntervalSuggestions)
    }

    public func fetchOpenWeatherSuggestions(_ search: String) {

        guard
            self.isReadyToGetSuggestions,
            search.isEmpty == false,
            let viewLocation = ContentCoordinator.shared.screenPopover.viewLocation
        else {
            return
        }

        guard AppGlobals.useSuggestionsSample == false
        else {
            viewLocation.indicatorCircular.isHidden = true
            viewLocation.indicatorCircular.stopAnimation(nil)
            refreshOpenWeatherSuggestions(Data())
            return
        }

        // let keyLoaded = AppOptions.keyOpenWeatherAPIOption ?? ""
        // let key = keyLoaded.isEmpty ? AppGlobals.keyOpenWeatherAPI : keyLoaded

        let keySaved = AppGlobals.keyOpenWeatherAPI
        let key = keySaved.isEmpty ? AppOptions.keyOpenWeatherAPIOption ?? "" : keySaved

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

        let urlString = OpenWeatherAPI.directGeoCoding(city: name, limit: limit, appid: key)
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
        serviceOpenWeatherSuggestions.requestData(url: requestURL, timeoutIntervalSuggestions)
    }
}

extension MeteoClientManager {

    private func handleCurrent(response: Result<Data, PerseusNetworkClientError>) {

        DispatchQueue.main.async {
            ContentCoordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)
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

            ContentCoordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)
            ContentCoordinator.shared.screenPopover.reloadWeatherData()

            self.statusMenusPresenter.reloadData()
            self.isReadyToCall = true
        }
    }

    private func handleForecast(response: Result<Data, PerseusNetworkClientError>) {

        DispatchQueue.main.async {
            ContentCoordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)
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
                    log.message(text + ": \(self.retriesCountForecast)", .info)

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

            ContentCoordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)
            ContentCoordinator.shared.screenPopover.reloadForecastData()

            self.isReadyToCallForecast = true
        }
    }

    private func handleOpenMeteoSuggestions(response: Result<Data,
                                            PerseusNetworkClientError>) {
        DispatchQueue.main.async {

            log.message("[\(type(of: self))].\(#function)")

            // stopAnimationIndicator

            let indicator =
            ContentCoordinator.shared.screenPopover.viewLocation.indicatorCircular

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
                            self.fetchOpenMeteoSuggestions(self.retrySearchSuggestions)
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
                log.message(text + " data should not be nil", .fault)
                return
            }

            self.refreshOpenMeteoSuggestions(data)
        }
    }

    private func handleOpenWeatherSuggestions(response: Result<Data,
                                              PerseusNetworkClientError>) {
        DispatchQueue.main.async {

            // stopAnimationIndicator

            let indicator =
            ContentCoordinator.shared.screenPopover.viewLocation.indicatorCircular

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
                            self.fetchOpenWeatherSuggestions(self.retrySearchSuggestions)
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
                log.message(text + " data should not be nil", .fault)
                return
            }

            self.refreshOpenWeatherSuggestions(data)
        }
    }

    private func refreshOpenMeteoSuggestions(_ data: Data) {

        DispatchQueue.main.async {

            let isSample = AppGlobals.useSuggestionsSample

            guard data.isEmpty == false || isSample else { return }

            let suggestions: [Location]? =
            isSample ? suggestionsSample() : suggestionsOpenMeteo(json: data)

            guard
                let suggestions = suggestions,
                let viewLocation = ContentCoordinator.shared.screenPopover.viewLocation
            else {
                return
            }

            if suggestions.isEmpty {
                let text = "There are no suggestions received".localizedValue
                log.message(text, .notice, .custom, .enduser)
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

    private func refreshOpenWeatherSuggestions(_ data: Data) {

        DispatchQueue.main.async {

            let isSample = AppGlobals.useSuggestionsSample

            guard data.isEmpty == false || isSample else { return }

            let suggestions: [Location]? =
            isSample ? suggestionsSample() : suggestionsOpenWeather(json: data)

            guard
                let suggestions = suggestions,
                let viewLocation = ContentCoordinator.shared.screenPopover.viewLocation
            else {
                return
            }

            if suggestions.isEmpty {
                let text = "There are no suggestions received".localizedValue
                log.message(text, .notice, .custom, .enduser)
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

        if let type = ContentCoordinator.shared.screenPopover.viewLocation?.locationCard {
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

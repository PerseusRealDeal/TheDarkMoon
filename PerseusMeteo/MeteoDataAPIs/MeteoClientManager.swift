//
//  MeteoClientManager.swift
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7534 PerseusRealDeal
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

    private let timeoutIntervalMeteoData = 10.0 // 10 sec.
    private let timeoutIntervalSuggestions = 5.0 // 5 sec.

    private var isReadyToCall = false
    private var isReadyToCallForecast = false
    private var isReadyToGetSuggestions = false

    private let serviceCurrentWeather = PerseusNetworkClient(URLSession.shared, "Current")
    private let serviceForecast = PerseusNetworkClient(URLSession.shared, "Forecast")
    private let serviceSuggestions = PerseusNetworkClient(URLSession.shared, "Suggestions")

    init(presenter: StatusMenusPresenter) {

        log.message("[\(type(of: self))].\(#function)", .notice)

        self.presenter = presenter

        serviceCurrentWeather.onDataGiven = handleCurrent
        serviceForecast.onDataGiven = handleForecast
        serviceSuggestions.onDataGiven = handleSuggestions

        isReadyToCall = true
        isReadyToCallForecast = true
        isReadyToGetSuggestions = true
    }

    public func fetchWeather() {

        guard isReadyToCall else {

            // TODO: Implement a timeout logic to cancel previous request

            log.message("[\(type(of: self))].\(#function) \(isReadyToCall)", .error)
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

        log.message(callDetails.urlString)

        do {
            Coordinator.shared.screenPopover.startAnimationProgressIndicator(.weather)

            try serviceCurrentWeather.call(
                urlString: callDetails.urlString, timeoutIntervalMeteoData)

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.weather)

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

        log.message(callDetails.urlString)

        do {
            Coordinator.shared.screenPopover.startAnimationProgressIndicator(.forecast)

            try serviceForecast.call(
                urlString: callDetails.urlString, timeoutIntervalMeteoData)

        } catch {

            log.message("[\(type(of: self))].\(#function) \(error)", .error)

            Coordinator.shared.screenPopover.stopAnimationProgressIndicator(.forecast)

            isReadyToCall = true
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
            // TODO: Is it correct refresh?
            refreshCurrent(Data())
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

        switch response {
        case .success(let data):
            meteoData = data
        case .failure(let error):
            errorResponse = error
        }

        if let error = errorResponse {

            switch error { // TODO: end-user messages localizations
            case .invalidUrl:
                log.message("Incorrect URL used", .notice, .custom, .enduser)
            case .failedRequest(let text):
                log.message("Rquest failed: \(text)", .notice, .custom, .enduser)
            case .statusCode404:
                log.message("Not Found: Status Code 404", .notice, .custom, .enduser)
            case .failedResponse(let text):
                log.message("Response failed: \(text)", .notice, .custom, .enduser)
            case .timedOut:
                log.message("Current Weather request TIMED OUT", .notice, .custom, .enduser)
            case .emptyData:
                log.message("Received empty response data", .notice, .custom, .enduser)
            }

            self.isReadyToCall = true
            return
        }

        guard let data = meteoData else {
            log.message("[\(type(of: self))].\(#function) data should not be nil", .fault)
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

        switch response {
        case .success(let data):
            meteoData = data
        case .failure(let error):
            errorResponse = error
        }

        if let error = errorResponse {

            switch error {
            case .invalidUrl:
                log.message("Incorrect URL used", .notice, .custom, .enduser)
            case .failedRequest(let text):
                log.message("Rquest failed: \(text)", .notice, .custom, .enduser)
            case .statusCode404:
                log.message("Not Found: Status Code 404", .notice, .custom, .enduser)
            case .failedResponse(let text):
                log.message("Response failed: \(text)", .notice, .custom, .enduser)
            case .timedOut:
                log.message("Forecast request TIMED OUT", .notice, .custom, .enduser)
            case .emptyData:
                log.message("Received empty response data", .notice, .custom, .enduser)
            }

            self.isReadyToCallForecast = true
            return
        }

        guard let data = meteoData else {
            log.message("[\(type(of: self))].\(#function) data should not be nil", .fault)
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

            var suggestions: Data?
            var errorResponse: PerseusNetworkClientError?

            switch response {
            case .success(let data):
                suggestions = data
            case .failure(let error):
                errorResponse = error
            }

            if let error = errorResponse {

                switch error {
                case .invalidUrl:
                    log.message("Incorrect URL used", .notice, .custom, .enduser)
                case .failedRequest(let text):
                    log.message("Rquest failed: \(text)", .notice, .custom, .enduser)
                case .statusCode404:
                    log.message("Not Found: Status Code 404", .notice, .custom, .enduser)
                case .failedResponse(let text):
                    log.message("Response failed: \(text)", .notice, .custom, .enduser)
                case .timedOut:
                    log.message("Suggestions request TIMED OUT", .notice, .custom, .enduser)
                case .emptyData:
                    log.message("Received empty response data", .notice, .custom, .enduser)
                }

                self.isReadyToGetSuggestions = true
                return
            }

            guard let data = suggestions else {
                log.message("[\(type(of: self))].\(#function) data should not be nil", .fault)
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
            viewLocation.hideControls()

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

//
//  LocationView.swift, LocationView.xib
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
//  swiftlint:disable file_length
//

import Cocoa

extension String {
    public func cut(length: Int = 27, ending: String = "...") -> String {
        guard self.count > length else {
            return self
        }
        return self.prefix(length) + ending
    }
}

@IBDesignable
class LocationView: NSView, NSTextFieldDelegate {

    // MARK: - Internals

    private let useSuggestionsSample = false
    private var typeDeepCounter: Int = 0 // Suggestion request delay shift (offset)

    // private var geocodingDirectOpenWeatherMap = OpenWeatherClient()
    // private var isReadyToGetSuggestions = false

    private var locationNameLocalized: String {
        switch locationCard {
        case .suggestion:
            if let suggestionName = AppGlobals.suggestion?.localName {
                return suggestionName
            } else {
                return "Suggestion Location".localizedValue
            }
        case .favorite:
            if let favoriteName = AppOptions.favoriteLocationsOption.first(
                where: { $0.isOnDisplay })?.localName {
                return favoriteName
            } else {
                return "Favorite Location".localizedValue
            }
        case .current:
            return "Current Location".localizedValue
        }
    }

    private var geoCoordinatesLocalized: String {

        var point: GeoPoint?

        switch locationCard {
        case .suggestion:
            point = AppGlobals.suggestion?.point
        case .favorite:
            point = AppOptions.favoriteLocationsOption.first(
                where: { $0.isOnDisplay })?.point
        case .current:
            point = AppGlobals.currentLocation
        }

        if let point = point {
            return "\(point.latitude.cut(.two)), \(point.longitude.cut(.two))"
        }

        return "Geo Couple".localizedValue
    }

    // MARK: - Properties

    public var locationCard: LocationCardType = .current

    // MARK: - Outlets

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var textFieldLocationNameSearch: NSTextField!

    @IBOutlet private(set) weak var viewSuggestions: SuggestionsView!
    @IBOutlet public weak var collectionSuggestions: NSCollectionView!
    @IBOutlet public weak var indicatorCircular: NSProgressIndicator!
    @IBOutlet public weak var constraintViewSuggestionsHeight: NSLayoutConstraint!

    @IBOutlet public weak var labelLocationName: NSTextField!
    @IBOutlet private(set) weak var labelGeoCoordinates: NSTextField!
    @IBOutlet private(set) weak var labelPermissionStatus: NSTextField!
    @IBOutlet private(set) weak var labelAutoSuggestionsRequest: NSTextField!

    @IBOutlet private(set) weak var buttonUpdateCurrentLocation: NSButton!
    @IBOutlet public weak var checkBoxAutoSuggestionsRequest: NSButton!
    @IBOutlet private(set) weak var buttonSuggestionsRequest: NSButton!

    @IBOutlet private(set) weak var comboBoxFavorites: NSComboBox!
    @IBOutlet private(set) weak var buttonBookmark: NSButton!

    // MARK: - Actions

    @IBAction func updateCurrentLocationButtonTapped(_ sender: NSButton) {
        guard locationCard == .current else {
            let text = "Current Location should be selected".localizedValue
            log.message(text, .notice, .custom, .enduser)
            return
        }

        LocationDealer.requestCurrent()
    }

    @IBAction func autoSuggestionsRequestTapped(_ sender: NSButton) {
        AppOptions.autoSuggestionsRequestOption = sender.state == .on ? true : false
    }

    @IBAction func suggestionsRequestButtonTapped(_ sender: Any) {

        log.message("[\(type(of: self))].\(#function)", .notice)

        if textFieldLocationNameSearch.stringValue.isEmpty {
            let text = "Location Name should be typed".localizedValue
            log.message(text, .notice, .custom, .enduser)
            return
        }

        if AppOptions.autoSuggestionsRequestOption {
            let text = "Auto requesting suggestions is on!".localizedValue
            log.message(text, .notice, .custom, .enduser)
            return
        }

        Coordinator.fetchSuggestions(textFieldLocationNameSearch.stringValue)
    }

    @IBAction func bookmarkButtonTapped(_ sender: NSButton) {
        AppGlobals.notificationCenter.post(Notification.init(name: .bookmarkNotification))
    }

    @IBAction func favoritesComboBoxDidChange(_ sender: NSComboBox) {

        let index = sender.indexOfSelectedItem

        if index >= AppOptions.favoriteLocationsOption.count {
            log.message("[\(type(of: self))].\(#function) out of index", .error)
            return
        }

        let favorite = AppOptions.favoriteLocationsOption[index]

        // Send a notification with the favorite tapped

        let nc = AppGlobals.notificationCenter
        let key = Notification.Name.favoriteNotification.rawValue

        nc.post(Notification.init(name: .favoriteNotification,
                                  object: self,
                                  userInfo: [key: favorite, "index": index]))
        return
    }

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        indicatorCircular.isHidden = true
        textFieldLocationNameSearch.delegate = self

        viewSuggestions.wantsLayer = true
        viewSuggestions.collectionView = collectionSuggestions

        collectionSuggestions.delegate = viewSuggestions
        collectionSuggestions.dataSource = viewSuggestions
        collectionSuggestions.backgroundColors = [NSColor.clear]

        constraintViewSuggestionsHeight.constant = 0
        viewSuggestions.alphaValue = 0.0

        checkBoxAutoSuggestionsRequest.state =
        AppOptions.autoSuggestionsRequestOption == true ? .on : .off

        localize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        // Setup the view as a reusable control.

        guard let className = type(of: self).className().components(separatedBy: ".").last,
              let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) No nib loaded."
            log.message(text, .fault); fatalError(text)
        }

        // log.message("[\(type(of: self))].\(#function) \(className)")

        nib.instantiate(withOwner: self, topLevelObjects: nil)

        var newConstraints: [NSLayoutConstraint] = []

        for oldConstraint in viewContent.constraints {

            let firstItem = oldConstraint.firstItem === viewContent ?
            self : oldConstraint.firstItem

            let secondItem = oldConstraint.secondItem === viewContent ?
            self : oldConstraint.secondItem

            newConstraints.append(
                NSLayoutConstraint(item: firstItem as Any,
                                   attribute: oldConstraint.firstAttribute,
                                   relatedBy: oldConstraint.relation,
                                   toItem: secondItem,
                                   attribute: oldConstraint.secondAttribute,
                                   multiplier: oldConstraint.multiplier,
                                   constant: oldConstraint.constant)
            )
        }

        for newView in viewContent.subviews {
            self.addSubview(newView)
        }

        self.addConstraints(newConstraints)

        geoSetup()
    }

    private func geoSetup() {

        // Determine location card type

        locationCard = AppOptions.favoriteLocationsOption.first(where: {
            $0.isOnDisplay && $0.isCurrentLocation }) != nil ? .current : .favorite

        // Connect to Geo Coordinator

        GeoCoordinator.register(stakeholder: self, selector: #selector(reloadData))
    }

    // MARK: - Contract

    @objc public func reloadData() {
        labelPermissionStatus.stringValue = AppGlobals.permissionStatusLocalized()

        let locationNameLocalizedFull = locationNameLocalized
        let lengthLimit = 28

        labelLocationName.toolTip = locationNameLocalizedFull.count > lengthLimit ?
        locationNameLocalizedFull : nil

        labelLocationName.stringValue = locationNameLocalizedFull.cut(length: lengthLimit)
        labelGeoCoordinates.stringValue = geoCoordinatesLocalized

        labelAutoSuggestionsRequest.stringValue = "Auto".localizedValue

        buttonSuggestionsRequest.title = "Button: Request Suggestions".localizedValue
        buttonUpdateCurrentLocation.title = "Button: Refresh Current Location".localizedValue

        reloadComboBox()
        reloadBookmarkButton()
    }

    public func makeup() {

        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        if isHighSierra {

            self.appearance = LIGHT_APPEARANCE_DEFAULT_IN_USE

            let style = DarkModeAgent.shared.style

            let colorSet =
            style == .dark ? DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE

            self.textFieldLocationNameSearch.appearance = colorSet
            self.comboBoxFavorites.appearance = colorSet
            self.checkBoxAutoSuggestionsRequest.appearance = colorSet
            self.buttonSuggestionsRequest.appearance = colorSet
            self.buttonUpdateCurrentLocation.appearance = colorSet
            self.buttonBookmark.appearance = colorSet

            let whiteOrBlack: Color = style == .dark ? .white : .black

            self.labelPermissionStatus.textColor = whiteOrBlack
            self.labelLocationName.textColor = whiteOrBlack
            self.labelGeoCoordinates.textColor = whiteOrBlack
            self.labelAutoSuggestionsRequest.textColor = whiteOrBlack
        }

        viewSuggestions.collectionView?.reloadData()
    }

    public func localize() {
        reloadData()

        REDIRECT_ALERT_TITLES = ActionAlertText(
            title: "Redirect Alert: title".localizedValue,
            message: "Redirect Alert: message".localizedValue,
            buttonCancel: "Redirect Alert: cancel".localizedValue,
            buttonFunction: "Redirect Alert: function".localizedValue
        )
        REDIRECT_ALERT_TITLES.titleCalculated = AppGlobals.permissionStatusLocalized
    }

    private func reloadComboBox() {

        let locations = AppOptions.favoriteLocationsOption

        if let indexToDisplay = locations.firstIndex(where: { $0.isOnDisplay == true }) {
            comboBoxFavorites.removeAllItems()

            for item in locations {
                comboBoxFavorites.addItem(withObjectValue: "\(item)".localizedValue)
            }

            comboBoxFavorites.selectItem(at: indexToDisplay)
        }
    }

    private func reloadBookmarkButton() {
        switch self.locationCard {
        case .suggestion:
            buttonBookmark.image = NSImage(named: NSImage.Name("NSAddTemplate"))
        case .favorite:
            buttonBookmark.image = NSImage(named: NSImage.Name("NSRemoveTemplate"))
        case .current:
            buttonBookmark.image = NSImage(named: NSImage.Name("NSBookmarksTemplate"))
        }
    }

    // MARK: - NSTextFieldDelegate Protocol

    func controlTextDidChange(_ obj: Notification) {

        if textFieldLocationNameSearch.stringValue.isEmpty {

            // reset suggestion request delay shift
            typeDeepCounter = 0

            // stop indicator
            indicatorCircular.isHidden = true
            indicatorCircular.stopAnimation(nil)

            // hide suggestions view
            SuggestionsView.shouldProcessVisisbility = false
            viewSuggestions.alphaValue = 0.0
            showControls()
            constraintViewSuggestionsHeight.constant = 0

            // remove all suggestions items
            viewSuggestions.suggestionsArray.removeAll()
            collectionSuggestions.reloadData()

            log.message("[\(type(of: self))].\(#function) deepCounter : \(typeDeepCounter)")

            return
        }

        guard AppOptions.autoSuggestionsRequestOption == true else { return }

        typeDeepCounter += 1

        log.message("[\(type(of: self))].\(#function) : \(typeDeepCounter)")

        // start indicator
        self.indicatorCircular.isHidden = false
        self.indicatorCircular.startAnimation(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {

            if self.typeDeepCounter > 0 {
                self.typeDeepCounter -= 1

                let logText = "deepCounter > 0 : \(self.typeDeepCounter)"
                log.message("[\(type(of: self))].\(#function) \(logText)")
            }

            guard
                self.typeDeepCounter == 0,
                self.textFieldLocationNameSearch.stringValue.isEmpty == false,
                AppOptions.autoSuggestionsRequestOption == true
            else {
                log.message("[\(type(of: self))].\(#function) guard : \(self.typeDeepCounter)")
                return
            }

            Coordinator.fetchSuggestions(self.textFieldLocationNameSearch.stringValue)
        })
    }

    public func hideControls() {
        labelLocationName.isHidden = true
        checkBoxAutoSuggestionsRequest.isHidden = true
        labelGeoCoordinates.isHidden = true
        labelAutoSuggestionsRequest.isHidden = true
    }

    public func showControls() {
        labelLocationName.isHidden = false
        checkBoxAutoSuggestionsRequest.isHidden = false
        labelGeoCoordinates.isHidden = false
        labelAutoSuggestionsRequest.isHidden = false
    }
}

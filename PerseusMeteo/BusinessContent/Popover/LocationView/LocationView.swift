//
//  LocationView.swift, LocationView.xib
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

import Cocoa

@IBDesignable
class LocationView: NSView {

    // MARK: - Outlets

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var labelLocationNameValue: NSTextField!
    @IBOutlet private(set) weak var labelGeoCoupleDataValue: NSTextField!

    @IBOutlet private(set) weak var labelPermissionTitle: NSTextField!
    @IBOutlet private(set) weak var labelPermissionValue: NSTextField!

    @IBOutlet private(set) weak var buttonRefresh: NSButton!

    // MARK: - Actions

    @IBAction func quitButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function)")

        // AppOptions.removeAll()
        AppGlobals.quitTheApp()
    }

    @IBAction func refreshButtonTapped(_ sender: NSButton) {
        log.message("[\(type(of: self))].\(#function)")
        LocationDealer.requestCurrent()
    }

    // MARK: - Initialization

    override func viewWillDraw() {
        super.viewWillDraw()
        log.message("[\(type(of: self))].\(#function)")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        log.message("[\(type(of: self))].\(#function)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        log.message("[\(type(of: self))].\(#function)")

        localize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        log.message("[\(type(of: self))].\(#function)")

        // Setup the view as a reusable control.

        guard let className = type(of: self).className().components(separatedBy: ".").last,
              let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) No nib loaded."
            log.message(text, .error); fatalError(text)
        }

        log.message("[\(type(of: self))].\(#function) \(className)")

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

        // Connect to Geo Coordinator
        GeoCoordinator.register(stakeholder: self, selector: #selector(reloadData))
    }

    // MARK: - Contract

    @objc public func reloadData() {

        labelLocationNameValue.stringValue = "Greetings".localizedValue
        labelGeoCoupleDataValue.stringValue = geoCoupleDataLocalized

        labelPermissionTitle.stringValue = "Label: Permission".localizedValue + ":"
        labelPermissionValue.stringValue = GeoAgent.currentStatus.localizedKey.localizedValue

        buttonRefresh.title = "Button: Refresh Current Location".localizedValue
    }

    public func makeup() {
        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")
    }

    public func localize() {
        log.message("[\(type(of: self))].\(#function)")
        reloadData()
    }
}

// MARK: - Extentions

extension LocationView {

    private var geoCoupleDataLocalized: String {
        guard let location = AppGlobals.currentLocation else {
            return "Geo Couple".localizedValue
        }
        return "\(location.latitude.cut(.four)), \(location.longitude.cut(.four))"
    }
}

extension GeoStatusSimplified {

    var localizedKey: String {
        switch self {
        case .notDetermined:
            return "GeoAccess: .notDetermined"
        case .notAllowed:
            return "GeoAccess: .notAllowed"
        case .allowed:
            return "GeoAccess: .allowed"
        }
    }
}

extension GeoStatus {

    var localizedKey: String {
        switch self {
        case .notDetermined:
            return "GeoAccess: .notDetermined"
        case .deniedForAllAndRestricted:
            return "GeoAccess: .deniedForAllAndRestricted"
        case .restricted:
            return "GeoAccess: .restricted"
        case .deniedForAllApps:
            return "GeoAccess: .deniedForAllApps"
        case .deniedForTheApp:
            return "GeoAccess: .deniedForTheApp"
        case .allowed:
            return "GeoAccess: .allowed"
        }
    }
}

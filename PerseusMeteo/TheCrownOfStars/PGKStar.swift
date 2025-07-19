//
//  PerseusGeoKitStar.swift
//  Version: 1.0.3
//
//  Standalone PerseusGeoKit
//
//
//  For iOS and macOS only. Use Stars to adopt for the specifics you need.
//
//  DESC: HAVE A DEAL WITH WHERE YOU ARE.
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
// swiftlint:disable file_length
//

import CoreLocation

#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif

// MARK: - Constants

public let APPROPRIATE_ACCURACY_DEFAULT = GeoAccuracy.threeKilometers

public let REDIRECT_TEXT_DEFAULT = ActionAlertText(title: "Geo Agent for the App",
                                                   message: "Open System Settings App?",
                                                   buttonCancel: "Cancel",
                                                   buttonFunction: "Open")

#if os(iOS)
public let OPENSETTINGS_URL = UIApplication.openSettingsURLString
#elseif os(macOS)
public let OPENSETTINGS_URL = "x-apple.systempreferences:"
#endif

// MARK: - GeoAgent

public class GeoAgent: NSObject {

    // MARK: - Specifics

    internal enum GeoAgentOrder: CustomStringConvertible {

        public var description: String {
            switch self {
            case .none: // There should be no location notifying activity.
                return "none"
            case .currentLocation:
                return "current location"
            case .locationUpdates:
                return "location updates"
            case .permission: // Used to invoke Current Location Diolog on macOS only.
                return "permission"
            }
        }

        case none
        case currentLocation
        case locationUpdates
        case permission
    }

    // MARK: - Properties

    public static var currentStatus: GeoStatusSimplified {
        return sharedInstance.geoStatus.short
    }

    public static var currentAccuracy: GeoAccuracy {
        get {
            return GeoAccuracy(rawValue: sharedInstance.locationManager.desiredAccuracy)
        }
        set {
            accuracy = newValue.rawValue
        }
    }

    // MARK: - Internals

    internal var locationManager: CLLocationManager
    internal let notificationCenter: NotificationCenter

    internal var geoStatus: GeoStatus {

        let enabled = type(of: locationManager).locationServicesEnabled()
        let status = type(of: locationManager).authorizationStatus()

        return getGeoStatus(serviceEnabled: enabled, status: status)
    }

    internal static var accuracy: CLLocationAccuracy {
        get {
            return sharedInstance.locationManager.desiredAccuracy
        }
        set {
            sharedInstance.locationManager.desiredAccuracy = newValue
        }
    }

    internal var isAuthorizedForLocationServices = false {
        didSet {
            if oldValue { isAuthorizedForLocationServices = oldValue }
        }
    }

    internal var order: GeoAgentOrder = .none

    // MARK: - Singletone

    public static var shared: GeoAgent { return sharedInstance }

    private static let sharedInstance = GeoAgent()
    private override init() {

        log.message("[\(GeoAgent.self)].\(#function)", .info)

        locationManager = CLLocationManager()
        notificationCenter = NotificationCenter.default

        super.init()

        locationManager.desiredAccuracy = APPROPRIATE_ACCURACY_DEFAULT.rawValue
        locationManager.delegate = self
    }

    // MARK: - Contract

    public static func aboutLocationServices() -> (enabled: Bool,
                                                   auth: CLAuthorizationStatus,
                                                   inDetail: GeoStatus) {

        let enabled = type(of: sharedInstance.locationManager).locationServicesEnabled()
        let authorization = type(of: sharedInstance.locationManager).authorizationStatus()

        let status = getGeoStatus(serviceEnabled: enabled, status: authorization)

        return (enabled, authorization, status)
    }

    public static func register(_ stakeholder: Any, _ selector: Selector, _ event: GeoEvent) {
        let nc = sharedInstance.notificationCenter
        nc.addObserver(stakeholder, selector: selector, name: event.name, object: nil)
    }

#if os(iOS)

    public static func showRedirectAlert(_ parentViewController: UIViewController,
                                         _ titles: ActionAlertText = REDIRECT_TEXT_DEFAULT) {

        ActionAlert(redirectToSettingsApp, titles).show(using: parentViewController)
    }

#elseif os(macOS)

    public static func showRedirectAlert(_ titles: ActionAlertText = REDIRECT_TEXT_DEFAULT) {

        ActionAlert(redirectToSettingsApp, titles).show()
    }

#endif

    public func requestPermission(
        _ authorization: LocationPermissionRequest = .always,
        _ actionIfAlreadyDetermined: ((_ statusUsed: GeoStatus) -> Void)? = nil) {

        var status = geoStatus

#if os(iOS)

        guard status == .notDetermined else {
            actionIfAlreadyDetermined?(status)
            return
        }

#elseif os(macOS)

        guard status == .notDetermined, isAuthorizedForLocationServices == false else {
            if status == .notDetermined, isAuthorizedForLocationServices {

                // HOTFIX: Location Services Status in OpenCore usage case.
                // Reinit location manager.

                reInitLocationManager()
            }

            status = geoStatus

            actionIfAlreadyDetermined?(status)
            return
        }

#endif

#if os(iOS)

        switch authorization {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .always:
            locationManager.requestAlwaysAuthorization()
        }

        order = .none
        return

#elseif os(macOS)

        guard #available(macOS 10.15, *) else {
            order = .permission
            locationManager.startUpdatingLocation()
            return
        }

        locationManager.requestAlwaysAuthorization()
#endif

    }

    public func requestCurrentLocation() throws {

        let status = geoStatus

        guard status == .allowed else {

            locationManager.stopUpdatingLocation()
            order = .none

            throw LocationError.permissionRequired(status)
        }

        locationManager.stopUpdatingLocation()

        order = .currentLocation
        locationManager.desiredAccuracy = GeoAgent.accuracy

#if os(iOS)

        locationManager.requestLocation()

#elseif os(macOS)

        locationManager.startUpdatingLocation()

#endif

    }

    public func requestUpdatingLocation() throws {

        let status = geoStatus

        guard status == .allowed else {

            locationManager.stopUpdatingLocation()
            order = .none

            throw LocationError.permissionRequired(status)
        }

        order = .locationUpdates

        locationManager.desiredAccuracy = GeoAgent.accuracy
        locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {

        locationManager.stopUpdatingLocation()
        order = .none
    }

    // MARK: - To serve hotfixes

    public static func reInit() {
        sharedInstance.reInitLocationManager()
    }

    internal func reInitLocationManager() {

        let desiredAccuracy = locationManager.desiredAccuracy

        locationManager = CLLocationManager()

        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.delegate = self
    }
}

// MARK: - Helpers

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

extension CLAuthorizationStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse: // iOS only.
            return "authorizedWhenInUse"
        @unknown default:
            log.message("Unknown CLAuthorizationStatus \(self)", .error)
            // fatalError("Unknown CLAuthorizationStatus \(self)")
            return "unknown"
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension GeoAgent: CLLocationManagerDelegate {

    // MARK: - Location Services Error

#if targetEnvironment(simulator)

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        let nsError = error as NSError

        // CASE -1- NOT REPORTED, Simulator

        let note = "[CASE - SIMULATOR]"
        let details = "\(nsError.domain), code: \(nsError.code)"

        return
    }

#else

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        // locationManager.stopUpdatingLocation()

        let nsError = error as NSError

        let statusLM = type(of: locationManager).authorizationStatus()
        var locationError: LocationError = .failedRequest(error.localizedDescription,
                                                          nsError.domain,
                                                          nsError.code)

        // ISSUE: macOS (new releases) generates an error on startUpdatingLocation() if
        // an end-user makes no decision about permission immediately, 2 or 3 sec.
        // FIXED: In case if an end-user tries to give a permission not immediately,
        // restrict error notifiying so that there is no difference
        // in Current Location Diolog behavior in either early or newer macOS releases.

        // List of macOS systems that generates error if start in .notDetermined (2 or 3 sec):
        // Starting from macOS BigSur than Monterey, Ventura, Sonoma, Sequoia, ...

#if os(macOS)

        var isErrorCased = false

        // CASE -2- NOT REPORTED, "The Current Location Dialog"

        if order == .permission, statusLM == .notDetermined {

            isErrorCased = true

            // HOTFIX: startUpdatingLocation() case with "the location dialog" invoked.
            // Ignore that end-user takes more than 2 or 3 sec to make decision.

            locationManager.stopUpdatingLocation()
            order = .none

            return
        }

        // CASE -3- NOT REPORTED, OpenCore usage

        if nsError.domain == kCLErrorDomain, nsError.code == 1, statusLM == .notDetermined,
           isAuthorizedForLocationServices {

            isErrorCased = true

            // HOTFIX: Location Services Status in OpenCore usage case.
            // Reinit location manager.

            reInitLocationManager()

            return
        }

        // CASE -4- REPORTED, Hardware

        if nsError.domain == kCLErrorDomain, nsError.code == 0 {
            isErrorCased = true
        }

        // CASE -5- REPORTED, Authorization

        if nsError.domain == kCLErrorDomain, nsError.code == 1 {
            // The app permitted to off, denied or Location Services off
            isErrorCased = true
        }

        if isErrorCased == false {
            let errorInfo = "[NOTKNOWN] " + error.localizedDescription
            locationError = .failedRequest(errorInfo, nsError.domain, nsError.code)
        }

#endif

        // order = .none
        notificationCenter.post(name: GeoEvent.locationError.name, object: locationError)
    }

#endif

    // MARK: - Location Services Status Change

    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {

#if os(iOS)
        if [.authorizedAlways, .authorizedWhenInUse].contains(status) {
            isAuthorizedForLocationServices = true
        }
#elseif os(macOS)
        if [.authorized, .authorizedAlways].contains(status) {
            isAuthorizedForLocationServices = true
        }
#endif

        let statusLM = type(of: locationManager).authorizationStatus()
        if statusLM == .notDetermined, isAuthorizedForLocationServices {
            // HOTFIX: Location Services Status in OpenCore usage case.
            return
        }

        notificationCenter.post(name: GeoEvent.locationStatus.name, object: status)
    }

    // MARK: - Location Services Location Data

    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {

        if type(of: locationManager).authorizationStatus() == .notDetermined {
            // HOTFIX: Location Services Status in OpenCore usage case.
            return
        }

        if order == .none {
            locationManager.stopUpdatingLocation()
            return
        }

        if order == .permission {
            locationManager.stopUpdatingLocation()
            order = .none
            return
        }

        if order == .currentLocation {

            locationManager.stopUpdatingLocation()
            order = .none

            let result: Result<GeoPoint, LocationError> = locations.first == nil ?
                .failure(.receivedEmptyLocationData) :
                .success(locations.first!.point)

            notificationCenter.post(name: GeoEvent.currentLocation.name, object: result)

        } else if order == .locationUpdates {
            let result: Result<[GeoPoint], LocationError> = locations.isEmpty ?
                .failure(.receivedEmptyLocationData) :
                .success(locations.map { $0.point })

            notificationCenter.post(name: GeoEvent.locationUpdates.name, object: result)
        }
    }
}

// MARK: - GeoAccuracy

public struct GeoAccuracy: RawRepresentable, Equatable {

    // MARK: - Values

    // The highest possible accuracy that uses additional sensor data.
    public static let bestForNavigation = setup(kCLLocationAccuracyBestForNavigation)

    // The best level of accuracy available.
    public static let best = setup(kCLLocationAccuracyBest)

    // Accurate to within ten meters of the desired target.
    public static let nearestTenMeters = setup(kCLLocationAccuracyNearestTenMeters)

    // Accurate to within one hundred meters.
    public static let hundredMeters = setup(kCLLocationAccuracyHundredMeters)

    // Accurate to the nearest kilometer.
    public static let kilometer = setup(kCLLocationAccuracyKilometer)

    // Accurate to the nearest three kilometers.
    public static let threeKilometers = setup(kCLLocationAccuracyThreeKilometers)

    // MARK: - RawRepresentable

    public var rawValue: CLLocationAccuracy

    // MARK: - Initializer

    public init(rawValue: CLLocationAccuracy) {
        self.rawValue = rawValue
    }

    public static func setup(_ rawValue: CLLocationAccuracy) -> GeoAccuracy {
        return GeoAccuracy(rawValue: rawValue)
    }
}

// MARK: - GeoEvent

public enum GeoEvent: CustomStringConvertible {

    public var description: String {
        switch self {
        case .locationError:
            return "locationErrorEvent"
        case .locationStatus:
            return "locationStatusEvent"
        case .currentLocation:
            return "currentLocationEvent"
        case .locationUpdates:
            return "locationUpdatesEvent"
        }
    }

    public var name: Notification.Name {
        return Notification.Name("\(self)")
    }

    case locationError
    case locationStatus
    case currentLocation
    case locationUpdates
}

// MARK: - GeoPoint

extension CLLocation {
    public var point: GeoPoint {
        return GeoPoint(self)
    }
}

public struct GeoPoint: CustomStringConvertible, Equatable {

    public var description: String {
        /*
         let locationTwo = "[\(latitude.cut(.two)), \(longitude.cut(.two))]"

         let latitudeFour = "latitude = \(latitude.cut(.four))"
         let longitudeFour = "longitude = \(longitude.cut(.four))"

         return locationTwo + ": \(latitudeFour), \(longitudeFour)"
         */
        return "\(latitude.cut(.four)), \(longitude.cut(.four))"
    }

    // MARK: - Location Data, As Is

    public let location: CLLocation

    public var latitude: Double { return location.coordinate.latitude }
    public var longitude: Double { return location.coordinate.longitude }

    // MARK: - Initializer

    public init(_ location: CLLocation) {
        self.location = location
    }

    // MARK: - Equatable

    public static func == (lhs: GeoPoint, rhs: GeoPoint) -> Bool {
        return lhs.location == rhs.location
    }
}

extension Double {

    public enum DecimalPlaces: Double { // Mathematical precision.
        case two  = 100.0
        case four = 10000.0
    }

    public func cut(_ off: DecimalPlaces) -> Double {
        return (self * off.rawValue).rounded(self > 0 ? .down : .up) / off.rawValue
    }
}

// MARK: - GeoStatus

public enum GeoStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notDetermined:
            return "not determined"
        case .deniedForAllAndRestricted:
            return "denied for all and restricted"
        case .restricted:
            return "restricted"
        case .deniedForAllApps:
            return "denied for all apps"
        case .deniedForTheApp:
            return "denied for the app"
        case .allowed:
            return "allowed"
        }
    }

    // Not authorized. Neither restricted nor the app denided.
    case notDetermined

    // Go to Settings > General > Restrictions.
    // Location Services turned off and the app restricted.
    case deniedForAllAndRestricted
    // Location Services turned on and the app restricted.
    case restricted

    // Go to Settings > Privacy.
    // Location Services turned off but the app not restricted.
    case deniedForAllApps

    // Go to Settings > The App.
    // Location Services turned on but the app not restricted.
    case deniedForTheApp

    // Authorized. Either authorizedAlways or authorizedWhenInUse.
    case allowed

    public var short: GeoStatusSimplified {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .deniedForAllAndRestricted:
            return .notAllowed
        case .restricted:
            return .notAllowed
        case .deniedForAllApps:
            return .notAllowed
        case .deniedForTheApp:
            return .notAllowed
        case .allowed:
            return .allowed
        }
    }
}

public func getGeoStatus(serviceEnabled: Bool, status: CLAuthorizationStatus) -> GeoStatus {

    // There is no status .notDetermined with serviceEnabled false.
    if status == .notDetermined { // So, it means that serviceEnabled is true for now.
        return .notDetermined
    }

    if status == .denied {
        return serviceEnabled ? .deniedForTheApp : .deniedForAllApps
    }

    if status == .restricted {
        return serviceEnabled ? .restricted : .deniedForAllAndRestricted
    }

    return .allowed
}

public enum GeoStatusSimplified: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notDetermined:
            return "not determined"
        case .notAllowed:
            return "not allowed"
        case .allowed:
            return "allowed"
        }
    }

    case notDetermined
    case notAllowed
    case allowed
}

// MARK: - LocationError

public enum LocationError: Error, Equatable, CustomStringConvertible {

    public var description: String {
        switch self {
        case .permissionRequired(let status):
            return "permission required if status: \(status)"
        case .receivedEmptyLocationData:
            return "recieved empty location data"
        case .failedRequest(_, let domain, let code):
            return "domain: \(domain), code: \(code)"
        }
    }

    case permissionRequired(GeoStatus)
    case receivedEmptyLocationData
    case failedRequest(String, String, Int) // localizedDescription, domain, code.

    public var failedRequestDetails: (domain: String, code: Int)? {
        switch self {
        case .permissionRequired:
            return nil
        case .receivedEmptyLocationData:
            return nil
        case .failedRequest(_, let domain, let code):
            return (domain: domain, code: code)
        }
    }
}

// MARK: - LocationPermissionRequest

public enum LocationPermissionRequest: CustomStringConvertible {

    public var description: String {
        switch self {
        case .whenInUse:
            return "When-in-use"
        case .always:
            return "Always"
        }
    }

    case whenInUse
    case always
}

// MARK: - Alert Titles

public struct ActionAlertText {

    public var title: String
    public var message: String
    public var buttonCancel: String
    public var buttonFunction: String

    public init(title: String = "Title",
                message: String = "Message",
                buttonCancel: String = "Cancel",
                buttonFunction: String = "Action") {

        self.title = title
        self.message = message
        self.buttonCancel = buttonCancel
        self.buttonFunction = buttonFunction
    }
}

// MARK: - Alert for iOS

#if os(iOS)

public class ActionAlert {

    public var titles: ActionAlertText? {
        didSet {
            self.alertText = titles ?? ActionAlertText()
            self.alert = create()
        }
    }

    private var alertText: ActionAlertText
    private let action: () -> Void

    private var alert: UIAlertController?

    private var actionFunction: UIAlertAction?
    private var actionCancel: UIAlertAction?

    // MARK: - Initializer

    init(_ function: @escaping () -> Void, _ titles: ActionAlertText? = nil) {

        self.action = function
        self.alertText = titles ?? ActionAlertText()

        self.alert = create()
    }

    private func create() -> UIAlertController {

        let alert = UIAlertController(title: alertText.title,
                                      message: alertText.message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: alertText.buttonCancel, style: .cancel))
        alert.addAction(UIAlertAction(title: alertText.buttonFunction,
                                      style: .default) { _ in
            self.action()
        })

        return alert
    }

    // MARK: - Contract

    public func show(using parent: UIViewController) {

        if let alert = alert {
            parent.present(alert, animated: true, completion: nil)
        }
    }
}

#elseif os(macOS)

// MARK: - Alert for macOS

public class ActionAlert {

    public var titles: ActionAlertText? {
        didSet {
            self.alertText = titles ?? ActionAlertText()
            self.alert = create()
        }
    }

    private var alertText: ActionAlertText
    private let action: () -> Void

    private var alert: NSAlert?

    // MARK: - Initializer

    init(_ function: @escaping () -> Void, _ titles: ActionAlertText? = nil) {

        self.action = function
        self.alertText = titles ?? ActionAlertText()

        self.alert = create()
    }

    private func create() -> NSAlert {

        let alert = NSAlert.init()

        alert.alertStyle = .informational

        alert.messageText = alertText.title
        alert.informativeText = alertText.message

        alert.addButton(withTitle: alertText.buttonFunction)
        alert.addButton(withTitle: alertText.buttonCancel)

        return alert
    }

    // MARK: - Contract

    public func show() {

        guard let alert = alert, alert.runModal() == .alertFirstButtonReturn
        else {
            log.message("[\(type(of: self))].\(#function) tapped cancel.")
            return
        }

        action()
    }
}

#endif

#if os(iOS)

// MARK: - Redirect Function for iOS

public func redirectToSettingsApp() {

    guard let settingsURL = URL(string: OPENSETTINGS_URL) else {
        return
    }

    guard UIApplication.shared.canOpenURL(settingsURL) else {
        return
    }

    UIApplication.shared.open(settingsURL)
}

#elseif os(macOS)

// MARK: - Redirect Function for macOS

public func redirectToSettingsApp() {

    guard let pathURL = URL(string: OPENSETTINGS_URL)
    else {
        return
    }

    if NSWorkspace.shared.open(pathURL) {
       // Opened.
    } else {
        // Not opened.
    }
}

#endif

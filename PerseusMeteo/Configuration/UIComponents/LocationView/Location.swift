//
//  Location.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (30.09.2025).
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import CoreLocation

public struct Location: CustomStringConvertible, Codable {

    public var description: String {

        if isCurrentLocation {
            return "Current Location"
        }

        return localName ?? "No name"
    }

    public var name: String?
    public var localName: String? {
        if
            let names = localNames,
            let local = names[globals.languageSwitcher.currentAppLanguage] {
            return local
        }
        return name
    }

    public var point: GeoPoint? {
        get {
            guard let latitude = latitude, let longitude = longitude else {
                return nil
            }

            return GeoPoint(latitude, longitude)
        }
        set {
            guard let change = newValue else {
                latitude = nil
                longitude = nil
                return
            }

            latitude = change.location.point.latitude
            longitude = change.location.point.longitude
        }
    }

    public var zip: String?
    public var country: String?
    public var state: String?

    public let isCurrentLocation: Bool
    public var isOnDisplay: Bool

    public var latitude: Double?
    public var longitude: Double?

    public var localNames: [String: String]?

    // MARK: - Initializer

    public init(isCurrent: Bool = false, isOnDisplay: Bool = false) {
        self.isCurrentLocation = isCurrent
        self.isOnDisplay = isOnDisplay
    }
}

public enum LocationCardType: String, CustomStringConvertible {

    case suggestion = "suggestion"
    case favorite   = "favorite"
    case current    = "current location"

    public var description: String {
        return self.rawValue
    }
}

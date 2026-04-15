//
//  Extensions.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (15.04.2026.)
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

extension String {

    func capitalizingFirstLetter() -> String { // Generated with Google AI
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() { // Generated with Google AI
        self = self.capitalizingFirstLetter()
    }
}

extension Notification.Name {
    public static let suggestionNotification = Notification.Name("suggestionNotification")
    public static let favoriteNotification = Notification.Name("favoriteNotification")
    public static let bookmarkNotification = Notification.Name("bookmarkNotification")
}

extension GeoPoint {
    public init(_ latitude: Double, _ longitude: Double) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}

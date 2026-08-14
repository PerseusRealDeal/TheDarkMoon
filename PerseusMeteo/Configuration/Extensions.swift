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

import AppKit
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

extension String {

    // swiftlint:disable:next cyclomatic_complexity
    func toAppleIconName(isLight: Bool = true) -> String {

        var iconName = self

        if self.hasPrefix("OW_") {

            iconName = self.replacingOccurrences(of: "OW_", with: "")

            switch iconName {
            case "01d":
                return isLight ? "sun.max.fill" : "sun.max.dark"
            case "01n":
                return isLight ? "moon.fill" : "moon.dark"
            case "02d":
                return isLight ? "cloud.sun.fill" : "cloud.sun.dark"
            case "02n":
                return isLight ? "cloud.moon.fill" : "cloud.moon.dark"
            case "03d":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "03n":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "04d":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "04n":
                return isLight ? "cloud.fill" : "cloud.dark"
            case "09d":
                return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"
            case "09n":
                return isLight ? "cloud.heavyrain.fill" : "cloud.heavyrain.dark"
            case "10d":
                return isLight ? "cloud.sun.rain.fill" : "cloud.sun.rain.dark"
            case "10n":
                return isLight ? "cloud.moon.rain.fill" : "cloud.moon.rain.dark"
            case "11d":
                return isLight ? "cloud.sun.bolt.fill" : "cloud.sun.bolt.dark"
            case "11n":
                return isLight ? "cloud.moon.bolt.fill" : "cloud.moon.bolt.dark"
            case "13d":
                return isLight ? "snow.fill" : "snow.dark"
            case "13n":
                return isLight ? "snow.fill" : "snow.dark"
            case "50d":
                return isLight ? "cloud.fog.fill" : "cloud.fog.dark"
            case "50n":
                return isLight ? "cloud.fog.fill" : "cloud.fog.dark"
            default:
                break
            }
        }

        return iconName
    }
}

extension NSImage {

    func resizeProportionally(to height: CGFloat, padding: CGFloat) {

        let currentHeight = self.size.height
        let requiredHeight = height - padding

        guard currentHeight != requiredHeight else { return }

        let kChanged = currentHeight > requiredHeight ?
        currentHeight / requiredHeight : requiredHeight / currentHeight

        let resizedWidth = (self.size.width / kChanged) + padding

        self.size = NSSize(width: resizedWidth, height: requiredHeight)
    }
}

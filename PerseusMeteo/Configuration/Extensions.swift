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

    public var iso8601Date: Date? {

        let formatter = ISO8601DateFormatter()

        formatter.formatOptions =
        [
            .withInternetDateTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]

        let date = formatter.date(from: self)

        return date
    }
}

extension String {

    public var jsonData: Data {

        let opts: JSONSerialization.ReadingOptions = [.mutableContainers]

        guard let jsonData = self.data(using: .utf16) else {
            log.message("\(#function): jsonData", .error, .standard)
            return Data()
        }

        do {
            let object = try JSONSerialization.jsonObject(with: jsonData, options: opts)
            // log.message("\(#function): serialized", .info, .standard)

            let data = try JSONSerialization.data(withJSONObject: object)
            // log.message("\(#function):\n\(data.prettyPrinted ?? "")", .info, .standard)

            return data
        } catch let error as NSError {
            log.message("\(#function): \(error.debugDescription)", .error, .standard)
        }

        return Data()
    }
}

extension String {

    public func cut(length: Int = 27, ending: String = "...") -> String {
        guard self.count > length else {
            return self
        }
        return self.prefix(length) + ending
    }
}

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

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func toAppleIconName(isLight: Bool = true) -> String {

        var iconName = self

        // From OpenWeatherMap

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

        // From OpenMeteo

        switch iconName {

        case "99d", "96d", "95d":
            return isLight ? "moon.fill" : "moon.dark"
        case "99n", "96n", "95n":
            return isLight ? "moon.fill" : "moon.dark"

        case "86d", "85d", "82d", "81d", "80d":
            return isLight ? "moon.fill" : "moon.dark"
        case "86n", "85n", "82n", "81n", "80n":
            return isLight ? "moon.fill" : "moon.dark"

        case "77d", "75d", "73d", "71d":
            return isLight ? "moon.fill" : "moon.dark"
        case "77n", "75n", "73n", "71n":
            return isLight ? "moon.fill" : "moon.dark"

        case "67d", "66d", "65d", "63d", "61d":
            return isLight ? "moon.fill" : "moon.dark"
        case "67n", "66n", "65n", "63n", "61n":
            return isLight ? "moon.fill" : "moon.dark"

        case "57d", "56d", "55d", "53d", "51d":
            return isLight ? "moon.fill" : "moon.dark"
        case "57n", "56n", "55n", "53n", "51n":
            return isLight ? "moon.fill" : "moon.dark"

        case "48d", "45d":
            return isLight ? "moon.fill" : "moon.dark"
        case "48n", "45n":
            return isLight ? "moon.fill" : "moon.dark"

        case "3d", "2d", "1d", "0d":
            return isLight ? "moon.fill" : "moon.dark"
        case "3n", "2n", "1n", "0n":
            return isLight ? "moon.fill" : "moon.dark"

        default:
            // return isLight ? "sun.max.fill" : "sun.max.dark"
            break
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

extension Color {

    public static var linkWebColor: Color {
        return DarkModeAgent.shared.style == .light ? .linkColor : .perseusCyan
    }

    public static var snowmanMessageColor: Color {
        // return DarkModeAgent.shared.style == .light ? .black : .perseusCyan
        return .labelColor
    }
}

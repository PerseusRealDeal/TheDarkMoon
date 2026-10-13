//
//  Extensions.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (15.04.2026.)
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
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

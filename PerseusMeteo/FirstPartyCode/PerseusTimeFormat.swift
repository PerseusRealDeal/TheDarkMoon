//
//  PerseusTimeFormat.swift
//  PerseusRealDeal
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7532 PerseusRealDeal.
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 PerseusRealDeal
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
//  The above copyright notices and this permission notice shall be included in all
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

//
// DESC: USE IT TO KNOW CURRENT SYSTEM TIME FORMAT
//

/* SOURCE CODE SAMPLE

 let toBe = TimeFormatOption.system

 let current = Date.currentTimeFormat
 let required = toBe == .system ? current : toBe == .hour12 ? .hour12 : .hour24

*/

import Foundation

// Used to calculate a time format appylied in current macOS (local).
public enum TimeFormat: Int, CustomStringConvertible {

    case hour24 = 0
    case hour12 = 1

    public var description: String {
        switch self {
        case .hour24:
            return "24-hour"
        case .hour12:
            return "12-hour"
        }
    }
}

extension Date {

    // MARK: - Contract

    public static var currentTimeFormat: TimeFormat {
        return systemTimeFormat
    }

    public func timeInFormat(_ required: TimeFormat, withSeconds: Bool = false) -> String? {

        guard let timezone = TimeZone(secondsFromGMT: 0) else { return nil }

        var calendar = Calendar.current
        calendar.timeZone = timezone

        let components = calendar.dateComponents([.hour, .minute, .second], from: self)

        // Parse.

        guard
            let hour = components.hour, // Always in 24-hour.
            let minute = components.minute,
            let second = components.second else { return nil }

        // Formate.

        let hourInTime = required == .hour12 ? hour.hour12.description : hour.inTime

        let minuteInTime = minute.inTime
        let secondInTime = second.inTime

        var time = withSeconds ? "\(hourInTime):\(minuteInTime):\(secondInTime)" :
        "\(hourInTime):\(minuteInTime)"

        if required == .hour12 {
            time.append(contentsOf: " \(hour.period)")
        }

        return time
    }

    // MARK: - Realization

    private static var systemTimeFormat: TimeFormat {

        let sunset: TimeInterval = 1704795546
        let timezone = 25200

        let formatter = timeFormatter(.short, timezone)
        let sunsetDate = Date(timeIntervalSince1970: sunset) // 9 Jan 2024 at 5:19 PM

        return formatter.string(from: sunsetDate).first == "5" ? .hour12 : .hour24
    }

    private static func timeFormatter(_ style: DateFormatter.Style = .short,
                                      _ timezone: Int = 0,
                                      _ locale: Locale = .current) -> DateFormatter {

        let formatter = DateFormatter()

        formatter.locale = locale
        formatter.dateStyle = .none
        formatter.timeStyle = style

        formatter.timeZone = TimeZone(secondsFromGMT: timezone)

        return formatter
    }
}

extension Int {

    // Just in time.
    public var inTime: String {
        guard self >= 0, self <= 9 else { return String(self) }
        return "0\(self)"
    }

    // Get period of 24-hour, either AM or PM in interval from 0 to 24.
    public var period: String {

        var period = ""

        switch self {
        case 0...11, 24:
            period = "AM".localizedValue
        case 12...23:
            period = "PM".localizedValue
        default:
            break
        }

        return period
    }

    // Get 12-hour of 24-hour in interval from 0 to 24.
    public var hour12: Int {

        guard self >= 0, self <= 24 else { return self }

        switch self {
        case 0, 24:
            return 12
        case 13...23:
            return self-12
        default:
            break
        }

        return self
    }
}

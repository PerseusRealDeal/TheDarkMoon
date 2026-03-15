//
//  PerseusCompassDirection.swift
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
// DESC: USE IT TO KNOW COMPASS POINT BY WIND DEGREE
//

/* SOURCE CODE SAMPLE

 let value = 253
 guard let point = try? WindDegree("\(value)") else { return }

 print("\(Int(point.degree))°: \(point.common.abbreviation)") // 253°: WSW

 print(point) // PerseusCompassDirection(degree: 253.0, common: West-Southwest)

*/

import Foundation

// MARK: - Aliases

typealias WindDegree = PerseusCompassDirection
typealias WindDegreeError = PerseusCompassDirectionError

// MARK: - Errors

public enum PerseusCompassDirectionError: String, Error, CustomStringConvertible {

    case degreeIsOutOfRange     = "Out of Range"
    case degreeString2Double    = "String 2 Double"
    case directionNotDetermined = "Direction not Determined"

    public var description: String {
        return self.rawValue
    }

    public var logError: String {
        return "[\(type(of: self))].\(#function) - \(self)"
    }
}

// MARK: - The 16-Point Compass Representation

public enum CardinalPoint: String, CaseIterable, CustomStringConvertible {

    // MARK: - Full point name

    public var description: String {
        return self.rawValue
    }

    // MARK: - Compass points list

    case north          = "North"            // 1.  350, 360, 010

    case northNorthEast = "North-Northeast"  // 2.  20, 30
    case northEast      = "Northest"         // 3.  40, 50
    case eastNorthEast  = "East-Northeast"   // 4.  60, 70

    case east           = "East"             // 5.  80, 90, 100

    case eastSouthEast  = "East-Southeast"   // 6.  110, 120
    case southEast      = "Southeast"        // 7.  130, 140
    case southSouthEast = "South-Southeast"  // 8.  150, 160

    case south          = "South"            // 9.  170, 180, 190

    case southSouthWest = "South-Southwest"  // 10. 200, 210
    case southWest      = "Southwest"        // 11. 220, 230
    case westSouthWest  = "West-Southwest"   // 12. 240, 250

    case west           = "West"             // 13. 260, 270, 280

    case westNorthWest  = "West-Northwest"   // 14. 290, 300
    case northWest      = "Northwest"        // 15. 310, 320
    case northNorthWest = "North-Northwest"  // 16. 330, 340

    // MARK: - Short point name

    public var abbreviation: String {
        switch self {

        case .north:
            return "Compass: N"

        case .northNorthEast:
            return "Compass: NNE"
        case .northEast:
            return "Compass: NE"
        case .eastNorthEast:
            return "Compass: ENE"

        case .east:
            return "Compass: E"

        case .eastSouthEast:
            return "Compass: ESE"
        case .southEast:
            return "Compass: SE"
        case .southSouthEast:
            return "Compass: SSE"

        case .south:
            return "Compass: S"

        case .southSouthWest:
            return "Compass: SSW"
        case .southWest:
            return "Compass: SW"
        case .westSouthWest:
            return "Compass: WSW"

        case .west:
            return "Compass: W"

        case .westNorthWest:
            return "Compass: WNW"
        case .northWest:
            return "Compass: NW"
        case .northNorthWest:
            return "Compass: NNW"
        }
    }

    // MARK: - Corresponding sectors ranges based on 32-point compass

    public var degrees: [(from: Double, to: Double)] {

        // Points count goes with 1° in 0°...360°.

        switch self {
        case .north:          // Sector 1 (16) / 1 (32). Count is 24.
            return [(348.75, 360), (0, 11.24)]

        case .northNorthEast: // Sector 2 (16) / 3 (32). Count is 22.
            return [(11.25, 33.74)]
        case .northEast:      // Sector 3 (16) / 5 (32). Count is 23.
            return [(33.75, 56.24)]
        case .eastNorthEast:  // Sector 4 (16) / 7 (32). Count is 22.
            return [(56.25, 78.74)]

        case .east:           // Sector 5 (16) / 9 (32). Count is 23.
            return [(78.75, 101.24)]

        case .eastSouthEast:  // Sector 6 (16) / 11 (32). Count is 22.
            return [(101.25, 123.74)]
        case .southEast:      // Sector 7 (16) / 13 (32). Count is 23.
            return [(123.75, 146.24)]
        case .southSouthEast: // Sector 8 (16) / 15 (32). Count is 22.
            return [(146.25, 168.74)]

        case .south:          // Sector 9 (16) / 17 (32). Count is 23.
            return [(168.75, 191.24)]

        case .southSouthWest: // Sector 10 (16) / 19 (32). Count is 22.
            return [(191.25, 213.74)]
        case .southWest:      // Sector 11 (16) / 21 (32). Count is 23.
            return [(213.75, 236.24)]
        case .westSouthWest:  // Sector 12 (16) / 23 (32). Count is 22.
            return [(236.25, 258.74)]

        case .west:           // Sector 13 (16) / 25 (32). Count is 23.
            return [(258.75, 281.24)]

        case .westNorthWest:  // Sector 14 (16) / 27 (32). Count is 22.
            return [(281.25, 303.74)]
        case .northWest:      // Sector 15 (16) / 29 (32). Count is 23.
            return [(303.75, 326.24)]
        case .northNorthWest: // Sector 16 (16) / 31 (32). Count is 22.
            return [(326.25, 348.74)]
        }
    }
}

public struct PerseusCompassDirection {

    // MARK: - Contract

    public let degree: Double
    public let common: CardinalPoint

    init(_ degree: Double) throws {

        guard 0...360 ~= degree else {
            throw PerseusCompassDirectionError.degreeIsOutOfRange
        }

        guard let direction = PerseusCompassDirection.direction(degree) else {
            throw PerseusCompassDirectionError.directionNotDetermined
        }

        self.degree = degree
        self.common = direction
    }

    init(_ degree: String) throws {

        guard let number = Double(degree) else {
            throw PerseusCompassDirectionError.degreeString2Double
        }

        guard 0...360 ~= number else {
            throw PerseusCompassDirectionError.degreeIsOutOfRange
        }

        guard let direction = PerseusCompassDirection.direction(number) else {
            throw PerseusCompassDirectionError.directionNotDetermined
        }

        self.degree = number
        self.common = direction
    }

    // MARK: - Realization

    private static func direction(_ degree: Double) -> CardinalPoint? {

        for point in CardinalPoint.allCases {
            for range in point.degrees where range.from...range.to ~= degree {
                return point
            }
        }

        return nil
    }
}

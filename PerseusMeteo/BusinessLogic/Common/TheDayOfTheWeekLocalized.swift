//
//  TheDayOfTheWeekLocalized.swift
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

import Foundation

enum DayOfTheWeek: Int, CustomStringConvertible {

    public var description: String {
        return self.rawValue.description
    }

    case sun = 1
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7

    public var localized: String {
        switch self {
        case .sun:
            return "Day: Sun".localizedValue
        case .mon:
            return "Day: Mon".localizedValue
        case .tue:
            return "Day: Tue".localizedValue
        case .wed:
            return "Day: Wed".localizedValue
        case .thu:
            return "Day: Thu".localizedValue
        case .fri:
            return "Day: Fri".localizedValue
        case .sat:
            return "Day: Sat".localizedValue
        }
    }
}

//
//  LanguageSwitcherModels.swift
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

protocol Localizable {
    func localize()
}

extension Notification.Name {
    public static let languageSwitchedManuallyNotification =
        Notification.Name("languageSwitchedManuallyNotification")
}

extension String {

    static var bundle: Bundle?

    var localizedValue: String {

        guard
            let bundle = String.bundle
        else {
            return NSLocalizedString(self, comment: "")
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}

public enum LanguageOption: Int, CustomStringConvertible {

    case en     = 0
    case ru     = 1
    case system = 2

    // TODO: Reorder lang nums

    /* should go like this

    case ru     = 2
    case en     = 1
    case system = 0

    */

    public var description: String {
        switch self {
        case .en:
            return "English"
        case .ru:
            return "Russian"
        case .system:
            return "System"
        }
    }

    public var code: String {
        switch self {
        case .en:
            return "en"
        case .ru:
            return "ru"
        case .system:
            return "system"
        }
    }
}

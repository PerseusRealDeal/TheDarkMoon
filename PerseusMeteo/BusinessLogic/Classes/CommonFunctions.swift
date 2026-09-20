//
//  CommonFunctions.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

func getInstance<T>(_ tag: String,
                    _ type: T.Type,
                    _ dic: [String: Any]) -> T? where T: Any {

    if dic.isEmpty {
        log.message("\(#function) \"\(tag)\", but dictionary is empty", .error)
        return nil
    }

    if let value = dic[tag] {
        if let instance = value as? T {

            // log.message("\(#function) \"\(tag)\" cast to \(T.self)", .notice)

            return instance

        } else {
            log.message("\(#function)\"\(tag)\" can't be cast to \(T.self)", .error)
        }
    } else {
        log.message("\(#function) \"\(tag)\" not found", .notice)
    }

    return nil
}

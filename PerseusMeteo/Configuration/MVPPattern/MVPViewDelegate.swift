//
//  MVPViewDelegate.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532 (19.11.2025).
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

// MARK: - Common Delegating Communication

protocol MVPViewDelegate: AnyObject {
    func setupUI()
    func makeUp()
    func localize()
}

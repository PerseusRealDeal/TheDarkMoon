//
//  SelfieViewPresenter.swift
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

// MARK: - SelfieWindow Communication

protocol SelfieViewDelegate: MVPViewDelegate {
    func refreshLogTextView()
}

// MARK: - SelfieWindow Business Logic

class SelfieViewPresenter: MVPPresenter {

    private var logReportObservation: NSKeyValueObservation?

    // MARK: - Initialization

    init(view: SelfieViewDelegate) {
        super.init(view: view)
    }

    // MARK: - Life Circle

    func viewDidLoad() {

        log.message("[\(type(of: self))].\(#function)")

        guard let view = view as? SelfieViewDelegate else { return }

        logReportObservation = localReport.observe(\.lastMessage, options: .new) { _, _ in
            view.refreshLogTextView()
        }

        view.setupUI()

        view.makeUp()
        view.localize()
    }

    func viewDidAppear() {

        log.message("[\(type(of: self))].\(#function)")

        guard let view = view as? SelfieViewDelegate else { return }

        view.refreshLogTextView()
    }

    // MARK: - Business Contract

    // MARK: - Realization

}

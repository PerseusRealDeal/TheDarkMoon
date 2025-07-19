//
//  ForecastHoursViewItem.swift, ForecastHoursViewItem.xib
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

import Cocoa

class ForecastHoursViewItem: NSCollectionViewItem {

    // MARK: - Internals

    let darkModeObserver = DarkModeObserver()

    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected

            view.layer?.borderWidth = isSelected ? 2.0 : 0.0
            makeup()
        }
    }

    var data: ForecastHour? {
        didSet {
            guard isViewLoaded else { return }

            reload()
        }
    }

    // MARK: - Outlets

    @IBOutlet private(set) weak var time: NSTextField!

    @IBOutlet private(set) weak var temperature: NSTextField!
    @IBOutlet private(set) weak var incomingPrecipitation: NSTextField!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

        darkModeObserver.action = { _ in self.makeup() }

        makeup()
        reload()
    }

    private func configure() {

        view.layer = CALayer()
        view.layer?.cornerRadius = 5.0
        view.layer?.masksToBounds = true

        view.wantsLayer = true
    }

    private func makeup() {
        /*
         view.layer?.backgroundColor = isSelected ? NSColor.red.cgColor : NSColor.clear.cgColor
         */
    }

    private func reload() {

        guard let hour = self.data else { return }

        log.message("[\(type(of: self))].\(#function) hour \(hour.label)")

        // textField?.stringValue = hour.label
        // view.layer?.backgroundColor = NSColor.clear.cgColor

        /*
        view.layer?.backgroundColor = isSelected ? NSColor.red.cgColor : NSColor.clear.cgColor
         */

        self.time?.stringValue = hour.time
        self.temperature?.stringValue = hour.temperature
        self.incomingPrecipitation?.stringValue = hour.precipitation
    }
}

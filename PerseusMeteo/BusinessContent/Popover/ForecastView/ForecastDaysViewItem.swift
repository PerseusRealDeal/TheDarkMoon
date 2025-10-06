//
//  ForecastDaysViewItem.swift, ForecastDaysViewItem.xib
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

class ForecastDaysViewItem: NSCollectionViewItem {

    // MARK: - Internals

    let darkModeObserver = DarkModeObserver()

    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected

            view.layer?.borderWidth = isSelected ? 2.0 : 0.0
            makeup()
        }
    }

    var data: ForecastDay? {
        didSet {
            guard isViewLoaded else { return }

            reload()
        }
    }

    // MARK: - Outlets

    @IBOutlet private(set) weak var viewWeatherConditionIcon: NSImageView!
    @IBOutlet private(set) weak var date: NSTextField!

    @IBOutlet private(set) weak var labelWeatherConditionValue: NSTextField!

    @IBOutlet private(set) weak var nightTemperature: NSTextField!
    @IBOutlet private(set) weak var dayTemperature: NSTextField!

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

        // imageView?.layer?.borderColor = NSColor.customChosenOne.cgColor
        // textField?.textColor = isSelected ? NSColor.customChosenOne : NSColor.black

        view.layer?.backgroundColor = NSColor.clear.cgColor
        // isSelected ? NSColor.red.cgColor : NSColor.clear.cgColor
    }

    private func reload() {

        guard let day = self.data else { return }

        // log.message("[\(type(of: self))].\(#function) day \(day.label)")

        // textField?.stringValue = day.date
        view.layer?.backgroundColor = NSColor.clear.cgColor

        // imageView?.image = NSImage(named: friend.iconName)
        // view.layer?.backgroundColor = NSColor.red.cgColor

        self.viewWeatherConditionIcon?.image = NSImage(named: day.weatherConditionIconName)
        self.labelWeatherConditionValue?.stringValue = day.weatherConditions

        self.date?.stringValue = "\(day.dateDayOfTheWeek), \(day.dateDayMonth)"

        self.nightTemperature?.stringValue = day.minimumTemperature
        self.dayTemperature?.stringValue = day.maximumTemperature
    }
}

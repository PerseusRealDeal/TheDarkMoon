//
//  WeatherView.swift, WeatherView.xib
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

@IBDesignable
class WeatherView: NSView {

    // MARK: - View Data Source

    public let dataSource = globals.sourceWeather
    public var startProgressIndicator: Bool = false {
        didSet {
            if startProgressIndicator {
                indicator.isHidden = false
                indicator.startAnimation(nil)
            } else {
                indicator.isHidden = true
                indicator.stopAnimation(nil)
            }
        }
    }

    // MARK: - Outlets

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var viewMeteoGroup: MeteoGroupView!

    @IBOutlet private(set) weak var indicator: NSProgressIndicator!

    @IBOutlet private(set) weak var viewWeatherConditionsIcon: NSImageView!
    @IBOutlet private(set) weak var labelTemperatureValue: NSTextField!
    @IBOutlet private(set) weak var labelWeatherConditionsDescriptionValue: NSTextField!

    @IBOutlet private(set) weak var labelSunriseTitle: NSTextField!
    @IBOutlet private(set) weak var labelSunriseValue: NSTextField!

    @IBOutlet private(set) weak var labelSunsetTitle: NSTextField!
    @IBOutlet private(set) weak var labelSunsetValue: NSTextField!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        // log.message("[\(type(of: self))].\(#function)")

        // localize()
        startProgressIndicator = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        log.message("[\(type(of: self))].\(#function)")

        // Create a new instance from *xib and reference it to viewContent outlet.

        guard let className = type(of: self).className().components(separatedBy: ".").last,
              let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) No nib loaded."
            log.message(text, .fault); fatalError(text)
        }

        // log.message("[\(type(of: self))].\(#function) \(className)")

        nib.instantiate(withOwner: self, topLevelObjects: nil)

        var newConstraints: [NSLayoutConstraint] = []

        for oldConstraint in viewContent.constraints {

            let firstItem = oldConstraint.firstItem === viewContent ?
            self : oldConstraint.firstItem

            let secondItem = oldConstraint.secondItem === viewContent ?
            self : oldConstraint.secondItem

            newConstraints.append(
                NSLayoutConstraint(item: firstItem as Any,
                                   attribute: oldConstraint.firstAttribute,
                                   relatedBy: oldConstraint.relation,
                                   toItem: secondItem,
                                   attribute: oldConstraint.secondAttribute,
                                   multiplier: oldConstraint.multiplier,
                                   constant: oldConstraint.constant)
            )
        }

        for newView in viewContent.subviews {
            self.addSubview(newView)
        }

        self.addConstraints(newConstraints)
    }

    // MARK: - Contract

    public func reloadData() {

        log.message("[\(type(of: self))].\(#function)")

        // Temperature, Weather Icon, and Short desc

        let temperature = dataSource.temperature

        let wcs = dataSource.weatherConditions
        let img = NSImage(named: wcs.icon)

        labelTemperatureValue.stringValue = temperature
        viewWeatherConditionsIcon.image = img

        labelWeatherConditionsDescriptionValue.stringValue = wcs.description

        // Sunrise and sunset

        labelSunriseTitle.stringValue = "Label: Sunrise".localizedValue
        labelSunsetTitle.stringValue = "Label: Sunset".localizedValue

        labelSunriseValue.stringValue = dataSource.sunrise
        labelSunsetValue.stringValue = dataSource.sunset

        // Prepare Meteo group

        var meteogroup = MeteoGroupData()

        // Line 1 - Top

        let titleMinMax = "Prefix: Min".localizedValue + ", " + "Prefix: Max".localizedValue
        let valueMinMax = "\(dataSource.temperatureMinimum) : \(dataSource.temperatureMaximum)"

        meteogroup.title1 = titleMinMax
        meteogroup.value1 = valueMinMax

        meteogroup.title2 = "Prefix: Feels Like".localizedValue
        meteogroup.value2 = dataSource.temperatureFeelsLike

        meteogroup.title3 = "Prefix: Visibility".localizedValue
        meteogroup.value3 = dataSource.visibility

        // Line 2 - Middle

        meteogroup.title4 = "Label: Speed".localizedValue
        meteogroup.value4 = dataSource.windSpeed

        meteogroup.title5 = "Label: Direction".localizedValue
        meteogroup.value5 = dataSource.windDirection

        meteogroup.title6 = "Label: Gust".localizedValue
        meteogroup.value6 = dataSource.windGusts

        // Line 3 - Bottom

        meteogroup.title7 = "Label: Pressure".localizedValue
        meteogroup.value7 = dataSource.pressure

        meteogroup.title8 = "Prefix: Humidity".localizedValue
        meteogroup.value8 = dataSource.humidity

        meteogroup.title9 = "Prefix: Cloudiness".localizedValue
        meteogroup.value9 = dataSource.cloudiness

        // Set meteo group

        self.viewMeteoGroup.data = meteogroup
    }
}

// MARK: - DARK MODE

extension WeatherView {
    public func makeup() {
        // log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")
    }
}

// MARK: - LOCALIZATION

extension WeatherView {
    public func localize() {
        // log.message("[\(type(of: self))].\(#function)")
        reloadData()
    }
}

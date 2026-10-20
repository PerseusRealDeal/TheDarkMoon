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
// swiftlint:disable file_length
//

import Cocoa

@IBDesignable
class WeatherView: NSView {

    // MARK: - View Data Source

    public let weatherReader = AppGlobals.currentReader
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
    @IBOutlet private(set) weak var viewSunriseIcon: NSImageView!
    @IBOutlet private(set) weak var viewSunsetIcon: NSImageView!
    @IBOutlet private(set) weak var viewMoonriseIcon: NSImageView!
    @IBOutlet private(set) weak var viewMoonsetIcon: NSImageView!

    @IBOutlet private(set) weak var labelTemperatureValue: NSTextField!
    @IBOutlet private(set) weak var labelWeatherConditionsDescriptionValue: NSTextField!

    @IBOutlet private(set) weak var labelSunriseValue: NSTextField!
    @IBOutlet private(set) weak var labelSunsetValue: NSTextField!
    @IBOutlet private(set) weak var labelMoonriseValue: NSTextField!
    @IBOutlet private(set) weak var labelMoonsetValue: NSTextField!

    @IBOutlet private(set) weak var labelUVIndex: NSTextField!
    @IBOutlet private(set) weak var labelMoonphase: NSTextField!

    @IBOutlet private(set) weak var labelPrecipitationProbability: NSTextField!
    @IBOutlet private(set) weak var labelRainPrecipitation: NSTextField!
    @IBOutlet private(set) weak var labelSnowPrecipitation: NSTextField!

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

        log.message("[\(type(of: self))].\(#function)", .debug, .standard)

        // Temperature, Weather Description, and Icon

        let temperature = weatherReader.temperature
        let weatherDesc = weatherReader.weatherDescription.capitalizingFirstLetter()

        // let wcs = dataSource.weatherConditions

        let imageName = weatherReader.weatherIconName.symbolName(
            isLight: DarkModeAgent.shared.style == .light)

        viewWeatherConditionsIcon.image = NSImage(named: imageName)

        /*

        if imageName == AppGlobals.statusMenusButtonIconName {
            viewWeatherConditionsIcon.image = NSImage(named: imageName)
        } else if #available(macOS 11.0, *) {
            viewWeatherConditionsIcon.image = NSImage(systemSymbolName: imageName,
                                                      accessibilityDescription: nil)
        } else { // Images for legacy macOS
            viewWeatherConditionsIcon.image = NSImage(named: imageName)
        }

        */

        labelTemperatureValue.stringValue = temperature
        labelWeatherConditionsDescriptionValue.stringValue = weatherDesc

        // Sunrise and sunset

        viewSunriseIcon.toolTip = "Label: Sunrise".localizedValue
        viewSunsetIcon.toolTip = "Label: Sunset".localizedValue

        labelSunriseValue.stringValue = weatherReader.sunrise
        labelSunsetValue.stringValue = weatherReader.sunset

        // Moonrise and moonset

        viewMoonriseIcon.toolTip = "Label: Moonrise".localizedValue
        viewMoonsetIcon.toolTip = "Label: Moonset".localizedValue

        labelMoonriseValue.stringValue = weatherReader.moonrise
        labelMoonsetValue.stringValue = weatherReader.moonset

        // UV Index

        let uvindex = "Label: UV Index".localizedValue + " \(weatherReader.uvindex)"
        labelUVIndex.stringValue = uvindex

        // Moon Phase

        let moonphase = "Label: Moon Phase".localizedValue + " \(weatherReader.moonphase)"
        labelMoonphase.stringValue = moonphase

        // Precipitation probability

        let probability = "Label: Probability".localizedValue + " \(weatherReader.probability)"
        labelPrecipitationProbability.stringValue = "\(probability)"
        labelPrecipitationProbability.toolTip = selectToolTip("labelPrecipitationProbability")

        // Precipitation

        let rain = "Label: Rain".localizedValue + " \(weatherReader.precipitation.rain)"
        labelRainPrecipitation.stringValue = "\(rain)"
        labelRainPrecipitation.toolTip = selectToolTip("labelRainPrecipitation")

        let snow = "Label: Snow".localizedValue + " \(weatherReader.precipitation.snow)"
        labelSnowPrecipitation.stringValue = "\(snow)"
        labelSnowPrecipitation.toolTip = selectToolTip("labelSnowPrecipitation")

        // Meteo group params

        showMeteoGroupParams()
        showSpecialUIElementsIfRequired()
    }

    private func selectToolTip(_ label: String) -> String? {

        let provider = weatherReader.meteoProvider ?? AppOptions.currentMeteoProviderOption

        switch label {
        case "labelPrecipitationProbability":
            switch provider {
            case .serviceOpenMeteo:
                return "ToolTip: Probability OM".localizedValue
            case .serviceOpenWeatherMap:
                return "ToolTip: Probability OW".localizedValue
            }
        case "labelRainPrecipitation":
            switch provider {
            case .serviceOpenMeteo:
                return "ToolTip: Rain OM".localizedValue
            case .serviceOpenWeatherMap:
                return "ToolTip: Rain OW".localizedValue
            }
        case "labelSnowPrecipitation":
            switch provider {
            case .serviceOpenMeteo:
                return "ToolTip: Snow OM".localizedValue
            case .serviceOpenWeatherMap:
                return "ToolTip: Snow OW".localizedValue
            }
        default:
            return nil
        }
    }

    private func showSpecialUIElementsIfRequired() {

        let whiteOrBlack: Color = DarkModeAgent.shared.style == .dark ? .white : .black

        if AppGlobals.weather == nil {
            if AppOptions.currentMeteoProviderOption == .serviceOpenMeteo {
                labelUVIndex.textColor = whiteOrBlack
                labelMoonsetValue.textColor = whiteOrBlack
                labelMoonriseValue.textColor = whiteOrBlack
                labelMoonphase.textColor = whiteOrBlack
                labelPrecipitationProbability.textColor = whiteOrBlack
            } else {
                labelUVIndex.textColor = .perseusGray
                labelMoonsetValue.textColor = .perseusGray
                labelMoonriseValue.textColor = .perseusGray
                labelMoonphase.textColor = .perseusGray
                labelPrecipitationProbability.textColor = .perseusGray
            }
        } else if AppGlobals.weather?.source == .serviceOpenMeteo {
            labelUVIndex.textColor = whiteOrBlack
            labelMoonsetValue.textColor = whiteOrBlack
            labelMoonriseValue.textColor = whiteOrBlack
            labelMoonphase.textColor = whiteOrBlack
            labelPrecipitationProbability.textColor = whiteOrBlack
        } else {
            labelUVIndex.textColor = .perseusGray
            labelMoonsetValue.textColor = .perseusGray
            labelMoonriseValue.textColor = .perseusGray
            labelMoonphase.textColor = .perseusGray
            labelPrecipitationProbability.textColor = .perseusGray
        }

        labelPrecipitationProbability.textColor =
        labelPrecipitationProbability.stringValue.contains(MeteoFactsDefaults.probability) ?
            .perseusGray : whiteOrBlack

        labelRainPrecipitation.textColor =
        labelRainPrecipitation.stringValue.contains(MeteoFactsDefaults.rain) ?
            .perseusGray : whiteOrBlack

        labelSnowPrecipitation.textColor =
        labelSnowPrecipitation.stringValue.contains(MeteoFactsDefaults.snow) ?
            .perseusGray : whiteOrBlack
    }

    private func showMeteoGroupParams() {

        var meteogroup = MeteoGroupData()

        let provider = AppOptions.currentMeteoProviderOption

        switch provider {
        case .serviceOpenMeteo:
            meteogroup.setTemplatedValuesUp(provider: .serviceOpenMeteo,
                                            category: .currentWeather)
        case .serviceOpenWeatherMap:
            meteogroup.setTemplatedValuesUp(provider: .serviceOpenWeatherMap,
                                            category: .currentWeather)
        }

        // Line 1 - Top

        let valueMinMax =
        "\(weatherReader.temperatureMinimum) : \(weatherReader.temperatureMaximum)"

        meteogroup.value1 = valueMinMax
        meteogroup.value2 = weatherReader.temperatureFeelsLike
        meteogroup.value3 = weatherReader.visibility

        // Line 2 - Middle

        meteogroup.value4 = weatherReader.windSpeed
        meteogroup.value5 = weatherReader.windDirection
        meteogroup.value6 = weatherReader.windGusts

        // Line 3 - Bottom

        meteogroup.value7 = weatherReader.pressure
        meteogroup.value8 = weatherReader.humidity
        meteogroup.value9 = weatherReader.cloudiness

        // Set meteo group

        self.viewMeteoGroup.data = meteogroup
    }
}

// MARK: - DARK MODE

extension WeatherView {

    public func makeup() {

        // log.message("[\(type(of: self))].\(#function) DarkMode: \(DarkMode.style)")
        log.message("[\(type(of: self))].\(#function)", .debug, .standard)

        let isDarkModeInLight = DarkModeAgent.shared.style == .light

        let imageName = weatherReader.weatherIconName.symbolName(isLight: isDarkModeInLight)

        let sunriseIconName = isDarkModeInLight ? "sunrise.fill" : "sunrise.dark"
        let sunsetIconName = isDarkModeInLight ? "sunset.fill" : "sunset.dark"
        let moonriseIconName = isDarkModeInLight ? "moonrise.fill" : "moonrise.dark"
        let moonsetIconName = isDarkModeInLight ? "moonset.fill" : "moonset.dark"

        viewWeatherConditionsIcon.image = NSImage(named: imageName)

        viewSunriseIcon.image = NSImage(named: sunriseIconName)
        viewSunsetIcon.image = NSImage(named: sunsetIconName)
        viewMoonriseIcon.image = NSImage(named: moonriseIconName)
        viewMoonsetIcon.image = NSImage(named: moonsetIconName)

        if isHighSierra {

            self.appearance = LIGHT_APPEARANCE_DEFAULT_IN_USE
            let whiteOrBlack: Color = DarkModeAgent.shared.style == .dark ? .white : .black

            self.labelTemperatureValue.textColor = whiteOrBlack
            self.labelWeatherConditionsDescriptionValue.textColor = whiteOrBlack
            self.labelSunriseValue.textColor = whiteOrBlack
            self.labelSunsetValue.textColor = whiteOrBlack
            self.labelMoonriseValue.textColor = whiteOrBlack
            self.labelMoonsetValue.textColor = whiteOrBlack
            self.labelUVIndex.textColor = whiteOrBlack
            self.labelMoonphase.textColor = whiteOrBlack
            self.viewMeteoGroup.title1.textColor = whiteOrBlack
            self.viewMeteoGroup.value1.textColor = whiteOrBlack
            self.viewMeteoGroup.title2.textColor = whiteOrBlack
            self.viewMeteoGroup.value2.textColor = whiteOrBlack
            self.viewMeteoGroup.title3.textColor = whiteOrBlack
            self.viewMeteoGroup.value3.textColor = whiteOrBlack
            self.viewMeteoGroup.title4.textColor = whiteOrBlack
            self.viewMeteoGroup.value4.textColor = whiteOrBlack
            self.viewMeteoGroup.title5.textColor = whiteOrBlack
            self.viewMeteoGroup.value5.textColor = whiteOrBlack
            self.viewMeteoGroup.title6.textColor = whiteOrBlack
            self.viewMeteoGroup.value6.textColor = whiteOrBlack
            self.viewMeteoGroup.title7.textColor = whiteOrBlack
            self.viewMeteoGroup.value7.textColor = whiteOrBlack
            self.viewMeteoGroup.title8.textColor = whiteOrBlack
            self.viewMeteoGroup.value8.textColor = whiteOrBlack
            self.viewMeteoGroup.title9.textColor = whiteOrBlack
            self.viewMeteoGroup.value9.textColor = whiteOrBlack
        }
        showSpecialUIElementsIfRequired()
    }
}

// MARK: - LOCALIZATION

extension WeatherView {
    public func localize() {
        // log.message("[\(type(of: self))].\(#function)")
        reloadData()
    }
}

//
//  ForecastView.swift, ForecastView.xib
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
class ForecastView: NSView {

    // MARK: Internals

    private let daysID = NSUserInterfaceItemIdentifier(rawValue: "ForecastDays")
    private let hoursID = NSUserInterfaceItemIdentifier(rawValue: "ForecastHours")

    // MARK: - View Data Source

    public let dataSource = globals.sourceForecast
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

    @IBOutlet private(set) var contentView: NSView!

    @IBOutlet private(set) weak var indicator: NSProgressIndicator!

    @IBOutlet private(set) weak var viewForecastDays: NSCollectionView!
    @IBOutlet private(set) weak var viewForecastHours: NSCollectionView!

    @IBOutlet private(set) weak var labelWeatherDescription: NSTextField!
    @IBOutlet private(set) weak var viewMeteoGroup: MeteoGroupView!

    // MARK: - Initialization
/*
    override func viewWillDraw() {
        super.viewWillDraw()
        // log.message("[\(type(of: self))].\(#function)")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // log.message("[\(type(of: self))].\(#function)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // log.message("[\(type(of: self))].\(#function)")
    }
*/
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

        // Create a new instance from *xib and reference it to contentView outlet.

        guard
            let className = type(of: self).className().components(separatedBy: ".").last,
            let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) No nib loaded."
            log.message(text, .fault); fatalError(text)
        }

        // log.message("[\(type(of: self))].\(#function) \(className)")

        nib.instantiate(withOwner: self, topLevelObjects: nil)

        var newConstraints: [NSLayoutConstraint] = []

        for oldConstraint in contentView.constraints {

            let firstItem = oldConstraint.firstItem === contentView ?
            self : oldConstraint.firstItem

            let secondItem = oldConstraint.secondItem === contentView ?
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

        for newView in contentView.subviews {
            self.addSubview(newView)
        }

        self.addConstraints(newConstraints)
    }

    // MARK: - Contract

    public func setupUI() {

        wantsLayer = true

        self.startProgressIndicator = false

        self.viewForecastDays.identifier = daysID
        self.viewForecastHours.identifier = hoursID

        self.viewForecastDays.dataSource = self
        self.viewForecastHours.dataSource = self

        self.viewForecastDays.delegate = self
        self.viewForecastHours.delegate = self

        self.viewForecastDays.wantsLayer = true
        self.viewForecastDays.backgroundColors = [NSColor.clear]

        self.viewForecastHours.wantsLayer = true
        self.viewForecastHours.backgroundColors = [NSColor.clear]

        viewMeteoGroup.applyFonts()
    }

    public func reloadData(saveSelection: Bool = false) {

        // log.message("[\(type(of: self))].\(#function)")

        // dataSource.refresh()

        reloadDaysCollection(selectionSaved: saveSelection)
        reloadHoursCollection(selectionSaved: saveSelection)

        viewMeteoGroup.reload()
    }

    public func selectTheFirstForecastDay() {

        let indexPath = IndexPath(item: 0, section: 0)
        let indexes: Set<IndexPath> = [indexPath]

        viewForecastDays.selectItems(at: indexes, scrollPosition: .top)

        log.message("[\(type(of: self))].\(#function) The first day selected.")
    }

    public func selectTheFirstForecastHour() {

        let indexPath = IndexPath(item: 0, section: 0)
        let indexes: Set<IndexPath> = [indexPath]

        viewForecastHours.selectItems(at: indexes, scrollPosition: .left)
        let daySelected = viewForecastDays.selectionIndexPaths

        if !dataSource.forecastDays.isEmpty {
            // log.message("[\(type(of: self))].\(#function) ForecastDays not empty.")

            if !dataSource.forecastDays[0].hours.isEmpty {
                // log.message("[\(type(of: self))].\(#function) Hours not empty.")

                if let daySelectedIndex = daySelected.first {
                    let index = daySelectedIndex.item
                    let item = dataSource.forecastDays[index].hours[0]

                    viewMeteoGroup.data = item.prepareMeteoGroupData()
                    labelWeatherDescription.stringValue = item.weatherConditions.description
                } else {
                    let item = dataSource.forecastDays[0].hours[0]

                    viewMeteoGroup.data = item.prepareMeteoGroupData()
                    labelWeatherDescription.stringValue = item.weatherConditions.description
                }
            }
        }

        log.message("[\(type(of: self))].\(#function) The first hour selected.")
    }

    // MARK: - Realization

    private func reloadDaysCollection(selectionSaved: Bool) {

        let paths = viewForecastDays.selectionIndexPaths

        viewForecastDays.reloadData()

        if selectionSaved {
            viewForecastDays.selectItems(at: paths, scrollPosition: .nearestHorizontalEdge)
        }

        log.message("[\(type(of: self))].\(#function) Days collection reloaded.")
    }

    private func reloadHoursCollection(selectionSaved: Bool) {

        labelWeatherDescription.stringValue = MeteoFactsDefaults.conditions

        guard viewForecastDays.selectionIndexPaths.first != nil else {

            viewForecastHours.reloadData()
            viewMeteoGroup.data = nil

            return
        }

        let paths = viewForecastHours.selectionIndexPaths

        viewForecastHours.reloadData()

        if selectionSaved {
            viewForecastHours.selectItems(at: paths, scrollPosition: .nearestVerticalEdge)
        }

        // Reload selected item

        let indexDay = viewForecastDays.selectionIndexPaths.first
        let indexHour = paths.first

        if !dataSource.forecastDays.isEmpty && indexDay != nil {
            // log.message("[\(type(of: self))].\(#function) forecastDays not empty")

            let dayItem = indexDay!.item

            if !dataSource.forecastDays[dayItem].hours.isEmpty && indexHour != nil {
                // log.message("[\(type(of: self))].\(#function) hours not empty")

                let hourItem = indexHour!.item
                let item = dataSource.forecastDays[dayItem].hours[hourItem]

                viewMeteoGroup.data = item.prepareMeteoGroupData()
                labelWeatherDescription.stringValue = item.weatherConditions.description
            }
        }

        // viewMeteoGroup.reload()
        log.message("[\(type(of: self))].\(#function) Hours collection reloaded.")
    }
}

// MARK: - NSCollectionViewDataSource, CREATING

extension ForecastView: NSCollectionViewDataSource {

    // MARK: - Count of Items

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection
        section: Int) -> Int {

        // log.message("[\(type(of: self))].\(#function) : \(dataSource.forecastDays.count)")

        // Amount of items in the Forecast Days collection.

        if collectionView.identifier == daysID {
            return dataSource.forecastDays.count
        }

        // Amount of items in the Forecast Hours collection of the day selected.

        if collectionView.identifier == hoursID,
            dataSource.forecastDays.isEmpty == false {

            if
                let selectedIndexPath = viewForecastDays.selectionIndexPaths.first,
                (selectedIndexPath as NSIndexPath).item != -1 {

                let theDay = dataSource.forecastDays[(selectedIndexPath as NSIndexPath).item]

                return theDay.hours.count
            }
        }

        return 0
    }

    // MARK: - Create a new Item

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt
        indexPath: IndexPath) -> NSCollectionViewItem {

        // Create a new Forecast Day item

        if collectionView.identifier == daysID {

            // The day data.

            let index = (indexPath as NSIndexPath).item
            var data = dataSource.forecastDays[index]

            // log.message("day \(index) : \(dataSource.forecastDays.count)", .info)

            data.label = "\(index)"

            // The view for the day.

            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(
                rawValue: ForecastDaysViewItem.description()), for: indexPath)
                as? ForecastDaysViewItem

            item?.data = data

            return (item) ?? ForecastDaysViewItem()
        }

        // Create a new Forecast Hour item

        if collectionView.identifier == hoursID,
            dataSource.forecastDays.isEmpty == false {

            if
                let selectedIndexPath = viewForecastDays.selectionIndexPaths.first,
                (selectedIndexPath as NSIndexPath).item != -1 {

                // The day data.

                let day = dataSource.forecastDays[(selectedIndexPath as NSIndexPath).item]

                // The hour of the day data.

                let index = (indexPath as NSIndexPath).item
                var data = day.hours[index]

                // log.message("hour \(index) : \(dataSource.forecastDays.count)", .info)

                data.label = "\(index)"

                // The new view for the hour of the day.

                let item = collectionView.makeItem(withIdentifier:
                    NSUserInterfaceItemIdentifier(
                    rawValue: ForecastHoursViewItem.description()), for: indexPath)
                    as? ForecastHoursViewItem

                item?.data = data

                return (item) ?? ForecastHoursViewItem()
            }
        }

        return NSCollectionViewItem()
    }
}

// MARK: - NSCollectionViewDelegate, SELECTING

extension ForecastView: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView,
                        didSelectItemsAt indexPaths: Set<IndexPath>) {

        // log.message("[\(type(of: self))].\(#function)")

        if collectionView.identifier == daysID {
            viewMeteoGroup.data = nil
            viewForecastHours.reloadData()

            self.selectTheFirstForecastHour()
        }

        if collectionView.identifier == hoursID {

            var hourDetails: ForecastHour?

            if
                let selectedIndexPath = viewForecastDays.selectionIndexPaths.first,
                !dataSource.forecastDays.isEmpty,
                (selectedIndexPath as NSIndexPath).item != -1,
                let hourIndexPaths = indexPaths.first {

                let day = dataSource.forecastDays[(selectedIndexPath as NSIndexPath).item]

                hourDetails = day.hours[(hourIndexPaths as NSIndexPath).item]
            }

            labelWeatherDescription.stringValue =
                hourDetails?.weatherConditions.description ?? MeteoFactsDefaults.conditions
            viewMeteoGroup.data = hourDetails?.prepareMeteoGroupData()
        }
    }
}

// MARK: - DARK MODE

extension ForecastView {

    public func makeup() {

        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        if isHighSierra {
            self.appearance = LIGHT_APPEARANCE_DEFAULT_IN_USE
            let whiteOrBlack: Color = DarkModeAgent.shared.style == .dark ? .white : .black

            self.labelWeatherDescription.textColor = whiteOrBlack

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
    }
}

// MARK: - LOCALIZATION

extension ForecastView {

    public func localize() {

        // log.message("[\(type(of: self))].\(#function)")

        reloadData(saveSelection: true)
    }
}

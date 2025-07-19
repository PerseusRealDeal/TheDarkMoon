//
//  MeteoGroupView.swift, MeteoGroupView.xib
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
class MeteoGroupView: NSView {

    // MARK: - Data

    var data: MeteoGroupData? {
        didSet {
            reload()
        }
    }

    // MARK: - Outlets

    @IBOutlet private(set) var viewContent: NSView!

    @IBOutlet private(set) weak var title1: NSTextField!
    @IBOutlet private(set) weak var title2: NSTextField!
    @IBOutlet private(set) weak var title3: NSTextField!

    @IBOutlet private(set) weak var title4: NSTextField!
    @IBOutlet private(set) weak var title5: NSTextField!
    @IBOutlet private(set) weak var title6: NSTextField!

    @IBOutlet private(set) weak var title7: NSTextField!
    @IBOutlet private(set) weak var title8: NSTextField!
    @IBOutlet private(set) weak var title9: NSTextField!

    @IBOutlet private(set) weak var value1: NSTextField!
    @IBOutlet private(set) weak var value2: NSTextField!
    @IBOutlet private(set) weak var value3: NSTextField!

    @IBOutlet private(set) weak var value4: NSTextField!
    @IBOutlet private(set) weak var value5: NSTextField!
    @IBOutlet private(set) weak var value6: NSTextField!

    @IBOutlet private(set) weak var value7: NSTextField!
    @IBOutlet private(set) weak var value8: NSTextField!
    @IBOutlet private(set) weak var value9: NSTextField!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        log.message("[\(type(of: self))].\(#function)")
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        log.message("[\(type(of: self))].\(#function)")

        // Create a new instance from *xib and reference it to contentView outlet.

        guard
            let className = type(of: self).className().components(separatedBy: ".").last,
            let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
                let text = "[\(type(of: self))].\(#function) No nib loaded."
                log.message(text, .error); fatalError(text)
        }

        log.message("[\(type(of: self))].\(#function) \(className)")

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

    func applyCompactFonts() {

        let fontSizeTitle: CGFloat = 10
        let fontSizeValue: CGFloat = 8

        title1.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value1.font = NSFont.systemFont(ofSize: fontSizeValue)

        title2.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value2.font = NSFont.systemFont(ofSize: fontSizeValue)

        title3.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value3.font = NSFont.systemFont(ofSize: fontSizeValue)

        title4.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value4.font = NSFont.systemFont(ofSize: fontSizeValue)

        title5.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value5.font = NSFont.systemFont(ofSize: fontSizeValue)

        title6.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value6.font = NSFont.systemFont(ofSize: fontSizeValue)

        title7.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value7.font = NSFont.systemFont(ofSize: fontSizeValue)

        title8.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value8.font = NSFont.systemFont(ofSize: fontSizeValue)

        title9.font = NSFont.boldSystemFont(ofSize: fontSizeTitle)
        value9.font = NSFont.systemFont(ofSize: fontSizeValue)
    }

    func reload() {

        let title1str = "Prefix: Min".localizedValue + ", " + "Prefix: Max".localizedValue
        let value1str = "\(MeteoFactsDefaults.temperature) : \(MeteoFactsDefaults.temperature)"

        self.title1.stringValue = data?.title1 ?? title1str
        self.value1.stringValue = data?.value1 ?? value1str

        self.title2.stringValue = data?.title2 ?? "Prefix: Feels Like".localizedValue
        self.value2.stringValue = data?.value2 ?? MeteoFactsDefaults.temperature

        self.title3.stringValue = data?.title3 ?? "Prefix: Visibility".localizedValue
        self.value3.stringValue = data?.value3 ?? MeteoFactsDefaults.visibility

        self.title4.stringValue = data?.title4 ?? "Label: Speed".localizedValue
        self.value4.stringValue = data?.value4 ?? MeteoFactsDefaults.windSpeed

        self.title5.stringValue = data?.title5 ?? "Label: Direction".localizedValue
        self.value5.stringValue = data?.value5 ?? MeteoFactsDefaults.windDirection

        self.title6.stringValue = data?.title6 ?? "Label: Gust".localizedValue
        self.value6.stringValue = data?.value6 ?? MeteoFactsDefaults.windSpeed

        self.title7.stringValue = data?.title7 ?? "Label: Pressure".localizedValue
        self.value7.stringValue = data?.value7 ?? MeteoFactsDefaults.pressure

        self.title8.stringValue = data?.title8 ?? "Prefix: Humidity".localizedValue
        self.value8.stringValue = data?.value8 ?? MeteoFactsDefaults.humidity

        self.title9.stringValue = data?.title9 ?? "Prefix: Cloudiness".localizedValue
        self.value9.stringValue = data?.value9 ?? MeteoFactsDefaults.cloudiness
    }
}

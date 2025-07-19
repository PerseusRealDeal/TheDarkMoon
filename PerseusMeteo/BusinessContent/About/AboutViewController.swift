//
//  AboutViewController.swift, AboutWindowController.storyboard
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

class AboutViewController: NSViewController {

    // MARK: - Outlets

    @IBOutlet private(set) weak var buttonTheAppSourceCode: NSButton!
    @IBOutlet private(set) weak var buttonTheTechnologicalTree: NSButton!

    @IBOutlet private(set) weak var buttonPerseusDarkMode: NSButton!
    @IBOutlet private(set) weak var buttonTheOpenWeatherClient: NSButton!
    @IBOutlet private(set) weak var buttonPerseusGeoLocationKit: NSButton!

    @IBOutlet private(set) weak var buttonPerseusCompassDirection: NSButton!
    @IBOutlet private(set) weak var buttonPerseusTimeFormat: NSButton!
    @IBOutlet private(set) weak var buttonPerseusLogger: NSButton!
    @IBOutlet private(set) weak var buttonConsolePerseusLogger: NSButton!

    @IBOutlet private(set) weak var buttonLicense: NSButton!
    @IBOutlet private(set) weak var buttonTerms: NSButton!
    @IBOutlet private(set) weak var buttonClose: NSButton!

    @IBOutlet private(set) weak var labelTheAppName: NSTextField!

    @IBOutlet private(set) weak var labelTheAppVersionTitle: NSTextField!
    @IBOutlet private(set) weak var labelTheAppVersionValue: NSTextField!

    @IBOutlet private(set) var viewCopyrightText: NSTextView!
    @IBOutlet private(set) var viewCopyrightDetailsText: NSTextView!

    @IBOutlet private(set) var viewTheCreditsText: NSTextView!

    // MARK: - Actions

    @IBAction func buttonCloseTapped(_ sender: NSButton) {
        statusMenusButtonPresenter.screenAbout.close()
    }

    @IBAction func buttonLicenseTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkLicense)
    }

    @IBAction func buttonTermsAndConditionsTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkTermsAndConditions)
    }

    @IBAction func buttonTheAppSourceCodeTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkTheAppSourceCode)
    }

    @IBAction func buttonTheTechnologicalTreeTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkTheTechnologicalTree)
    }

    @IBAction func buttonPerseusDarkModeTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkPerseusDarkMode)
    }

    @IBAction func buttonTheOpenWeatherClientTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkTheOpenWeatherClient)
    }

    @IBAction func buttonPerseusGeoLocationKitTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkPerseusGeoLocationKit)
    }

    @IBAction func buttonPerseusCompassDirectionTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkPerseusCompassDirection)
    }

    @IBAction func buttonPerseusTimeFormatTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkPerseusTimeFormat)
    }

    @IBAction func buttonPerseusLoggerTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkPerseusLogger)
    }

    @IBAction func buttonConsolePerseusLoggerTapped(_ sender: NSButton) {
        AppGlobals.openDefaultBrowser(string: linkConsolePerseusLogger)
    }

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        log.message("[\(type(of: self))].\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        log.message("[\(type(of: self))].\(#function)")

        // Setup content options.

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)
        configure()
    }

    // MARK: - Configuration

    private func configure() {

        viewCopyrightText.backgroundColor = .clear
        viewCopyrightText.isEditable = false
        viewCopyrightText.alignment = .center

        viewCopyrightDetailsText.backgroundColor = .clear
        viewCopyrightDetailsText.isEditable = false
        viewCopyrightDetailsText.alignment = .center

        viewTheCreditsText.backgroundColor = .clear
        viewTheCreditsText.isEditable = false
        viewTheCreditsText.alignment = .left

        buttonTheAppSourceCode.toolTip = linkTheAppSourceCode
        buttonTheTechnologicalTree.toolTip = linkTheTechnologicalTree

        buttonPerseusDarkMode.toolTip = linkPerseusDarkMode
        buttonTheOpenWeatherClient.toolTip = linkTheOpenWeatherClient
        buttonPerseusGeoLocationKit.toolTip = linkPerseusGeoLocationKit

        buttonPerseusCompassDirection.toolTip = linkPerseusCompassDirection
        buttonPerseusTimeFormat.toolTip = linkPerseusTimeFormat
        buttonPerseusLogger.toolTip = linkPerseusLogger
        buttonConsolePerseusLogger.toolTip = linkConsolePerseusLogger
    }
}

// MARK: - Extensions

extension AboutViewController {

    // MARK: - Dark Mode

    public func makeUp() {
        log.message("[\(type(of: self))].\(#function)")

        viewCopyrightText.textColor = .perseusGray
        viewCopyrightDetailsText.textColor = .perseusGray
        viewTheCreditsText.textColor = .perseusGray
    }

    // MARK: - Localization

    @objc func localize() {
        log.message("[\(type(of: self))].\(#function)")

        buttonTheAppSourceCode.title = "Button: The App Source Code".localizedValue
        buttonTheTechnologicalTree.title = "Button: The Technological Tree".localizedValue

        labelTheAppName.stringValue = "Product Name".localizedValue

        labelTheAppVersionTitle.stringValue = "Label: The App Version".localizedValue + ":"

        // InfoPlist.strings.
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        labelTheAppVersionValue.stringValue = (version as? String) ?? "Number"

        viewCopyrightText.string = "Label: Star Copyright Notice".localizedValue
        viewCopyrightDetailsText.string = "Label: Copyright Details".localizedValue

        viewTheCreditsText.string = combineCredits()

        buttonLicense.title = "Button: License".localizedValue
        buttonTerms.title = "Button: Terms & Conditions".localizedValue
        buttonClose.title = "Button: Close".localizedValue
    }

    private func combineCredits() -> String {

        return """
        \("Label: Credits".localizedValue):
          \("Label: Balancing and Control".localizedValue) \("Label: Author".localizedValue)
          \("Label: Writing".localizedValue) \("Label: Author".localizedValue)
          \("Label: Documenting".localizedValue) \("Label: Author".localizedValue)
          \("Label: Artworking".localizedValue) \("Label: Author".localizedValue)
          \("Label: EN Expectation".localizedValue) \("Label: Author".localizedValue)
          \("Label: RU Expectation".localizedValue) \("Label: Author".localizedValue)
        """
    }
}

//
//  AboutViewController.swift, AboutWindowController.storyboard
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

import Cocoa

class AboutViewController: NSViewController {

    // MARK: - Internals

    private var logReportObservation: NSKeyValueObservation?

    private let tabEssentialsID = "Essentials"
    private let tabLogID = "Log"

    private let fontSizeCopyrightText: CGFloat = 10.0
    private let fontSizeCopyrightDetailsText: CGFloat = 10.0
    private let fontSizeTheCreditsText: CGFloat = 10.0

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

    @IBOutlet private(set) weak var viewCopyrightText: NSTextView!
    @IBOutlet private(set) weak var viewCopyrightDetailsText: NSTextView!

    @IBOutlet private(set) weak var viewTheCreditsText: NSTextView!

    @IBOutlet private(set) weak var tabView: NSTabView!
    @IBOutlet private(set) weak var tabEssentials: NSTabViewItem!
    @IBOutlet private(set) weak var tabLog: NSTabViewItem!

    // MARK: - Outlets Log Viewer

    @IBOutlet private(set) weak var textViewLog: NSTextView!

    @IBOutlet weak var buttonLogTurned: NSButton!
    @IBOutlet weak var buttonLogOutput: NSComboBox!
    @IBOutlet weak var buttonLogLevel: NSComboBox!
    @IBOutlet weak var buttonLogMessageFormat: NSComboBox!

    // MARK: - Actions

    @IBAction func buttonCloseTapped(_ sender: NSButton) {
        statusMenusPresenter.screenAbout.close()
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

    // MARK: - Actions Log Viewer

    @IBAction func buttonLogTurnedTapped(_ sender: NSButton) {
        log.turned = sender.state == .on ? .on : .off

        if sender.state == .off {
            localReport.clear()
            textViewLog.string = ""
        }
    }

    @IBAction func buttonLogOutputTapped(_ sender: NSComboBox) {
        guard let item = PerseusLogger.Output(rawValue: sender.stringValue)
        else {
            return
        }

        log.output = item
    }

    @IBAction func buttonLogLevelTapped(_ sender: NSComboBox) {
        guard let item = PerseusLogger.Level(rawValue: abs(sender.indexOfSelectedItem - 5))
        else {
            return
        }

        log.level = item
    }

    @IBAction func buttonLogMessageFormatTapped(_ sender: NSComboBox) {
        guard let item = PerseusLogger.MessageFormat(rawValue: sender.stringValue)
        else {
            return
        }

        log.format = item
    }

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        log.message("[\(type(of: self))].\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        log.message("[\(type(of: self))].\(#function)")

        // Setup content options

        self.view.wantsLayer = true
        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        // Connect to Log Reporting
        logReportObservation = localReport.observe(\.lastMessage, options: .new) { _, _ in
            self.refreshLogReportTextView()
        }

        textViewLog.backgroundColor = .clear
        textViewLog.textColor = .darkGray

        // All other configurations
        onViewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        refreshLogReportTextView()
    }

    // MARK: - Configuration

    private func onViewDidLoad() {

        viewCopyrightText.backgroundColor = .clear
        viewCopyrightText.isEditable = false
        viewCopyrightText.alignment = .left
        viewCopyrightText.font = NSFont.systemFont(ofSize: fontSizeCopyrightText)

        viewCopyrightDetailsText.backgroundColor = .clear
        viewCopyrightDetailsText.isEditable = false
        viewCopyrightDetailsText.alignment = .justified
        viewCopyrightDetailsText.font = NSFont.systemFont(ofSize: fontSizeCopyrightDetailsText)

        viewTheCreditsText.backgroundColor = .clear
        viewTheCreditsText.isEditable = false
        viewTheCreditsText.alignment = .left
        viewTheCreditsText.font = NSFont.systemFont(ofSize: fontSizeTheCreditsText)

        buttonTheAppSourceCode.toolTip = linkTheAppSourceCode
        buttonTheTechnologicalTree.toolTip = linkTheTechnologicalTree

        buttonPerseusDarkMode.toolTip = linkPerseusDarkMode
        buttonTheOpenWeatherClient.toolTip = linkTheOpenWeatherClient
        buttonPerseusGeoLocationKit.toolTip = linkPerseusGeoLocationKit

        buttonPerseusCompassDirection.toolTip = linkPerseusCompassDirection
        buttonPerseusTimeFormat.toolTip = linkPerseusTimeFormat
        buttonPerseusLogger.toolTip = linkPerseusLogger
        buttonConsolePerseusLogger.toolTip = linkConsolePerseusLogger

        // Log Viewer configuration

        buttonLogTurned.state = log.turned == .on ? .on : .off

        buttonLogOutput.removeAllItems()
        buttonLogLevel.removeAllItems()
        buttonLogMessageFormat.removeAllItems()

        for item in PerseusLogger.Output.allCases {
            buttonLogOutput.addItem(withObjectValue: "\(item)")
        }

        for item in PerseusLogger.Level.allCases {
            buttonLogLevel.addItem(withObjectValue: "\(item)")
        }

        for item in PerseusLogger.MessageFormat.allCases {
            buttonLogMessageFormat.addItem(withObjectValue: "\(item)")
        }

        buttonLogOutput.selectItem(withObjectValue: "\(log.output)")
        buttonLogLevel.selectItem(withObjectValue: "\(log.level)")
        buttonLogMessageFormat.selectItem(withObjectValue: "\(log.format)")
    }

    private func refreshLogReportTextView() {
        textViewLog.string = localReport.text

        // TODO: - Scroll to bottom
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

        tabEssentials.label = "Tab: Essentials".localizedValue
        tabLog.label = "Tab: Log".localizedValue
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

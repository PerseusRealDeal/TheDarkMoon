//
//  SelfieViewController.swift
//  The Technological Tree
//
//  Created by Mikhail Zhigulin of Novosibirsk in 7534 (7.11.2025).
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  Unlicensed Free Software
//
//  INFO:
//   Architectural points. MVP.
//   Based on [Gist](https://gist.github.com/PerseusRealDeal/5301e90881732f0cd0040e2083a78a3d).
//
//  This is SelfieViewController.swift
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//

import Cocoa

class SelfieViewController: NSViewController {

    // MARK: - Presenter

    var presenter: SelfieViewPresenter?

    // MARK: - Outlets

    @IBOutlet weak var labelTheAppName: NSTextField!
    @IBOutlet weak var labelTheAppVersion: NSTextField!

    @IBOutlet weak var labelCopyrightText: NSTextField!
    @IBOutlet weak var labelCopyrightDetailsText: NSTextField!
    @IBOutlet weak var viewTheCreditsText: NSTextView!

    @IBOutlet weak var labelTheAppSourceCode: WebLabel!
    @IBOutlet weak var labelTheTechnologicalTree: WebLabel!

    @IBOutlet weak var buttonLicense: NSButton!
    @IBOutlet weak var buttonTerms: NSButton!

    @IBOutlet weak var buttonClose: NSButton!

    @IBOutlet weak var labelPerseusDarkMode: WebLabel!
    @IBOutlet weak var labelPerseusGeoKit: WebLabel!
    @IBOutlet weak var labelPerseusLogger: WebLabel!
    @IBOutlet weak var labelConsolePerseusLogger: WebLabel!
    @IBOutlet weak var labelPerseusTimeFormat: WebLabel!
    @IBOutlet weak var labelPerseusCompassDirection: WebLabel!
    @IBOutlet weak var labelSnowman: WebLabel!
    @IBOutlet weak var labelConvertorMov2Gif: WebLabel!

    // MARK: - Actions

    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.view.window?.close()
    }

    @IBAction func buttonTermsTapped(_ sender: Any) {
        AppGlobals.openDefaultBrowser(string: linkTermsAndConditions)
    }

    @IBAction func buttonLicenseTapped(_ sender: Any) {
        AppGlobals.openDefaultBrowser(string: linkLicense)
    }

    @IBAction func buttonTheTechnologicalTreeTapped(_ sender: Any) {
        AppGlobals.openDefaultBrowser(string: linkTheTechnologicalTree)
    }

    @IBAction func buttonTheAppSourceCodeTapped(_ sender: Any) {
        AppGlobals.openDefaultBrowser(string: linkTheAppSourceCode)
    }
}

// MARK: - MVP View

extension SelfieViewController: SelfieViewDelegate {

    // MARK: - MVPViewDelegate

    func setupUI() {

        log.message("[\(type(of: self))].\(#function)")

        self.view.wantsLayer = true

        labelTheAppSourceCode.weblink = linkTheAppSourceCode
        labelTheTechnologicalTree.weblink = linkTheTechnologicalTree

        labelPerseusDarkMode.weblink = linkPerseusDarkMode
        labelPerseusDarkMode.text = "PerseusDarkMode"

        labelPerseusGeoKit.weblink = linkPerseusGeoKit
        labelPerseusGeoKit.text = "PerseusGeoKit"

        labelPerseusCompassDirection.weblink = linkPerseusCompassDirection
        labelPerseusCompassDirection.text = "PerseusCompassDirection"

        labelPerseusTimeFormat.weblink = linkPerseusTimeFormat
        labelPerseusTimeFormat.text = "PerseusTimeFormat"

        labelPerseusLogger.weblink = linkPerseusLogger
        labelPerseusLogger.text = "PerseusLogger"

        labelConsolePerseusLogger.weblink = linkConsolePerseusLogger
        labelConsolePerseusLogger.text = "ConsolePerseusLogger"

        labelSnowman.weblink = linkSnowman
        labelSnowman.text = "Snowman"

        labelConvertorMov2Gif.weblink = linkConvertorMov2Gif
        labelConvertorMov2Gif.text = "Convertor mov2gif"

        viewTheCreditsText.backgroundColor = .clear
        viewTheCreditsText.isEditable = false
        viewTheCreditsText.alignment = .center
        viewTheCreditsText.font = NSFont.systemFont(ofSize: 20.0)
    }

    func makeUp() {

        log.message("[\(type(of: self))].\(#function), DarkMode: \(DarkMode.style)")

        // view.layer?.backgroundColor = NSColor.perseusBlue.cgColor

        if isHighSierra {
            view.window?.appearance = DarkModeAgent.DarkModeUserChoice == .on ?
            DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE
        }

        viewTheCreditsText.textColor = .perseusGray
    }

    func localize() {

        log.message("[\(type(of: self))].\(#function)")

        self.view.window?.title = "Title: The Dark Moon".localizedValue

        labelTheAppSourceCode.text = "Button: The App Source Code".localizedValue
        labelTheTechnologicalTree.text = "Button: The Technological Tree".localizedValue

        buttonLicense.title = "Button: License".localizedValue
        buttonTerms.title = "Button: Terms & Conditions".localizedValue
        buttonClose.title = "Button: Close".localizedValue

        labelTheAppName.stringValue = "Product Name".localizedValue
        labelTheAppVersion.stringValue = theAppVersionLocalized
        labelCopyrightText.stringValue = "Label: Copyright Notice".localizedValue
        labelCopyrightDetailsText.stringValue = "Label: Copyright Details".localizedValue

        viewTheCreditsText.string = theCredits
    }

    var theAppVersionLocalized: String {
        guard
            let ver = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        else {
            return ""
        }
        return "Label: The App Version".localizedValue + ": \(ver)"
    }

    var theCredits: String {
        return """
        \n\("Label: Credits".localizedValue)\n
        \("Label: Balancing and Control".localizedValue) \("Label: Author".localizedValue)
        \("Label: Writing".localizedValue) \("Label: Author".localizedValue)
        \("Label: Documenting".localizedValue) \("Label: Author".localizedValue)
        \("Label: Artworking".localizedValue) \("Label: Author".localizedValue)
        \("Label: EN Expectation".localizedValue) \("Label: Author".localizedValue)
        \("Label: RU Expectation".localizedValue) \("Label: Author".localizedValue)
        """
    }
}

//
//  WebLabel.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (05.12.2025.)
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import AppKit

class WebLabel: NSTextField {

    // MARK: - Internals

    private(set) var theDarknessTrigger: DarkModeObserver?

    // MARK: - Properties

    public var text: String = "" {
        didSet {
            reset(text, color: .labelPerseus)
        }
    }

    public var weblink: String {
        return text == AppGlobals.meteoProviderName ? linkAuthor : linkOpenWeather
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        theDarknessTrigger = DarkModeObserver { _ in
            self.textColor = .labelPerseus
        }
    }

    // MARK: - Realization: The following code based on Google AI Mode

    private func reset(_ value: String, color: NSColor) {
        if value == AppGlobals.meteoProviderName {
            self.stringValue = value
        } else {
            self.attributedStringValue = createUnderlinedString(
                text: value,
                style: .single,
                color: color
            )
        }
        self.textColor = color
        self.toolTip = weblink
    }

    private func createUnderlinedString(text: String, style: NSUnderlineStyle, color: NSColor)
    -> NSAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: style.rawValue,
            .underlineColor: color
        ]

        return NSAttributedString(string: text, attributes: attributes)
    }

    // MARK: - The following code based on https://share.google/aimode/R6SnHOWBFRzizB8lw

    // 1. Enable mouse movement events to be received
    override func awakeFromNib() {
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited,
                                               .mouseMoved,
                                               .activeAlways,
                                               .inVisibleRect]
        let trackingArea = NSTrackingArea(rect: bounds,
                                          options: options,
                                          owner: self,
                                          userInfo: nil)
        self.addTrackingArea(trackingArea)
    }

    // 2. Respond to mouse movement
    override func mouseMoved(with event: NSEvent) {
        // Change to the 'pointing hand' cursor (or any other system cursor)
        NSCursor.pointingHand.set()
        reset(text, color: .perseusBlue)
    }

    // 3. Ensure the cursor reverts when the mouse exits the view (optional, but good practice)
    override func mouseExited(with event: NSEvent) {
        NSCursor.arrow.set() // Revert to the default arrow cursor
        reset(text, color: .labelPerseus)
    }

    override func mouseUp(with event: NSEvent) {
        AppGlobals.openDefaultBrowser(string: weblink)
    }
}

//
//  MouseTrackingAreaView.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (28.09.2025).
//
//  Copyright © 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import Cocoa

class MouseTrackingAreaView: NSView {

    public var suggestionsViewItem: SuggestionsViewItem?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }

        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let trackingArea = NSTrackingArea(rect: bounds,
                                          options: options,
                                          owner: self,
                                          userInfo: nil)
        addTrackingArea(trackingArea)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        // log.message("[\(type(of: self))].\(#function)")
        SuggestionsView.single?.deselectAllItems()
        suggestionsViewItem?.isSelected = true
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        // log.message("[\(type(of: self))].\(#function)")
        suggestionsViewItem?.isSelected = false
    }
}

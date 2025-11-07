//
//  SuggestionsViewItem.swift, SuggestionsViewItem.xib
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

class SuggestionsViewItem: NSCollectionViewItem {

    public static let heightConstant = 25.0
    public static let minimumLineSpacing = 2.0

    var data: Location? {
        didSet {
            guard isViewLoaded else { return }

            reload()
        }
    }

    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected

            makeup()
        }
    }

    @IBOutlet private(set) weak var labelCountry: NSTextField!
    @IBOutlet private(set) weak var labelLocationName: NSTextField!
    @IBOutlet private(set) weak var labelCoordinates: NSTextField!

    @IBOutlet private(set) weak var viewMouseTrackingArea: MouseTrackingAreaView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewMouseTrackingArea.suggestionsViewItem = self

        configure()

        reload()
        makeup()
    }

    private func configure() {

        view.layer = CALayer()

        view.layer?.cornerRadius = 7.0
        view.layer?.masksToBounds = true
        view.layer?.borderWidth = 2.0

        view.wantsLayer = true

        labelCountry.font = NSFont.systemFont(ofSize: 10)
        labelLocationName.font = NSFont.boldSystemFont(ofSize: 10)
        labelCoordinates.font = NSFont.systemFont(ofSize: 9)
    }

    private func reload() {
        guard let location = self.data, let name = location.localName  else { return }

        let country = location.country ?? "##"
        let state = location.state ?? ""

        var coordinates = "Geo Couple".localizedValue

        if let lat = location.latitude, let lon = location.longitude {
            coordinates = "\(lat.cut(.two)), \(lon.cut(.two))"
        }

        let coordinatesWithState = state.isEmpty ? coordinates : "\(coordinates) > \(state)"

        labelCountry.stringValue = country + ":"
        labelLocationName.stringValue = name
        labelCoordinates.stringValue = coordinatesWithState
    }

    private func makeup() {
        view.layer?.borderColor = isSelected ?
        NSColor.white.cgColor : NSColor.black.cgColor

        labelLocationName.textColor = .labelPerseus
        labelCountry.textColor = .labelPerseus

        view.layer?.backgroundColor = Color.perseusGray3.cgColor
    }

    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        // log.message("[\(type(of: self))].\(#function)")
        mouseTapped()
    }

    public override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        mouseTapped()
    }

    private func mouseTapped() {

        // Send a notification with the suggestion tapped

        if let suggestion = data {
            let nc = AppGlobals.notificationCenter
            let key = Notification.Name.suggestionNotification.rawValue
            nc.post(Notification.init(name: .suggestionNotification,
                                      object: self,
                                      userInfo: [key: suggestion]))
        }
    }
}

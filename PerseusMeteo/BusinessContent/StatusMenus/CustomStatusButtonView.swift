//
//  CustomStatusButtonView.swift, CustomStatusButtonView.xib
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (08.10.2025).
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

class CustomStatusButtonView: NSView {

    // MARK: - Properties

    public var titleOne: String {
        get {
            return labelOneOutlet.stringValue
        }
        set {
            labelOneOutlet.stringValue = newValue
        }
    }

    public var titleTwo: String {
        get {
            return labelTwoOutlet.stringValue
        }
        set {
            labelTwoOutlet.stringValue = newValue
        }
    }

    public var image: NSImage? {
        get {
            return imageOutlet.image
        }
        set {
            imageOutlet.image = newValue
        }
    }

    public var titleOneFontSize: CGFloat = 10 {
        didSet {
            labelOneOutlet.font = NSFont.systemFont(ofSize: titleOneFontSize)
        }
    }

    public var titleTwoFontSize: CGFloat = 10 {
        didSet {
            labelTwoOutlet.font = NSFont.systemFont(ofSize: titleTwoFontSize)
        }
    }

    // MARK: - Outlets

    @IBOutlet private(set) var contentView: NSView!

    @IBOutlet private(set) weak var labelOneOutlet: NSTextField!
    @IBOutlet private(set) weak var labelTwoOutlet: NSTextField!

    @IBOutlet private(set) weak var imageOutlet: NSImageView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {

        guard let className = type(of: self).className().components(separatedBy: ".").last,
              let nib = NSNib(nibNamed: className, bundle: Bundle(for: type(of: self)))
        else {
            let text = "[\(type(of: self))].\(#function) No nib loaded."
            log.message(text, .fault); fatalError(text)
        }

        nib.instantiate(withOwner: self, topLevelObjects: nil)

        addSubview(contentView)

        contentView.frame = self.bounds

        labelOneOutlet.font = NSFont.systemFont(ofSize: titleOneFontSize)
        labelTwoOutlet.font = NSFont.systemFont(ofSize: titleTwoFontSize)
    }
}

//
//  SelfieWindowController.swift, SelfieWindowController.storyboard
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

import Cocoa

extension SelfieWindowController {

    class func storyboardInstance() -> SelfieWindowController {

        let sb = NSStoryboard(name: String(describing: self), bundle: nil)

        guard
            let screen = sb.instantiateInitialController() as? SelfieWindowController,
            let vc = screen.contentViewController as? SelfieViewController
        else {
            let text = "[\(type(of: self))].\(#function)"
            log.message(text, .error)
            fatalError(text)
        }

        vc.presenter = SelfieViewPresenter(view: vc)
        vc.presenter?.viewDidLoad()

        // Do default setup; don't set any parameter causing loadView up, breaks unit tests

        // screen?.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        // screen?.view.backgroundColor = UIColor.yellow

        return screen
    }
}

public class SelfieWindowController: NSWindowController {

    // MARK: - Internals

    private var alwaysOnTop: Any?

    // MARK: - Initialization

    public override func awakeFromNib() {
        super.awakeFromNib()
        // log.message("[\(type(of: self))].\(#function)")

        let nc = AppGlobals.notificationCenter

        // Always on top.

        let notification = NSApplication.didResignActiveNotification
        let queue = OperationQueue.main

        alwaysOnTop = nc.addObserver(forName: notification, object: nil, queue: queue) { _ in
            self.window?.level = .floating
        }
    }

    public override func windowDidLoad() {
        super.windowDidLoad()
        // log.message("[\(type(of: self))].\(#function)")

        // No title for the app screen.
        self.window?.title = ""
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        log.message("[\(type(of: self))].\(#function)")

        self.window?.orderOut(sender)
        return false
    }
}

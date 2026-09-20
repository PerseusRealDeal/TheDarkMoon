//
//  Functions.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import AppKit

func quitTheApp() {
    app.terminate(appDelegate)
}

func openDefaultBrowser(string link: String) {

    guard let url = NSURL(string: link) as URL? else {
        log.message(#function, .error)
        return
    }

    _ = NSWorkspace.shared.open(url) ?
    log.message("\(#function): Default browser opened") :
    log.message("\(#function): Default browser not opened")

    log.message("\(#function): Called: \(link)", .info)
}

func loadCPLProfile(_ name: String) -> (status: Bool, info: String) {
    if let path = Bundle.main.url(forResource: name, withExtension: "json") {
        if log.loadConfig(path) {
            return (true, "Logging options successfully reseted")
        } else {
            return (false, "Failed to reset options")
        }
    } else {
        return (false, "Failed to create URL")
    }
}

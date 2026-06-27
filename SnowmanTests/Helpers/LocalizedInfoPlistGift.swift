//
//  LocalizedInfoPlistGift.swift
//  Gifts
//
//  Just a gift, tested with Swift 4.2 compiler.
//
//  Unlicensed Free Software. For more information, <http://unlicense.org/>
//

/* Perseus Logger source code */
/* https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5 */

import Foundation

extension String {

    var localizedInfoPlist: String? {

        guard
            let infoPlist = Bundle.main.localizedInfoDictionary
        else {
            log.message("InfoPlist.strings", .error)
            return nil
        }

        // InfoPlist.strings localized.
        let value = infoPlist[self] as? String

        return value
    }
}

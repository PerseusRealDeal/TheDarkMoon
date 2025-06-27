//
//  LocalizedExpectationGift.swift
//  Gifts
//
//  Just a gift, tested with Swift 4.2 compiler.
//
//  Unlicensed Free Software. For more information, <http://unlicense.org/>
//

/* Perseus Logger source code */
/* https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5 */

import Foundation

// Customer requirements for localization.

let customerRequirementsFilePrefix = "Translation_"
let customerRequirements = ["en", "ru"] // Just add another one if needed.

extension String {

    var localizedExpectation: String? {

        guard
            let identifier = Locale.preferredLanguages.first,
            let currentLang = Locale(identifier: identifier).languageCode
        else {
            log.message("Failed to get current System language.", .error)
            return nil
        }

        let lang = customerRequirements.contains(currentLang) ? currentLang : "en"
        let resourceName = "\(customerRequirementsFilePrefix)\(lang)"

        guard
            let path = Bundle.main.url(forResource: resourceName, withExtension: "plist")
        else {
            log.message("\(resourceName) not found.", .error)
            return nil
        }

        guard
            let data = try? Data(contentsOf: path)
        else {
            log.message("The property list gives no data.", .error)
            return nil
        }

        guard
            let result = try? PropertyListSerialization.propertyList(from: data,
                                                                     options: [],
                                                                     format: nil)
                as? [String: String]
        else {
            log.message("The property list not serialized.", .error)
            return nil
        }

        guard
            let value = result[self]
        else {
            log.message("No value by the key: \(self).", .error)
            return nil
        }

        return value
    }
}

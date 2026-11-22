//
//  MeteoJsonAsDictionary.swift
//  Gifts
//
//  Just a gift.
//  <https://gist.github.com/perseusrealdeal/918c25633122e64d51f363f00059f6f8>
//
//  Unlicensed Free Software. For more information, <http://unlicense.org/>
//

/* Perseus Logger source code */
/* https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5 */

import Foundation

public class MeteoJsonAsDictionary {

    // MARK: - Internals

    internal var jsonPath: (() -> (Data, MeteoProvider)?)?

    // MARK: - Contract

    public var path: (() -> (Data, MeteoProvider)?)? {
        didSet {
            jsonPath = path
        }
    }

    public var jsonAsDictionary: [String: Any]? { // JSON as Dictionary

        log.message("[\(type(of: self))].\(#function): Property called", .info, .standard)

        guard let source = jsonPath, let jsonDataSource = source()?.0 else { return nil }

        let opts: JSONSerialization.ReadingOptions = [.mutableContainers]

        do {
            let object = try JSONSerialization.jsonObject(with: jsonDataSource, options: opts)
            let logMsg = "[\(type(of: self))].\(#function): JSON data serialized"

            log.message(logMsg, .info, .standard)

            guard
                let dictionary = object as? [String: Any]
            else {
                log.message("[\(type(of: self))].\(#function): Can't go as Dictionary", .error)
                return nil
            }

            return dictionary

        } catch {
            log.message("[\(type(of: self))].\(#function): Wrong JSON data\n\(error)", .error)
            return nil
        }
    }
}

//
//  JsonDataPrettyPrintedGift.swift
//  Gifts
//
//  Just a gift.
//  <https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca>
//
//  Unlicensed Free Software. For more information, <http://unlicense.org/>
//

/* Perseus Logger source code */
/* https://gist.github.com/perseusrealdeal/df456a9825fcface44eca738056eb6d5 */

import Foundation

extension Data {

    /* Inspired by the following gist, many thanks. */
    /* https://gist.github.com/cprovatas/5c9f51813bc784ef1d7fcbfb89de74fe */

    public var prettyPrinted: NSString? {

        let opts: JSONSerialization.WritingOptions = [.prettyPrinted]
        let enc: UInt = String.Encoding.utf8.rawValue

        do {
            let object = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: object, options: opts)

            guard
                let prettyPrinted = NSString(data: data, encoding: enc)
            else {
                log.message("[\(type(of: self))].\(#function), NSString", .error)
                return nil
            }

            return prettyPrinted

        } catch {
            log.message("[\(type(of: self))].\(#function) \(error)", .error)
            return nil
        }
    }
}

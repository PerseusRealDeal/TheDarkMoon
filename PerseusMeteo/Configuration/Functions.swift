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

public func sampleSuggestions() -> [Location] {

    var suggestion1 = Location()
    var suggestion2 = Location()
    var suggestion3 = Location()

    var suggestion4 = Location()
    var suggestion5 = Location()
    var suggestion6 = Location()

    var suggestion7 = Location()

    suggestion1.name = "Советская улица, 75, НСК"
    suggestion1.point = GeoPoint(55.0377335373108, 82.91413691298119)
    suggestion1.country = "RU"
    suggestion1.localNames = [
        "en": "Sovetskaya, 75, NSK",
        "ru": "Советская улица, 75, НСК"
    ]

    suggestion2.name = "ГЛПК Прибой, НСК"
    suggestion2.point = GeoPoint(54.83263291679862, 82.91570663265945)
    suggestion2.country = "RU"

    suggestion3.name = "Остров Тань-Вань, НСК"
    suggestion3.point = GeoPoint(54.817322188351405, 83.03674574747961)
    suggestion3.country = "RU"

    suggestion4.name = "Озеро Мраморное, НСК обл."
    suggestion4.point = GeoPoint(54.22810680087118, 81.7071991707937)
    suggestion4.country = "RU"

    suggestion5.name = "Беловский водопад, Белово, НСК обл."
    suggestion5.point = GeoPoint(54.55994697554389, 83.62070984232841)
    suggestion5.country = "RU"

    suggestion6.name = "Бердские скалы, Новоседово, Нск обл."
    suggestion6.point = GeoPoint(54.618033965714915, 83.98273590642789)
    suggestion6.country = "RU"

    suggestion7.name = "Гора Церковка, Белокуриха"
    suggestion7.point = GeoPoint(51.97283289139373, 84.92740741343708)
    suggestion7.country = "RU"

    return [
        suggestion1,
        suggestion2,
        suggestion3,
        suggestion4,
        suggestion5,
        suggestion6,
        suggestion7
    ]
}

public func sampleCurrentOpenMeteoData() -> Data {

    let opts: JSONSerialization.ReadingOptions = [.mutableContainers]

    guard let jsonDataSource = sampleResponseCurrentOpenMeteo.data(using: .utf16) else {
        log.message("\(#function): jsonDataSource", .error, .standard)
        return Data()
    }

    do {
        let object = try JSONSerialization.jsonObject(with: jsonDataSource, options: opts)
        log.message("\(#function): serialized", .info, .standard)

        let data = try JSONSerialization.data(withJSONObject: object)
        log.message("\(#function):\n\(data.prettyPrinted ?? "")", .info, .standard)

        return data
    } catch let error as NSError {
        log.message("\(#function): \(error.debugDescription)", .error, .standard)
    }

    return Data()
}

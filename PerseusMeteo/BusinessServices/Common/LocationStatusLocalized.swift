//
//  LocationStatusLocalized.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532 and copied from LocationView in 7535 (29.09.2025).
//
//  Copyright © 7532 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

extension GeoStatusSimplified {

    var localizedKey: String {
        switch self {
        case .notDetermined:
            return "GeoAccess: .notDetermined"
        case .notAllowed:
            return "GeoAccess: .notAllowed"
        case .allowed:
            return "GeoAccess: .allowed"
        }
    }
}

extension GeoStatus {

    var localizedKey: String {
        switch self {
        case .notDetermined:
            return "GeoAccess: .notDetermined"
        case .deniedForAllAndRestricted:
            return "GeoAccess: .deniedForAllAndRestricted"
        case .restricted:
            return "GeoAccess: .restricted"
        case .deniedForAllApps:
            return "GeoAccess: .deniedForAllApps"
        case .deniedForTheApp:
            return "GeoAccess: .deniedForTheApp"
        case .allowed:
            return "GeoAccess: .allowed"
        }
    }
}

//
//  PerseusSecretCredentials.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 - 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 - 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public struct SecretCredentials {

    let dataSecured: String // Secured note

    let service: String // Name field in Keychain app.
    let account: String // Account field in Keychain app.
    let description: String // Kind field in Keychain app.

    init(secret: String = "",
         service: String = "Weather",
         account: String = "Snowman",
         description: String = "Personal Weather Service") {

        self.dataSecured = secret

        self.service = service
        self.account = account
        self.description = description
    }
}

extension SecretCredentials: KeychainQueryable {

    public var keychainQuery: [String: Any] {

        var query: [String: Any] = [:]

        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        query[String(kSecAttrAccount)] = account
        query[String(kSecAttrDescription)] = description

        return query
    }

    public var keychainLoadQuery: [String: Any] {

        var query: [String: Any] = [:]

        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        query[String(kSecAttrAccount)] = account
        query[String(kSecAttrDescription)] = description

        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue

        return query
    }
}

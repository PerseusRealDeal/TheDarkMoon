//
//  PerseusProxyCredentials.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7535 (10.11.2026).
//
//  Copyright © 7535 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7535 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public struct PerseusProxyServerPort {

    public let server: String
    public let port: Int

    public init(_ configuration: String) {

        let split = configuration.split(separator: ":")

        if split.count == 2 {

            self.server = String(split[0])
            self.port = Int(split[1]) ?? 80

            return
        }

        self.server = ""
        self.port = 80
    }

    public init(server: String, port: Int) {
        self.server = server
        self.port = port
    }

    public var credentials: String {
        return "\(server):\(port)"
    }
}

public struct PerseusProxyLoginPassword {

    public let login: String
    public let password: String

    public init(_ configuration: String) {

        let split = configuration.split(separator: ":")

        if split.count == 2 {

            self.login =  String(split[0])
            self.password =  String(split[1])

            return
        }

        self.login = ""
        self.password = ""
    }

    public init(_ login: String, _ password: String) {
        self.login = login
        self.password = password
    }

    public var credentials: String {
        return "\(login):\(password)"
    }
}

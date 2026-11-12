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

public struct PerseusProxyCredentials {

    public let server: String
    public let port: Int

    public let login: String
    public let password: String

    public init(_ configuration: String) {

        let split = configuration.split(separator: ":")

        if split.count == 2 {

            self.server = String(split[0])
            self.port = Int(split[1]) ?? 80
            self.login = ""
            self.password = ""

            return

        } else if split.count == 4 {

            self.server = String(split[0])
            self.port = Int(split[1]) ?? 80
            self.login = String(split[2])
            self.password = String(split[3])

            return

        }

        self.server = ""
        self.port = -1
        self.login = ""
        self.password = ""
    }

    public init(server: String, port: Int, login: String = "", password: String = "") {

        self.server = server
        self.port = port

        self.login = login
        self.password = password
    }

    public var credentials: String {
        return "\(server):\(port):\(login):\(password)"
    }
}

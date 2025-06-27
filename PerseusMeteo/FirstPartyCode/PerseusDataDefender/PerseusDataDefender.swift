//
//  PerseusDataDefender.swift
//  PerseusMeteo
//
//  Created by Mikhail Zhigulin in 7532.
//
//  Copyright © 7532 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7532 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//
//  Special thanks for the Keychain API tutorial goes to Lorenzo Boaro.
//  https://www.kodeco.com/9240-keychain-services-api-tutorial-for-passwords-in-swift
//

import Foundation
import Security

import ConsolePerseusLogger

public protocol KeychainQueryable {
    var keychainQuery: [String: Any] { get } // To remove, update, or add a secret
    var keychainLoadQuery: [String: Any] { get } // To load a secret
}

public enum DataDefenderError: Error, CustomStringConvertible {

    case noData
    case string2DataError
    case unhandledError(from: OSStatus)

    public var description: String {
        switch self {
        case .noData:
            return "Nothing of queried data is found."
        case .string2DataError:
            return "Getting data of string went wrong."
        case .unhandledError( _:):
            return "The query is rejected for some reasons."
        }
    }

    public var logMessage: String {
        return "[\(type(of: self))].\(#function) - \(self)"
    }
}

final class PerseusDataDefender: NSObject {

    public static let shared: PerseusDataDefender = { return PerseusDataDefender() }()

    private override init() {
        super.init()
    }

    public func save(_ secret: OpenWeatherCredentials) throws {

        // Get data of note
        guard let secretData = secret.note.data(using: .utf8)
        else {
            let error = DataDefenderError.string2DataError
            log.message(error.logMessage, .error)

            throw error
        }

        // Get keychain query
        var query = secret.keychainQuery

        // Try to find a copy of data in keychain
        var status = SecItemCopyMatching(query as CFDictionary, nil)

        switch status {
        case errSecSuccess: // There is a copy of data that already exists
            log.message("[\(type(of: self))].\(#function) - errSecSuccess")
            // Update the keychain item
            var updateKeychainItem: [String: Any] = [:]

            updateKeychainItem[String(kSecValueData)] = secretData
            status = SecItemUpdate(query as CFDictionary, updateKeychainItem as CFDictionary)

            if status != errSecSuccess {
                let error = DataDefenderError.unhandledError(from: status)
                log.message(error.logMessage, .error)

                throw error
            }

            log.message("[\(type(of: self))].\(#function) - secret updated.")
            return

        case errSecItemNotFound: // There is no copy of data that found in keychain
            log.message("[\(type(of: self))].\(#function) - errSecItemNotFound")
            // Add new keychain item
            query[String(kSecValueData)] = secretData

            status = SecItemAdd(query as CFDictionary, nil)

            if status != errSecSuccess {
                let error = DataDefenderError.unhandledError(from: status)
                let text = "[\(type(of: self))].\(#function) - \(error)"

                log.message(text, .error)

                throw error
            }
            log.message("[\(type(of: self))].\(#function) - secret added.")
            return

        default:
            let error = DataDefenderError.unhandledError(from: status)
            log.message(error.logMessage, .error)

            throw error
        }
    }

    public func remove(_ secret: OpenWeatherCredentials) throws {

        let query = secret.keychainQuery
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            let error = DataDefenderError.unhandledError(from: status)
            log.message(error.logMessage, .error)

            throw error
        }

        switch status {
        case errSecSuccess:
            log.message("[\(type(of: self))].\(#function) - secret removed.")
            return

        case errSecItemNotFound:
            let error = DataDefenderError.noData
            log.message(error.logMessage, .error)

            throw error

        default:
            let error = DataDefenderError.unhandledError(from: status)
            log.message(error.logMessage, .error)

            throw error
        }
    }

    public func load(_ secret: OpenWeatherCredentials) throws -> String {

        // Get keychain query to load secret
        let query = secret.keychainLoadQuery

        // Make a request to load a secret
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        // Get secret value or return empty string
        switch status {

        case errSecSuccess:
            guard
                let queriedItem = result as? [String: Any],
                let secretData = queriedItem[String(kSecValueData)] as? Data,
                let secret = String(data: secretData, encoding: .utf8)
            else {
                let error = DataDefenderError.string2DataError
                log.message(error.logMessage, .error)

                throw error
            }

            log.message("[\(type(of: self))].\(#function) - secret loaded.")
            return secret

        case errSecItemNotFound:
            let error = DataDefenderError.noData
            log.message(error.logMessage, .error)

            throw error

        default:
            let error = DataDefenderError.unhandledError(from: status)
            log.message(error.logMessage, .error)

            throw error
        }
    }
}

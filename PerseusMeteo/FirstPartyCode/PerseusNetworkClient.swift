//
//  PerseusNetworkClient.swift
//  TheDarkMoon
//
//  Created by Mikhail Zhigulin in 7534 (31.03.2026.)
//
//  Copyright © 7534 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  All rights reserved.
//
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2025" is the beginning of 7534.
//
//  Unlicensed Free Software
//
//  <This> means the file named <PerseusNetworkClient.swift>.
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//

import Foundation

/*

import ConsolePerseusLogger

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

*/

public enum PerseusNetworkClientError: Error, Equatable {

    case invalidUrl
    case cancelled
    case notConnectedToInternet

    case timedOut
    case statusCode404
    case nilOrEmptyRequestedData

    case failedResponseStatusCode
    case failedResponse(String)

}

public class PerseusNetworkClient: CustomStringConvertible {

    // MARK: - Internals

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession

    // MARK: - Request Result Delegate

    public var responseHandler: ((_ result: Result<Data, PerseusNetworkClientError>) -> Void)?

    // MARK: - CustomStringConvertible

    public var description: String

    // MARK: - Init

    public init(_ session: URLSession = URLSession.shared, _ purpose: String = "") {

        self.session = session
        self.description = purpose

        self.responseHandler = responseDelegateDefault

        log.message("[\(type(of: self))].\(#function): \(self)", .notice)
    }

    // MARK: - Contract

    public func call(urlString: String, timeout: TimeInterval) throws {
        guard let requestURL = URL(string: urlString) else {
            // WRONG: URL cann't be created at all
            throw PerseusNetworkClientError.invalidUrl
        }

        requestData(url: requestURL, timeout)
    }

    public func cancell() {
        dataTask?.cancel()
    }

    // MARK: - Realization

    // swiftlint:disable:next cyclomatic_complexity
    internal func requestData(url: URL, _ timeout: TimeInterval) {

        var request = URLRequest(url: url)
        request.timeoutInterval = timeout

        dataTask = session.dataTask(with: request) {
            // swiftlint:disable:next closure_parameter_position
            [self] (requestedData: Data?, response: URLResponse?, error: Error?) in

            // Check error

            var errorChecked: PerseusNetworkClientError?

            // Check response status

            if let error = error {
                if (error as NSError).code == NSURLErrorTimedOut {
                    // error code: -1001
                    log.message("\((error as NSError).code)", .info)
                    errorChecked = .timedOut
                } else if (error as NSError).code == NSURLErrorCancelled {
                    // error code: -999
                    log.message("\((error as NSError).code)", .info)
                    errorChecked = .cancelled
                } else if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    // error code: -1009
                    errorChecked = .notConnectedToInternet
                } else {
                    // WRONG: https://apiiiii.openweathermap.org/...
                    errorChecked = .failedResponse(error.localizedDescription)
                }
            } else {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 404 {
                        // WRONG: https://api.openweathermap.org/data/999/...
                        errorChecked = .statusCode404
                    } else if !(200...299).contains(statusCode) {
                        // WRONG: https://api.openweathermap.org/...&appid=wrong_api_key
                        errorChecked = .failedResponse(
                            HTTPURLResponse.localizedString(forStatusCode: statusCode))
                    }
                } else {
                    errorChecked = .failedResponseStatusCode
                }
            }

            // Communicate request result

            if let communicateResult = responseHandler {
                if let error = errorChecked {
                    communicateResult(.failure(error))
                } else if let data = requestedData {
                    if data.isEmpty {
                        communicateResult(.failure(.nilOrEmptyRequestedData))
                    } else {
                        communicateResult(.success(data))
                    }
                } else {
                    communicateResult(.failure(.nilOrEmptyRequestedData))
                }
            }

            self.dataTask = nil
        }

        dataTask?.resume()
    }

    private func responseDelegateDefault(_ result: Result<Data, PerseusNetworkClientError>) {

        switch result {

        case .success(let data):
            log.message("[\(type(of: self))].\(#function): \(data)", .debug, .standard)

        case .failure(let error):
            var errStr = ""
            switch error {
            case .invalidUrl:
                errStr = "invalidUrl"
            case .cancelled:
                errStr = "cancelled"
            case .notConnectedToInternet:
                errStr = "notConnectedToInternet"
            case .timedOut:
                errStr = "timedOut"
            case .statusCode404:
                errStr = "statusCode404"
            case .failedResponseStatusCode:
                errStr = "failedResponseStatusCode"
            case .nilOrEmptyRequestedData:
                errStr = "nilOrEmptyRequestedData"
            case .failedResponse(let errText):
                errStr = errText
            }

            log.message("[\(type(of: self))].\(#function): \(errStr)", .error)
        }
    }
}

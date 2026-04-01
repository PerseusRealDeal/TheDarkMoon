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
//  MIT License
//
//  Copyright © 7534 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7534 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2025" is the beginning of 7534.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/*

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

*/

public enum PerseusNetworkClientError: Error, Equatable {

    case invalidUrl
    case timedOut
    case statusCode404
    case failedRequest(String)
    case failedResponse(String)
    case emptyData

}

public class PerseusNetworkClient: CustomStringConvertible {

    // MARK: - Internals

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession

    // MARK: - CustomStringConvertible

    public var description: String

    // MARK: - Init

    public init(_ session: URLSession = URLSession.shared, _ description: String = "") {

        self.session = session
        self.description = description

        log.message("[\(type(of: self))].\(#function) \(self)", .notice)
    }

    // MARK: - Contract

    public var onDataGiven: (Result<Data, PerseusNetworkClientError>) -> Void = { result in

        switch result {

        case .success(let weatherData):
            log.message("[PerseusNetworkClient].\(#function): \(result)")

        case .failure(let error):
            var errStr = ""
            switch error {
            case .invalidUrl:
                errStr = "invalidUrl"
            case .timedOut:
                errStr = "timedOut"
            case .statusCode404:
                errStr = "statusCode404"
            case .failedRequest(let errText):
                errStr = errText
            case .failedResponse(let errText):
                errStr = errText
            case .emptyData:
                errStr = "received empty data"
            }

            log.message("[PerseusNetworkClient].\(#function): \(errStr)", .error)
        }
    }

    public func call(urlString: String, _ timeout: TimeInterval) throws {
        guard let requestURL = URL(string: urlString) else {
            // WRONG: URL cann't be created at all
            throw PerseusNetworkClientError.invalidUrl
        }

        requestData(url: requestURL, timeout)
    }

    // MARK: - Realization

    internal func requestData(url: URL, _ timeout: TimeInterval) {

        var request = URLRequest(url: url)
        request.timeoutInterval = timeout

        dataTask = session.dataTask(with: URLRequest(url: url)) {
            // swiftlint:disable:next closure_parameter_position
            [self] (requestedData: Data?, response: URLResponse?, error: Error?) in

            // Check error

            var errorChecked: PerseusNetworkClientError?

            // Check response Status

            if let error = error {
                if (error as NSError).code == NSURLErrorTimedOut {
                    errorChecked = .timedOut
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
                    errorChecked = .failedResponse("Failed getting Status Code")
                }
            }

            // Communicate request result

            if let error = errorChecked {
                self.onDataGiven(.failure(error))
            } else if let data = requestedData {
                if data.isEmpty {
                    self.onDataGiven(.failure(.emptyData))
                } else {
                    self.onDataGiven(.success(data))
                }
            } else {
                self.onDataGiven(.failure(.emptyData))
            }

            self.dataTask = nil
        }

        dataTask?.resume()
    }
}

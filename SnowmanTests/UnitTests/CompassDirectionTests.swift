//
//  CompassDirectionsTests.swift
//  SnowmanTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7534 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 - 7534 PerseusRealDeal
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest

@testable import Snowman

class CompassDirectionTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    // func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_sector_north() {

        // act

        // testlog.message("\(CardinalPoint.north)")

        for point in CardinalPoint.north.degrees {

            // assert

            // testlog.message("\(point)")

            check_is_degree_in_sector(point.from, expected: .north)
            check_is_degree_in_sector(point.to, expected: .north)
        }
    }

    func test_sector_northNorthWest() {

        // act

        for point in CardinalPoint.northNorthWest.degrees {

            // assert

            // testlog.message("\(point)")

            check_is_degree_in_sector(point.from, expected: .northNorthWest)
            check_is_degree_in_sector(point.to, expected: .northNorthWest)
        }
    }

    func test_compass_sectors_count() {

        // arrange

        let compassDegrees = 0...360
        var directions = [CardinalPoint]()

        // act

        for degree in compassDegrees {

            guard
                let point = try? WindDegree("\(degree)")
            else {
                    XCTFail("Point for \(degree) not found.")
                    return
            }

            directions.append(point.common)
        }

        // assert

        // testlog.message("\(directions.count)")
        // testlog.message("\(directions.filter({$0 == .northNorthWest }).count)")

        XCTAssertEqual(directions.count, compassDegrees.count)

        check_elements_count(in: directions, with: .north, expected: 24)

        check_elements_count(in: directions, with: .northNorthEast, expected: 22)
        check_elements_count(in: directions, with: .northEast, expected: 23)
        check_elements_count(in: directions, with: .eastNorthEast, expected: 22)

        check_elements_count(in: directions, with: .east, expected: 23)

        check_elements_count(in: directions, with: .eastSouthEast, expected: 22)
        check_elements_count(in: directions, with: .southEast, expected: 23)
        check_elements_count(in: directions, with: .southSouthEast, expected: 22)

        check_elements_count(in: directions, with: .south, expected: 23)

        check_elements_count(in: directions, with: .southSouthWest, expected: 22)
        check_elements_count(in: directions, with: .southWest, expected: 23)
        check_elements_count(in: directions, with: .westSouthWest, expected: 22)

        check_elements_count(in: directions, with: .west, expected: 23)

        check_elements_count(in: directions, with: .westNorthWest, expected: 22)
        check_elements_count(in: directions, with: .northWest, expected: 23)
        check_elements_count(in: directions, with: .northNorthWest, expected: 22)
    }

    private func check_is_degree_in_sector(_ degree: Double,
                                           expected: CardinalPoint,
                                           file: StaticString = #file,
                                           line: UInt = #line) {

        guard
            let sut = try? WindDegree(degree)
        else {
                XCTFail("Point for \(degree) not found.", file: file, line: line)
                return
        }

        XCTAssertEqual(sut.common, expected, file: file, line: line)
    }

    private func check_elements_count(in array: [CardinalPoint],
                                      with criteria: CardinalPoint,
                                      expected count: Int,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let sut = array.filter({ $0 == criteria }).count

        XCTAssertEqual(sut, count, file: file, line: line)
    }
}

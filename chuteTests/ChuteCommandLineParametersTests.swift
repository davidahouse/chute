//
//  ChuteCommandLineParametersTests.swift
//  chuteTests
//
//  Created by David House on 10/21/17.
//  Copyright © 2017 David House. All rights reserved.
//

import XCTest

class ChuteCommandLineParametersTests: XCTestCase {

    func testDoesNotErrorIfGivenNoArguments() {
        let parameters = ChuteCommandLineParameters(arguments: [])
        XCTAssertNil(parameters.project)
        XCTAssertFalse(parameters.hasRequiredParameters)
    }

    func testCanDetectRequiredParameters() {
        let parameters = ChuteCommandLineParameters(arguments: ["-project", "aProject"])
        XCTAssertNotNil(parameters.project)
        XCTAssertTrue(parameters.hasRequiredParameters)
    }

    func testParameterCanDealWithOnlyParameterNameGivenWithNoValue() {
        let onlyOneParameterWithNoValue = ChuteCommandLineParameters(arguments: ["-project"])
        XCTAssertNil(onlyOneParameterWithNoValue.project)

        let twoParametersWithNoValues = ChuteCommandLineParameters(arguments: ["-project", "-branch"])
        XCTAssertNil(twoParametersWithNoValues.project)
        XCTAssertNil(twoParametersWithNoValues.branch)
    }

    func testIfGivenParameterTwiceTheSecondOneWins() {
        let sameParameterTwice = ChuteCommandLineParameters(arguments: ["-project", "fred", "-project", "barney"])
        XCTAssertEqual(sameParameterTwice.project, "barney")
    }
}

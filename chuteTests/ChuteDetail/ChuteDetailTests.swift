//
//  ChuteDetailTests.swift
//  chuteTests
//
//  Created by David House on 10/22/17.
//  Copyright © 2017 David House. All rights reserved.
//

import XCTest

class ChuteDetailTests: XCTestCase {

    func testChuteDetailIsDifferenceable() {

        let original = ChuteDetail(project: "aProject", testDate: Date(), branch: "aBranch", pullRequestNumber: "aPRNumber", testResults: [], codeCoverage: [], attachments: [], styleSheets: [])
        let comparing = ChuteDetail(project: "bProject", testDate: Date(), branch: "aBranch", pullRequestNumber: "aPRNumber", testResults: [], codeCoverage: [], attachments: [], styleSheets: [])

    }
}

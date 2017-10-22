//
//  ChuteTestResult.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteTestResult: Encodable {

    let testIdentifier: String
    let testStatus: String

    init?(detail: TestDetails) {

        guard let testIdentifier = detail.testIdentifier,
            let testStatus = detail.testStatus else {
                return nil
        }

        self.testIdentifier = testIdentifier
        self.testStatus = testStatus
    }
}

extension ChuteTestResult {

    static func findResults(testSummary: TestSummary) -> [ChuteTestResult] {

        var results = [ChuteTestResult]()

        for summary in testSummary.testableSummaries {
            for test in summary.tests {
                results += findTestableSummaries(testDetails: test)
            }
        }

        return results
    }

    private static func findTestableSummaries(testDetails: TestDetails) -> [ChuteTestResult] {

        var results = [ChuteTestResult]()

        if let result = ChuteTestResult(detail: testDetails) {
            results += [result]
        }

        if let subtests = testDetails.subtests {

            for subtest in subtests {
                results += findTestableSummaries(testDetails: subtest)
            }
        }

        return results
    }
}

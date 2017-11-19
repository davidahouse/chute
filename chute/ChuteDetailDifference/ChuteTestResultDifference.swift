//
//  ChuteTestResultDifference.swift
//  chute
//
//  Created by David House on 10/29/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteTestResultDifference {

    let newTestResults: [ChuteTestResult]
    let changedTestResults: [(ChuteTestResult, ChuteTestResult)]
    let removedTestResults: [ChuteTestResult]

    init(detail: DataCapture, comparedTo: DataCapture, detailAttachmentURL: URL, comparedToAttachmentURL: URL) {

        var newResults = [ChuteTestResult]()
        var changedResults = [(ChuteTestResult, ChuteTestResult)]()
        var removedResults = [ChuteTestResult]()

        for test in comparedTo.testResults {

            let foundTests = detail.testResults.filter { $0.testIdentifier == test.testIdentifier }
            if let foundTest: ChuteTestResult = foundTests.first {
                if foundTest.testStatus != test.testStatus {
                    changedResults.append((foundTest, test))
                }
            } else {
                newResults.append(test)
            }
        }

        for test in detail.testResults {

            let foundTests = comparedTo.testResults.filter { $0.testIdentifier == test.testIdentifier }
            if foundTests.isEmpty {
                removedResults.append(test)
            }
        }

        newTestResults = newResults
        changedTestResults = changedResults
        removedTestResults = removedResults
    }
}

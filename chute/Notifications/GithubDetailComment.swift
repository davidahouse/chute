//
//  GithubDetailComment.swift
//  chute
//
//  Created by David House on 11/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class GithubDetailComment {

    enum Constants {
        static let CommentTemplate = """
        # Chute Detail

        *Test Summary*
        - Total Tests: {{total_tests}}
        - Success Tests: {{success_tests}}
        - Failed Tests: {{failed_tests}}

        *Code Coverage Summary*
        - Average Coverage: {{average_coverage}}%
        - Total Files Above 90%: {{total_above_90}}
        - Total Files With No Coverage: {{total_no_coverage}}
        """
    }

    var detail: DataCapture

    lazy var comment: String = {
        self.generateComment()
    }()

    init(detail: DataCapture) {
        self.detail = detail
    }

    private func generateComment() -> String {

        var totalTests = 0
        var successTests = 0
        var failedTests = 0
        for result in detail.testResults {
            if result.testStatus == "Success" {
                successTests += 1
            } else {
                failedTests += 1
            }
            totalTests += 1
        }

        let parameters: [String: CustomStringConvertible] = [
            "total_tests": totalTests,
            "success_tests": successTests,
            "failed_tests": failedTests,
            "average_coverage": Int(round(detail.codeCoverageSummary.averageCoverage * 100)),
            "total_above_90": detail.codeCoverageSummary.filesAdequatelyCovered,
            "total_no_coverage": detail.codeCoverageSummary.filesWithNoCoverage
        ]
        return Constants.CommentTemplate.render(parameters: parameters)
    }
}

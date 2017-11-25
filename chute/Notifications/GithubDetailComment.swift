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

        {{full_report_link}}
        """
    }

    var dataCapture: DataCapture
    var publishedURL: String?

    lazy var comment: String = {
        self.generateComment()
    }()

    init(dataCapture: DataCapture, publishedURL: String?) {
        self.dataCapture = dataCapture
        self.publishedURL = publishedURL
    }

    private func generateComment() -> String {

        var totalTests = 0
        var successTests = 0
        var failedTests = 0
        for result in dataCapture.testResults {
            if result.testStatus == "Success" {
                successTests += 1
            } else {
                failedTests += 1
            }
            totalTests += 1
        }

        let reportLink: String = {
            guard let publishedURL = publishedURL else {
                return ""
            }
            return "[Chute Report](\(publishedURL))"
        }()
        
        let parameters: [String: CustomStringConvertible] = [
            "total_tests": totalTests,
            "success_tests": successTests,
            "failed_tests": failedTests,
            "average_coverage": Int(round(dataCapture.codeCoverageSummary.averageCoverage * 100)),
            "total_above_90": dataCapture.codeCoverageSummary.filesAdequatelyCovered,
            "total_no_coverage": dataCapture.codeCoverageSummary.filesWithNoCoverage,
            "full_report_link": reportLink
        ]
        return Constants.CommentTemplate.render(parameters: parameters)
    }
}

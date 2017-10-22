//
//  ChuteMarkdownOutput.swift
//  chute
//
//  Created by David House on 10/19/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteMarkdownMainReport: ChuteOutputRenderable {

    enum Constants {
        static let Template: String = """
        #  Chute Test Report

        ## Project: {{project}}
        ## Test Date: {{test_date}}
        ## Branch: {{branch}}

        ---

        {{test_summary}}

        ---

        {{code_coverage}}

        ---

        {{style_sheet}}
        """

        static let TestSummaryTemplate = """
        ## Test Summary

        |      |      |
        |------|------|
        | Total | {{total_tests}} |
        | Success | {{success_tests}} |
        | Failed | {{failed_tests}} |

        [Test Details](test_details.md)
        """

        static let CodeCoverageTemplate = """
        ### Code Coverage

        |      |      |
        |------|------|
        | Average | {{average_coverage}} |
        | Total Files Above 90% | {{total_above_90}} |
        | Total Files With No Coverage | {{total_no_coverage}} |

        [Code Coverage Details](code_coverage.md)
        """

        static let NoCodeCoverageTemplate = """
        No Code Coverage Details Found
        """

        static let StyleSheetTemplate = """
        [Style Sheet Details](style_sheet.md)
        """
    }

    func render(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "project": detail.project,
            "test_date": detail.testDate,
            "branch": detail.branch ?? "",
            "test_summary": reportTestSummary(detail: detail),
            "code_coverage": reportCodeCoverage(detail: detail),
            "style_sheet": reportStyleSheet(detail: detail)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportTestSummary(detail: ChuteOutputDetail) -> String {

        var totalTests = 0
        var successTests = 0
        var failedTests = 0
        for result in detail.detail.testResults {
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
            "failed_tests": failedTests
        ]
        return Constants.TestSummaryTemplate.render(parameters: parameters)
    }

    private func reportCodeCoverage(detail: ChuteOutputDetail) -> String {

        if detail.detail.codeCoverage.count > 0 {
            let coverage = detail.detail.codeCoverage.map { $0.coverage }
            let average = Double(coverage.reduce(0, +))/Double(coverage.count)
            let totalAbove90 = detail.detail.codeCoverage.filter { $0.coverage >= 0.90 }.count
            let totalAt0 = detail.detail.codeCoverage.filter { $0.coverage == 0.0 }.count

            let parameters: [String: CustomStringConvertible] = [
                "average_coverage": Int(round(average * 100)),
                "total_above_90": totalAbove90,
                "total_no_coverage": totalAt0
            ]
            return Constants.CodeCoverageTemplate.render(parameters: parameters)
        } else {
            return Constants.NoCodeCoverageTemplate.render(parameters: [:])
        }
    }

    private func reportStyleSheet(detail: ChuteOutputDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [:]
        return Constants.StyleSheetTemplate.render(parameters: parameters)
    }
}

//
//  ChuteHTMLMainReport.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLMainReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        {{header}}
        {{test_summary}}
        {{screenshots}}
        {{code_coverage}}
        {{style_sheet}}
        """

        static let HeaderTemplate = """
        <div class="jumbotron">
        <h1>Chute Test Report</h1>
        <div>
        <p>Project: {{project}}</p>
        <p>Test Date: {{test_date}}</p>
        <p>Branch: {{branch}}</p>
        </div>
        </div>
        """

        static let TestSummaryTemplate = """
        <div class="jumbotron">
        <h3>Test Summary</h3>
        <div class="table-responsive">
        <table class="table table-striped">
        <tbody>
        <tr>
        <td class="info">Total: {{total_tests}}</td>
        <td class="success">Success: {{success_tests}}</td>
        <td class="danger">Failed: {{failed_tests}}</td>
        </tr>
        </tbody>
        </table>
        </div>
        <div>
        <a href="test_details.html">Test Details</a>
        </div>
        </div>
        """

        static let ScreenShotTemplate = """
        <div class="jumbotron">
        <h3>Screenshots</h3>
        <div class="table-responsive">
        <table class="table table-striped">
        <tbody>
        <tr>
        <td class="info">Total Screenshots: {{total_screenshots}}</td>
        </tr>
        </tbody>
        </table>
        </div>
        <div>
        <a href="screenshots.html">Screenshot Details</a>
        </div>
        </div>
        """
        
        static let CodeCoverageTemplate = """
        <div class="jumbotron">
        <h3>Code Coverage</h3>
        <div class="table-responsive">
        <table class="table table-striped">
        <tbody>
        <tr>
        <td class="info">Average Coverage: {{average_coverage}}%</td>
        <td class="info">Total Files Above 90%: {{total_above_90}}</td>
        <td class="info">Total Files With No Coverage: {{total_no_coverage}}</td>
        </tr>
        </tbody>
        </table>
        </div>
        <div>
        <a href="code_coverage.html">Code Coverage Details</a>
        </div>
        </div>
        """

        static let NoCodeCoverageTemplate = """
        <div class="jumbotron">
        <h3>Code Coverage</h3>
        <div>No Code Coverage Details Found</div>
        </div>
        """

        static let StyleSheetTemplate = """
        <div class="jumbotron">
        <h3>Style Sheet</h3>
        <div>
        <a href="style_sheet.html">Style Sheet Details</a>
        </div>
        </div>
        """
    }

    func render(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(detail: detail)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "header": reportHeader(detail: detail),
            "test_summary": reportTestSummary(detail: detail),
            "screenshots": reportScreenshots(detail: detail),
            "code_coverage": reportCodeCoverage(detail: detail),
            "style_sheet": reportStyleSheet(detail: detail)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportHeader(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "project": detail.project,
            "test_date": detail.testDate,
            "branch": detail.branch ?? ""
        ]
        return Constants.HeaderTemplate.render(parameters: parameters)
    }

    private func reportTestSummary(detail: ChuteDetail) -> String {

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
            "failed_tests": failedTests
        ]
        return Constants.TestSummaryTemplate.render(parameters: parameters)
    }
    
    private func reportScreenshots(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "total_screenshots": detail.attachments.count
        ]
        return Constants.ScreenShotTemplate.render(parameters: parameters)
    }

    private func reportCodeCoverage(detail: ChuteDetail) -> String {

        if detail.codeCoverage.count > 0 {
            let parameters: [String: CustomStringConvertible] = [
                "average_coverage": Int(round(detail.codeCoverageSummary.averageCoverage * 100)),
                "total_above_90": detail.codeCoverageSummary.filesAdequatelyCovered,
                "total_no_coverage": detail.codeCoverageSummary.filesWithNoCoverage
            ]
            return Constants.CodeCoverageTemplate.render(parameters: parameters)
        } else {
            return Constants.NoCodeCoverageTemplate.render(parameters: [:])
        }
    }

    private func reportStyleSheet(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [:]
        return Constants.StyleSheetTemplate.render(parameters: parameters)
    }
}
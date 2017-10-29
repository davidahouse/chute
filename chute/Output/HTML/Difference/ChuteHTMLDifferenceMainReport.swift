//
//  ChuteHTMLDifferenceMainReport.swift
//  chute
//
//  Created by David House on 10/23/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLDifferenceMainReport: ChuteOutputDifferenceRenderable {

    enum Constants {
        static let Template = """
        {{header}}
        {{test_summary}}
        {{code_coverage}}
        {{style_sheet}}
        """

        static let HeaderTemplate = """
        <div class="jumbotron">
        <h1>Chute Test Report</h1>
        <div>
        <p>Project: {{project}}</p>
        <p>Origin Branch: {{origin_branch}}</p>
        <p>Compared Branch: {{compared_branch}}</p>
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
        <td class="info">New Tests: {{new_tests}}</td>
        <td class="success">Changed Tests: {{changed_tests}}</td>
        <td class="danger">Removed Tests: {{removed_tests}}</td>
        </tr>
        </tbody>
        </table>
        </div>
        <div>
        <a href="test_details_difference.html">Test Difference Details</a>
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

    func render(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(difference: difference)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "header": reportHeader(difference: difference),
            "test_summary": reportTestSummary(difference: difference),
            "code_coverage": reportCodeCoverage(difference: difference),
            "style_sheet": reportStyleSheet(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportHeader(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "project": difference.project,
            "origin_branch": difference.originBranch ?? "",
            "compared_branch": difference.comparedBranch ?? ""
        ]
        return Constants.HeaderTemplate.render(parameters: parameters)
    }

    private func reportTestSummary(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "new_tests": difference.testResultDifference.newTestResults.count,
            "changed_tests": difference.testResultDifference.changedTestResults.count,
            "removed_tests": difference.testResultDifference.removedTestResults.count
        ]
        return Constants.TestSummaryTemplate.render(parameters: parameters)
    }

    private func reportCodeCoverage(difference: ChuteDetailDifference) -> String {

//        if detail.codeCoverage.count > 0 {
//            let coverage = detail.codeCoverage.map { $0.coverage }
//            let average = Double(coverage.reduce(0, +))/Double(coverage.count)
//            let totalAbove90 = detail.codeCoverage.filter { $0.coverage >= 0.90 }.count
//            let totalAt0 = detail.codeCoverage.filter { $0.coverage == 0.0 }.count
//
//            let parameters: [String: CustomStringConvertible] = [
//                "average_coverage": Int(round(average * 100)),
//                "total_above_90": totalAbove90,
//                "total_no_coverage": totalAt0
//            ]
//            return Constants.CodeCoverageTemplate.render(parameters: parameters)
//        } else {
//            return Constants.NoCodeCoverageTemplate.render(parameters: [:])
//        }
        return ""
    }

    private func reportStyleSheet(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [:]
        return Constants.StyleSheetTemplate.render(parameters: parameters)
    }
}

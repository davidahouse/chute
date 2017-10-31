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
        <td class="info">Average Coverage: {{average_coverage}}% <span class="badge {{average_coverage_change_badge}}">{{average_coverage_change}}%</span></td>
        <td class="info">Total Files Above 90%: {{total_above_90}} <span class="badge {{total_above_90_change_badge}}">{{total_above_90_change}}%</span></td>
        <td class="info">Total Files With No Coverage: {{total_no_coverage}} <span class="badge {{total_no_coverage_change_badge}}">{{total_no_coverage_change}}%</span></td>
        </tr>
        </tbody>
        </table>
        </div>
        <div>
        <a href="code_coverage_difference.html">Code Coverage Details</a>
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
        <div class="table-responsive">
        <table class="table table-striped">
        <tbody>
        <tr>
        <td class="info">Colors Added: {{new_colors}}</td>
        <td class="info">Colors Removed: {{removed_colors}}</td>
        <td class="info">Fonts Added: {{new_fonts}}</td>
        <td class="info">Fonts Removed: {{removed_fonts}}</td>
        </tr>
        </tbody>
        </table>
        </div>
        <a href="style_sheet_difference.html">Style Sheet Details</a>
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

        if difference.comparedTo.codeCoverage.count > 0 {

            let average_coverage_change = difference.comparedTo.codeCoverageSummary.averageCoverage - difference.detail.codeCoverageSummary.averageCoverage
            let total_above_90_change = difference.comparedTo.codeCoverageSummary.filesAdequatelyCovered - difference.detail.codeCoverageSummary.filesAdequatelyCovered
            let total_no_coverage_change = difference.comparedTo.codeCoverageSummary.filesWithNoCoverage - difference.detail.codeCoverageSummary.filesWithNoCoverage

            let average_coverage_change_badge: String = {
                if average_coverage_change < 0.0 {
                    return "badge-danger"
                } else {
                    return "badge-success"
                }
            }()

            let total_above_90_change_badge: String = {
                if total_above_90_change < 0 {
                    return "badge-danger"
                } else {
                    return "badge-success"
                }
            }()

            let total_no_coverage_change_badge: String = {
                if total_no_coverage_change < 0 {
                    return "badge-danger"
                } else {
                    return "badge-success"
                }
            }()

            let parameters: [String: CustomStringConvertible] = [
                "average_coverage": Int(round(difference.comparedTo.codeCoverageSummary.averageCoverage * 100)),
                "average_coverage_change": Int(round(average_coverage_change * 100)),
                "average_coverage_change_badge": average_coverage_change_badge,
                "total_above_90": difference.comparedTo.codeCoverageSummary.filesAdequatelyCovered,
                "total_above_90_change": total_above_90_change,
                "total_above_90_change_badge": total_above_90_change_badge,
                "total_no_coverage": difference.comparedTo.codeCoverageSummary.filesWithNoCoverage,
                "total_no_coverage_change": total_no_coverage_change,
                "total_no_coverage_change_badge": total_no_coverage_change_badge
            ]
            return Constants.CodeCoverageTemplate.render(parameters: parameters)
        } else {
            return Constants.NoCodeCoverageTemplate.render(parameters: [:])
        }
    }

    private func reportStyleSheet(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "new_colors": difference.styleSheetDifference.newColors.count,
            "removed_colors": difference.styleSheetDifference.removedColors.count,
            "new_fonts": difference.styleSheetDifference.newFonts.count,
            "removed_fonts": difference.styleSheetDifference.removedFonts.count
        ]
        return Constants.StyleSheetTemplate.render(parameters: parameters)
    }
}

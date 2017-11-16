//
//  SlackDetailDifferenceMessage.swift
//  chute
//
//  Created by David House on 11/4/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class SlackDetailDifferenceMessage {

    enum Constants {
        static let MessageTemplate = """
        {
            "attachments": [
                {
                    "fallback": "Test Summary. New Tests: {{new_tests}} Changed Tests: {{changed_tests}} Removed Tests: {{removed_tests}}",
                    "color": "#36a64f",
                    "pretext": "Chute Difference",
                    "title": "Test Summary",
                    "text": "New Tests: {{new_tests}}\nChanged Tests: {{changed_tests}}\nRemoved Tests: {{removed_tests}}"
                },
                {
                    "fallback": "Code Coverage. Avg Coverage: {{average_coverage}}% ({{average_coverage_change}}%) ( Total Above 90%: {{total_above_90}} ({{total_above_90_change}}) Total No Coverage: {{total_no_coverage}} ({{total_no_coverage_change}})",
                    "color": "#36a64f",
                    "title": "Code Coverage",
                    "text": "Avg Coverage: {{average_coverage}}% ({{average_coverage_change}}%)\nTotal Above 90%: {{total_above_90}} ({{total_above_90_change}})\nTotal No Coverage: {{total_no_coverage}} ({{total_no_coverage_change}})"
                },
                {
                    "fallback": "Stylesheet. New Colors: {{new_colors}} Removed Colors: {{removed_colors}} New Fonts: {{new_fonts}} Removed Fonts: {{removed_fonts}}",
                    "color": "#36a64f",
                    "title": "Styles",
                    "text": "New Colors: {{new_colors}}\nRemoved Colors: {{removed_colors}}\nNew Fonts: {{new_fonts}}\nRemoved Fonts: {{removed_fonts}}"
                }
            ]
        }
        """
    }

    var difference: DataCaptureDifference

    lazy var message: String = {
        self.generateMessage()
    }()

    init(difference: DataCaptureDifference) {
        self.difference = difference
    }

    private func generateMessage() -> String {
        let average_coverage_change = difference.comparedTo.codeCoverageSummary.averageCoverage - difference.detail.codeCoverageSummary.averageCoverage
        let total_above_90_change = difference.comparedTo.codeCoverageSummary.filesAdequatelyCovered - difference.detail.codeCoverageSummary.filesAdequatelyCovered
        let total_no_coverage_change = difference.comparedTo.codeCoverageSummary.filesWithNoCoverage - difference.detail.codeCoverageSummary.filesWithNoCoverage

        let parameters: [String: CustomStringConvertible] = [
        :
//            "new_tests": difference.testResultDifference.newTestResults.count,
//            "changed_tests": difference.testResultDifference.changedTestResults.count,
//            "removed_tests": difference.testResultDifference.removedTestResults.count,
//            "average_coverage": Int(round(difference.comparedTo.codeCoverageSummary.averageCoverage * 100)),
//            "average_coverage_change": Int(round(average_coverage_change * 100)),
//            "total_above_90": difference.codeCoverageDifference.comparedToSummary.filesAdequatelyCovered,
//            "total_above_90_change": total_above_90_change > 0 ? total_above_90_change : "",
//            "total_no_coverage": difference.codeCoverageDifference.comparedToSummary.filesWithNoCoverage,
//            "total_no_coverage_change": total_no_coverage_change > 0 ? total_no_coverage_change : "",
//            "new_colors": difference.styleSheetDifference.newColors.count,
//            "removed_colors": difference.styleSheetDifference.removedColors.count,
//            "new_fonts": difference.styleSheetDifference.newFonts.count,
//            "removed_fonts": difference.styleSheetDifference.removedFonts.count
        ]
        return Constants.MessageTemplate.render(parameters: parameters)
    }
}

//
//  GithubDetailDifferenceComment.swift
//  chute
//
//  Created by David House on 11/1/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class GithubDetailDifferenceComment {

    enum Constants {
        static let CommentTemplate = """
        # Chute Difference

        *Test Summary*
        - New Tests: {{new_tests}}
        - Changed Tests: {{changed_tests}}
        - Removed Tests: {{removed_tests}}

        *Code Coverage Summary*
        - Average Coverage: {{average_coverage}}% ({{average_coverage_change}}%)
        - Total Files Above 90%: {{total_above_90}} {{total_above_90_change}}
        - Total Files With No Coverage: {{total_no_coverage}} {{total_no_coverage_change}}

        *Style Sheet Summary*
        - New Colors: {{new_colors}}
        - Removed Colors: {{removed_colors}}
        - New Fonts: {{new_fonts}}
        - Removed Fonts: {{removed_fonts}}

        {{full_report_link}}
        """
    }

    var difference: DataCaptureDifference
    var publishedURL: String?
    
    lazy var comment: String = {
        self.generateComment()
    }()

    init(difference: DataCaptureDifference, publishedURL: String?) {
        self.difference = difference
        self.publishedURL = publishedURL
    }

    private func generateComment() -> String {

        let average_coverage_change = difference.comparedTo.codeCoverageSummary.averageCoverage - difference.detail.codeCoverageSummary.averageCoverage
        let total_above_90_change = difference.comparedTo.codeCoverageSummary.filesAdequatelyCovered - difference.detail.codeCoverageSummary.filesAdequatelyCovered
        let total_no_coverage_change = difference.comparedTo.codeCoverageSummary.filesWithNoCoverage - difference.detail.codeCoverageSummary.filesWithNoCoverage

        let reportLink: String = {
            guard let publishedURL = publishedURL else {
                return ""
            }
            return "[Chute Report](\(publishedURL))"
        }()
        
        let parameters: [String: CustomStringConvertible] = [
            "new_tests": difference.testResultDifference.newTestResults.count,
            "changed_tests": difference.testResultDifference.changedTestResults.count,
            "removed_tests": difference.testResultDifference.removedTestResults.count,
            "average_coverage": Int(round(difference.comparedTo.codeCoverageSummary.averageCoverage * 100)),
            "average_coverage_change": Int(round(average_coverage_change * 100)),
            "total_above_90": difference.codeCoverageDifference.comparedToSummary.filesAdequatelyCovered,
            "total_above_90_change": total_above_90_change > 0 ? total_above_90_change : "",
            "total_no_coverage": difference.codeCoverageDifference.comparedToSummary.filesWithNoCoverage,
            "total_no_coverage_change": total_no_coverage_change > 0 ? total_no_coverage_change : "",
            "new_colors": difference.styleSheetDifference.newColors.count,
            "removed_colors": difference.styleSheetDifference.removedColors.count,
            "new_fonts": difference.styleSheetDifference.newFonts.count,
            "removed_fonts": difference.styleSheetDifference.removedFonts.count,
            "full_report_link": reportLink
        ]
        return Constants.CommentTemplate.render(parameters: parameters)
    }
}

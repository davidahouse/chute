//
//  DifferenceReportSummary.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportSummary: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        <div class="jumbotron">
        <h3>Summary</h3>
        <div class="table-responsive">
        <table class="table table-striped">
        <tbody>
        {{test_summary_row}}
        {{code_coverage_summary_row}}
        {{views_summary_row}}
        {{stylesheet_summary_row}}
        </tbody>
        </table>
        </div>
        </div>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let testSummary = DifferenceReportSummaryTests()
        let codeCoverage = DifferenceReportSummaryCodeCoverage()
        let views = DifferenceReportSummaryViews()
        let styleSheet = DifferenceReportSummaryStyleSheet()
        
        let parameters: [String: CustomStringConvertible] = [
            "test_summary_row": testSummary.render(difference: difference),
            "code_coverage_summary_row": codeCoverage.render(difference: difference),
            "views_summary_row": views.render(difference: difference),
            "stylesheet_summary_row": styleSheet.render(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

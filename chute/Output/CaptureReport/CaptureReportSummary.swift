//
//  CaptureReportSummary.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportSummary: ChuteOutputRenderable {
    
    enum Constants {
        
        static let SummaryTemplate = """
        <div class="jumbotron">
        <h3>Summary</h3>
        <div>
        {{test_summary_row}}
        {{code_coverage_summary_row}}
        {{views_summary_row}}
        {{stylesheet_summary_row}}
        </div>
        </div>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let testSummary = CaptureReportSummaryTests()
        let codeCoverageSummary = CaptureReportSummaryCodeCoverage()
        let viewSummary = CaptureReportSummaryViews()
        let styleSheetSummary = CaptureReportSummaryStyleSheet()
        
        let parameters: [String: CustomStringConvertible] = [
            "test_summary_row": testSummary.render(dataCapture: dataCapture),
            "code_coverage_summary_row": codeCoverageSummary.render(dataCapture: dataCapture),
            "views_summary_row": viewSummary.render(dataCapture: dataCapture),
            "stylesheet_summary_row": styleSheetSummary.render(dataCapture: dataCapture)
        ]
        return Constants.SummaryTemplate.render(parameters: parameters)
    }
}

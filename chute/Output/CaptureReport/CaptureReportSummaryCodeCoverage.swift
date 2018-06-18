//
//  CaptureReportSummaryCodeCoverage.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportSummaryCodeCoverage: ChuteOutputRenderable {
    
    enum Constants {
        
        static let CodeCoverageSummaryRowTemplate = """
        <div class="summary">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{average_coverage}} %</h1></div>
                <div class="summary-item-text"><h3>Avg Coverage</h3></div>
            </div>

            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{total_above_90}}</h1></div>
                <div class="summary-item-text"><h3>Above 90% Coverage</h3></div>
            </div>

            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{total_no_coverage}}</h1></div>
                <div class="summary-item-text"><h3>No Coverage</h3></div>
            </div>
        </div>
        """
        
        static let NoCodeCoverageTemplate = """
        <div class="summary-1-column">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h3>No coverage found</h3></div>
            </div>
        </div>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {

        if dataCapture.codeCoverage.coveredLines > 0 {
            let parameters: [String: CustomStringConvertible] = [
                "average_coverage": Int(round(dataCapture.codeCoverageSummary.averageCoverage * 100)),
                "total_above_90": dataCapture.codeCoverageSummary.filesAdequatelyCovered,
                "total_no_coverage": dataCapture.codeCoverageSummary.filesWithNoCoverage
            ]
            return Constants.CodeCoverageSummaryRowTemplate.render(parameters: parameters)
        } else {
            return Constants.NoCodeCoverageTemplate.render(parameters: [:])
        }
    }
}

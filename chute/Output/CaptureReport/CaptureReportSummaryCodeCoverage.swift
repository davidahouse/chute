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
        <tr>
        <td>Code Coverage:</td>
        <td class="info">Average Coverage: {{average_coverage}}%</td>
        <td class="info">Total Files Above 90%: {{total_above_90}}</td>
        <td class="info">Total Files With No Coverage: {{total_no_coverage}}</td>
        </tr>
        """
        
        static let NoCodeCoverageTemplate = """
        <tr>
        <td>Code Coverage:</td>
        <td>No code coverage found</td>
        </tr>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {

        if dataCapture.codeCoverage.count > 0 {
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

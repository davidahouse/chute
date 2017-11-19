//
//  DifferenceReportSummaryCodeCoverage.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportSummaryCodeCoverage: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
         <div class="summary">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{average_coverage}} %</h1><span class="badge {{average_coverage_change_badge}}">{{average_coverage_change}}%</span></div>
                <div class="summary-item-text"><h3>Avg Coverage</h3></div>
            </div>

            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{total_above_90}}</h1><span class="badge {{total_above_90_change_badge}}">{{total_above_90_change}}</span></div>
                <div class="summary-item-text"><h3>Above 90% Coverage</h3></div>
            </div>

            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{total_no_coverage}}</h1><span class="badge {{total_no_coverage_change_badge}}">{{total_no_coverage_change}}</span></div>
                <div class="summary-item-text"><h3>No Coverage</h3></div>
            </div>
        </div>
        """
        
        static let NoCodeCoverageTemplate = """
        <div class="summary">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{average_coverage}} %</h1></div>
                <div class="summary-item-text"><h3>No coverage found</h3></div>
            </div>
        </div>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
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
            return Constants.Template.render(parameters: parameters)
        } else {
            return Constants.NoCodeCoverageTemplate.render(parameters: [:])
        }
    }
}


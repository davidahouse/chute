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
        <style>
        .summary {
             -webkit-column-count: 3; /* Chrome, Safari, Opera */
             -moz-column-count: 3; /* Firefox */
             column-count: 3;
        }
        .gallery img{ width: 100%; padding: 7px 0; margin-bottom: 7px; }
        @media (max-width: 500px) {
            .gallery {
                -webkit-column-count: 1; /* Chrome, Safari, Opera */
                -moz-column-count: 1; /* Firefox */
                column-count: 1;
            }
        }
        .gallery-image {
            border: 1px solid lightgray;
            margin-bottom: 7px;
            border-radius: 5px;
            width: 100%;
            height: auto;
            display: inline-block;
        }
        .gallery-image > h5 {
            color: #777;
            padding: 7px 5px 0px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            border-bottom: 1px solid lightgray;
        }
        </style>
        <div class="jumbotron">
        <h3>Summary</h3>
        <div class="summary">
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

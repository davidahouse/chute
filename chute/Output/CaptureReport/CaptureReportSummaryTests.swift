//
//  CaptureReportSummaryTests.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportSummaryTests: ChuteOutputRenderable {
    
    enum Constants {
        static let TestSummaryRowTemplate = """
        <div class="summary">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{total_tests}}</h1></div>
                <div class="summary-item-text"><h3>Total Tests</h3></div>
            </div>

            <div class="summary-item alert alert-success">
                <div class="summary-item-text"><h1>{{success_tests}}</h1></div>
                <div class="summary-item-text"><h3>Success Tests</h3></div>
            </div>

            <div class="summary-item alert alert-danger">
                <div class="summary-item-text"><h1>{{failed_tests}}</h1></div>
                <div class="summary-item-text"><h3>Failed Tests</h3></div>
            </div>
        </div>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        var totalTests = 0
        var successTests = 0
        var failedTests = 0
        for result in dataCapture.testResults {
            if result.testStatus == "Success" {
                successTests += 1
            } else {
                failedTests += 1
            }
            totalTests += 1
        }
        
        let parameters: [String: CustomStringConvertible] = [
            "total_tests": totalTests,
            "success_tests": successTests,
            "failed_tests": failedTests
        ]
        return Constants.TestSummaryRowTemplate.render(parameters: parameters)
    }
}

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
            <tr>
            <td>Unit Tests:</td>
            <td class="info">Total: {{total_tests}}</td>
            <td class="success">Success: {{success_tests}}</td>
            <td class="danger">Failed: {{failed_tests}}</td>
            </tr>
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

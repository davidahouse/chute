//
//  SlackDetailMessage.swift
//  chute
//
//  Created by David House on 11/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class SlackDetailMessage {

    enum Constants {
        static let MessageTemplate = """
        {
            "attachments": [
                {
                    "fallback": "Test Summary. Total Tests: {{total_tests}} Success Tests: {{success_tests}} Failed Tests: {{failed_tests}}",
                    "color": "#36a64f",
                    "pretext": "Chute Detail",
                    "title": "Test Summary",
                    "title_link": "{{report_link}}",
                    "text": "Total Tests: {{total_tests}}\nSuccess Tests: {{success_tests}}\nFailed Tests: {{failed_tests}}"
                },
                {
                    "fallback": "Code Coverage. Avg Coverage: {{average_coverage}}% Total Above 90%: {{total_above_90}} Total No Coverage: {{total_no_coverage}}",
                    "color": "#36a64f",
                    "title": "Code Coverage",
                    "title_link": "{{report_link}}",
                    "text": "Avg Coverage: {{average_coverage}}\nTotal Above 90%: {{total_above_90}}\nTotal No Coverage: {{total_no_coverage}}"
                }
            ]
        }
        """
    }

    var dataCapture: DataCapture
    var publishedURL: String?
    
    lazy var message: String = {
        self.generateMessage()
    }()

    init(dataCapture: DataCapture, publishedURL: String?) {
        self.dataCapture = dataCapture
        self.publishedURL = publishedURL
    }

    private func generateMessage() -> String {
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

        let reportLink: String = {
            guard let publishedURL = publishedURL else {
                return ""
            }
            return publishedURL
        }()
        
        let parameters: [String: CustomStringConvertible] = [
            "total_tests": totalTests,
            "success_tests": successTests,
            "failed_tests": failedTests,
            "average_coverage": Int(round(dataCapture.codeCoverageSummary.averageCoverage * 100)),
            "total_above_90": dataCapture.codeCoverageSummary.filesAdequatelyCovered,
            "total_no_coverage": dataCapture.codeCoverageSummary.filesWithNoCoverage,
            "report_link": reportLink
        ]
        return Constants.MessageTemplate.render(parameters: parameters)
    }
}

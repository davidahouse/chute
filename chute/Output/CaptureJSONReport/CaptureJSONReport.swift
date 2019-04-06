//
//  CaptureReport.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureJSONReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        {
        "project": "{{project}}",
        "testDate": "{{test_date}}",
        "branch": "{{branch}}",
        "summary": {
            "totalTests": {{total_tests}},
            "successTests": {{success_tests}},
            "failedTests": {{failed_tests}},
            "avgCoverage": {{average_coverage}},
            "above90Coverage": {{total_above_90}},
            "noCoverage": {{total_no_coverage}}
        },
        "testDetails": [
            {{test_details}}
        ],
        "codeCoverageDetails": [
            {{code_coverage_details}}
        ]
        }
        """

        static let TestDetailsTemplate = """
        {
            "testClass": "{{test_class}}",
            "tests": [ {{tests}} ]
        }
        """

        static let TestDetailTemplate = """
        {
            "test": "{{test}}",
            "status": "{{status}}"
        }
        """

        static let CodeCoverageDetailTemplate = """
        {
            "target": "{{target}}",
            "file": "{{file}}",
            "coverage": {{coverage}}
        }
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

        var testClasses: [String] = []
        for result in dataCapture.testResults {
            let parts = result.testIdentifier.components(separatedBy: "/")
            if !testClasses.contains(parts[0]) {
                testClasses.append(parts[0])
            }
        }

        var testDetails = ""

        for testClass in testClasses.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "test_class": testClass,
                "tests": reportTestDetails(dataCapture: dataCapture, testClass: testClass)
            ]
            if testDetails != "" {
                testDetails += ","
            }
            testDetails += Constants.TestDetailsTemplate.render(parameters: parameters)
        }

        let parameters: [String: CustomStringConvertible] = [
            "project": dataCapture.project,
            "test_date": dataCapture.testExecutionDate,
            "branch": dataCapture.branch,
            "total_tests": totalTests,
            "success_tests": successTests,
            "failed_tests": failedTests,
            "average_coverage": Int(round(dataCapture.codeCoverageSummary.averageCoverage * 100)),
            "total_above_90": dataCapture.codeCoverageSummary.filesAdequatelyCovered,
            "total_no_coverage": dataCapture.codeCoverageSummary.filesWithNoCoverage,
            "test_details": testDetails,
            "code_coverage_details": reportCodeCoverage(dataCapture: dataCapture)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportTestDetails(dataCapture: DataCapture, testClass: String) -> String {

        var output = ""
        for result in dataCapture.testResults {
            if result.testIdentifier.starts(with: testClass) {
                let parts = result.testIdentifier.components(separatedBy: "/")
                let identifier = parts[1].replacingOccurrences(of: "()", with: "")
                let parameters: [String: CustomStringConvertible] = [
                    "test": identifier,
                    "status": result.testStatus
                ]
                if output != "" {
                    output += ","
                }
                output += Constants.TestDetailTemplate.render(parameters: parameters)
            }
        }
        return output
    }

    func reportCodeCoverage(dataCapture: DataCapture) -> String {
        var output = ""
        for target in dataCapture.codeCoverage.targets {
            for file in target.files {
                let trClass: String = {
                    if file.lineCoverage <= 0.70 {
                        return "table-danger"
                    } else if file.lineCoverage >= 0.90 {
                        return "table-success"
                    } else {
                        return "table-warning"
                    }
                }()

                let parameters: [String: CustomStringConvertible] = [
                    "row_class": trClass,
                    "target": target.name,
                    "file": file.name,
                    "coverage": Int(round(file.lineCoverage * 100))
                ]
                if output != "" {
                    output += ","
                }
                output += Constants.CodeCoverageDetailTemplate.render(parameters: parameters)
            }
        }
        return output
    }
}

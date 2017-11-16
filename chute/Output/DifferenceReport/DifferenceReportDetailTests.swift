//
//  DifferenceReportDetailTests.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportDetailTests: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        {{new_tests}}
        {{changed_tests}}
        {{removed_tests}}
        """

        static let TestsTemplate = """
        <div class="jumbotron">
        <h3>{{title}}</h3>
        <div class="table-responsive">
        <table class="table">
        <tbody>
        {{details}}
        </tbody>
        </table>
        </div>
        </div>
        """

        static let TestClassTemplate = """
        <tr><td><strong>{{test_class}}</strong></td></tr>
        {{test_details}}
        """

        static let TestDetailTemplate = """
        <tr class="{{row_class}}"><td>{{identifier}}</td></tr>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "new_tests": newTests(difference: difference),
            "changed_tests": changedTests(difference: difference),
            "removed_tests": removedTests(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func newTests(difference: DataCaptureDifference) -> String {

        var testClasses: [String] = []
        for result in difference.testResultDifference.newTestResults {
            let parts = result.testIdentifier.components(separatedBy: "/")
            if !testClasses.contains(parts[0]) {
                testClasses.append(parts[0])
            }
        }

        var output = ""

        for testClass in testClasses.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "test_class": testClass,
                "test_details": reportTestDetails(difference: difference, tests: difference.testResultDifference.newTestResults, testClass: testClass, styleRows: true)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }

        let parameters: [String: CustomStringConvertible] = [
            "title": "New Tests",
            "details": output
        ]
        return Constants.TestsTemplate.render(parameters: parameters)
    }

    private func changedTests(difference: DataCaptureDifference) -> String {

        var testClasses: [String] = []
        for result in difference.testResultDifference.changedTestResults {
            let parts = result.0.testIdentifier.components(separatedBy: "/")
            if !testClasses.contains(parts[0]) {
                testClasses.append(parts[0])
            }
        }

        var output = ""

        for testClass in testClasses.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "test_class": testClass,
                "test_details": reportTestDetails(difference: difference, tests: difference.testResultDifference.changedTestResults.map { $0.1 }, testClass: testClass, styleRows: true)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }
        let parameters: [String: CustomStringConvertible] = [
            "title": "Changed Tests",
            "details": output
        ]
        return Constants.TestsTemplate.render(parameters: parameters)
    }

    private func removedTests(difference: DataCaptureDifference) -> String {

        var testClasses: [String] = []
        for result in difference.testResultDifference.removedTestResults {
            let parts = result.testIdentifier.components(separatedBy: "/")
            if !testClasses.contains(parts[0]) {
                testClasses.append(parts[0])
            }
        }

        var output = ""

        for testClass in testClasses.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "test_class": testClass,
                "test_details": reportTestDetails(difference: difference, tests: difference.testResultDifference.removedTestResults, testClass: testClass, styleRows: false)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }
        let parameters: [String: CustomStringConvertible] = [
            "title": "Removed Tests",
            "details": output
        ]
        return Constants.TestsTemplate.render(parameters: parameters)
    }

    private func reportTestDetails(difference: DataCaptureDifference, tests: [ChuteTestResult], testClass: String, styleRows: Bool) -> String {

        var output = ""
        for result in tests {
            if result.testIdentifier.starts(with: testClass) {
                let parts = result.testIdentifier.components(separatedBy: "/")
                let identifier = parts[1].replacingOccurrences(of: "()", with: "")
                let trClass = result.testStatus == "Success" ? "table-success" : "table-danger"
                let parameters: [String: CustomStringConvertible] = [
                    "row_class": styleRows ? trClass : "table-info",
                    "identifier": identifier
                ]
                output += Constants.TestDetailTemplate.render(parameters: parameters)
            }
        }
        return output
    }
}


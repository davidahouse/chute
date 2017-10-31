//
//  ChuteHTMLDifferenceTestDetailReport.swift
//  chute
//
//  Created by David House on 10/29/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLDifferenceTestDetailReport: ChuteOutputDifferenceRenderable {

    enum Constants {
        static let Template = """
        <div class="jumbotron">
        <h1>Chute Test Report</h1>
        </div>
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
        {{test_attachments}}
        """

        static let TestAttachmentTemplate = """
        <tr><td><img src="attachments/{{attachment_file_name}}" style="max-width:100%;max-height=100%;" title="{{attachment_name}}"></td></tr>
        """
    }

    func render(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(difference: difference)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "new_tests": newTests(difference: difference),
            "changed_tests": changedTests(difference: difference),
            "removed_tests": removedTests(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func newTests(difference: ChuteDetailDifference) -> String {

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
                "test_details": reportTestDetails(difference: difference, tests: difference.testResultDifference.newTestResults, testClass: testClass, includeAttachments: true)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }

        let parameters: [String: CustomStringConvertible] = [
            "title": "New Tests",
            "details": output
        ]
        return Constants.TestsTemplate.render(parameters: parameters)
    }

    private func changedTests(difference: ChuteDetailDifference) -> String {

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
                "test_details": reportTestDetails(difference: difference, tests: difference.testResultDifference.changedTestResults.map { $0.1 }, testClass: testClass, includeAttachments: true)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }
        let parameters: [String: CustomStringConvertible] = [
            "title": "Changed Tests",
            "details": output
        ]
        return Constants.TestsTemplate.render(parameters: parameters)
    }

    private func removedTests(difference: ChuteDetailDifference) -> String {

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
                "test_details": reportTestDetails(difference: difference, tests: difference.testResultDifference.removedTestResults, testClass: testClass, includeAttachments: false)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }
        let parameters: [String: CustomStringConvertible] = [
            "title": "Removed Tests",
            "details": output
        ]
        return Constants.TestsTemplate.render(parameters: parameters)
    }

    private func reportTestDetails(difference: ChuteDetailDifference, tests: [ChuteTestResult], testClass: String, includeAttachments: Bool) -> String {

        var output = ""
        for result in tests {
            if result.testIdentifier.starts(with: testClass) {
                let parts = result.testIdentifier.components(separatedBy: "/")
                let identifier = parts[1].replacingOccurrences(of: "()", with: "")
                let trClass = result.testStatus == "Success" ? "success" : "danger"
                let parameters: [String: CustomStringConvertible] = [
                    "row_class": trClass,
                    "identifier": identifier,
                    "test_attachments": includeAttachments ? reportAttachment(difference: difference, result: result) : ""
                ]
                output += Constants.TestDetailTemplate.render(parameters: parameters)
            }
        }
        return output
    }

    private func reportAttachment(difference: ChuteDetailDifference, result: ChuteTestResult) -> String {

        var output = ""
        for attachment in difference.testResultDifference.attachments.filter({ $0.testIdentifier == result.testIdentifier }) {

            let parameters: [String: CustomStringConvertible] = [
                "attachment_name": attachment.attachmentName,
                "attachment_file_name": attachment.attachmentFileName
            ]
            output += Constants.TestAttachmentTemplate.render(parameters: parameters)
        }
        return output
    }
}

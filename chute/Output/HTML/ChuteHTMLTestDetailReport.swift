//
//  ChuteHTMLTestDetailReport.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLTestDetailReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        <div class="jumbotron">
        <h1>Chute Test Report</h1>
        </div>
        <div class="jumbotron">
        <h3>Test Details</h3>
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

    func render(detail: ChuteOutputDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(detail: detail)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(detail: ChuteOutputDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "details": reportDetails(detail: detail)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportDetails(detail: ChuteOutputDetail) -> String {

        var testClasses: [String] = []
        for result in detail.detail.testResults {
            let parts = result.testIdentifier.components(separatedBy: "/")
            if !testClasses.contains(parts[0]) {
                testClasses.append(parts[0])
            }
        }

        var output = ""

        for testClass in testClasses.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "test_class": testClass,
                "test_details": reportTestDetails(detail: detail, testClass: testClass)
            ]
            output += Constants.TestClassTemplate.render(parameters: parameters)
        }
        return output
    }

    private func reportTestDetails(detail: ChuteOutputDetail, testClass: String) -> String {

        var output = ""
        for result in detail.detail.testResults {
            if result.testIdentifier.starts(with: testClass) {
                let parts = result.testIdentifier.components(separatedBy: "/")
                let identifier = parts[1].replacingOccurrences(of: "()", with: "")
                let trClass = result.testStatus == "Success" ? "success" : "danger"
                let parameters: [String: CustomStringConvertible] = [
                    "row_class": trClass,
                    "identifier": identifier,
                    "test_attachments": reportAttachment(detail: detail, result: result)
                ]
                output += Constants.TestDetailTemplate.render(parameters: parameters)
            }
        }
        return output
    }

    private func reportAttachment(detail: ChuteOutputDetail, result: ChuteTestResult) -> String {

        var output = ""
        for attachment in detail.attachments.filter({ $0.testIdentifier == result.testIdentifier }) {

            let parameters: [String: CustomStringConvertible] = [
                "attachment_name": attachment.attachmentName,
                "attachment_file_name": attachment.attachmentFileName
            ]
            output += Constants.TestAttachmentTemplate.render(parameters: parameters)
        }
        return output
    }
}

//
//  ChuteMarkdownTestDetailOutput.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteMarkdownTestDetailReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        #  Chute Test Report

        {{details}}
        """

        static let TestClassTemplate = """
        ### {{test_class}}

        {{test_details}}
        """

        static let TestDetailTemplate = """
        - {{identifier}} [{{row_class}}]

        {{test_attachments}}

        """

        static let TestAttachmentTemplate = """
        <img src="attachments/{{attachment_file_name}}" height="50%" width="50%"/>

        """
    }

    func render(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "details": reportDetails(detail: detail)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportDetails(detail: ChuteDetail) -> String {

        var testClasses: [String] = []
        for result in detail.testResults {
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

    private func reportTestDetails(detail: ChuteDetail, testClass: String) -> String {

        var output = ""
        for result in detail.testResults {
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

    private func reportAttachment(detail: ChuteDetail, result: ChuteTestResult) -> String {

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

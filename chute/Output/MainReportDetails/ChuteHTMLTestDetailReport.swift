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
        """
    }

    func render(detail: ChuteDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(detail: detail)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(detail: ChuteDetail) -> String {

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
                let trClass = result.testStatus == "Success" ? "table-success" : "table-danger"
                let parameters: [String: CustomStringConvertible] = [
                    "row_class": trClass,
                    "identifier": identifier
                ]
                output += Constants.TestDetailTemplate.render(parameters: parameters)
            }
        }
        return output
    }
}

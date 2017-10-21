//
//  ChuteHTMLCodeCoverageReport.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLCodeCoverageReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
            <div class="jumbotron">
            <h1>Chute Code Coverage Report</h1>
            </div>

            <div class="jumbotron">
            <h3>Code Coverage Details</h3>
            <div class="table-responsive">
            <table class="table">
            <thead>
            <th>Target</th>
            <th>File</th>
            <th>Coverage</th>
            </thead>
            <tbody>
            {{details}}
            </tbody>
            </table>
            </div>
            </div>
        """

        static let CoverageTemplate = """
            <tr class="{{row_class}}">
            <td>{{target}}</td>
            <td>{{file}}</td>
            <td>{{coverage}}%</td>
            </tr>
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

        var output = ""
        for coverage in detail.detail.codeCoverage {
            let trClass: String = {
                if coverage.coverage <= 0.70 {
                    return "danger"
                } else if coverage.coverage >= 0.90 {
                    return "success"
                } else {
                    return "warning"
                }
            }()

            let parameters: [String: CustomStringConvertible] = [
                "row_class": trClass,
                "target": coverage.target,
                "file": coverage.file,
                "coverage": Int(round(coverage.coverage * 100))
            ]
            output += Constants.CoverageTemplate.render(parameters: parameters)
        }
        return output
    }
}

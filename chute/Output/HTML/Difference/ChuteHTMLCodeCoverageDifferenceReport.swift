//
//  ChuteHTMLCodeCoverageDifferenceReport.swift
//  chute
//
//  Created by David House on 10/31/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLCodeCoverageDifferenceReport: ChuteOutputDifferenceRenderable {

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
            <td>{{coverage}}% <span class="badge {{change_badge}}">{{change}}%</span></td>
            </tr>
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
            "details": reportDetails(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportDetails(difference: ChuteDetailDifference) -> String {

        var output = ""
        for coverage in difference.codeCoverageDifference.codeCoverageChanges {
            let trClass: String = {
                if coverage.0.coverage <= 0.70 {
                    return "danger"
                } else if coverage.0.coverage >= 0.90 {
                    return "success"
                } else {
                    return "warning"
                }
            }()

            let changeBadge: String = {
                if coverage.1 <= 0.0 {
                    return "badge-danger"
                } else {
                    return "badge-success"
                }
            }()

            let parameters: [String: CustomStringConvertible] = [
                "row_class": trClass,
                "target": coverage.0.target,
                "file": coverage.0.file,
                "coverage": Int(round(coverage.0.coverage * 100)),
                "change_badge": changeBadge,
                "change": Int(round(coverage.1 * 100))
            ]
            output += Constants.CoverageTemplate.render(parameters: parameters)
        }
        return output
    }
}

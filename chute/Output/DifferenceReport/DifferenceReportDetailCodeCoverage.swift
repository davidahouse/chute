//
//  DifferenceReportDetailCodeCoverage.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportDetailCodeCoverage: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
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
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "details": reportDetails(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportDetails(difference: DataCaptureDifference) -> String {

        var output = ""
        for coverage in difference.codeCoverageDifference.codeCoverageChanges {
            let trClass: String = {
                if coverage.1.lineCoverage <= 0.70 {
                    return "table-danger"
                } else if coverage.1.lineCoverage >= 0.90 {
                    return "table-success"
                } else {
                    return "table-warning"
                }
            }()

            let changeBadge: String = {
                if coverage.2 <= 0.0 {
                    return "badge-danger"
                } else {
                    return "badge-success"
                }
            }()

            let parameters: [String: CustomStringConvertible] = [
                "row_class": trClass,
                "target": coverage.0,
                "file": coverage.1.name,
                "coverage": Int(round(coverage.1.lineCoverage * 100)),
                "change_badge": changeBadge,
                "change": Int(round(coverage.2 * 100))
            ]
            output += Constants.CoverageTemplate.render(parameters: parameters)
        }
        return output
    }
}

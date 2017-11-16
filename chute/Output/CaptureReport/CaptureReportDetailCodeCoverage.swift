//
//  CaptureReportDetailCodeCoverage.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportDetailCodeCoverage: ChuteOutputRenderable {
    
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
            <td>{{coverage}}%</td>
            </tr>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "details": reportDetails(dataCapture: dataCapture)
        ]
        return Constants.Template.render(parameters: parameters)
    }
    
    func reportDetails(dataCapture: DataCapture) -> String {
        var output = ""
        for coverage in dataCapture.codeCoverage {
            let trClass: String = {
                if coverage.coverage <= 0.70 {
                    return "table-danger"
                } else if coverage.coverage >= 0.90 {
                    return "table-success"
                } else {
                    return "table-warning"
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

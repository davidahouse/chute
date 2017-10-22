//
//  ChuteMarkdownCodeCoverageReport.swift
//  chute
//
//  Created by David House on 10/22/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteMarkdownCodeCoverageReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        # Code Coverage Report

        | Target | File | Coverage |
        |--------|------|----------|
        {{details}}
        """

        static let CoverageTemplate = """
        | {{target}} | {{file}} | {{coverage}} |
        """
    }

    func render(detail: ChuteOutputDetail) -> String {

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

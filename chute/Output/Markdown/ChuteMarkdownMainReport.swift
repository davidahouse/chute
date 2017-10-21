//
//  ChuteMarkdownOutput.swift
//  chute
//
//  Created by David House on 10/19/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteMarkdownMainReport: ChuteOutputRenderable {

    enum Constants {
        static let Template: String = """
        #  Chute Test Report

        ## Project: {{project}}
        ## Test Date: {{test_date}}
        ## Branch: {{branch}}

        {{test_summary}}

        {{code_coverage_summary}}

        {{style_guide_summary}}
        """
    }

    func render(detail: ChuteOutputDetail) -> String {

        let summary = ChuteMarkdownTestSummaryOutput()

        let parameters: [String: CustomStringConvertible] = [
            "project": detail.detail.project,
            "test_date": detail.detail.testDate,
            "branch": detail.detail.branch ?? "",
            "test_summary": summary.render(detail: detail)
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

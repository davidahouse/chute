//
//  DifferenceReportDetail.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportDetail: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        {{test_details}}
        {{code_coverage_details}}
        {{view_details}}
        {{style_sheet_details}}
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let testDetail = DifferenceReportDetailTests()
        let codeCoverage = DifferenceReportDetailCodeCoverage()
        let views = DifferenceReportDetailViews()
        let styleSheet = DifferenceReportDetailStyleSheet()
        
        let parameters: [String: CustomStringConvertible] = [
            "test_details": testDetail.render(difference: difference),
            "code_coverage_details": codeCoverage.render(difference: difference),
            "view_details": views.render(difference: difference),
            "style_sheet_details": styleSheet.render(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

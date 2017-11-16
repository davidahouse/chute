//
//  CaptureReportDetail.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportDetail: ChuteOutputRenderable {
    
    enum Constants {
        
        static let Template: String = """
        {{test_details}}
        {{code_coverage_details}}
        {{view_details}}
        {{style_sheet_details}}
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let testDetail = CaptureReportDetailTests()
        let codeCoverage = CaptureReportDetailCodeCoverage()
        let views = CaptureReportDetailViews()
        let styleSheet = CaptureReportDetailStyleSheet()
        
        let parameters: [String: CustomStringConvertible] = [
            "test_details": testDetail.render(dataCapture: dataCapture),
            "code_coverage_details": codeCoverage.render(dataCapture: dataCapture),
            "view_details": views.render(dataCapture: dataCapture),
            "style_sheet_details": styleSheet.render(dataCapture: dataCapture)
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

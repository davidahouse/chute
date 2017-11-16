//
//  CaptureReport.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReport: ChuteOutputRenderable {
    
    enum Constants {
        static let Template = """
        {{header}}
        {{summary}}
        {{details}}
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(dataCapture)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }
    
    private func reportContents(_ dataCapture: DataCapture) -> String {
        
        let header = CaptureReportHeader()
        let summary = CaptureReportSummary()
        let detail = CaptureReportDetail()
        
        let parameters: [String: CustomStringConvertible] = [
            "header": header.render(dataCapture: dataCapture),
            "summary": summary.render(dataCapture: dataCapture),
            "details": detail.render(dataCapture: dataCapture)
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

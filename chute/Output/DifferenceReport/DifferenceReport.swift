//
//  DifferenceReport.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReport: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        {{header}}
        {{summary}}
        {{details}}
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Difference Report",
            "report": reportContents(difference)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }
    
    private func reportContents(_ difference: DataCaptureDifference) -> String {

        let header = DifferenceReportHeader()
        let summary = DifferenceReportSummary()
        let detail = DifferenceReportDetail()

        let parameters: [String: CustomStringConvertible] = [
            "header": header.render(difference: difference),
            "summary": summary.render(difference: difference),
            "details": detail.render(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

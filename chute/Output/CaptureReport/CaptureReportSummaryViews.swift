//
//  CaptureReportSummaryViews.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportSummaryViews: ChuteOutputRenderable {
    
    enum Constants {
        static let ViewSummaryRowTemplate = """
        <tr>
        <td>Views:</td>
        <td>Views Captured: {{total_views}}</td>
        </tr>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "total_views": dataCapture.attachments.count
        ]
        return Constants.ViewSummaryRowTemplate.render(parameters: parameters)
    }
}

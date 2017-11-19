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
        <div class="summary-1-column">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{total_views}}</h1></div>
                <div class="summary-item-text"><h3>Views Captured</h3></div>
            </div>
        </div>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "total_views": dataCapture.attachments.count
        ]
        return Constants.ViewSummaryRowTemplate.render(parameters: parameters)
    }
}

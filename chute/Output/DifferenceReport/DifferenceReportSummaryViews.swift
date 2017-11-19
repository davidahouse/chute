//
//  DifferenceReportSummaryViews.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportSummaryViews: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        <div class="summary-2-column">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{new_views}}</h1></div>
                <div class="summary-item-text"><h3>New Views Captured</h3></div>
            </div>

            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{changed_views}}</h1></div>
                <div class="summary-item-text"><h3>Changed Views</h3></div>
            </div>
        </div>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "new_views": difference.viewDifference.newViews.count,
            "changed_views": difference.viewDifference.changedViews.count
        ]
        return Constants.Template.render(parameters: parameters)
    }
}


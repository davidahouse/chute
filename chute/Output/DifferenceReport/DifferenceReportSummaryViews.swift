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
        <tr>
        <td>Views:</td>
        <td class="info">New Views: {{new_views}}</td>
        <td class="info">Changed Views: {{changed_views}}</td>
        </tr>
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


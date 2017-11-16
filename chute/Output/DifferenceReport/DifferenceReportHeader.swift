//
//  DifferenceReportHeader.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportHeader: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        
        static let Template = """
        <div class="jumbotron">
        <h1>Chute Difference Report</h1>
        <div>
        <p>Project: {{project}}</p>
        <p>Origin Branch: {{origin_branch}}</p>
        <p>Compared Branch: {{compared_branch}}</p>
        </div>
        </div>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "project": difference.detail.project,
            "origin_branch": difference.comparedTo.branch,
            "compared_branch": difference.detail.branch
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

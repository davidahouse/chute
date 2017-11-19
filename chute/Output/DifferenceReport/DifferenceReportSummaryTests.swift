//
//  DifferenceReportSummaryTests.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportSummaryTests: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        <div class="summary">
            <div class="summary-item alert alert-success">
                <div class="summary-item-text"><h1>{{new_tests}}</h1></div>
                <div class="summary-item-text"><h3>New Tests</h3></div>
            </div>

            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{changed_tests}}</h1></div>
                <div class="summary-item-text"><h3>Changed Tests</h3></div>
            </div>

            <div class="summary-item alert alert-danger">
                <div class="summary-item-text"><h1>{{removed_tests}}</h1></div>
                <div class="summary-item-text"><h3>Removed Tests</h3></div>
            </div>
        </div>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "new_tests": difference.testResultDifference.newTestResults.count,
            "changed_tests": difference.testResultDifference.changedTestResults.count,
            "removed_tests": difference.testResultDifference.removedTestResults.count
        ]
        return Constants.Template.render(parameters: parameters)
    }
}

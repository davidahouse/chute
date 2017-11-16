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
        <tr>
        <td>Unit Tests:</td>
        <td class="info">New Tests: {{new_tests}}</td>
        <td class="success">Changed Tests: {{changed_tests}}</td>
        <td class="danger">Removed Tests: {{removed_tests}}</td>
        </tr>
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

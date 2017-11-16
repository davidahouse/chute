//
//  CaptureReportHeader.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportHeader: ChuteOutputRenderable {
    
    enum Constants {

        static let HeaderTemplate = """
        <div class="jumbotron">
        <h1>Chute Report</h1>
        <div>
        <p>Project: {{project}}</p>
        <p>Test Date: {{test_date}}</p>
        <p>Branch: {{branch}}</p>
        </div>
        </div>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "project": dataCapture.project,
            "test_date": dataCapture.testExecutionDate,
            "branch": dataCapture.branch
        ]
        return Constants.HeaderTemplate.render(parameters: parameters)
    }
}

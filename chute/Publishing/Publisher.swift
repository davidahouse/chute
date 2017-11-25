//
//  Publisher.swift
//  chute
//
//  Created by David House on 11/24/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class Publisher {
    
    let environment: Environment
    let outputFolder: ChuteOutputFolder
    let testExecutionDate: Date

    init(environment: Environment, outputFolder: ChuteOutputFolder, testExecutionDate: Date) {
        self.environment = environment
        self.outputFolder = outputFolder
        self.testExecutionDate = testExecutionDate
    }
    
    func publish() {
     
        if environment.arguments.hasParametersForGithubPagesPublish {
            let publisher = GithubPagesPublisher(environment: environment, outputFolder: outputFolder, testExecutionDate: testExecutionDate)
            publisher.publish()
        }
    }
}

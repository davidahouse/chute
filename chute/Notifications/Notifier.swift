//
//  Notifier.swift
//  chute
//
//  Created by David House on 11/25/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class Notifier {
    
    let environment: Environment
    let dataCapture: DataCapture
    let differenceDataCapture: DataCaptureDifference?

    lazy var publishCaptureLink: String? = {
        guard let publishRootURL = environment.arguments.publishRootURL, let rootURL = URL(string: publishRootURL) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let folderName = formatter.string(from: self.dataCapture.testExecutionDate)
        let captureURL = rootURL.appendingPathComponents([folderName, "chute.html"])
        return captureURL.description
    }()
    
    lazy var publishDifferenceLink: String? = {
        guard let publishRootURL = environment.arguments.publishRootURL, let rootURL = URL(string: publishRootURL) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let folderName = formatter.string(from: self.dataCapture.testExecutionDate)
        let captureURL = rootURL.appendingPathComponents([folderName, "chute_difference.html"])
        return captureURL.description
    }()
    
    init(environment: Environment, dataCapture: DataCapture, difference: DataCaptureDifference?) {
        self.environment = environment
        self.dataCapture = dataCapture
        self.differenceDataCapture = difference
    }
    
    func notify() {

        if environment.arguments.hasParametersForGithubNotification {
            let notifier = GithubNotifier()
            notifier.notify(using: environment, including: dataCapture, publishedURL: publishCaptureLink)
            
            if let difference = differenceDataCapture {
                notifier.notify(using: environment, including: difference, publishedURL: publishDifferenceLink)
            }
        }
        
        if environment.arguments.hasParametersForSlackNotification {
            let notifier = SlackNotifier()
            notifier.notify(using: environment, including: dataCapture, publishedURL: publishCaptureLink)
            
            if let difference = differenceDataCapture {
                notifier.notify(using: environment, including: difference, publishedURL: publishDifferenceLink)
            }
        }
    }
}

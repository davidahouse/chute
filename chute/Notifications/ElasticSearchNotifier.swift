//
//  ElasticSearchNotifier.swift
//  chute
//
//  Created by David House on 6/20/18.
//  Copyright © 2018 David House. All rights reserved.
//

import Foundation

class ElasticSearchNotifier {
    
    struct ElasticSearchDocument: Codable {
        let repository: String
        let platform: String
        let branch: String
        let testExecutionDate: Date
    }
    
    func notify(using environment: Environment, including dataCapture: DataCapture, publishedURL: String?) {

        guard let repository = environment.arguments.githubRepository, let platform = environment.arguments.platform, let branch = environment.arguments.branch else {
            print("Error missing required parameters for ElasticSearch notifier")
            return
        }
        
        let document = ElasticSearchDocument(repository: repository, platform: platform, branch: branch, testExecutionDate: dataCapture.testExecutionDate)
        guard let json = try? JSONEncoder().encode(document) else {
            print("Error: unable to encode ElasticSearchDocument")
            return
        }
        
        // Create a URL for this request
        let esurl = "https://admin:JREQCNRPBGALKPTA@kp1-sjc01-c00-5.compose.direct:18343/"
        let index = "\(platform)_\(repository)"
        let urlString = "\(esurl)/\(index.lowercased())/chute"
        guard let postURL = URL(string: urlString) else {
            print("--- Error creating URL for posting to elastic search: \(urlString)")
            return
        }
        
        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("--- Error storing document into elastic search: \(error.localizedDescription)")
            }
            
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print("--- Response: \(dataString ?? "")")
            }
            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: DispatchTime.now() + DispatchTimeInterval.seconds(30))
    }
    
    func notify(using environment: Environment, including difference: DataCaptureDifference, publishedURL: String?) {
        
    }
}
